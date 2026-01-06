package models;

public class Menu {
    private int id;
    private String nama;
    private String deskripsi;
    private double harga;
    private int stok;
    private String gambar;
    private int diskon;
    private boolean isPopular;
    private String kategori; // TAMBAHKAN INI

    public Menu() {}

    // Getter dan Setter Kategori (WAJIB ADA)
    public String getKategori() { return kategori; }
    public void setKategori(String kategori) { this.kategori = kategori; }

    // Getter dan Setter lainnya
    public boolean getIsPopular() { return isPopular; }
    public void setIsPopular(boolean isPopular) { this.isPopular = isPopular; }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }
    public String getDeskripsi() { return deskripsi; }
    public void setDeskripsi(String deskripsi) { this.deskripsi = deskripsi; }
    public double getHarga() { return harga; }
    public void setHarga(double harga) { this.harga = harga; }
    public int getStok() { return stok; }
    public void setStok(int stok) { this.stok = stok; }
    public String getGambar() { return gambar; }
    public void setGambar(String gambar) { this.gambar = gambar; }
    public int getDiskon() { return diskon; }
    public void setDiskon(int diskon) { this.diskon = diskon; }
}