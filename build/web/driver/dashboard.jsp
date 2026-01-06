<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="models.User, java.util.List, models.Order" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"driver".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String userName = user.getName();
%>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Driver</title>
    <meta http-equiv="refresh" content="10"> <!-- auto refresh tiap 10 detik -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-5">

    <!-- HEADER -->
    <div class="card shadow-sm mb-4">
        <div class="card-body d-flex justify-content-between">
            <div>
                <h4 class="fw-bold">Halo, Driver 👋</h4>
                <span class="badge bg-success"></span>
            </div>
            <a href="<%=request.getContextPath()%>/LogoutServlet"
               class="btn btn-outline-danger">
                Logout
            </a>
        </div>
    </div>

    <!-- NOTIF PESANAN SIAP -->
    <div class="card shadow-sm">
        <div class="card-header fw-semibold bg-warning">
            🔔 Pesanan Siap Diantar
        </div>

        <div class="card-body">

            <table class="table table-bordered align-middle">
                <thead class="table-light">
                    <tr>
                        <th>ID Pesanan</th>
                        <th>Alamat Tujuan</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                            <!-- AMBIL PESANAN -->
                            <form action="<%=request.getContextPath()%>/DriverController"
                                  method="post" class="d-inline">
                                <input type="hidden" name="action" value="ambil">
                                <input type="hidden" name="orderId" value="">
                                <button class="btn btn-success btn-sm">
                                    Ambil Pesanan
                                </button>
                            </form>

                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>
