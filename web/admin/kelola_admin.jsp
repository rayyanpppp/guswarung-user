<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Kelola Admin - GusWarung</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Poppins', sans-serif; }
        .main-container { margin-top: 40px; margin-bottom: 40px; }
        .page-title { font-weight: 700; color: #2d3436; }
        .btn-back { text-decoration: none; color: #636e72; font-size: 0.9rem; display: inline-block; margin-bottom: 25px; }
        .btn-back:hover { color: #ffc107; }
        .card-table { border: none; border-radius: 15px; overflow: hidden; background: white; }
        .card-header-custom { padding: 20px 25px; border-bottom: 1px solid #f1f1f1; display: flex; justify-content: space-between; align-items: center; }
        .table thead th { font-weight: 600; text-transform: uppercase; font-size: 0.8rem; color: #636e72; padding: 15px; border: none; }
        .badge-id { background-color: #e8f0fe; color: #1a73e8; padding: 5px 10px; border-radius: 8px; font-weight: 600; }
        .btn-action { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 10px; border: none; margin: 0 2px; }
    </style>
</head>
<body>

<div class="container main-container text-start">
    <h2 class="page-title">Manajemen Data Admin</h2>
    <a href="admin/dashboard.jsp" class="btn-back"><i class="fas fa-arrow-left me-1"></i> Kembali ke Dashboard</a>

    <div class="card card-table shadow-sm">
        <div class="card-header-custom">
            <h5 class="mb-0 fw-bold"><i class="fas fa-user-shield me-2 text-warning"></i>Daftar Akun Admin</h5>
            <button class="btn btn-warning fw-bold px-4 shadow-sm" style="border-radius: 10px;" data-bs-toggle="modal" data-bs-target="#modalTambah">
                <i class="fas fa-plus-circle me-2"></i>Tambah Admin
            </button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th class="text-center" width="10%">ID</th>
                            <th>Nama Lengkap</th>
                            <th>Email Akun</th>
                            <th class="text-center" width="20%">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="admin" items="${adminList}">
                            <tr>
                                <td class="text-center"><span class="badge-id">#${admin[0]}</span></td>
                                <td class="fw-bold">${admin[1]}</td>
                                <td class="text-muted">${admin[2]}</td>
                                <td class="text-center">
                                    <button onclick="openEditModal('${admin[0]}', '${admin[1]}', '${admin[2]}')" class="btn btn-primary btn-action shadow-sm"><i class="fas fa-pencil-alt"></i></button>
                                    <a href="AdminServlet?action=delete&id=${admin[0]}" class="btn btn-danger btn-action shadow-sm" onclick="return confirm('Hapus admin ini?')"><i class="fas fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalTambah" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 20px;">
            <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
                <div class="modal-header border-0 pt-4 px-4">
                    <h5 class="fw-bold">Tambah Admin Baru</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body px-4 text-start">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Nama Lengkap</label>
                        <input type="text" name="name" class="form-control" placeholder="Nama admin" required style="border-radius: 10px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Email</label>
                        <input type="email" name="email" class="form-control" placeholder="email@guswarung.com" required style="border-radius: 10px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Password</label>
                        <div class="input-group">
                            <input type="password" name="password" id="passInput" class="form-control" required style="border-radius: 10px 0 0 10px;">
                            <button class="btn btn-outline-secondary" type="button" id="togglePass" style="border-radius: 0 10px 10px 0;"><i class="fas fa-eye"></i></button>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 pb-4 px-4">
                    <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning fw-bold px-4">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="modalEdit" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 20px;">
            <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="edit-id">
                <div class="modal-header border-0 pt-4 px-4">
                    <h5 class="fw-bold">Edit Data Admin</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body px-4 text-start">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Nama Lengkap</label>
                        <input type="text" name="name" id="edit-name" class="form-control" required style="border-radius: 10px;">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Email</label>
                        <input type="email" name="email" id="edit-email" class="form-control" required style="border-radius: 10px;">
                    </div>
                </div>
                <div class="modal-footer border-0 pb-4 px-4">
                    <button type="button" class="btn btn-light fw-bold" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary fw-bold px-4">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openEditModal(id, name, email) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-email').value = email;
        new bootstrap.Modal(document.getElementById('modalEdit')).show();
    }

    document.getElementById('togglePass').addEventListener('click', function() {
        const pass = document.getElementById('passInput');
        const icon = this.querySelector('i');
        if (pass.type === 'password') {
            pass.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            pass.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>