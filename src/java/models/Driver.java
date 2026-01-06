package models;

public class Driver extends User {

    public Driver() {
        super();
    }

    public Driver(int idUser, String name, String email, String password) {
        super(idUser, name, email, password, "driver");
    }

    @Override
    public void tampilkanMenu() {
        System.out.println("=== MENU DRIVER ===");
    }


    public void updateStatusPengantaran(int idPesanan, String status) {
        System.out.println(
            "Update status pengantaran pesanan ID " + idPesanan +
            " menjadi: " + status
        );
    }



}
