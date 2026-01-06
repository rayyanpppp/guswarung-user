package models;

public class Admin extends User {
    public Admin() {
        super();
    }

    public Admin(int idUser, String name, String email, String password) {
        super(idUser, name, email, password, "admin");
    }
    
    @Override
    public void tampilkanMenu() {
        System.out.println("=== MENU ADMIN ===");
    }

    public void kelolaUser(String aksi, int idUser) {
        System.out.println("Admin melakukan aksi '" + aksi + "' pada user ID: " + idUser);
    }

    // kelolaMakanan(aksi, idMakanan) : void
    public void kelolaMakanan(String aksi, int idMakanan) {
        System.out.println("Admin melakukan aksi '" + aksi + "' pada makanan ID: " + idMakanan);
    }

    public void kelolaLaporan(String periode) {
        System.out.println("Admin melihat laporan periode: " + periode);
    }

    public void kelolaStok(String aksi, int idStock, int jumlahBaru) {
        System.out.println(
            "Admin melakukan aksi '" + aksi +
            "' pada stok ID: " + idStock +
            " dengan jumlah baru: " + jumlahBaru
        );
    }
}
