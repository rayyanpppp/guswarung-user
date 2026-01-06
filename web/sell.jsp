<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, models.Menu, java.text.NumberFormat" %>
<%@ page import="models.Order, java.util.List, java.text.SimpleDateFormat" %>
<%
    // 1. Ambil data dari Servlet (List yang sudah difilter di Controller)
    List<Menu> makanan = (List<Menu>) request.getAttribute("makanan");
    List<Menu> minuman = (List<Menu>) request.getAttribute("minuman");
    List<Menu> addons = (List<Menu>) request.getAttribute("addons");
    
    // Gabungkan semua menu ke dalam satu list utama agar JavaScript Filter bekerja maksimal
    List<Menu> allMenu = new ArrayList<>();
    if(makanan != null) allMenu.addAll(makanan);
    if(minuman != null) allMenu.addAll(minuman);
    if(addons != null) allMenu.addAll(addons);
    
    String userName = (String) session.getAttribute("userName"); 
    NumberFormat nf = NumberFormat.getInstance(new Locale("id", "ID"));
    String contextPath = request.getContextPath();
%>
<%
    // Mendapatkan nama file atau servlet yang sedang diakses
    String currentPath = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Menu Penjualan - GusWarung</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="css/style-penjualan.css" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
</head>

<style>
    .nav-link.active {
    color: #fff !important; /* Warna teks saat aktif */
    background-color: rgba(0, 0, 0, 0.1); /* Background tipis */
    border-radius: 8px;
    padding: 8px 15px;
}

.menu-header {
    padding-top: 150px;
    padding-bottom: 80px;
    /* Menggunakan gambar kuliner estetik */
    background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), 
                url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2070&auto=format&fit=crop') center/cover no-repeat;
    color: white;
    text-align: center;
}

.search-container {
    max-width: 550px;
    margin: 0 auto;
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(10px);
    padding: 10px;
    border-radius: 50px;
}

.search-container .form-control {
    border-radius: 0 50px 50px 0;
    border: none;
}

.search-container .input-group-text {
    border-radius: 50px 0 0 50px;
    border: none;
    padding-left: 20px;
}
</style>

<body style="background-color: #f8f9fa;">

    <%
        // 1. Ambil nama user dari session (pastikan nama atribut sama dengan di Servlet)
//        String userName = (String) session.getAttribute("userName");

        // 2. Jika session kosong, lempar ke login
        if (userName == null) {
            response.sendRedirect("login.jsp");
            return; // Penting agar kode di bawah tidak dijalankan
        }

        // 3. Inisialisasi variabel badge pesanan agar tidak error "cannot be resolved"
        Integer newOrdersCount = (Integer) request.getAttribute("newOrdersCount");
        if (newOrdersCount == null) {
            newOrdersCount = 0; // Default jika tidak ada data
        }
    %>

    <nav class="fixed-top navbar navbar-expand-lg shadow-lg" style="background-color: #ffc107">
        <div class="container">
            <a class="navbar-brand text-white fw-bold" href="home.jsp">
                <img src="${pageContext.request.contextPath}/img/logo/logo.png" width="40" height="40">
                GusWarung
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav align-items-center">
                    <li class="nav-item">
        <a class="nav-link text-black <%= currentPath.contains("home") ? "active fw-bold border-bottom border-dark" : "" %>" href="home">Home</a>
    </li>
    <li class="nav-item">
        <a class="nav-link text-black <%= currentPath.contains("sell") ? "active fw-bold border-bottom border-dark" : "" %>" href="sell">Penjualan</a>
    </li>
    <li class="nav-item">
        <a class="nav-link text-black <%= currentPath.contains("about") ? "active fw-bold border-bottom border-dark" : "" %>" href="about.jsp">About</a>
    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-black d-flex align-items-center position-relative"
                           href="#" role="button" data-bs-toggle="dropdown">
                            <c:choose>
                                    <%-- Jika session userAvatar ada isinya (hasil upload) --%>
                                    <c:when test="${not empty sessionScope.userAvatar}">
                                        <img src="${pageContext.request.contextPath}/${sessionScope.userAvatar}" 
                                             width="32" height="32" class="rounded-circle me-2 shadow-sm" 
                                             style="object-fit: cover; border: 2px solid #fff;">
                                    </c:when>
                                </c:choose>
                            
                            <%-- Menampilkan Nama User --%>
                            <span class="fw-bold"><%= userName %></span>

                            <%-- Menampilkan Badge jika ada pesanan baru --%>
                            <% if (newOrdersCount > 0) { %>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    <%= newOrdersCount %>
                                </span>
                            <% } %>
                        </a>

                        <ul class="dropdown-menu dropdown-menu-end bg-warning shadow">
    <li><span class="dropdown-item fw-bold text-black border-bottom">Halo, <%= userName %></span></li>

    <%-- 🔔 HEADER STATUS --%>
    <li><h6 class="dropdown-header text-dark mt-2">🔔 Status Pesanan Terbaru</h6></li>

    <%
        List<Order> latestOrders = (List<Order>) request.getAttribute("latestOrders");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM HH:mm");

        if (latestOrders != null && !latestOrders.isEmpty()) {
            for (Order ord : latestOrders) {
                String status = ord.getStatus();
                // Logika Warna Status (Sama seperti Laravel Anda)
                String textClass = "text-primary";
                if (status.contains("Baru") || status.contains("Menunggu")) textClass = "text-info";
                else if (status.contains("Selesai") || status.contains("Lunas")) textClass = "text-success";
                else if (status.contains("Batal") || status.contains("Ditolak")) textClass = "text-danger";
    %>
        <li>
            <a class="dropdown-item small border-bottom py-2" href="#" style="line-height: 1.2;">
                <div class="d-flex justify-content-between">
                    <strong>#<%= ord.getId() %></strong>
                    <span class="text-muted" style="font-size: 10px;"><%= sdf.format(ord.getCreatedAt()) %></span>
                </div>
                <span class="<%= textClass %> fw-bold" style="font-size: 11px;">
                    Status: <%= status %>
                </span>
            </a>
        </li>
    <% 
            }
        } else { 
    %>
        <li><span class="dropdown-item text-muted small">Belum ada pesanan terbaru.</span></li>
    <% } %>

    <li><hr class="dropdown-divider"></li>
    <li><a class="dropdown-item" href="profile.jsp">Akun Saya</a></li>
    <li><a class="dropdown-item text-danger" href="LogoutServlet">Keluar</a></li>
</ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>


<header class="menu-header">
    <div class="container" data-aos="zoom-in">
        <h1 class="display-4 fw-bold mb-2">Daftar Menu Kami</h1>
        <p class="lead mb-4" style="color: #ffc107;">Pilih hidangan favoritmu dan rasakan kelezatannya</p>
        
        <div class="search-container shadow-lg">
            <div class="input-group">
                <span class="input-group-text bg-white border-0">
                    <i class="bi bi-search text-warning"></i>
                </span>
                <input type="text" id="searchInput" class="form-control ps-2 py-3" placeholder="Mau makan apa hari ini?">
            </div>
        </div>
    </div>
</header>

    <div class="container mt-4 mb-5" data-aos="fade-up">
        <div class="d-flex justify-content-center flex-wrap gap-2" id="menu-filters">
            <button class="btn btn-warning active" data-filter="all">Semua Menu</button>
            <button class="btn btn-outline-warning" data-filter="makanan">Makanan</button>
            <button class="btn btn-outline-warning" data-filter="minuman">Minuman</button>
            <button class="btn btn-outline-warning" data-filter="tambahan">Add-ons</button>
            <button class="btn btn-outline-warning" data-filter="populer">Populer</button>
            <button class="btn btn-outline-warning" data-filter="diskon">Diskon</button>
        </div>
    </div>

<div class="container my-5">
    <div class="row g-4" id="menu-list-container">
        <% 
            if (allMenu == null || allMenu.isEmpty()) { 
        %>
            <div class="col-12 text-center py-5">
                <i class="bi bi-egg-fried display-1 text-muted"></i>
                <h3 class="mt-3 text-muted">Menu belum tersedia</h3>
            </div>
        <% 
            } else { 
                for(Menu m : allMenu) { 
                    // 1. Hitung harga setelah diskon
                    double hargaFinal = m.getHarga() * (1 - (m.getDiskon() / 100.0));
                    
                    // 2. Tentukan Path Gambar (Mengambil dari m.getGambar())
                    // Jika database menyimpan nama file seperti "nasi-goreng.jpg"
             String finalImgUrl;

if (m.getGambar() != null && !m.getGambar().isEmpty()) {
    finalImgUrl = contextPath + "/" + m.getGambar();
} else {
    finalImgUrl = contextPath + "/img/makanan/sample.png";
}

        %>
            <div class="col-md-4 col-sm-6 menu-item" 
                 data-category="<%= (m.getKategori() != null) ? m.getKategori().toLowerCase() : "" %>"
                 data-popular="<%= m.getIsPopular() %>"
                 data-discount="<%= (m.getDiskon() > 0) %>">
                
                <div class="card h-100 shadow-sm border-0 position-relative">
                    <% if(m.getIsPopular()) { %> 
                        <span class="badge bg-danger position-absolute m-2 top-0 start-0 z-1">⭐ Populer</span> 
                    <% } %>
                    
                    <img src="<%= finalImgUrl %>" class="card-img-top" alt="<%= m.getNama() %>" style="height:220px; object-fit:cover;">
                    
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title fw-bold text-dark mb-1"><%= m.getNama() %></h5>
                        <p class="card-text text-muted small flex-grow-1"><%= m.getDeskripsi() %></p>
                        
                        <div class="mb-2">
                            <% if(m.getStok() > 0) { %>
                                <small class="text-success fw-bold"><i class="bi bi-box-seam"></i> Stok: <%= m.getStok() %></small>
                            <% } else { %>
                                <small class="text-danger fw-bold"><i class="bi bi-x-circle"></i> Habis</small>
                            <% } %>
                        </div>

                        <div class="price-group my-3">
                            <% if(m.getDiskon() > 0) { %>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="text-decoration-line-through text-muted small">Rp <%= nf.format(m.getHarga()) %></span>
                                    <span class="badge bg-success-subtle text-success small"><%= m.getDiskon() %>% OFF</span>
                                </div>
                                <span class="fw-bold text-danger fs-4">Rp <%= nf.format(hargaFinal) %></span>
                            <% } else { %>
                                <span class="fw-bold text-warning fs-4">Rp <%= nf.format(m.getHarga()) %></span>
                            <% } %>
                        </div>

                        <button class="btn btn-warning text-white w-100 fw-bold" 
        onclick="addToCart(<%= m.getId() %>, '<%= m.getNama() %>', <%= hargaFinal %>, '<%= finalImgUrl %>', <%= m.getStok() %>)" 
        <%= (m.getStok() <= 0 ? "disabled" : "") %>>
    <i class="bi bi-cart-plus-fill me-2"></i> Tambah Ke Keranjang
</button>
                    </div>
                </div>
            </div>
        <% 
                } 
            } 
        %>
    </div>
