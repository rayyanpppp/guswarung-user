package models;

import java.io.File;

public class Customer extends User {
    private String kota;
    private String phone;
    private String avatar;

    public Customer() {
        super();
    }

    public Customer(int idUser, String name, String email, String password) {
        super(idUser, name, email, password, "customer");
        this.kota = kota;
        this.phone = phone;
        this.avatar = avatar;
    }

    @Override
    public void tampilkanMenu() {
        System.out.println("=== MENU CUSTOMER ===");
    }

    public void tambahItemKeranjang(int idMakanan, int jumlah) {
        System.out.println(
            "Menambahkan makanan ID " + idMakanan +
            " sebanyak " + jumlah + " ke keranjang"
        );
    }

    public void updateJumlahKeranjang(int idMakanan, int jumlahBaru) {
        System.out.println(
            "Update jumlah makanan ID " + idMakanan +
            " menjadi " + jumlahBaru
        );
    }

    public void hapusItemKeranjang(int idMakanan) {
        System.out.println(
            "Menghapus makanan ID " + idMakanan +
            " dari keranjang"
        );
    }

    // uploadBuktiPembayaran(idPesanan, file) : void
    public void uploadBuktiPembayaran(int idPesanan, File file) {
        System.out.println(
            "Upload bukti pembayaran untuk pesanan ID " + idPesanan +
            " dengan file: " + file.getName()
        );
    }


    
    public String getKota() {
        return kota;
    }

    public void setKota(String kota) {
        this.kota = kota;
    }

    public String getphone() {
        return phone;
    }
    
    public String getAvatar() {
        return avatar;
    }
    
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
