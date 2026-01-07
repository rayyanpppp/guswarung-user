<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Laporan Penjualan - GusWarung</title>

    <!-- BOOTSTRAP & FONT -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background-color: #fdf9f4;
            color: #3c2f2f;
        }

        .page-wrapper {
            max-width: 1200px;
            margin: 48px auto;
            padding: 32px 40px;
        }

        .stat-card {
            background-color: #fff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,.08);
            height: 100%;
        }
    </style>
</head>
<body>

<div class="page-wrapper">

    <!-- ================= HEADER ================= -->
    <div class="mb-5">
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
            class="btn btn-warning mb-3">
            Kembali ke Dashboard
        </a>
        <h2 class="fw-bold mb-1">Laporan Penjualan</h2>
    </div>
    
    <a href="${pageContext.request.contextPath}/ExportReportPdf"
         class="btn btn-danger mb-3">
         <i class="fas fa-file-pdf"></i> Export PDF
    </a>


    <!-- ================= FILTER PERIODE ================= -->
    <div class="mb-4">
        <h5 class="fw-semibold mb-3">Total Penjualan per Periode</h5>

        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/ReportServlet?period=daily"
               class="btn ${period == 'daily' ? 'btn-warning' : 'btn-outline-warning'}">
                Hari Ini
            </a>

            <a href="${pageContext.request.contextPath}/ReportServlet?period=weekly"
               class="btn ${period == 'weekly' ? 'btn-warning' : 'btn-outline-warning'}">
                Minggu Ini
            </a>

            <a href="${pageContext.request.contextPath}/ReportServlet?period=monthly"
               class="btn ${period == 'monthly' ? 'btn-warning' : 'btn-outline-warning'}">
                Bulan Ini
            </a>
        </div>
    </div>

    <!-- ================= CARD RINGKASAN ================= -->
    <div class="row g-4 mt-3 mb-5">

        <div class="col-md-6">
            <div class="stat-card">
                <p class="text-muted mb-1">Total Penjualan</p>
                <h3 class="fw-bold">
                    Rp <fmt:formatNumber value="${revenue}" pattern="#,###"/>
                </h3>
                <small class="text-muted">${label}</small>
            </div>
        </div>

        <div class="col-md-6">
            <div class="stat-card">
                <p class="text-muted mb-1">Jumlah Transaksi</p>
                <h3 class="fw-bold">${totalOrders}</h3>
                <small class="text-muted">${label}</small>
            </div>
        </div>

    </div>

    <hr class="my-5">

    <!-- ================= TABEL TRANSAKSI ================= -->
    <h5 class="fw-semibold mb-3">10 Transaksi Terbaru</h5>

    <div class="table-responsive">
        <table class="table table-bordered align-middle bg-white">
            <thead class="table-light">
                <tr>
                    <th>Waktu</th>
                    <th>Pelanggan</th>
                    <th>Total</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${latestOrders}">
                    <tr>
                        <td>${o.createdAt}</td>
                        <td>${o.customerName}</td>
                        <td>
                            Rp <fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/>
                        </td>
                        <td>${o.status}</td>
                    </tr>
                </c:forEach>

                <c:if test="${empty latestOrders}">
                    <tr>
                        <td colspan="4" class="text-center text-muted py-4">
                            Tidak ada data transaksi
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    
    <hr class="my-5">

<h5 class="mt-5 mb-3">Laporan Stok Barang (Inventaris)</h5>

<div class="table-responsive">
    <table class="table table-bordered align-middle">
        <thead class="table-light">
            <tr>
                <th>Nama Barang</th>
                <th class="text-center">Stok</th>
                <th class="text-center">Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="i" items="${inventarisList}">
    <tr>
        <td>${i.name}</td>
        <td>${i.quantity} ${i.unit}</td>
        <td>
            <span class="badge 
                ${i.status == 'rendah' ? 'bg-danger' : 'bg-success'}">
                ${i.status}
            </span>
        </td>
    </tr>
</c:forEach>

        </tbody>
    </table>
</div>


<hr class="my-5">

<h5 class="mb-3">Penjualan Terbanyak</h5>

<div class="table-responsive">
    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>Produk</th>
                <th class="text-center">Total Terjual</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${topProducts}">
                <tr>
                    <td>${p.productName}</td>
                    <td class="text-center">${p.quantity}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>


</div>

</body>
</html>