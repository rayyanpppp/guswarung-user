package models;

import config.Koneksi;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class InventarisDAO {

    // ================================
    // LAPORAN STOK BARANG (READ ONLY)
    // ================================
    public List<Inventaris> getInventarisForReport() {
    List<Inventaris> list = new ArrayList<>();

    String sql = """
        SELECT 
            id,
            name,
            quantity,
            unit,
            minimal_stock,
            price,
            status
        FROM inventaris
        ORDER BY 
            CASE WHEN status = 'rendah' THEN 1 ELSE 2 END,
            quantity ASC
    """;

    try (Connection conn = Koneksi.configDB();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Inventaris i = new Inventaris();
            i.setId(rs.getInt("id"));
            i.setName(rs.getString("name"));
            i.setQuantity(rs.getInt("quantity"));
            i.setUnit(rs.getString("unit"));
            i.setMinimalStock(rs.getInt("minimal_stock"));
            i.setPrice(rs.getDouble("price"));
            i.setStatus(rs.getString("status"));

            list.add(i);
        }

        // DEBUG (WAJIB cek ini)
        System.out.println("Inventaris Report Size: " + list.size());

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

}