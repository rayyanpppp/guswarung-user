package config;
import config.Koneksi;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class Password {

    public static void main(String[] args) {

        String selectSql = "SELECT id, password FROM users";
        String updateSql = "UPDATE users SET password = ? WHERE id = ?";

        try (
            Connection conn = Koneksi.configDB();
            PreparedStatement selectPs = conn.prepareStatement(selectSql);
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
        ) {

            ResultSet rs = selectPs.executeQuery();

            int totalUpdated = 0;

            while (rs.next()) {
                int userId = rs.getInt("id");
                String plainPassword = rs.getString("password");

                // ===============================
                // CEK: JANGAN HASH ULANG YANG SUDAH HASH
                // ===============================
                if (plainPassword != null && !plainPassword.startsWith("$2a$")) {

                    String hashedPassword = BCrypt.hashpw(
                        plainPassword,
                        BCrypt.gensalt()
                    );

                    updatePs.setString(1, hashedPassword);
                    updatePs.setInt(2, userId);
                    updatePs.executeUpdate();

                    totalUpdated++;
                    System.out.println("✔ Password user ID " + userId + " berhasil di-hash");
                }
            }

            System.out.println("=== SELESAI ===");
            System.out.println("Total password di-hash: " + totalUpdated);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
