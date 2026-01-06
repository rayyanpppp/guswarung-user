package models;

public class Qris implements Payment {

    private String kodeQR;
    private String buktiPembayaran;

    public Qris(String kodeQR, String buktiPembayaran) {
        this.kodeQR = kodeQR;
        this.buktiPembayaran = buktiPembayaran;
    }


    @Override
    public boolean prosesPembayaran(int idPesanan, float total) {
        System.out.println(
            "Pembayaran QRIS untuk pesanan ID " + idPesanan +
            " sebesar Rp " + total
        );
        System.out.println("Kode QR: " + kodeQR);
        return true;
    }

    @Override
    public boolean konfirmasi(int idPesanan) {
        System.out.println(
            "Konfirmasi pembayaran QRIS untuk pesanan ID " + idPesanan
        );
        return true;
    }

    // =========================
    // GETTER & SETTER
    // =========================
    public String getKodeQR() {
        return kodeQR;
    }

    public void setKodeQR(String kodeQR) {
        this.kodeQR = kodeQR;
    }

    public String getBuktiPembayaran() {
        return buktiPembayaran;
    }

    public void setBuktiPembayaran(String buktiPembayaran) {
        this.buktiPembayaran = buktiPembayaran;
    }
}
