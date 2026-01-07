package models;

public class Qris implements Payment {

    @Override
    public String getMethodName() {
        return "QRIS";
    }

    @Override
    public String getInstruction() {
        return "Silakan scan QRIS GusWarung untuk melakukan pembayaran.";
    }

    @Override
    public boolean isUploadRequired() {
        return true;
    }
    
    @Override
    public String getInitialStatus() {
        return "Menunggu Verifikasi Pembayaran QRIS";
    }

}
