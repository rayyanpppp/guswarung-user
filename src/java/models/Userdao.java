package models;

import config.Koneksi;
import models.User;
import models.Admin;
import models.Customer;
import models.Driver;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Userdao {

    // =========================
    // LOGIN
    // =========================
    public User login(String name, String email, String password) {

        String sql = "SELECT * FROM users WHERE name = ? AND email = ? LIMIT 1";

        try (Connection conn = Koneksi.configDB();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String passwordDB = rs.getString("password");

                // Verifikasi password (BCrypt)
                if (!BCrypt.checkpw(password, passwordDB)) {
                    return null;
                }

                String role = rs.getString("role");

                // =========================
                // BUAT OBJEK SESUAI ROLE
                // =========================
                if ("admin".equalsIgnoreCase(role)) {
                    return new Admin(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        passwordDB
                    );

                } else if ("customer".equalsIgnoreCase(role)) {
                    return new Customer(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        passwordDB
                    );

                } else if ("driver".equalsIgnoreCase(role)) {
                    return new Driver(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        passwordDB
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // REGISTER
    // =========================
    public boolean register(String name, String email, String password, String role) {

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";

        try (Connection conn = Koneksi.configDB();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, role);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
