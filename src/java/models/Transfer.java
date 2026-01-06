package models;

public class Transfer implements Payment {

    // =========================
    // ATRIBUT (SESUAI DIAGRAM)
    // =========================
    private String nomorRekening;
    private String bukti;

    // =========================
    // CONSTRUCTOR
    // =========================
    public Transfer() {
    }

    public Transfer(String nomorRekening, String bukti) {
        this.nomorRekening = nomorRekening;
        this.bukti = bukti;
    }

    // =========================
    // IMPLEMENTASI INTERFACE
    // =========================

    @Override
    public boolean prosesPembayaran(int idPesanan, float total) {
        System.out.println(
            "Pembayaran Transfer untuk pesanan ID " + idPesanan +
            " sebesar Rp " + total
        );
        System.out.println("No Rekening: " + nomorRekening);
        return true;
    }

    @Override
    public boolean konfirmasi(int idPesanan) {
        System.out.println(
            "Konfirmasi pembayaran Transfer untuk pesanan ID " + idPesanan
        );
        return true;
    }

    // =========================
    // GETTER & SETTER
    // =========================
    public String getNomorRekening() {
        return nomorRekening;
    }

    public void setNomorRekening(String nomorRekening) {
        this.nomorRekening = nomorRekening;
    }

    public String getBukti() {
        return bukti;
    }

    public void setBukti(String bukti) {
        this.bukti = bukti;
    }
}
