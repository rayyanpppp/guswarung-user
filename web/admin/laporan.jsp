<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Laporan - GusWarung</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        body { font-family: "Poppins", sans-serif; background-color: #fdf9f4; color: #3c2f2f; }
        .laporan-container { padding: 50px 80px; }
        .laporan-container h2 { font-weight: 700; color: #3b2b20; }
        .stat-card { background-color: #fff; border: 1px solid #e5e5e5; border-radius: 15px; padding: 25px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05); transition: all 0.3s ease; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1); }
        .stat-value { font-size: 1.7rem; font-weight: 700; color: #3b2b20; }
        .badge-selesai { background-color: #d4edda; color: #155724; padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; }
    </style>
</head>
<body>

    <div class="laporan-container">
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-warning mb-4" data-aos="fade-right">
            <i class="fas fa-arrow-left"></i> Kembali ke Dashboard
        </a>
        
        <h2 data-aos="fade-right">Laporan Penjualan</h2>
        <p data-aos="fade-left">Ringkasan penjualan dan performa warung</p>

        <div class="container my-5">
            <div class="row g-4">
                <div class="col-md-4" data-aos="zoom-in" data-aos-delay="100">
                    <div class="stat-card">
                        <p class="mb-1 text-muted">Total Pendapatan</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="stat-value">
                                Rp <fmt:formatNumber value="${totalRevenue}" pattern="#,###" />
                            </div>
                            <div class="rounded-4 p-2" style="background: #ffca28;">
                                <span class="material-symbols-outlined text-dark">payments</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4" data-aos="zoom-in" data-aos-delay="200">
                    <div class="stat-card">
                        <p class="mb-1 text-muted">Jumlah Transaksi</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="stat-value">${orders.size()}</div>
                            <div class="rounded-4 p-2" style="background: #03a9f4;">
                                <span class="material-symbols-outlined text-white">receipt_long</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-5">
                <div class="col-md-12" data-aos="fade-up">
                    <div class="card shadow-sm border-0 rounded-4 p-4">
                        <h5 class="fw-bold mb-4">Grafik Penjualan Terbaru</h5>
                        <div style="height:350px;">
                            <canvas id="salesChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <section class="my-5" data-aos="fade-up">
                <div class="card shadow-sm border-0 rounded-4 p-4">
                    <h5 class="fw-bold mb-4 text-center">10 Transaksi Terbaru</h5>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Waktu</th>
                                    <th>Pelanggan</th>
                                    <th>Metode</th>
                                    <th>Total Bayar</th>
                                    <th class="text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${orders}">
                                    <tr>
                                        <td>${o.createdAt}</td>
                                        <td><strong>${o.customerName}</strong><br><small>${o.customerPhone}</small></td>
                                        <td>${o.paymentMethod}</td>
                                        <td>Rp <fmt:formatNumber value="${o.totalAmount}" pattern="#,###" /></td>
                                        <td class="text-center">
                                            <span class="badge-selesai">${o.status}</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init();

        // LOGIKA GRAFIK
        const ctx = document.getElementById('salesChart').getContext('2d');
        const labels = [];
        const dataValues = [];

        <c:forEach var="o" items="${orders}" varStatus="loop">
            <c:if test="${loop.index < 10}"> // Ambil 10 data terakhir untuk grafik
                labels.push('${o.createdAt}');
                dataValues.push(${o.totalAmount});
            </c:if>
        </c:forEach>

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels.reverse(), // Reverse agar urutan waktu dari lama ke baru
                datasets: [{
                    label: 'Total Bayar (Rp)',
                    data: dataValues.reverse(),
                    backgroundColor: 'rgba(255, 193, 7, 0.6)',
                    borderColor: 'rgba(255, 193, 7, 1)',
                    borderWidth: 1,
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    </script>
</body>
</html>