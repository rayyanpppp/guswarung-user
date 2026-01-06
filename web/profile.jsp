<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- Asumsi: Objek user disimpan di session dengan nama "user" --%>
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profil</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: #fffef8;
        }

        .profile-card {
            max-width: 700px;
            margin: 60px auto;
            padding: 35px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .avatar-preview {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #ffc107;
        }

        .upload-btn {
            background: #ffc107;
            color: #fff;
            font-weight: 600;
            border-radius: 25px;
        }
        
        .btn-group-action {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
    </style>
</head>

<body>

    <div class="profile-card">
        <h2 class="text-center text-warning fw-bold mb-4">Pengaturan Profil</h2>

        <%-- Menampilkan pesan sukses --%>
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">✅ ${sessionScope.success}</div>
            <% session.removeAttribute("success"); %>
        </c:if>

        <form method="POST" action="${pageContext.request.contextPath}/ProfileUpdateServlet" enctype="multipart/form-data">
            
            <div class="text-center mb-4">
                <c:set var="userAvatar" value="${user.avatar != null ? user.avatar : 'img/default.jpg'}" />
                <img id="avatarPreview" src="${pageContext.request.contextPath}/${userAvatar}" class="avatar-preview">

                <div class="mt-2">
                    <label for="avatar" class="upload-btn btn btn-sm">Upload Foto</label>
                    <input type="file" id="avatar" name="avatar" class="d-none" accept="image/*">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Nama</label>
                <input type="text" name="name" class="form-control" value="${user.name}" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Password Baru</label>
                <input type="password" name="password" class="form-control"
                    placeholder="Kosongkan jika tidak ingin mengubah password">
            </div>

            <div class="row mb-3">
                <div class="col">
                    <label class="form-label">No. Telepon</label>
                    <input type="text" name="phone" class="form-control" value="${user.phone}">
                </div>

                <div class="col">
                    <label class="form-label">Kota</label>
                    <input type="text" name="kota" class="form-control" value="${user.kota}">
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="${user.email}" required>
            </div>

            <div class="btn-group-action">
                <button type="submit" class="btn btn-success w-100 fw-semibold rounded-pill py-2">
                    Simpan Perubahan
                </button>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary w-100 rounded-pill py-2">
                    Home
                </a>
            </div>
        </form>
    </div>

    <script>
        document.getElementById("avatar").addEventListener("change", function (e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (event) {
                    document.getElementById("avatarPreview").src = event.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    </script>

</body>
</html>