<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="models.Inventaris"%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Inventaris - GusWarung</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        body { font-family: "Poppins", sans-serif; background-color: #f4f6f9; }
        .card { border-radius: 12px; border: none; transition: transform 0.2s ease, box-shadow 0.2s ease; background: #fff; }
        .card:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0, 0, 0, 0.08) !important; }
        .card-img-top { width: 100%; height: 160px; object-fit: cover; border-top-left-radius: 12px; border-top-right-radius: 12px; background-color: #eee; }
        .alert { border-radius: 10px; }
        .badge { font-size: 0.85rem; padding: 6px 10px; }
        input.form-control, select.form-select { border-radius: 8px; padding: 10px 14px; }
        .btn-warning { background-color: #ffc107 !important; border: none; color: white !important; }
        .btn-warning:hover { background-color: #e0a800 !important; }
        .fw-bold { font-weight: 600 !important; }
        .fade-in { opacity: 0; transform: translateY(25px); transition: opacity 0.8s ease, transform 0.8s ease; }
        .fade-in.show { opacity: 1; transform: translateY(0); }
        .btn-group .btn.active { background-color: #e9de08 !important; color: #ffffff !important; font-weight: 700; border-color: #e9de08; }
    </style>
</head>

<body>

    <div class="container py-4 fade-in">

        <div class="mb-4 pb-3 border-bottom">
            <div class="d-flex align-items-center mb-3">
                <img src="${pageContext.request.contextPath}/img/logo/logo.png" width="40" height="40">
                <h3 class="m-0 fw-bold text-dark">Admin Inventaris</h3>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-outline-secondary shadow-sm" style="border-radius: 10px;">
                <i class="fas fa-arrow-left me-2"></i> Kembali ke Dashboard
            </a>
        </div>

        <div class="d-flex justify-content-between align-items-start mb-4">
            <div>
                <h2 class="fw-bold text-dark">Manajemen Stok</h2>
                <h5 class="text-muted">Kelola bahan baku warung</h5>
            </div>

            <div class="d-flex flex-column gap-2">
                <button class="btn btn-warning shadow-sm px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#addItemModal">
                    <i class="fas fa-plus me-2"></i> Tambah Item
                </button>
                <button class="btn btn-primary text-white shadow-sm px-4" data-bs-toggle="modal" data-bs-target="#updateItemModal">
                    <i class="fas fa-sync-alt me-2"></i> Update Stok
                </button>
            </div>
        </div>

        <%
            // 1. LOGIKA JAVA DI DALAM JSP (Pengganti @php Laravel)
            List<Inventaris> stok = (List<Inventaris>) request.getAttribute("dataStok");
            List<Inventaris> stokRendah = new ArrayList<>();
            
            // Format Rupiah Indonesia
            NumberFormat kursIDR = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
            
            if (stok != null) {
                for (Inventaris item : stok) {
                    if (item.getQuantity() <= item.getMinimalStock()) {
                        stokRendah.add(item);
                    }
                }
            }
        %>

        <% if (!stokRendah.isEmpty()) { %>
            <div class="alert alert-danger border-danger border-2 fade-in show shadow-sm mb-4" role="alert">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <i class="fas fa-exclamation-triangle fs-5"></i>
                    <strong>Peringatan Stok Rendah</strong>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <% for (Inventaris lowItem : stokRendah) { %>
                        <span class="badge bg-danger fs-6">
                            <%= lowItem.getName() %>: <%= lowItem.getQuantity() %> <%= lowItem.getUnit() %>
                        </span>
                    <% } %>
                </div>
            </div>
        <% } %>

        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3 fade-in">
            <div class="btn-group shadow-sm" role="group">
                <button class="btn btn-light border active" data-filter="all">Semua</button>
                <button class="btn btn-light border text-success" data-filter="aman">Aman</button>
                <button class="btn btn-light border text-danger" data-filter="rendah">Rendah</button>
            </div>
            <div class="input-group w-50 shadow-sm">
                <span class="input-group-text bg-white border-end-0">
                    <i class="fas fa-search text-muted"></i>
                </span>
                <input type="text" class="form-control border-start-0" placeholder="Cari nama barang..." id="searchInput" />
            </div>
        </div>

        <div class="row g-4" id="inventoryContainer">
            <% 
            if (stok != null && !stok.isEmpty()) {
                for (Inventaris item : stok) {
                    // Logic Status
                    boolean isLow = item.getQuantity() <= item.getMinimalStock();
                    String status = isLow ? "rendah" : "aman";
                    String textClass = isLow ? "text-danger" : "text-warning";
                    String badgeClass = isLow ? "bg-danger" : "bg-success";
                    
                    // Logic Gambar Sederhana (Ganti spasi jadi dash, lowercase)
                    // Misal "Bawang Merah" jadi "img/bawang-merah.jpg"
                    String imgName = item.getName().toLowerCase().replace(" ", "-") + ".jpg";
                    String imgPath = "img/" + imgName;
            %>
                <div class="col-md-3 inventory-item fade-in" data-status="<%= status %>">
                    <div class="card shadow-sm h-100">
                        <img src="<%= imgPath %>" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'" class="card-img-top" alt="<%= item.getName() %>">

                        <div class="card-body p-3 d-flex flex-column">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title text-truncate m-0 fw-bold text-dark" style="max-width: 85%;" title="<%= item.getName() %>">
                                    <%= item.getName() %>
                                </h5>

                                <button class="btn btn-sm text-secondary p-0 border-0"
                                    onclick="confirmDelete(<%= item.getId() %>, '<%= item.getName() %>')" 
                                    data-bs-toggle="modal" data-bs-target="#deleteItemModal">
                                    <i class="fas fa-trash-alt hover-danger"></i>
                                </button>
                            </div>

                            <h3 class="fw-bold <%= textClass %> my-2">
                                <%= item.getQuantity() %> <small class="fs-6 text-muted"><%= item.getUnit() %></small>
                            </h3>

                            <div class="small text-muted mt-auto">
                                <div class="d-flex justify-content-between">
                                    <span>Min. stok:</span> <strong><%= item.getMinimalStock() %></strong>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span>Harga:</span> <strong><%= String.format("%,.0f", item.getPrice()) %></strong>
                                </div>
                            </div>
                            <div class="mt-3">
                                <span class="badge <%= badgeClass %> w-100 py-2"><%= status.substring(0, 1).toUpperCase() + status.substring(1) %></span>
                            </div>
                        </div>
                    </div>
                </div>
            <% 
                } 
            } else { 
            %>
                <div class="col-12 text-center py-5">
                    <p class="text-muted fw-semibold">Data inventaris masih kosong.</p>
                </div>
            <% } %>
        </div>

    </div>

    <div class="modal fade" id="addItemModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-warning text-white">
                    <h5 class="modal-title fw-bold">Tambah Bahan</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/inventaris/simpan" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Nama Bahan</label>
                            <input type="text" name="name" class="form-control" placeholder="Contoh: Beras" required>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-semibold">Jumlah Awal</label>
                                <input type="number" name="quantity" class="form-control" placeholder="0" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-semibold">Satuan</label>
                                <input type="text" name="unit" class="form-control" placeholder="kg/pcs/liter" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label fw-semibold">Minimal Stok</label>
                                <input type="number" name="minimal_stock" class="form-control" placeholder="0" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label fw-semibold">Harga (Rp)</label>
                                <input type="number" name="price" class="form-control" placeholder="harga awal" required>
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Status Awal</label>
                            <select name="status" class="form-select">
                                <option value="aman" selected>Aman</option>
                                <option value="rendah">Rendah</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-warning w-100 text-white fw-bold">Simpan</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updateItemModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold">Update Stok</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/inventaris/update" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Nama Bahan</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="fas fa-search"></i></span>
                                <input type="text" name="name" class="form-control" placeholder="Masukkan nama sama" required>
                            </div>
                            <small class="text-muted">*Pastikan nama sesuai dengan data yang ada.</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Jumlah Stok Baru</label>
                            <input type="number" name="quantity" class="form-control" placeholder="Masukkan jumlah terbaru" required>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-4">
                                <label class="form-label fw-semibold">Satuan</label>
                                <input type="text" name="unit" class="form-control" placeholder="kg/pcs/liter" required>
                            </div>
                            <div class="col-6 mb-4">
                                <label class="form-label fw-semibold">Harga Baru (Rp)</label>
                                <input type="number" name="price" class="form-control" placeholder="Update harga" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 text-white fw-bold">Update</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="deleteItemModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content">
                <div class="modal-body text-center p-4">
                    <i class="fas fa-exclamation-circle text-danger display-1 mb-3"></i>
                    <h4 class="fw-bold mb-2">Hapus Barang?</h4>
                    <p class="text-muted">Anda akan menghapus:</p>
                    <h5 id="deleteItemName" class="fw-bold text-dark bg-light py-2 rounded">...</h5>
                    <p class="text-muted small mb-4">Tindakan ini tidak dapat dibatalkan.</p>

                    <form id="deleteForm" action="${pageContext.request.contextPath}/inventaris/hapus" method="POST">
                        <input type="hidden" name="id" id="deleteItemId">
                        
                        <div class="d-flex justify-content-center gap-2">
                            <button type="button" class="btn btn-light fw-semibold px-4" data-bs-dismiss="modal">Batal</button>
                            <button type="submit" class="btn btn-danger fw-semibold px-4">Ya, Hapus</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 1. Animasi Fade-in
        document.addEventListener("DOMContentLoaded", () => {
            document.querySelectorAll(".fade-in").forEach(el => {
                const observer = new IntersectionObserver(entries => {
                    entries.forEach(entry => { if (entry.isIntersecting) entry.target.classList.add("show"); });
                });
                observer.observe(el);
            });
        });

        // 2. Logic Filter & Search
        const items = document.querySelectorAll(".inventory-item");

        document.querySelectorAll("[data-filter]").forEach(btn => {
            btn.addEventListener("click", () => {
                document.querySelectorAll("[data-filter]").forEach(b => b.classList.remove("active", "btn-dark", "text-white"));
                document.querySelectorAll("[data-filter]").forEach(b => b.classList.add("btn-light"));
                btn.classList.remove("btn-light"); btn.classList.add("active", "btn-dark", "text-white");

                const filter = btn.dataset.filter;
                items.forEach(item => item.style.display = (filter === "all" || item.dataset.status === filter) ? "block" : "none");
            });
        });

        document.getElementById("searchInput").addEventListener("input", (e) => {
            const query = e.target.value.toLowerCase();
            items.forEach(item => item.style.display = item.querySelector("h5").textContent.toLowerCase().includes(query) ? "block" : "none");
        });

        // 3. Logic Modal Hapus (Diubah sedikit untuk Java Servlet)
        function confirmDelete(id, name) {
            document.getElementById('deleteItemName').textContent = name;
            // Masukkan ID ke input hidden
            document.getElementById('deleteItemId').value = id;
            // Action tetap ke servlet 'stok-hapus'
//            document.getElementById('deleteForm').action = 'stok-hapus';
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>