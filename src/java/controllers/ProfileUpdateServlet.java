package controllers;

import config.Koneksi;
import models.User;
import models.Customer;
import org.mindrot.jbcrypt.BCrypt;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/ProfileUpdateServlet")
@MultipartConfig(
    fileSizeThreshold = 2 * 1024 * 1024,
    maxFileSize = 10 * 1024 * 1024,
    maxRequestSize = 50 * 1024 * 1024
)
public class ProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // =========================
        // AMBIL SESSION & CUSTOMER
        // =========================
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Object obj = session.getAttribute("user");
        if (!(obj instanceof Customer)) {
            response.sendRedirect("login.jsp");
            return;
        }

        Customer customer = (Customer) obj;
        long userId = customer.getIdUser();

        // =========================
        // DATA FORM
        // =========================
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String kota = request.getParameter("kota");
        String password = request.getParameter("password");

        // =========================
        // UPLOAD AVATAR
        // =========================
        String avatarPath = null;
        Part avatarPart = request.getPart("avatar");

        if (avatarPart != null && avatarPart.getSize() > 0) {
            String fileName = Paths.get(avatarPart.getSubmittedFileName()).getFileName().toString();

            String uploadDirPath = getServletContext().getRealPath("")
                    + File.separator + "img" + File.separator + "avatar";

            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String finalName = "avatar_" + userId + "_" + System.currentTimeMillis() + "_" + fileName;
            avatarPart.write(uploadDirPath + File.separator + finalName);

            avatarPath = "img/avatar/" + finalName;
        }

        // =========================
        // UPDATE DATABASE
        // =========================
        try (Connection conn = Koneksi.configDB()) {

            StringBuilder sql = new StringBuilder(
                "UPDATE users SET name=?, email=?, phone=?, kota=?"
            );

            if (password != null && !password.isEmpty()) {
                sql.append(", password=?");
            }
            if (avatarPath != null) {
                sql.append(", avatar=?");
            }

            sql.append(" WHERE id=?");

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int i = 1;

            ps.setString(i++, name);
            ps.setString(i++, email);
            ps.setString(i++, phone);
            ps.setString(i++, kota);

            if (password != null && !password.isEmpty()) {
                ps.setString(i++, BCrypt.hashpw(password, BCrypt.gensalt()));
            }
            if (avatarPath != null) {
                ps.setString(i++, avatarPath);
            }

            ps.setLong(i, userId);
            ps.executeUpdate();

            // =========================
            // UPDATE OBJECT CUSTOMER
            // =========================
            customer.setName(name);
            customer.setEmail(email);
            customer.setPhone(phone);
            customer.setKota(kota);

            if (avatarPath != null) {
                customer.setAvatar(avatarPath);
                session.setAttribute("userAvatar", avatarPath);
            }

            session.setAttribute("user", customer);
            session.setAttribute("success", "Profil berhasil diperbarui!");

            response.sendRedirect(request.getContextPath() + "/profile.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
