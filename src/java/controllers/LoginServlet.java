package controllers;

import models.Userdao;
import models.User;
import models.Admin;
import models.Driver;
import models.Customer;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(
    name = "LoginServlet",
    urlPatterns = {"/LoginServlet"}
)
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== LOGIN SERVLET DIPANGGIL ===");
        // =========================
        // AMBIL DATA FORM
        // =========================
        String username = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // =========================
        // VALIDASI INPUT
        // =========================
        if (username == null || email == null || password == null ||
            username.isEmpty() || email.isEmpty() || password.isEmpty()) {

            request.setAttribute("error", "Semua field wajib diisi!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // =========================
        // PROSES LOGIN VIA DAO
        // =========================
        Userdao userdao = new Userdao();
        User user = userdao.login(
                username.trim(),
                email.trim().toLowerCase(),
                password
        );

        // =========================
        // LOGIN GAGAL
        // =========================
        if (user == null) {
            request.setAttribute("error", "Username, email, atau password salah!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // =========================
        // LOGIN BERHASIL
        // =========================
        HttpSession session = request.getSession(true);

        // ===== OOP (POLYMORPHISM) =====
        session.setAttribute("user", user);

        // ===== DATA UNTUK EDIT PROFIL =====
        session.setAttribute("userName", user.getName());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userRole", user.getRole());

        // =========================
        // REDIRECT SESUAI ROLE
        // =========================
        if (user instanceof Admin) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");

        } else if (user instanceof Customer) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");

        } else if (user instanceof Driver) {
            response.sendRedirect(request.getContextPath() + "/driver/dashboard.jsp");

        } else {
            // Fallback keamanan
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
