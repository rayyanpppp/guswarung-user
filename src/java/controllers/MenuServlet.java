package controllers;

import models.Menu;
import models.MenuDAO;
import models.Order;      // Model untuk data order (status pesanan)
import models.OrderDAO;   // DAO untuk akses database order

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

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

@WebServlet(name = "MenuServlet", urlPatterns = {"/sell"})
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // --- BAGIAN BARU: AMBIL STATUS PESANAN UNTUK NAVBAR ---
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("user_id");
        
        if (userIdObj != null) {
            long userId = Long.parseLong(userIdObj.toString());
            OrderDAO orderDAO = new OrderDAO();
            // Panggil method yang kita buat sebelumnya
            List<Order> latestOrders = orderDAO.getLatestOrdersByUserId(userId);
            request.setAttribute("latestOrders", latestOrders);
        }
        // -----------------------------------------------------

        MenuDAO menuDAO = new MenuDAO();
        List<Menu> allMenu = menuDAO.getAllMenu();
        
        if (allMenu != null) {
            List<Menu> makanan = allMenu.stream()
                    .filter(m -> m.getKategori() != null && "makanan".equalsIgnoreCase(m.getKategori()))
                    .collect(Collectors.toList());
                    
            List<Menu> minuman = allMenu.stream()
                    .filter(m -> m.getKategori() != null && "minuman".equalsIgnoreCase(m.getKategori()))
                    .collect(Collectors.toList());
                    
            List<Menu> addons = allMenu.stream()
                    .filter(m -> m.getKategori() != null && "addon".equalsIgnoreCase(m.getKategori()))
                    .collect(Collectors.toList());

            request.setAttribute("makanan", makanan);
            request.setAttribute("minuman", minuman);
            request.setAttribute("addons", addons);
        }
        
        request.getRequestDispatcher("sell.jsp").forward(request, response);
    }
}