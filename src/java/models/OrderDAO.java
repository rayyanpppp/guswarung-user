package models;

import config.Koneksi;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /* ======================
       METHOD LAMA (AMAN)
    ====================== */

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
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

            try (PreparedStatement psOrder = con.prepareStatement(sqlOrder)) {
                psOrder.setInt(1, id);
                try (ResultSet rs = psOrder.executeQuery()) {
                    if (rs.next()) {
                        o = new Order();
                        o.setId(rs.getInt("id"));
                        o.setCustomerName(rs.getString("customer_name"));
                        o.setCustomerPhone(rs.getString("customer_phone"));
                        o.setCustomerAddress(rs.getString("customer_address"));
                        o.setPaymentMethod(rs.getString("payment_method"));
                        o.setTotalAmount(rs.getLong("total_amount"));
                        o.setStatus(rs.getString("status"));
                        o.setCreatedAt(rs.getTimestamp("created_at"));

                        List<OrderDetail> details = new ArrayList<>();
                        try (PreparedStatement psDetail = con.prepareStatement(sqlDetails)) {
                            psDetail.setInt(1, id);
                            try (ResultSet rd = psDetail.executeQuery()) {
                                while (rd.next()) {
                                    OrderDetail d = new OrderDetail();
                                    d.setProductName(rd.getString("product_name"));
                                    d.setQuantity(rd.getInt("quantity"));
                                    d.setPricePerUnit(rd.getLong("price_per_unit"));
                                    d.setTotalPrice(rd.getLong("total_price"));
                                    details.add(d);
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
        e.printStackTrace();
    }
    return list;
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
    }
    return false;
}


    /* ======================
       FITUR LAPORAN LANJUTAN
    ====================== */

    public long getTodayRevenue() {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE DATE(created_at) = CURDATE()";
        return executeSum(sql);
    }

    public int getTodayOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";
        try (Connection con = Koneksi.configDB();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public long getMonthlyRevenue() {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())";
        return executeSum(sql);
    }

    public List<Order> getLatestOrders(int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC LIMIT ?";

        try (Connection con = Koneksi.configDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);
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
            e.printStackTrace();
        }
        return list;
    }

    /* ======================
       HELPER
    ====================== */

    private long executeSum(String sql) {
        try (Connection con = Koneksi.configDB();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ================================
// PENJUALAN PER PERIODE
// ================================

// Hari ini
public long getRevenueToday() {
    String sql = "SELECT IFNULL(SUM(total_amount),0) FROM orders WHERE DATE(created_at) = CURDATE()";
    return getSingleRevenue(sql);
}

// Minggu ini
public long getRevenueThisWeek() {
    String sql = """
        SELECT IFNULL(SUM(total_amount),0)
        FROM orders
        WHERE YEARWEEK(created_at, 1) = YEARWEEK(CURDATE(), 1)
    """;
    return getSingleRevenue(sql);
}

// Bulan ini
public long getRevenueThisMonth() {
    String sql = """
        SELECT IFNULL(SUM(total_amount),0)
        FROM orders
        WHERE MONTH(created_at) = MONTH(CURDATE())
        AND YEAR(created_at) = YEAR(CURDATE())
    """;
    return getSingleRevenue(sql);
}

// Jumlah transaksi per periode
public int getOrderCountByPeriod(String period) {
    String condition = switch (period) {
        case "weekly" -> "YEARWEEK(created_at,1)=YEARWEEK(CURDATE(),1)";
        case "monthly" -> "MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())";
        default -> "DATE(created_at)=CURDATE()";
    };

    String sql = "SELECT COUNT(*) FROM orders WHERE " + condition;

    try (Connection c = Koneksi.configDB();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

// Helper
private long getSingleRevenue(String sql) {
    try (Connection c = Koneksi.configDB();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getLong(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

public List<OrderDetail> getTopSellingProducts() {
    List<OrderDetail> list = new ArrayList<>();

    String sql = """
        SELECT product_name, SUM(quantity) AS total_sold
        FROM order_details
        GROUP BY product_name
        ORDER BY total_sold DESC
        LIMIT 5
    """;

    try (Connection con = Koneksi.configDB();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            OrderDetail od = new OrderDetail();
            od.setProductName(rs.getString("product_name"));
            od.setQuantity(rs.getInt("total_sold"));
            list.add(od);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

    
}