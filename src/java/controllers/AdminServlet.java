package controllers;

import config.Koneksi;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try (Connection conn = Koneksi.configDB()) {
            switch (action) {
                case "delete":
                    hapusAdmin(conn, request, response);
                    break;
                default:
                    tampilkanDaftarAdmin(conn, request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection conn = Koneksi.configDB()) {

            if ("update".equals(action)) {

                // =========================
                // UPDATE ADMIN (TANPA PASSWORD)
                // =========================
                String id = request.getParameter("id");
                String sql = "UPDATE users SET name = ?, email = ? WHERE id = ? AND role = 'admin'";

                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setLong(3, Long.parseLong(id));
                ps.executeUpdate();

            } else {

                // =========================
                // TAMBAH ADMIN (HASH PASSWORD)
                // =========================
                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

                String sql = "INSERT INTO users (name, email, password, role, created_at) "
                           + "VALUES (?, ?, ?, 'admin', NOW())";

                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, hashedPassword); // 🔐 HASHED
                ps.executeUpdate();
            }

            response.sendRedirect("AdminServlet?action=list");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // =========================
    // LIST ADMIN
    // =========================
    private void tampilkanDaftarAdmin(Connection conn, HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        List<String[]> adminList = new ArrayList<>();
        String sql = "SELECT id, name, email FROM users WHERE role = 'admin'";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                adminList.add(new String[]{
                    rs.getString("id"),
                    rs.getString("name"),
                    rs.getString("email")
                });
            }
        }

        request.setAttribute("adminList", adminList);
        request.getRequestDispatcher("admin/kelola_admin.jsp").forward(request, response);
    }

    // =========================
    // DELETE ADMIN
    // =========================
    private void hapusAdmin(Connection conn, HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            long id = Long.parseLong(idParam);

            String sql = "DELETE FROM users WHERE id = ? AND role = 'admin'";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                ps.executeUpdate();
            }
        }
        response.sendRedirect("AdminServlet?action=list");
    }
}
