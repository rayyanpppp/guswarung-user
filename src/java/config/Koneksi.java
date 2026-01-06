package config; // Pastikan ini sesuai dengan nama folder/package Anda

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Koneksi {
    private static Connection mysqlconfig;
    
    public static Connection configDB() throws SQLException {
        try {
            // Sesuaikan dengan nama database guswarung_db
            String url = "jdbc:mysql://localhost:3306/guswarung"; 
            String user = "root"; 
            String pass = ""; 
            
            DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
            mysqlconfig = DriverManager.getConnection(url, user, pass);            
        } catch (Exception e) {
            System.err.println("Koneksi gagal: " + e.getMessage()); 
        }
        return mysqlconfig;
    }    
}