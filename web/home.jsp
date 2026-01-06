<%@ page import="models.Order, java.util.List, java.text.SimpleDateFormat" %>
<%@ page import="models.User" %>

<%
    // Ambil object user dari session
    User user = (User) session.getAttribute("user");

    // Cek login
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

//     Ambil data dari object user
//    String userName = user.getname();
//    String role = user.getRole();
//    if (!"customer".equalsIgnoreCase(user.getRole())
//        && !"driver".equalsIgnoreCase(user.getRole())) {
//        response.sendRedirect("login.jsp");
//        return;
//    }
%>

<%
    // Mendapatkan nama file atau servlet yang sedang diakses
    String currentPath = request.getRequestURI();
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <title>Gus Warung</title>
        <link rel="icon" href="${pageContext.request.contextPath}/img/logo/logo.png">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
        <script>
            AOS.init();
        </script>
        <style>
            /* ======= STYLE GLOBAL ======= */

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Poppins", sans-serif;
            }

            body {
                background-color: #fffef8;
                color: #222;
            }

            a {
                text-decoration: none;
                color: inherit;
            }

            header {
                width: 100%;
                padding: 20px 60px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: linear-gradient(90deg, #ffb703, #8bc34a);
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
            }

            .logo {
                font-weight: 800;
                font-size: 1.6rem;
                color: #222;
            }

            .logo span {
                color: #ff5722;
            }

            .navbar-brand {
                display: flex;
                align-items: center;
                /* sejajarkan logo dan teks di tengah vertikal */
                gap: 10px;
                /* beri jarak kecil antara logo dan teks */
            }

            .navbar-brand img {
                display: inline-block;
                vertical-align: middle;
                /* pastikan logo ikut rata tengah */
                margin-bottom: 0 !important;
                /* hilangkan offset bawah */
            }

            .nav-link.active {
                color: #fff !important;
                background-color: rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                padding: 8px 16px;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
                transition: all 0.3s ease;
            }

            /* ======= HERO SECTION ======= */

            .hero {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 60px 80px;
                background: linear-gradient(120deg, #fff8e1 0%, #f1f8e9 100%);
            }

            .hero-text {
                flex: 1;
            }

            .search-bar {
                margin-top: 25px;
                display: flex;
            }

            .search-bar input {
                padding: 12px 18px;
                width: 60%;
                border: 2px solid #ccc;
                border-radius: 25px 0 0 25px;
                outline: none;
                font-size: 1rem;
            }

            .search-bar button {
                background-color: #ff5722;
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 0 25px 25px 0;
                cursor: pointer;
                font-weight: 600;
            }

            .search-bar button:hover {
                background-color: #e64a19;
            }

            .hero-img {
                flex: 1;
                text-align: right;
            }

            .hero-img img {
                width: 420px;
                border-radius: 25px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            }

            .hero-scroll {
                display: flex;
                overflow-x: auto;
                scroll-snap-type: x mandatory;
                width: 100%;
                height: 100vh;
                background: #fffef8;
            }

            .hero-scroll::-webkit-scrollbar {
                height: 8px;
            }

            .hero-scroll::-webkit-scrollbar-thumb {
                background: rgba(255, 87, 34, 0.7);
                border-radius: 10px;
            }

            /* Tiap slide hero */
            .hero-slide {
                flex: 0 0 100%;
                position: relative;
                scroll-snap-align: start;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 4rem;
                color: white;
                background-color: #111;
                background-size: cover;
                background-position: center;
            }

            .hero-slide:nth-child(1) {
                background-image: url("${pageContext.request.contextPath}/img/restoran.jpeg");
            }

            .hero-slide:nth-child(2) {
                background-image: url("${pageContext.request.contextPath}/img/makan-makan.webp");
            }

            .hero-slide:nth-child(3) {
                background-image: url("${pageContext.request.contextPath}/img/dapur.png");
            }

            /* Transparan overlay di belakang teks */

            .hero-overlay {
                position: absolute;
                inset: 0;
                background: rgba(61, 59, 59, 0.466);
                backdrop-filter: blur(3px);
                z-index: 0;
            }

            /* Konten di atas overlay */

            .hero-slide .hero-text,
            .hero-slide .hero-img {
                position: relative;
                z-index: 1;
            }

            .hero-slide .hero-text h1 {
                font-size: 2.8rem;
                font-weight: 800;
                line-height: 1.3;
            }

            .hero-slide .search-bar {
                margin-top: 25px;
                display: flex;
            }

            .hero-slide .search-bar input {
                padding: 12px 18px;
                width: 60%;
                border: 2px solid #ccc;
                border-radius: 25px 0 0 25px;
                outline: none;
                font-size: 1rem;
            }

            .hero-slide .search-bar button {
                background-color: #8bc34a;
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 0 25px 25px 0;
                cursor: pointer;
                font-weight: 600;
            }

            .hero-slide .search-bar button:hover {
                background-color: #689f38;
            }

            .hero-slide .hero-img {
                flex: 1;
                text-align: right;
            }

            .hero-slide .hero-img img {
                width: 400px;
                border-radius: 25px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            }

            /* Responsif */

            @media (max-width: 900px) {
                .hero-slide {
                    flex-direction: column;
                    text-align: center;
                }

                .hero-slide .hero-img {
                    margin-top: 30px;
                }
            }

            .card:hover {
                transform: translateY(-4px);
                transition: 0.3s ease;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.15);
            }

            /* ======= CATEGORY ======= */

            .category-card {
                border-radius: 18px;
                transition: all 0.3s ease-in-out;
                background-color: #ffffff;
            }

            .category-card img {
                height: 170px;

                object-fit: cover;
                border-radius: 18px 18px 0 0;
            }

            .category-card .card-body {
                padding: 15px;
                background: #fffef8;
            }

            .category-card:hover {
                transform: translateY(-5px) scale(1.03);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
                background-color: #f1f8e9;
            }

            .category-card p {
                margin: 0;
                color: #444;
                font-size: 1.1rem;
            }

            /* Responsif */
            @media (max-width: 768px) {
                .category-card img {
                    height: 140px;
                }

                .category-card p {
                    font-size: 1rem;
                }
            }

            @media (max-width: 480px) {
                .category-card img {
                    height: 120px;
                }

                .category-card p {
                    font-size: 0.95rem;
                }
            }

            .categories {
                padding: 50px 60px;
                background-color: #fffef8;
                text-align: center;
            }

            .categories h2 {
                font-size: 2rem;
                color: #222;
                margin-bottom: 30px;
            }

            .cat-list {
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
                gap: 25px;
            }

            .cat-item {
                background: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                width: 130px;
                transition: 0.3s;
            }

            .cat-item img {
                width: 100%;
                border-radius: 10px;
            }

            .cat-item p {
                margin-top: 8px;
                font-weight: 600;
                color: #444;
            }

            .cat-item:hover {
                transform: scale(1.05);
                background: #f1f8e9;
            }

            /* ======= POPULAR MENU ======= */

            .popular {
                padding: 60px 80px;
                background: linear-gradient(90deg, #fff8e1, #f1f8e9);
            }

            .popular h2 {
                text-align: center;
                font-size: 2rem;
                margin-bottom: 40px;
                color: #222;
            }

            .menu-list {
                display: flex;
                justify-content: space-around;
                flex-wrap: wrap;
                gap: 10px;
            }

            .menu-card {
                background-color: white;
                width: 350px;
                border-radius: 20px;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
                overflow: hidden;
                transition: 0.3s;
            }

            .menu-card:hover {
                transform: translateY(-10px);
            }

            .menu-card img {
                width: 100%;
                height: 180px;
                object-fit: cover;
            }

            .menu-card h3 {
                margin: 15px;
                font-size: 1.2rem;
                color: #333;
            }

            .menu-card p {
                margin: 0 15px 15px;
                color: #666;
                font-size: 0.95rem;
            }

            .menu-card button {
                width: 100%;
                padding: 12px;
                border: none;
                background: #8bc34a;
                color: white;
                font-weight: 600;
                cursor: pointer;
                border-radius: 0 0 20px 20px;
            }

            .menu-card button:hover {
                background: #7cb342;
            }

            /* ======= SUBMIT RECIPE ======= */

            .submit-section {
                padding: 70px 80px;
                text-align: center;
            }

            .submit-section h2 {
                font-size: 2rem;
                color: #222;
            }

            .submit-section p {
                margin: 15px 0;
                color: #555;
            }

            .submit-section button {
                padding: 12px 25px;
                border: none;
                border-radius: 25px;
                background: linear-gradient(90deg, #ff5722, #8bc34a);
                color: white;
                font-weight: 600;
                font-size: 1rem;
                cursor: pointer;
            }

            .submit-section button:hover {
                opacity: 0.9;
            }

            /* ======= FOOTER ======= */

            footer {
                background: #222;
                color: #fff;
                padding: 50px 80px;
            }

            footer .footer-content {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 30px;
            }

            footer h3 {
                color: #ffb703;
                margin-bottom: 15px;
            }

            footer p,
            footer a {
                color: #ccc;
                font-size: 0.95rem;
            }

            footer a:hover {
                color: #ffb703;
            }

            .social-icons {
                margin-top: 10px;
            }

            .social-icons a {
                margin-right: 15px;
                color: #ffb703;
                font-size: 1.3rem;
            }

            .social-icons a:hover {
                color: #fff;
            }

            /* ======= RESPONSIVE ======= */

            @media (max-width: 900px) {
                .hero {
                    flex-direction: column;
                    text-align: center;
                }

                .hero-img {
                    margin-top: 30px;
                }

                .menu-list {
                    justify-content: center;
                }
            }

            /*STYLE promo */

            .promo-card img {
                height: 200px;
                object-fit: cover;
                border-radius: 12px 12px 0 0;
            }

            .promo-card {
                border-radius: 12px;
                transition: all 0.3s ease-in-out;
            }

            .promo-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            }

            .promo-card button {
                border-radius: 25px;
                transition: 0.3s;
            }

            .promo-card button:hover {
                opacity: 0.9;
            }

            .promo-bestdeal {
                background: linear-gradient(90deg, #fff8e1 0%, #f1f8e9 100%);
            }

            .discount-badge {
                border: 4px solid white;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
            }

            .btn-success:hover {
                background-color: #388e3c !important;
                transform: translateY(-2px);
                transition: 0.3s;
            }

            @media (max-width: 768px) {
                .promo-bestdeal h2 {
                    font-size: 2rem;
                    text-align: center;
                }

                .promo-bestdeal p {
                    text-align: center;
                }
            }

            /* Parent submenu container */
            .dropdown-submenu {
                position: relative;
            }

            /* Submenu hidden awal */
            .submenu-list {
                display: none;
                position: relative;
                background-color: #ffc107 !important;
                border-radius: 6px;
                margin-top: 5px;
                /* supaya tidak menutupi tombol logout */
                padding: 5px 0;
            }

            /* item styling */
            .dropdown-item {
                padding: 8px 15px;
            }

            .submenu-list .dropdown-item:hover {
                background-color: #f1b700;
            }

            .toggle-submenu {
                cursor: pointer;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .toggle-submenu .arrow {
                transition: transform 0.2s ease;
            }

            /* panah berputar ketika submenu terbuka */
            .toggle-submenu.open .arrow {
                transform: rotate(180deg);
            }
        </style></head>

    <body>

        <%
            // 1. Ambil nama user dari session (pastikan nama atribut sama dengan di Servlet)
            String userName = (String) session.getAttribute("userName");

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

        <!-- ================= NAVBAR ================= -->
        <nav class="fixed-top navbar navbar-expand-lg shadow-lg" style="background-color:#ffc107">
            <div class="container">
                <a class="navbar-brand fw-bold text-white" href="home.jsp">
                    <img src="${pageContext.request.contextPath}/img/logo/logo.png" width="40"> GusWarung
                </a>

                <div class="collapse navbar-collapse justify-content-end">
                    <ul class="navbar-nav align-items-center">
                        <li class="nav-item">
                            <a class="nav-link text-black <%= currentPath.contains("home") ? "active fw-bold border-bottom border-dark" : ""%>" href="home">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-black <%= currentPath.contains("sell") ? "active fw-bold border-bottom border-dark" : ""%>" href="sell">Penjualan</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-black <%= currentPath.contains("about") ? "active fw-bold border-bottom border-dark" : ""%>" href="about.jsp">About</a>
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
                                <span class="fw-bold"><%= userName%></span>

                                <%-- Menampilkan Badge jika ada pesanan baru --%>
                                <% if (newOrdersCount > 0) {%>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    <%= newOrdersCount%>
                                </span>
                                <% }%>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end bg-warning shadow">
                                <li><span class="dropdown-item fw-bold text-black border-bottom">Halo, <%= userName%></span></li>
                                <li><h6 class="dropdown-header text-dark mt-2">🔔 Status Pesanan Terbaru</h6></li>

                                <%
                                    List<Order> latestOrders = (List<Order>) request.getAttribute("latestOrders");
                                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM HH:mm");

                                    if (latestOrders != null && !latestOrders.isEmpty()) {
                                        for (Order ord : latestOrders) {
                                            String status = ord.getStatus();
                                            String textClass = "text-primary";

                                            // Logika warna status
                                            if (status.contains("Baru") || status.contains("Menunggu"))
                                                textClass = "text-info";
                                            else if (status.contains("Selesai") || status.contains("Lunas"))
                                                textClass = "text-success";
                                            else if (status.contains("Batal"))
                                                textClass = "text-danger";
                                %>
                                <li>
                                    <a class="dropdown-item small border-bottom py-2" href="#" style="line-height: 1.2;">
                                        <div class="d-flex justify-content-between">
                                            <strong>#<%= ord.getId()%></strong>
                                            <span class="text-muted" style="font-size: 10px;"><%= sdf.format(ord.getCreatedAt())%></span>
                                        </div>
                                        <span class="<%= textClass%> fw-bold" style="font-size: 11px;">Status: <%= status%></span>
                                    </a>
                                </li>
                                <%
                                    }
                                } else {
                                %>
                                <li><span class="dropdown-item text-muted small">Belum ada pesanan terbaru.</span></li>
                                    <% }%>

                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="profile.jsp">Akun Saya</a></li>
                                <li><a class="dropdown-item text-danger" href="LogoutServlet">Keluar</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero section -->
        <section class="hero-scroll">
            <div class="hero-slide">
                <div class="hero-overlay"></div>
                <div class="hero-text">
                    <<h2 class="text-warning">Hello, <%= userName%>!</h2>
                    <h1>
                        Nikmati Cita Rasa <br /><span>Nusantara</span> dari Warung Favoritmu
                    </h1>
                    <div class="card p-4 shadow-sm mx-auto" style="
                         max-width: 850px;
                         border-radius: 18px;
                         background-color: #ffe240;
                         border: 1px solid #eee;
                         ">
                        <p class="mb-0" style="
                           text-align: justify;
                           color: #444;
                           font-size: 1.05rem;
                           line-height: 1.7;
                           ">
                            Gus Warung adalah pengembangan digital dari sebuah UMKM kuliner
                            lokal yang kini hadir dalam bentuk platform online. Kami
                            berkomitmen menghadirkan pengalaman menikmati hidangan warung
                            tradisional dengan cara yang lebih mudah dan modern. Melalui
                            digitalisasi, Gus Warung tetap menjaga cita rasa khas warung,
                            pelayanan hangat, dan harga terjangkau bagi semua kalangan.
                        </p>
                    </div>
                </div>
                <div class="hero-img">
                    <img src="${pageContext.request.contextPath}/img/kursi.jpg" alt="Makanan Warung" />
                </div>
            </div>

            {{-- SLIDE 2 --}}
            <div class="hero-slide">
                <div class="hero-overlay"></div>
                <div class="hero-text">
                    <h1>
                        Nikmati Cita Rasa <br /><span>Nusantara</span> dari Warung Favoritmu
                    </h1>
                    <div class="card p-4 shadow-sm mx-auto" style="
                         max-width: 850px;
                         border-radius: 18px;
                         background-color: #ffe240;
                         border: 1px solid #eee;
                         ">
                        <p class="mb-0" style="
                           text-align: justify;
                           color: #444;
                           font-size: 1.05rem;
                           line-height: 1.7;
                           ">
                            Gus Warung berkomitmen menjadi jembatan antara warung lokal dan
                            pelanggan di era digital. Kami ingin setiap orang, di mana pun
                            berada, bisa menikmati cita rasa khas Nusantara tanpa kehilangan
                            sentuhan kehangatan warung tradisional. Inilah langkah kecil kami
                            untuk menjaga budaya kuliner Indonesia tetap hidup di dunia
                            digital.
                        </p>
                    </div>
                </div>
                <div class="hero-img">
                    <img src="${pageContext.request.contextPath}/img/AyamBakar.jpg" alt="Makanan Warung" />
                </div>
            </div>

            {{-- SLIDE 3 --}}
            <div class="hero-slide">
                <div class="hero-overlay"></div>
                <div class="hero-text">
                    <h1>
                        Nikmati Cita Rasa <br /><span>Nusantara</span> dari Warung Favoritmu
                    </h1>
                    <div class="card p-4 shadow-sm mx-auto" style="
                         max-width: 850px;
                         border-radius: 18px;
                         background-color: #ffe240;
                         border: 1px solid #ffffff;
                         ">
                        <p class="mb-0" style="
                           text-align: justify;
                           color: #444;
                           font-size: 1.05rem;
                           line-height: 1.7;
                           ">
                            Chef Baguz adalah sosok di balik setiap hidangan lezat yang
                            menjadi ciri khas Gus Warung. Berawal dari dapur sederhana warung
                            keluarga, ia menghadirkan cita rasa Nusantara yang tetap autentik
                            di era digital. Dengan dedikasi dan kecintaannya terhadap masakan
                            rumahan, Chef Gus terus berinovasi menghadirkan hidangan yang
                            menggugah selera tanpa meninggalkan cita rasa khas warung.
                        </p>
                    </div>
                </div>
                <div class="hero-img">
                    <img src="${pageContext.request.contextPath}/img/chef baguz.jpg" alt="Makanan Warung" />
                </div>
            </div>
        </section>
        <!-- ======= KATEGORI PILIHAN ======= -->
        <section class="categories py-5 bg-light">
            <div class="container text-center">
                <h2 class="fw-bold mb-4 text-dark">Kategori Pilihan</h2>

                <div class="row justify-content-center g-4">
                    <!-- Card 1 -->
                    <div class="col-6 col-md-3">
                        <div class="card category-card shadow-sm border-0">
                            <img src="${pageContext.request.contextPath}/img/nasi ayam.jpg" class="card-img-top" alt="Aneka Nasi" />
                            <div class="card-body">
                                <p class="card-text fw-semibold text-dark">Aneka Nasi</p>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2 -->
                    <div class="col-6 col-md-3">
                        <div class="card category-card shadow-sm border-0">
                            <img src="${pageContext.request.contextPath}/img/bubur ayam.jpg" class="card-img-top" alt="Bubur ayam" />
                            <div class="card-body">
                                <p class="card-text fw-semibold text-dark">Bubur Ayam</p>
                            </div>
                        </div>
                    </div>

                    <!-- Card 3 -->
                    <div class="col-6 col-md-3">
                        <div class="card category-card shadow-sm border-0">
                            <img src="${pageContext.request.contextPath}/img/aneka minuman.jpg" class="card-img-top" alt="Sate" />
                            <div class="card-body">
                                <p class="card-text fw-semibold text-dark">Aneka Minuman</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ======= POPULAR MENU ======= -->
        <section class="popular">
            <h2>Menu Populer Minggu Ini</h2>
            <div class="menu-list">
                <div class="menu-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsMjQSgKyAzBRNvo_z1PwbdiXcXxR0gb198w&s"
                         alt="Nasi kuning" />
                    <h3>Nasi Kuning Ayam Goreng</h3>
                    <p>
                        Nasi kuning gurih dengan ayam goreng renyah, sambal pedas manis, dan
                        pelengkap tradisional yang lezat.
                    </p>
                    <div class="text-center my-3">
                        <a href="sell" class="btn btn-success fw-semibold shadow-sm w-100 py-3 rounded-pill"
                           style="max-width: 300px">
                            Pesan Sekarang
                        </a>
                    </div>
                </div>
                <div class="menu-card">
                    <img src="https://nibble-images.b-cdn.net/nibble/original_images/resep_bubur_ayam_04_be2a72a6b8.jpeg?class=large"
                         alt="Soto Ayam" />
                    <h3>Bubur Ayam Komplit Dewasa</h3>
                    <p>
                        Bubur ayam gurih dengan topping lengkap — suwiran ayam, cakwe,
                        bawang goreng, dan kuah kaldu hangat yang menggoda selera. Cocok
                        disantap kapan saja!
                    </p>
                    <div class="text-center my-3">
                        <a href="sell" class="btn btn-success fw-semibold shadow-sm w-100 py-3 rounded-pill"
                           style="max-width: 300px">
                            Pesan Sekarang
                        </a>
                    </div>
                </div>
                <div class="menu-card">
                    <img src="${pageContext.request.contextPath}/img/AyamBakar.jpg" alt="Ayam Bakar" />
                    <h3>Ayam Bakar</h3>
                    <p>
                        Ayam bakar dengan bumbu manis gurih khas tradisional, dibakar hingga
                        matang sempurna dan harum menggoda selera.
                    </p>
                    <div class="text-center my-3">
                        <a href="sell" class="btn btn-success fw-semibold shadow-sm w-100 py-3 rounded-pill"
                           style="max-width: 300px">
                            Pesan Sekarang
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- ======= PROMO UTAMA GUS WARUNG ======= -->
        <section class="promo-bestdeal py-5">
            <div class="container">
                <div class="row align-items-center justify-content-center g-4">
                    <!-- Gambar Promo -->
                    <div class="col-md-6 text-center">
                        <div class="promo-img position-relative d-inline-block">
                            <img src="${pageContext.request.contextPath}/img/AyamLaos.webp" class="rounded-circle shadow-lg" alt="Promo Best Deal" style="
                                 width: 280px;
                                 height: 280px;
                                 object-fit: cover;
                                 border: 8px solid #f1f8e9;
                                 " />
                            <div class="discount-badge position-absolute top-0 end-0 bg-success text-white fw-bold rounded-circle d-flex align-items-center justify-content-center"
                                 style="
                                 width: 80px;
                                 height: 80px;
                                 font-size: 1.3rem;
                                 transform: translate(25%, -25%);
                                 ">
                                50%
                                <span style="font-size: 0.9rem; display: block">OFF</span>
                            </div>
                        </div>
                    </div>

                    <!-- Teks Promo -->
                    <div class="col-md-6 text-center text-md-start">
                        <h2 class="fw-bold text-dark" style="font-size: 2.5rem">
                            TODAY’S <span style="color: #4caf50">BEST DEAL!</span>
                        </h2>
                        <p class="text-muted my-3" style="font-size: 1.1rem">
                            Nikmati promo hemat spesial dari <strong>Gus Warung</strong> untuk
                            menu pilihan hari ini! Cita rasa khas warung dengan potongan harga
                            hingga 50%. Pesan sekarang sebelum kehabisan!
                        </p>
                        <a href="sell" class="btn btn-success fw-semibold shadow-sm w-100 py-3 rounded-pill"
                           style="max-width: 300px">
                            Pesan Sekarang
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- ======= FOOTER ======= -->
        <footer style="background: #222; color: #eee; padding: 60px 20px">
            <div class="footer-content" style="
                 display: flex;
                 flex-wrap: wrap;
                 justify-content: space-around;
                 gap: 40px;
                 text-align: left;
                 ">
                <!-- Kolom 1 -->
                <div style="max-width: 300px">
                    <h3 style="color: #ffb703">GUSWarung</h3>
                    <p style="color: #ccc">
                        Platform kuliner untuk menjelajahi cita rasa Nusantara dari warung
                        lokal. Cepat, mudah, dan terpercaya.
                    </p>
                </div>

                <!-- Kolom 2 -->
                <div>
                    <h3 style="color: #ffb703">Menu</h3>
                    <a href="#" style="color: #ccc; text-decoration: none">Beranda</a><br />
                    <a href="#" style="color: #ccc; text-decoration: none">Tentang</a><br />
                    <a href="#" style="color: #ccc; text-decoration: none">Kontak</a><br />
                </div>

                <!-- Kolom 3 -->
                <div>
                    <h3 style="color: #ffb703">Ikuti Kami</h3>
                    <div class="social-icons" style="margin-top: 10px">
                        <a href="#" class="me-3 text-white fs-4"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="me-3 text-white fs-4"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-white fs-4"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
