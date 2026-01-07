package controllers;

import config.Koneksi;
import models.User;

import java.io.File;
import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ===============================
        // 1. PROTEKSI LOGIN (FINAL)
        // ===============================
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ===============================
        // 2. AMBIL DATA FORM
        // ===============================
        String cartData = request.getParameter("cart_data");
        String customerName = request.getParameter("customer_name");
        String customerPhone = request.getParameter("customer_phone");
        String customerAddress = request.getParameter("customer_address");
        String paymentMethod = request.getParameter("payment_method");
        String notes = request.getParameter("notes");

        long totalAmount = Long.parseLong(request.getParameter("total_amount"));

        // ===============================
        // 3. HITUNG NILAI WAJIB DB
        // ===============================
        long subtotal = totalAmount; // bisa kamu hitung ulang dari cart
        long ppnAmount = 0;
        long shippingFee = 0;

        Connection conn = null;

        try {
            conn = Koneksi.configDB();
            conn.setAutoCommit(false); // TRANSACTION START

            // ===============================
            // 4. UPLOAD BUKTI PEMBAYARAN
            // ===============================
            String proofPath = null;
            Part filePart = request.getPart("proof_of_payment");

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") +
                        File.separator + "uploads" + File.separator + "payments";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + fileName);
                proofPath = "uploads/payments/" + fileName;
            }

            // ===============================
            // 5. INSERT KE TABEL ORDERS
            // ===============================
            String sqlOrder =
                "INSERT INTO orders (" +
                "customer_name, customer_phone, customer_address, notes, " +
                "payment_method, subtotal, ppn_amount, shipping_fee, " +
                "total_amount, payment_proof_path, status, created_at" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";

            PreparedStatement psOrder =
                    conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);

            psOrder.setString(1, customerName);
            psOrder.setString(2, customerPhone);
            psOrder.setString(3, customerAddress);
            psOrder.setString(4, notes);
            psOrder.setString(5, paymentMethod);
            psOrder.setLong(6, subtotal);
            psOrder.setLong(7, ppnAmount);
            psOrder.setLong(8, shippingFee);
            psOrder.setLong(9, totalAmount);
            psOrder.setString(10, proofPath);

            String initialStatus =
                    paymentMethod.equalsIgnoreCase("cash")
                            ? "Baru (Menunggu Konfirmasi)"
                            : "Menunggu Verifikasi Pembayaran";

            psOrder.setString(11, initialStatus);

            psOrder.executeUpdate();

            // Ambil ID order
            ResultSet rs = psOrder.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // ===============================
            // 6. INSERT ORDER DETAILS + UPDATE STOK
            // ===============================
            if (cartData != null && !cartData.isEmpty()) {
                JSONArray cartItems = new JSONArray(cartData);

                String sqlDetail =
                    "INSERT INTO order_details " +
                    "(order_id, menu_id, product_name, quantity, price_per_unit, total_price, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, NOW())";

                String sqlUpdateStok =
                    "UPDATE menus SET stok = stok - ? WHERE id = ? AND stok >= ?";

                PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
                PreparedStatement psUpdateStok = conn.prepareStatement(sqlUpdateStok);

                for (int i = 0; i < cartItems.length(); i++) {
                    JSONObject item = cartItems.getJSONObject(i);

                    int menuId = item.getInt("id");
                    int qty = item.getInt("quantity");
                    long price = item.getLong("price");

                    // order_details
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, menuId);
                    psDetail.setString(3, item.getString("name"));
                    psDetail.setInt(4, qty);
                    psDetail.setLong(5, price);
                    psDetail.setLong(6, qty * price);
                    psDetail.addBatch();

                    // update stok
                    psUpdateStok.setInt(1, qty);
                    psUpdateStok.setInt(2, menuId);
                    psUpdateStok.setInt(3, qty);
                    psUpdateStok.addBatch();
                }

                psDetail.executeBatch();
                psUpdateStok.executeBatch();
            }

            // ===============================
            // 7. COMMIT & REDIRECT
            // ===============================
            conn.commit();
            response.sendRedirect("sell?orderSuccess=true");

        } catch (Exception e) {
            // ===============================
            // ROLLBACK JIKA ERROR
            // ===============================
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            response.sendRedirect("keranjang.jsp?error=db");

        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}
