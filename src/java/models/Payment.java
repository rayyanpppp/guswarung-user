/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package models;

/**
 *
 * @author Rayyannabil
 */
public interface Payment {
    // prosesPembayaran(idPesanan, total) : bool
    boolean prosesPembayaran(int idPesanan, float total);

    // konfirmasi(idPesanan) : bool
    boolean konfirmasi(int idPesanan);
}
