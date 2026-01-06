<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String userName = user.getName();
%>
<!DOCTYPE html>
<html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Panel - GusWarung</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

        <style>
            body {
                background-color: #f4f7f6;
                font-family: 'Poppins', sans-serif;
            }
            .navbar-admin {
                background-color: #ffc107 !important;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .nav-link {
                color: #000 !important;
                font-weight: 500;
            }
            .card-menu {
                border: none;
                border-radius: 20px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                text-decoration: none;
                color: inherit;
                display: block;
                background: white;
                border: 1px solid rgba(0,0,0,0.05);
            }
            .card-menu:hover {
                transform: translateY(-8px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.08);
                border-color: #ffc107;
            }
            .icon-box {
                width: 55px;
                height: 55px;
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>

        <nav class="navbar navbar-expand-lg navbar-admin sticky-top">
            <div class="container">
                <a class="navbar-brand fw-bold text-dark" href="dashboard.jsp">
                    <i class="fas fa-store me-2"></i>GusWarung <span class="badge bg-dark ms-2" style="font-size: 0.6em;">ADMIN</span>
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="adminNav">
                    <ul class="navbar-nav me-auto"></ul>
                    <ul class="navbar-nav align-items-center">
                        <li class="nav-item me-3">
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle fw-bold d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle fs-4 me-2"></i> <%= userName%>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2">
                                <li><a class="dropdown-item rounded" href="profile.jsp"><i class="fas fa-cog me-2"></i>Pengaturan</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger rounded" href="../LogoutServlet"><i class="fas fa-sign-out-alt me-2"></i>Keluar</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container my-5">
            <div class="row mb-5">
                <div class="col-12">
                    <h2 class="fw-bold mb-1">Selamat Datang, <%= userName%>! 👋</h2>
                    <p class="text-muted">Pantau dan kelola pesanan warung secara real-time.</p>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <a href="products/ProductServlet?action=list" class="card-menu p-4 h-100 shadow-sm">
                        <div class="icon-box bg-warning text-white shadow-sm">
                            <i class="fas fa-utensils fa-xl"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Manajemen Produk</h5>
                        <p class="text-muted small mb-0">Atur menu, kategori, harga, dan diskon warung.</p>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/inventaris" class="card-menu p-4 h-100 shadow-sm">
                        <div class="icon-box bg-primary text-white shadow-sm">
                            <i class="fas fa-boxes fa-xl"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Manajemen Stok</h5>
                        <p class="text-muted small mb-0">Pantau sisa porsi menu dan ketersediaan stok.</p>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/admin/orders?action=index" class="card-menu p-4 h-100 shadow-sm">
                        <div class="icon-box bg-success text-white shadow-sm">
                            <i class="fas fa-receipt fa-xl"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Kelola Pesanan</h5>
                        <p class="text-muted small mb-0">Cek pesanan masuk, bukti transfer, dan status kirim.</p>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/admin/laporan.jsp" class="card-menu p-4 h-100 shadow-sm">
                        <div class="icon-box bg-info text-white shadow-sm">
                            <i class="fas fa-chart-line fa-xl"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Laporan Penjualan</h5>
                        <p class="text-muted small mb-0">Analisis pendapatan harian dan bulanan warung.</p>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/AdminServlet?action=list" class="card-menu p-4 h-100 shadow-sm">
                        <div class="icon-box bg-dark text-white shadow-sm">
                            <i class="fas fa-user-shield fa-xl"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Kelola Admin</h5>
                        <p class="text-muted small mb-0">Mengelola hak akses dan data akun administrator.</p>
                    </a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>