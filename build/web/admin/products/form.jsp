<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>--%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>${empty product ? 'Tambah' : 'Edit'} Produk</title>

    <!-- BOOTSTRAP -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- CUSTOM STYLE -->
    <style>
        body {
            background: linear-gradient(180deg, #f8f9fa, #ffffff);
            font-family: 'Segoe UI', sans-serif;
        }

        .admin-card {
            border-radius: 18px;
            border: none;
            background: #ffffff;
            box-shadow: 0 20px 45px rgba(0,0,0,0.08);
            overflow: hidden;
        }

        .admin-header {
            background: linear-gradient(135deg, #ffb703, #ffc107);
            padding: 28px 32px;
        }

        .admin-header h3 {
            font-weight: 800;
            letter-spacing: .5px;
            margin: 0;
            color: #212529;
        }

        .admin-header small {
            color: rgba(0,0,0,.6);
        }

        .section-title {
            font-size: 13px;
            font-weight: 700;
            letter-spacing: .8px;
            text-transform: uppercase;
            color: #ffb703;
            margin-bottom: 14px;
        }

        .form-label {
            font-weight: 600;
            font-size: 14px;
        }

        .form-control,
        .form-select {
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 14px;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #ffb703;
            box-shadow: 0 0 0 .15rem rgba(255,183,3,.35);
        }

        .divider {
            border-top: 1px dashed #dee2e6;
            margin: 36px 0;
        }

        .image-preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 14px;
            border: 3px solid #ffb703;
            background: #f8f9fa;
        }

        .btn-main {
            background: linear-gradient(135deg, #ffb703, #ffc107);
            color: #212529;
            font-weight: 700;
            border: none;
            padding: 12px 28px;
            border-radius: 14px;
        }

        .btn-main:hover {
            background: linear-gradient(135deg, #ffa500, #ffb703);
        }

        .btn-cancel {
            border-radius: 14px;
            padding: 12px 24px;
            font-weight: 600;
        }
    </style>
</head>

<body>

<div class="container my-5" style="max-width: 960px;">
    <div class="admin-card">

        <!-- HEADER -->
        <div class="admin-header">
            <h3>${empty product ? 'Tambah Produk' : 'Edit Produk'}</h3>
            <small>Kelola data produk dengan tampilan profesional</small>
        </div>

        <!-- CONTENT -->
        <div class="p-4 p-md-5">
            <form method="POST" action="ProductServlet" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${product.id}">

                <!-- INFO PRODUK -->
                <div class="section-title">Informasi Produk</div>

                <div class="mb-4">
                    <label class="form-label">Nama Produk</label>
                    <input type="text" class="form-control"
                           name="nama"
                           value="${product.nama}"
                           placeholder="Contoh: Ayam Geprek Level 5"
                           required>
                </div>

                <div class="mb-4">
                    <label class="form-label">Deskripsi</label>
                    <textarea class="form-control" rows="3"
                              name="deskripsi"
                              placeholder="Deskripsi singkat produk">${product.deskripsi}</textarea>
                </div>

                <div class="divider"></div>

                <!-- HARGA & STOK -->
                <div class="section-title">Harga & Stok</div>

                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <label class="form-label">Harga (Rp)</label>
                        <input type="number" class="form-control"
                               name="harga" value="${product.harga}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Stok</label>
                        <input type="number" class="form-control"
                               name="stok" value="${product.stok}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Diskon (%)</label>
                        <input type="number" class="form-control"
                               name="diskon_persen" value="${product.diskon}" min="0" max="100">
                    </div>
                </div>

                <div class="divider"></div>

                <!-- KATEGORI -->
                <div class="section-title">Kategori</div>

                <div class="mb-4">
                    <select class="form-select" name="kategori" required>
                        <option value="">Pilih kategori</option>
                        <option value="makanan" ${product.kategori == 'makanan' ? 'selected' : ''}>🍛 Makanan</option>
                        <option value="minuman" ${product.kategori == 'minuman' ? 'selected' : ''}>🥤 Minuman</option>
                        <option value="addon" ${product.kategori == 'addon' ? 'selected' : ''}>➕ Add-on</option>
                    </select>
                </div>

                <div class="divider"></div>

                <!-- GAMBAR -->
                <div class="section-title">Media Produk</div>

                <div class="mb-4">
                    <label class="form-label">Upload Gambar</label>
                    <input type="file" class="form-control" name="gambar" accept="image/*">
                </div>

                <c:if test="${not empty product.gambar}">
                    <div class="mb-4 d-flex align-items-center gap-4">
                        <img src="${pageContext.request.contextPath}/${product.gambar}" class="image-preview">
                        <div class="text-muted">Gambar saat ini</div>
                    </div>
                </c:if>

                <!-- ACTION -->
                <div class="d-flex justify-content-end gap-3 mt-5">
                    <a href="ProductServlet?action=list" class="btn btn-outline-secondary btn-cancel">
                        Batal
                    </a>
                    <button type="submit" class="btn btn-main">
                        Simpan Produk
                    </button>
                </div>

            </form>
        </div>
    </div>
</div>

</body>
</html>