</div>

 <div class="position-fixed bottom-0 end-0 m-4 z-3">
    <a href="keranjang.jsp" class="btn btn-danger rounded-circle shadow-lg p-3 d-flex align-items-center justify-content-center" 
       style="width:65px; height:65px; text-decoration: none;">
        <i class="bi bi-cart-fill fs-3 text-white"></i>
        <span id="cart-count" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-dark">0</span>
    </a>
</div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
   <script>
    AOS.init({ duration: 800, once: true });

    // KUNCI UTAMA: Nama storage harus sama dengan keranjang.jsp
    const CART_KEY = 'guswarung_cart';

    // Jalankan ini agar pas halaman di-refresh, angka di badge tidak balik ke 0
    document.addEventListener('DOMContentLoaded', () => {
        updateCartBadge();
    });

    // FUNGSI ADD TO CART YANG BENAR (Menyimpan Objek Lengkap)
    function addToCart(id, nama, harga, gambar, stok) {
        let cart = JSON.parse(localStorage.getItem(CART_KEY)) || [];
        
        // Cari apakah barang sudah ada di keranjang
        const existingItemIndex = cart.findIndex(item => item.id === id);

        if (existingItemIndex > -1) {
            // Jika sudah ada, cek stok lalu tambah quantity
            if (cart[existingItemIndex].quantity < stok) {
                cart[existingItemIndex].quantity += 1;
            } else {
                alert("Stok tidak mencukupi!");
                return;
            }
        } else {
            // Jika belum ada, masukkan objek lengkap agar bisa muncul di keranjang.jsp
            cart.push({
                id: id,
                name: nama,
                price: harga,
                image: gambar,
                stok: stok,
                quantity: 1
            });
        }

        // Simpan ke LocalStorage
        localStorage.setItem(CART_KEY, JSON.stringify(cart));
        
        // Update tampilan badge
        updateCartBadge();
        alert("Berhasil menambahkan " + nama + " ke keranjang!");
    }

    function updateCartBadge() {
        const cart = JSON.parse(localStorage.getItem(CART_KEY)) || [];
        // Hitung total quantity semua barang
        const totalCount = cart.reduce((sum, item) => sum + item.quantity, 0);
        document.getElementById('cart-count').innerText = totalCount;
    }

    // --- LOGIKA FILTER & SEARCH (Tetap sama) ---
    const filterButtons = document.querySelectorAll('#menu-filters button');
    const items = document.querySelectorAll('.menu-item');
    filterButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            filterButtons.forEach(b => b.classList.replace('btn-warning', 'btn-outline-warning'));
            btn.classList.replace('btn-outline-warning', 'btn-warning');
            const filter = btn.getAttribute('data-filter');
            items.forEach(item => {
                const category = item.getAttribute('data-category');
                const isPop = item.getAttribute('data-popular') === 'true';
                const isDisc = item.getAttribute('data-discount') === 'true';
                if (filter === 'all') item.style.display = 'block';
                else if (filter === 'populer') item.style.display = isPop ? 'block' : 'none';
                else if (filter === 'diskon') item.style.display = isDisc ? 'block' : 'none';
                else if (filter === 'tambahan') item.style.display = (category === 'addon' || category === 'tambahan') ? 'block' : 'none';
                else item.style.display = (category === filter) ? 'block' : 'none';
            });
        });
    });
    document.getElementById('searchInput').addEventListener('input', function() {
        const val = this.value.toLowerCase();
        items.forEach(item => {
            const text = item.querySelector('.card-title').innerText.toLowerCase();
            item.style.display = text.includes(val) ? 'block' : 'none';
        });
    });
</script>
</body>
</html>