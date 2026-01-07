package models;

public class Transfer implements Payment {

    @Override
    public String getMethodName() {
        return "TRANSFER BANK";
    }

    @Override
    public String getInstruction() {
        return "Transfer ke Bank XYZ - 12345678 a/n GusWarung.";
    }

    @Override
    public boolean isUploadRequired() {
        return true;
    }
    @Override
    public String getInitialStatus() {
        return "Menunggu Verifikasi Transfer Bank";
    }

}
