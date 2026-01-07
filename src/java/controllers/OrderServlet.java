package controllers;

import config.Koneksi;
import models.Payment;
import models.Qris;
import models.Transfer;
import java.io.File;
import java.io.IOException;
import java.sql.*;

// =======================
// JAKARTA SERVLET (Tomcat 10+)
// =======================
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

// =======================
// JIKA MASIH PAKAI JAVAX (Tomcat 9 ke bawah)
// =======================
// import javax.servlet.ServletException;
// import javax.servlet.annotation.MultipartConfig;
// import javax.servlet.annotation.WebServlet;
// import javax.servlet.http.*;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/OrderServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class OrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // 1. Proteksi Login
        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Ambil Parameter dari Form
        String cartData = request.getParameter("cart_data");
        String customerName = request.getParameter("customer_name");
        String customerPhone = request.getParameter("customer_phone");
        String customerAddress = request.getParameter("customer_address");
        String paymentMethod = request.getParameter("payment_method");
        String notes = request.getParameter("notes");
        
        long totalAmount = Long.parseLong(request.getParameter("total_amount"));

        Object userIdObj = session.getAttribute("userId");
        long userId = (userIdObj != null) ? Long.parseLong(userIdObj.toString()) : 0;
        
        Payment payment = null;
        switch (paymentMethod) {
            case "qris":
                payment = new Qris();
                break;
            case "transfer":
                payment = new Transfer();
                break;
            case "cash":
                payment = null; // Cash tidak pakai interface Payment
                break;
            default:
                throw new ServletException("Metode pembayaran tidak valid");
        }

        Connection conn = null;
        try {
            conn = Koneksi.configDB();
            conn.setAutoCommit(false); // Mulai Transaksi (Transaction)

            // 3. Handle Bukti Pembayaran (Simpan file ke folder uploads/payments)
            String proofPath = null;
            try {
                Part filePart = request.getPart("proof_of_payment");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    // Path fisik folder aplikasi
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "payments";
                    
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    filePart.write(uploadPath + File.separator + fileName);
                    proofPath = "uploads/payments/" + fileName; // Path untuk disimpan ke Database
                }
            } catch (Exception e) {
                System.out.println("No file uploaded or error in file upload.");
            }

            // 4. Simpan ke Tabel Orders
            String sqlOrder = "INSERT INTO orders (customer_name, customer_phone, customer_address, notes, payment_method, total_amount, payment_proof_path, status, user_id, created_at) "
                            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
            
            PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, customerName);
            psOrder.setString(2, customerPhone);
            psOrder.setString(3, customerAddress);
            psOrder.setString(4, notes);
            psOrder.setString(5, paymentMethod);
            psOrder.setLong(6, totalAmount);
            psOrder.setString(7, proofPath);
            
            // Status Awal
            String initialStatus = paymentMethod.equals("cash") ? "Baru (Menunggu Konfirmasi)" : "Menunggu Verifikasi Pembayaran";
            psOrder.setString(8, initialStatus);
            psOrder.setLong(9, userId);
            
            psOrder.executeUpdate();

            // Ambil ID Order yang baru saja di-insert
            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // 5. Simpan Detail Pesanan & Update Stok (Looping JSON)
            if (cartData != null && !cartData.isEmpty()) {
                JSONArray cartItems = new JSONArray(cartData);
                
                String sqlDetail = "INSERT INTO order_details (order_id, menu_id, product_name, quantity, price_per_unit, total_price, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())";
                String sqlUpdateStok = "UPDATE menus SET stok = stok - ? WHERE id = ?";

                PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                PreparedStatement psUpdateStok = conn.prepareStatement(sqlUpdateStok);

                for (int i = 0; i < cartItems.length(); i++) {
                    JSONObject item = cartItems.getJSONObject(i);
                    int menuId = item.getInt("id");
                    int qty = item.getInt("quantity");
                    long price = item.getLong("price");

                    // Insert ke order_details
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, menuId);
                    psDetail.setString(3, item.getString("name"));
                    psDetail.setInt(4, qty);
                    psDetail.setLong(5, price);
                    psDetail.setLong(6, qty * price);
                    psDetail.addBatch();

                    // Kurangi Stok di tabel menus
                    psUpdateStok.setInt(1, qty);
                    psUpdateStok.setInt(2, menuId);
                    psUpdateStok.addBatch();
                }

                psDetail.executeBatch();
                psUpdateStok.executeBatch();
            }

            conn.commit(); // Simpan permanen semua transaksi
            
            // 6. Redirect Sukses
            response.sendRedirect("sell?orderSuccess=true");

        } catch (Exception e) {
            // Jika ada satu saja error, batalkan semua perubahan (Rollback)
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            // Redirect ke keranjang dengan keterangan error
            response.sendRedirect("keranjang.jsp?error=db");
        } finally {
            // Tutup koneksi
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}