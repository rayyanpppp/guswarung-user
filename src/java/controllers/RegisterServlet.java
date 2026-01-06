package controllers;

import config.Koneksi;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Ambil data yang BENAR-BENAR ada di JSP
        String name = request.getParameter("name");
        String email = request.getParameter("email"); // Gunakan email, bukan phone/kota
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // =========================
        // HASH PASSWORD (WAJIB)
        // =========================
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try {
            Connection conn = Koneksi.configDB();
            
            // 2. Sesuaikan Query SQL dengan kolom tabel users kamu
            // Saya asumsikan kolomnya adalah: name, email, password, role
            String sql = "INSERT INTO users (name, email, password, role, created_at) VALUES (?, ?, ?, ?, NOW())";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, hashedPassword);
            pstmt.setString(4, role);

            int rowAffected = pstmt.executeUpdate();

            if (rowAffected > 0) {
                // Berhasil: Redirect ke home atau login
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("error", "Gagal mendaftarkan user.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Tampilkan error spesifik (misal: kolom 'email' tidak ditemukan atau duplicate)
            request.setAttribute("error", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}