package controllers;

import models.Order;
import models.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders"})
public class AdminOrderServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        OrderDAO dao = new OrderDAO();

        if ("show".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Order order = dao.getOrderById(id);
            request.setAttribute("order", order);
            request.getRequestDispatcher("/admin/orders/show.jsp").forward(request, response);
        } else {
            // Default: Tampilkan semua order
            List<Order> list = dao.getAllOrders();
            request.setAttribute("orders", list);
            request.getRequestDispatcher("/admin/orders/index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        
        OrderDAO dao = new OrderDAO();
        if (dao.updateStatus(id, status)) {
            request.getSession().setAttribute("success", "Status pesanan #" + id + " berhasil diperbarui!");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}