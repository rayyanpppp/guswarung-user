package controllers;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import models.Menu;
import models.MenuDAO;
import models.OrderDAO;
import models.OrderDetail;

import models.Inventaris;
import models.InventarisDAO;


@WebServlet(name = "ReportServlet", urlPatterns = {"/ReportServlet"})
public class ReportServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /* =====================================================
           1. PARAMETER PERIODE
        ===================================================== */
        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "daily";
        }

        /* =====================================================
           2. LAPORAN PENJUALAN PER PERIODE
        ===================================================== */
        OrderDAO orderDAO = new OrderDAO();

        long revenue;
        String label;

        switch (period) {
            case "weekly":
                revenue = orderDAO.getRevenueThisWeek();
                label = "Minggu Ini";
                break;
            case "monthly":
                revenue = orderDAO.getRevenueThisMonth();
                label = "Bulan Ini";
                break;
            default:
                revenue = orderDAO.getRevenueToday();
                label = "Hari Ini";
                break;
        }

        int totalOrders = orderDAO.getOrderCountByPeriod(period);

        request.setAttribute("revenue", revenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("period", period);
        request.setAttribute("label", label);

        /* =====================================================
           3. LAPORAN STOK BARANG
        ===================================================== */
        InventarisDAO inventarisDAO = new InventarisDAO();
        List<Inventaris> inventarisList = inventarisDAO.getInventarisForReport();
        request.setAttribute("inventarisList", inventarisList);

        /* =====================================================
           4. PENJUALAN TERBANYAK
        ===================================================== */
        List<OrderDetail> topProducts = orderDAO.getTopSellingProducts();
        request.setAttribute("topProducts", topProducts);

        /* =====================================================
           5. FORWARD KE JSP
        ===================================================== */
        request.getRequestDispatcher("admin/laporan.jsp")
               .forward(request, response);
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