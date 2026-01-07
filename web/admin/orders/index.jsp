<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <title>Kelola Pesanan - Admin GusWarung</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
</head>

<body class="bg-light">
    <div class="container my-5">
        <h1 class="mb-4 text-warning">Daftar Pesanan Baru</h1>
        <a href="/admin/dashboard.jsp" class="btn btn-outline-secondary mb-3">
            <i class="fas fa-arrow-left me-2"></i> Kembali ke Dashboard
        </a>
        <hr>

        <%-- Tampilkan Pesan Sukses (diambil dari session yang diset di AdminOrderServlet) --%>
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("success"); %>
        </c:if>

        <div class="table-responsive bg-white p-3 shadow-sm rounded">
            <table class="table table-striped table-hover align-middle">
                <thead class="bg-warning text-white">
                    <tr>
                        <th>ID Pesanan</th>
                        <th>Waktu</th>
                        <th>Nama Pelanggan</th>
                        <th>Total Bayar</th>
                        <th>Metode</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>#${order.id}</td>
                            <td>
                                <%-- Format tanggal agar mirip Laravel format('d M H:i') --%>
                                <fmt:formatDate value="${order.createdAt}" pattern="dd MMM HH:mm"/>
                            </td>
                            <td>${order.customerName}</td>
                            <td class="fw-bold">
                                Rp <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"/>
                            </td>
                            <td>
                                <span class="text-capitalize">${order.paymentMethod}</span>
                            </td>
                            <td>
                                <%-- Logika Badge Status (Pengganti @php match) --%>
                                <c:choose>
                                    <c:when test="${order.status == 'Lunas'}">
                                        <c:set var="badgeClass" value="bg-success" />
                                    </c:when>
                                    <c:when test="${order.status == 'Menunggu Pembayaran' || order.status == 'Baru (Menunggu Konfirmasi)'}">
                                        <c:set var="badgeClass" value="bg-info" />
                                    </c:when>
                                    <c:when test="${order.status == 'Menunggu Konfirmasi Admin'}">
                                        <c:set var="badgeClass" value="bg-warning text-dark" />
                                    </c:when>
                                    <c:when test="${order.status == 'Diproses'}">
                                        <c:set var="badgeClass" value="bg-primary" />
                                    </c:when>
                                    <c:when test="${order.status == 'Dibatalkan'}">
                                        <c:set var="badgeClass" value="bg-danger" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="badgeClass" value="bg-secondary" />
                                    </c:otherwise>
                                </c:choose>
                                <span class="badge ${badgeClass}">${order.status}</span>
                            </td>
                            <td>
                                <%-- Link mengarah ke Servlet action show --%>
                                <a href="${pageContext.request.contextPath}/admin/orders?action=show&id=${order.id}" class="btn btn-sm btn-outline-warning">
                                    <i class="fas fa-eye"></i> Detail
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <%-- Jika data kosong (Pengganti @empty) --%>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="7" class="text-center py-4">Belum ada pesanan yang masuk.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>