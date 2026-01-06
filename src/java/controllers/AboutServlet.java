package controllers;

import java.io.IOException;
import java.util.List;

import models.Order;
import models.OrderDAO;

// =======================
// JAKARTA SERVLET (Tomcat 10+)
// =======================
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// =======================
// JIKA MASIH PAKAI JAVAX (Tomcat 9 ke bawah)
// =======================
// import javax.servlet.ServletException;
// import javax.servlet.annotation.WebServlet;
// import javax.servlet.http.HttpServlet;
// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpServletResponse;
// import javax.servlet.http.HttpSession;

@WebServlet(name = "AboutServlet", urlPatterns = {"/about"}) // Ubah URL agar lebih cantik
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil session untuk mendapatkan user_id
        HttpSession session = request.getSession(false);
        
        // 2. Proteksi sederhana (jika tidak ada session, lempar ke login)
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 3. Ambil user_id dari session
            long userId = Long.parseLong(session.getAttribute("user_id").toString());

            // 4. Panggil DAO untuk mengambil 5 pesanan terbaru
            OrderDAO orderDAO = new OrderDAO();
            List<Order> latestOrders = orderDAO.getLatestOrdersByUserId(userId);

            // 5. Simpan data ke Request Attribute agar bisa dibaca JSP
            request.setAttribute("latestOrders", latestOrders);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 6. Teruskan ke halaman about.jsp
        request.getRequestDispatcher("about.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}