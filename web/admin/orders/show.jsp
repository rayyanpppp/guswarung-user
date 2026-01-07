<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <title>Detail Pesanan #${order.id} - Admin GusWarung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
</head>

<body class="bg-light">
    <div class="container my-5">
        <h1 class="mb-4 text-warning">Detail Pesanan #${order.id}</h1>
        <a href="AdminOrderServlet?action=index" class="btn btn-outline-secondary mb-3">
            <i class="fas fa-arrow-left me-2"></i> Kembali ke Daftar Pesanan
        </a>
        <hr>

        <%-- Tampilkan Pesan Sukses --%>
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show">
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>

        <div class="row">
            <%-- KOLOM KIRI: Detail Pelanggan & Item --%>
            <div class="col-lg-7">
                <div class="card shadow-sm mb-4 border-0">
                    <div class="card-header bg-warning text-white fw-bold">Detail Pelanggan & Status</div>
                    <div class="card-body">
                        <p><strong>Nama:</strong> ${order.customerName}</p>
                        <p><strong>Telepon:</strong> ${order.customerPhone}</p>
                        <p><strong>Alamat:</strong> ${not empty order.customerAddress ? order.customerAddress : '-'}</p>
                        <p><strong>Catatan:</strong> ${not empty order.notes ? order.notes : '-'}</p>
                        <p class="mt-3"><strong>Waktu Pesan:</strong> 
                            <fmt:formatDate value="${order.createdAt}" pattern="dd MMMM yyyy, HH:mm"/>
                        </p>

                        <h5 class="mt-4 fw-bold">Update Status Pesanan</h5>
                        <%-- Form POST ke Servlet untuk update status --%>
                        <form action="${pageContext.request.contextPath}/admin/orders" method="POST" class="d-flex gap-2">
                            <input type="hidden" name="id" value="${order.id}">
                            <select name="status" class="form-select w-75">
                                <option value="Menunggu Pembayaran" ${order.status == 'Menunggu Pembayaran' ? 'selected' : ''}>Menunggu Pembayaran</option>
                                <option value="Menunggu Konfirmasi Admin" ${order.status == 'Menunggu Konfirmasi Admin' ? 'selected' : ''}>Menunggu Konfirmasi Admin</option>
                                <option value="Diproses" ${order.status == 'Diproses' ? 'selected' : ''}>Diproses</option>
                                <option value="Lunas" ${order.status == 'Lunas' ? 'selected' : ''}>Lunas (Tandai Lunas)</option>
                                <option value="Dibatalkan" ${order.status == 'Dibatalkan' ? 'selected' : ''}>Dibatalkan</option>
                            </select>
                            <button type="submit" class="btn btn-warning w-25 text-white fw-bold">Update</button>
                        </form>
                    </div>
                </div>

                <div class="card shadow-sm border-0">
                    <div class="card-header bg-primary text-white fw-bold">Item Pesanan</div>
                    <ul class="list-group list-group-flush">
                        <c:forEach var="item" items="${order.details}">
                            <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                <div>
                                    <strong class="text-dark">${item.productName}</strong>
                                    <br>
                                    <small class="text-muted">${item.quantity} x Rp <fmt:formatNumber value="${item.pricePerUnit}"/></small>
                                </div>
                                <span class="fw-bold text-primary">Rp <fmt:formatNumber value="${item.totalPrice}"/></span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>

            <%-- KOLOM KANAN: Ringkasan & Bukti Bayar --%>
            <div class="col-lg-5">
                <div class="card bg-white shadow-sm p-4 border-0 mb-4">
                    <h5 class="fw-bold mb-3 text-center text-warning">Ringkasan Pembayaran</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Subtotal</span>
                        <span>Rp <fmt:formatNumber value="${order.subtotal}"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Ongkir</span>
                        <span>Rp <fmt:formatNumber value="${order.shippingFee}"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span>PPN (10%)</span>
                        <span>Rp <fmt:formatNumber value="${order.ppnAmount}"/></span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between fw-bold fs-5">
                        <span>TOTAL AKHIR</span>
                        <span class="text-danger">Rp <fmt:formatNumber value="${order.totalAmount}"/></span>
                    </div>

                    <h5 class="mt-4 fw-bold">Bukti Pembayaran (<span class="text-capitalize">${order.paymentMethod}</span>)</h5>
                    <c:if test="${order.paymentMethod != 'cash' && not empty order.paymentProofPath}">
                        <div class="mt-2 text-center">
                            <a href="${pageContext.request.contextPath}/${order.paymentProofPath}" target="_blank">
                                <img src="${pageContext.request.contextPath}/${order.paymentProofPath}" 
                                     alt="Bukti Pembayaran" class="img-fluid rounded shadow-sm mb-2" style="max-height: 350px;">
                            </a>
                            <p class="text-muted small">Klik gambar untuk memperbesar</p>
                        </div>
                    </c:if>
                    <c:if test="${order.paymentMethod == 'cash'}">
                        <div class="alert alert-secondary mt-2 small">Pembayaran dilakukan secara tunai saat pesanan diterima.</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>