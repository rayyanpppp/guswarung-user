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

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Cek login
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Ambil data pesanan terbaru untuk Navbar
        try {
            long userId = Long.parseLong(session.getAttribute("user_id").toString());
            OrderDAO orderDAO = new OrderDAO();
            List<Order> latestOrders = orderDAO.getLatestOrdersByUserId(userId);
            request.setAttribute("latestOrders", latestOrders);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Lempar ke home.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}