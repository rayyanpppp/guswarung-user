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

<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>
<!DOCTYPE html>
<html>
<head>
    <title>Manajemen Produk</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container my-5">
    <h2 class="mb-4 text-warning">Manajemen Produk</h2>
    
    <div class="mb-3">
        <a href="form.jsp" class="btn btn-success">Tambah Produk Baru</a>
        <a href="../dashboard.jsp" class="btn btn-outline-secondary">Kembali ke Dashboard</a>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive p-3">
            <table class="table table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Gambar</th>
                        <th>Nama</th>
                        <th>Kategori</th>
                        <th>Harga</th>
                        <th>Stok</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
               <tbody>
<c:forEach var="menu" items="${menus}">
    <tr>
        <td>${menu.id}</td>
        <td>
            <c:if test="${not empty menu.gambar}">
    <img src="${pageContext.request.contextPath}/${menu.gambar}"
         width="50" class="rounded">
</c:if>

        </td>
        <td>${menu.nama}</td>
        <td><span class="badge bg-info text-dark">${menu.kategori}</span></td>
        <td>
            <fmt:formatNumber value="${menu.harga}" type="currency"
                              currencySymbol="Rp " maxFractionDigits="0"/>
        </td>
        <td>${menu.stok}</td>
        <td>
            <a href="ProductServlet?action=edit&id=${menu.id}" class="btn btn-sm btn-primary">Edit</a>
            <a href="ProductServlet?action=delete&id=${menu.id}"
               class="btn btn-sm btn-danger"
               onclick="return confirm('Hapus produk ini?')">Hapus</a>
        </td>
    </tr>
</c:forEach>
</tbody>

            </table>
        </div>
    </div>
</div>
</body>
</html>