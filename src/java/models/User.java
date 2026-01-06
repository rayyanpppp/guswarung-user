package models;

public class User {

    // =========================
    // ATRIBUT (PRIVATE)
    // =========================
    protected int idUser;
    protected String name;
    protected String email;
    protected String password;
    protected String role;

    // =========================
    // CONSTRUCTOR
    // =========================
    public User() {
    }

    public User(int idUser, String name, String email, String password, String role) {
        this.idUser = idUser;
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // =========================
    // METHOD SESUAI CLASS DIAGRAM
    // =========================

    // login(username, password) : bool
    public boolean login(String email, String password) {
    return this.email.equals(email) && this.password.equals(password);
    }

    public void logout() {
        System.out.println("User dengan email " + email + " logout");
    }


    // tampilkanMenu() : void
    // ⚠️ Akan dioverride oleh subclass (Admin, Pelanggan, Driver)
    public void tampilkanMenu() {
        System.out.println("Menu default user");
    }

    // =========================
    // GETTER & SETTER
    // =========================
    public int getIdUser() {
        return idUser;
    }

    public void setIdUser(int idUser) {
        this.idUser = idUser;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    protected String getPassword() {
        return password;
    }

    protected void setPassword(String password) {
        this.password = password;
    }
    public String getRole() { 
        return role;
    }
}
