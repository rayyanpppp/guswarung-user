package controllers;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Order;
import models.OrderDAO;

@WebServlet(name = "ReportServlet", urlPatterns = {"/ReportServlet"})
public class ReportServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        OrderDAO dao = new OrderDAO();
        // Mengambil semua data order berdasarkan kolom di database anda
        List<Order> listOrders = dao.getAllOrders(); 
        
        // Hitung total ringkasan
        double totalRevenue = 0;
        int totalOrders = listOrders.size();
        
        for (Order o : listOrders) {
            totalRevenue += o.getTotal_amount(); // Mengacu pada kolom total_amount
        }

        // Kirim data ke JSP
        request.setAttribute("orders", listOrders);
        request.setAttribute("revenue", totalRevenue);
        request.setAttribute("count", totalOrders);
        
        request.getRequestDispatcher("admin/laporan.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}