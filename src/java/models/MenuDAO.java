package models;

import config.Koneksi;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO {

    /* =========================================================
       Ambil semua data menu
       ========================================================= */
    public List<Menu> getAllMenu() {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM menus";

        try (
            Connection con = Koneksi.configDB();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Menu m = new Menu();
                m.setId(rs.getInt("id"));
                m.setNama(rs.getString("nama"));
                m.setDeskripsi(rs.getString("deskripsi"));
                m.setHarga(rs.getDouble("harga"));
                m.setStok(rs.getInt("stok"));
                m.setKategori(rs.getString("kategori"));
                m.setGambar(rs.getString("gambar"));
                m.setIsPopular(rs.getBoolean("is_popular"));
                m.setDiskon(rs.getInt("diskon_persen"));

                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println("Error MenuDAO: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /* =========================================================
       Ambil satu menu berdasarkan ID (edit)
       ========================================================= */
    public Menu getMenuById(int id) {
        Menu m = null;
        String sql = "SELECT * FROM menus WHERE id = ?";

        try (
            Connection con = Koneksi.configDB();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    m = new Menu();
                    m.setId(rs.getInt("id"));
                    m.setNama(rs.getString("nama"));
                    m.setDeskripsi(rs.getString("deskripsi"));
                    m.setHarga(rs.getDouble("harga"));
                    m.setStok(rs.getInt("stok"));
                    m.setKategori(rs.getString("kategori"));
                    m.setGambar(rs.getString("gambar"));
                    m.setIsPopular(rs.getBoolean("is_popular"));
                    m.setDiskon(rs.getInt("diskon_persen"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return m;
    }

    /* =========================================================
       Hapus menu
       ========================================================= */
    public boolean deleteMenu(int id) {
        String sql = "DELETE FROM menus WHERE id = ?";

        try (
            Connection con = Koneksi.configDB();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* =========================================================
       Insert menu baru
       ========================================================= */
    public boolean insertMenu(Menu m) {
        String sql = """
            INSERT INTO menus
            (nama, deskripsi, harga, stok, kategori, gambar, diskon_persen)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (
            Connection con = Koneksi.configDB();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, m.getNama());
            ps.setString(2, m.getDeskripsi());
            ps.setDouble(3, m.getHarga());
            ps.setInt(4, m.getStok());
            ps.setString(5, m.getKategori());
            ps.setString(6, m.getGambar());
            ps.setInt(7, m.getDiskon());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /* =========================================================
       Update menu
       ========================================================= */
    public boolean updateMenu(Menu m) {
        String sql = """
            UPDATE menus
            SET nama = ?, deskripsi = ?, harga = ?, stok = ?, kategori = ?, gambar = ?, diskon_persen = ?
            WHERE id = ?
        """;

        try (
            Connection con = Koneksi.configDB();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, m.getNama());
            ps.setString(2, m.getDeskripsi());
            ps.setDouble(3, m.getHarga());
            ps.setInt(4, m.getStok());
            ps.setString(5, m.getKategori());
            ps.setString(6, m.getGambar());
            ps.setInt(7, m.getDiskon());
            ps.setInt(8, m.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
