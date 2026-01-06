package controllers;

import config.Koneksi;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
// Menggunakan jakarta.servlet karena menggunakan Tomcat 10+
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
            if (action.equals("list")) {
                tampilkanDaftarAdmin(conn, request, response);
            } else if (action.equals("delete")) {
                hapusAdmin(conn, request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
                String id = request.getParameter("id");
                String sql = "UPDATE users SET name = ?, email = ? WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setLong(3, Long.parseLong(id));
                ps.executeUpdate();
            } else {
                // Tambah Admin Baru dengan Password
                String sql = "INSERT INTO users (name, email, password, role, created_at) VALUES (?, ?, ?, 'admin', NOW())";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.executeUpdate();
            }
            response.sendRedirect("AdminServlet?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void tampilkanDaftarAdmin(Connection conn, HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<String[]> adminList = new ArrayList<>();
        String sql = "SELECT id, name, email FROM users WHERE role = 'admin'";
        
        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
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

    private void hapusAdmin(Connection conn, HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            long id = Long.parseLong(idParam);
            String sql = "DELETE FROM users WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setLong(1, id);
                ps.executeUpdate();
            }
        }
        response.sendRedirect("AdminServlet?action=list");
    }
}