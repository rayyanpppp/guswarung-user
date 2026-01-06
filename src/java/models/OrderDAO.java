package models;

import config.Koneksi;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        // Sesuaikan nama kolom dengan database Anda: created_at atau timestamps
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try (Connection con = Koneksi.configDB();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setCustomerName(rs.getString("customer_name"));
                o.setTotalAmount(rs.getLong("total_amount"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setStatus(rs.getString("status"));
                o.setPaymentProofPath(rs.getString("payment_proof_path"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Error getAllOrders: " + e.getMessage());
        }
        return list;
    }

    public Order getOrderById(int id) {
        Order o = null;
        String sqlOrder = "SELECT * FROM orders WHERE id = ?";
        String sqlDetails = "SELECT * FROM order_details WHERE order_id = ?";

        try (Connection con = Koneksi.configDB()) {
            // 1. Ambil Header Order
            try (PreparedStatement psOrder = con.prepareStatement(sqlOrder)) {
                psOrder.setInt(1, id);
                try (ResultSet rsOrder = psOrder.executeQuery()) {
                    if (rsOrder.next()) {
                        o = new Order();
                        o.setId(rsOrder.getInt("id"));
                        o.setCustomerName(rsOrder.getString("customer_name"));
                        o.setCustomerPhone(rsOrder.getString("customer_phone"));
                        o.setCustomerAddress(rsOrder.getString("customer_address"));
                        o.setNotes(rsOrder.getString("notes"));
                        o.setPaymentMethod(rsOrder.getString("payment_method"));
                        o.setSubtotal(rsOrder.getLong("subtotal"));
                        o.setPpnAmount(rsOrder.getLong("ppn_amount"));
                        o.setShippingFee(rsOrder.getLong("shipping_fee"));
                        o.setTotalAmount(rsOrder.getLong("total_amount"));
                        o.setPaymentProofPath(rsOrder.getString("payment_proof_path"));
                        o.setStatus(rsOrder.getString("status"));
                        o.setCreatedAt(rsOrder.getTimestamp("created_at"));

                        // 2. Ambil Item Details
                        List<OrderDetail> details = new ArrayList<>();
                        try (PreparedStatement psDetails = con.prepareStatement(sqlDetails)) {
                            psDetails.setInt(1, id);
                            try (ResultSet rsDetails = psDetails.executeQuery()) {
                                while (rsDetails.next()) {
                                    OrderDetail od = new OrderDetail();
                                    od.setProductName(rsDetails.getString("product_name"));
                                    od.setQuantity(rsDetails.getInt("quantity"));
                                    od.setPricePerUnit(rsDetails.getLong("price_per_unit"));
                                    od.setTotalPrice(rsDetails.getLong("total_price"));
                                    details.add(od);
                                }
                            }
                        }
                        o.setDetails(details);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getOrderById: " + e.getMessage());
        }
        return o;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection con = Koneksi.configDB();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Method ini sekarang sudah memiliki implementasi dasar
    public List<Order> getLatestOrdersByUserId(long userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC LIMIT 5";
        try (Connection con = Koneksi.configDB();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setCustomerName(rs.getString("customer_name"));
                    o.setTotalAmount(rs.getLong("total_amount"));
                    o.setStatus(rs.getString("status"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getLatestOrdersByUserId: " + e.getMessage());
        }
        return list;
    }
}