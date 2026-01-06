package controllers;

import config.Koneksi;
import models.Inventaris;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

// =======================
// JAKARTA SERVLET (Tomcat 10+)
// =======================
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// =======================
// JIKA MASIH PAKAI JAVAX (Tomcat 9 ke bawah)
// =======================
// import javax.servlet.ServletException;
// import javax.servlet.annotation.WebServlet;
// import javax.servlet.http.HttpServlet;
// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "InventarisController", urlPatterns = {
    "/inventaris", 
    "/inventaris/simpan", 
    "/inventaris/update", 
    "/inventaris/hapus"
})
public class InventarisController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (request.getServletPath().equals("/inventaris")) {
            List<Inventaris> listBarang = new ArrayList<>();
            try (Connection conn = Koneksi.configDB()) {
                if (conn != null) {
                    String sql = "SELECT * FROM inventaris ORDER BY name ASC";
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);

                    while (rs.next()) {
                        listBarang.add(new Inventaris(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("quantity"),
                            rs.getString("unit"),
                            rs.getInt("minimal_stock"),
                            rs.getDouble("price"),
                            rs.getString("status")
                        ));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            request.setAttribute("dataStok", listBarang);
            request.getRequestDispatcher("/admin/Inventaris.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        try (Connection conn = Koneksi.configDB()) {
            if (action.equals("/inventaris/simpan")) {
                String sql = "INSERT INTO inventaris (name, quantity, unit, minimal_stock, price, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setString(1, request.getParameter("name"));
                pst.setInt(2, Integer.parseInt(request.getParameter("quantity")));
                pst.setString(3, request.getParameter("unit"));
                pst.setInt(4, Integer.parseInt(request.getParameter("minimal_stock")));
                pst.setDouble(5, Double.parseDouble(request.getParameter("price")));
                pst.setString(6, request.getParameter("status"));
                pst.executeUpdate();

            } else if (action.equals("/inventaris/update")) {
                String sql = "UPDATE inventaris SET quantity=?, unit=?, price=?, updated_at=NOW() WHERE name=?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setInt(1, Integer.parseInt(request.getParameter("quantity")));
                pst.setString(2, request.getParameter("unit"));
                pst.setDouble(3, Double.parseDouble(request.getParameter("price")));
                pst.setString(4, request.getParameter("name"));
                pst.executeUpdate();

            } else if (action.equals("/inventaris/hapus")) {
                String sql = "DELETE FROM inventaris WHERE id=?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setInt(1, Integer.parseInt(request.getParameter("id")));
                pst.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/inventaris");
    }
}