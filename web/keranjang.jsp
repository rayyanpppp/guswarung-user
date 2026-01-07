<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Keranjang - GusWarung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .cart-item-row { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #ddd; }
        .cart-item-row img { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; }
        body { background-color: #fffbea; }
    </style>
</head>
<body>
    <div class="container mt-5 pt-5">
        <h2 class="text-center text-warning fw-bold mb-4">Keranjang Pesanan</h2>
        <div class="row">
            <div class="col-md-7">
                <form action="OrderServlet" method="POST" enctype="multipart/form-data" id="checkoutForm">
                    <h5 class="fw-bold text-warning">Informasi Pemesanan</h5>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nama Pemesan</label>
                        <input type="text" class="form-control" name="customer_name" value="<%= userName %>" required />
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nomor Telepon</label>
                        <input type="tel" class="form-control" name="customer_phone" placeholder="0812..." required />
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Alamat Pengiriman</label>
                        <textarea class="form-control" name="customer_address" rows="3" placeholder="Alamat lengkap..." required></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Catatan Tambahan (Notes)</label>
                        <textarea class="form-control" name="notes" rows="2" placeholder="Contoh: Tanpa sambal, nasi setengah..."></textarea>
                    </div>
                    
                    <h5 class="fw-bold text-warning mt-4">Metode Pembayaran</h5>
                    <select class="form-select" id="paymentMethod" name="payment_method" required>
                        <option value="" disabled selected>Pilih Pembayaran...</option>
                        <option value="cash">Tunai (Bayar di Tempat)</option>
                        <option value="qris">QRIS</option>
                        <option value="transfer">Transfer Bank</option>
                    </select>

                    <div id="paymentDetails" class="mt-3" style="display:none;">
                        <div class="alert alert-info" id="paymentInstruction"></div>
                        <label class="form-label fw-bold">Upload Bukti Bayar</label>
                        <input type="file" class="form-control" name="proof_of_payment" id="proofInput">
                    </div>

                    <input type="hidden" name="cart_data" id="cartDataInput">
                    <input type="hidden" name="total_amount" id="totalAmountInput">

                    <button type="submit" class="btn btn-warning w-100 mt-4 text-white fw-bold">Proses Pesanan</button>
                    <a href="sell" class="btn btn-link w-100 mt-2 text-dark">Kembali Belanja</a>
                </form>
            </div>

            <div class="col-md-5">
                <div class="card p-4 shadow-sm">
                    <h5 class="fw-bold text-center mb-3">Ringkasan Pesanan</h5>
                    <div id="cart-items-list"></div>
                    <hr>
                    <div class="d-flex justify-content-between">
                        <span>Subtotal</span>
                        <span id="subtotal-display">Rp 0</span>
                    </div>
                    <div class="d-flex justify-content-between text-muted small">
                        <span>PPN (10%) + Ongkir (5.000)</span>
                        <span id="tax-display">Rp 0</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between fw-bold fs-5">
                        <span>Total Bayar</span>
                        <span id="total-display" class="text-danger">Rp 0</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const CART_KEY = 'guswarung_cart';

        function formatRupiah(angka) {
            return "Rp " + new Intl.NumberFormat('id-ID').format(angka);
        }

        function renderCart() {
            const cart = JSON.parse(localStorage.getItem(CART_KEY)) || [];
            const container = document.getElementById('cart-items-list');
            
            if (cart.length === 0) {
                container.innerHTML = '<p class="text-center text-muted">Keranjang kosong.</p>';
                return;
            }

            container.innerHTML = '';
            let subtotal = 0;

            cart.forEach((item, index) => {
                subtotal += item.price * item.quantity;
                const row = `
                    <div class="cart-item-row">
                        <img src="\${item.image}" alt="\${item.name}">
                        <div class="flex-grow-1">
                            <h6 class="mb-0 fw-bold">\${item.name}</h6>
                            <small class="text-muted">\${item.quantity} x \${formatRupiah(item.price)}</small>
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(\${index})">×</button>
                    </div>
                `;
                container.innerHTML += row;
            });

            const tax = (subtotal * 0.1) + 5000;
            const total = subtotal + tax;

            document.getElementById('subtotal-display').innerText = formatRupiah(subtotal);
            document.getElementById('tax-display').innerText = formatRupiah(tax);
            document.getElementById('total-display').innerText = formatRupiah(total);
            
            document.getElementById('totalAmountInput').value = Math.round(total);
        }

        function removeItem(index) {
            let cart = JSON.parse(localStorage.getItem(CART_KEY)) || [];
            cart.splice(index, 1);
            localStorage.setItem(CART_KEY, JSON.stringify(cart));
            renderCart();
        }

        document.getElementById('paymentMethod').addEventListener('change', function () {
            const details = document.getElementById('paymentDetails');
            const instruct = document.getElementById('paymentInstruction');
            const proof = document.getElementById('proofInput');

            if (this.value === 'cash') {
                details.style.display = 'none';
                proof.required = false;
                proof.value = '';
            } 
            else if (this.value === 'qris') {
                details.style.display = 'block';
                proof.required = true;
                instruct.innerHTML = 'Silakan scan QRIS GusWarung lalu upload bukti pembayaran.';
            } 
            else if (this.value === 'transfer') {
                details.style.display = 'block';
                proof.required = true;
                instruct.innerHTML = 'Transfer ke Bank XYZ<br>No. Rek: 12345678 a/n GusWarung.';
            }
        });

        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const cart = localStorage.getItem(CART_KEY);
            if (!cart || JSON.parse(cart).length === 0) {
                alert("Keranjang kosong!");
                e.preventDefault();
                return;
            }
            document.getElementById('cartDataInput').value = cart;
            
            // Re-calculate one last time before submit
            const cartArray = JSON.parse(cart);
            let sub = 0;
            cartArray.forEach(i => sub += (i.price * i.quantity));
            document.getElementById('totalAmountInput').value = Math.round(sub + (sub * 0.1) + 5000);
        });

        document.addEventListener('DOMContentLoaded', renderCart);
    </script>
</body>
</html>