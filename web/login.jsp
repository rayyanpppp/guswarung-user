    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@ page isELIgnored="false" %>
    <!DOCTYPE html>
    <html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login Gus Warung</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                margin: 0;
                height: 100vh;
                overflow: hidden;
                font-family: Arial, sans-serif;
                background-color: #f7f7f7;
            }

            /* Left Image Section */
            .left-images {
                height: 100vh;
                padding: 20px;
                background: #111;
            }

            .left-images img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 14px;
            }

            /* Right Login Section */
            .right-login {
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 40px;
                height: 100vh;
            }

            .login-box {
                width: 100%;
                max-width: 380px;
            }

            .login-title {
                text-align: center;
                font-size: 32px;
                font-weight: 800;
                color: #e64a19;
            }

            .form-control {
                border-radius: 10px;
                box-shadow: none;
            }

            .btn-primary {
                background-color: #ff5722;
                color: white;
                font-size: 1.2rem;
                padding: 12px 30px;
                border-radius: 50px;
                border: none;
                text-transform: uppercase;
                font-weight: bold;
                transition: 0.3s ease;
            }

            .btn-primary:hover {
                background-color: #e64a19;
                cursor: pointer;
            }

            /* Mobile Responsiveness */
            @media (max-width: 768px) {
                .left-images {
                    display: none;
                }
                .right-login {
                    padding: 20px;
                }
                .login-box {
                    width: 100%;
                    max-width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="container-fluid h-100">
            <div class="row h-100">

                <div class="col-md-7 left-images">
                    <img src="${pageContext.request.contextPath}/img/gambar-login.png" alt="food-image">
                </div>

                <div class="col-md-5 right-login">
                    <div class="login-box">
                        <h1 class="login-title">Gus Warung</h1>
                        <h3 class="text-center mb-4">Login</h3>

                        <%-- PENGGANTI @if($errors->any()) MENGGUNAKAN JAVA SCRIPTLET --%>
                        <%
                            Object errorObj = request.getAttribute("errors");
                            if (errorObj != null) {
                                java.util.List<String> errors = (java.util.List<String>) errorObj;
                        %>
                            <div class="alert alert-danger">
                                <ul class="mb-0">
                                    <% for (String error : errors) { %>
                                        <li><%= error %></li>
                                    <% } %>
                                </ul>
                            </div>
                        <% } %>

                        <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">

                            <div class="mb-3">
                                <label class="form-label">Pilih Role</label>
                                <select class="form-select" name="role" required>
                                    <option value="admin">Admin</option>
                                    <option value="customer">Customer</option>
                                    <option value="driver">Driver</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Nama</label>
                                <input type="text" name="name" class="form-control" placeholder="Masukkan username" value="${param.name}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" placeholder="Masukkan email" value="${param.email}">
                            </div>

                            <div class="mb-3">
                                <label for="passwordInput" class="form-label">Password</label>
                                <div class="input-group">
                                    <input type="password" name="password" id="passwordInput" class="form-control" placeholder="Masukkan password" required>
                                    <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                        <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16">
                                            <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z" />
                                            <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z" />
                                        </svg>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mt-2">Login</button>

                            <div class="d-flex justify-content-between mt-3">
                                <a href="#" class="text-muted">Forgot password?</a>
                                <a href="register.jsp">Sign Up</a>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const togglePassword = document.getElementById('togglePassword');
                const passwordInput = document.getElementById('passwordInput');
                const eyeIcon = document.getElementById('eyeIcon');

                togglePassword.addEventListener('click', function () {
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);

                    if (type === 'text') {
                        // Ikon mata tertutup (X)
                        eyeIcon.innerHTML = '<path d="M13.359 11.237q.276-.239.527-.487q.263-.263.504-.539l-.497-.497a.499.499 0 0 0-.001-.707l-.41-.41a.5.5 0 0 0-.707 0L8 10.155l-2.753-2.753a.5.5 0 0 0-.707 0L4.13 8.358a.499.499 0 0 0-.001.707L5.51 9.957q-.276.239-.527.487q-.263.263-.504.539l.497.497a.499.499 0 0 0 .707 0l4.243-4.243 2.753 2.753a.5.5 0 0 0 .707 0l.41-.41a.5.5 0 0 0 0-.707zM8 3.5a3.5 3.5 0 1 0 0 7 3.5 3.5 0 0 0 0-7z"/><path d="M8 2a5.5 5.5 0 0 1 5.475 4.502c.002.096.002.193 0 .298A16.03 16.03 0 0 1 16 8s-3 5.5-8 5.5S0 8 0 8a16.03 16.03 0 0 1 2.525-3.201.5.5 0 0 0-.001.707L.13 8.358a.499.499 0 0 0-.001.707L5.51 9.957q-.276.239-.527.487q-.263.263-.504.539l.497.497a.499.499 0 0 0 .707 0l4.243-4.243 2.753 2.753a.5.5 0 0 0 .707 0l.41-.41a.5.5 0 0 0 0-.707z"/>';
                    } else {
                        // Ikon mata terbuka
                        eyeIcon.innerHTML = '<path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0z"/><path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8zm8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z"/>';
                    }
                });
            });
        </script>
    </body>
    </html>