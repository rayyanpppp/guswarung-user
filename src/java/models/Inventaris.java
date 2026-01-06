package models;

public class Inventaris {
    private int id;
    private String name;        // Sesuai kolom db: name
    private int quantity;       // Sesuai kolom db: quantity
    private String unit;        // Sesuai kolom db: unit
    private int minimalStock;   // Sesuai kolom db: minimal_stock
    private double price;       // Sesuai kolom db: price
    private String status;      // Sesuai kolom db: status

    // Constructor Kosong
    public Inventaris() {}

    // Constructor Lengkap
    public Inventaris(int id, String name, int quantity, String unit, int minimalStock, double price, String status) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.unit = unit;
        this.minimalStock = minimalStock;
        this.price = price;
        this.status = status;
    }

    // --- GETTER & SETTER ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public int getMinimalStock() { return minimalStock; }
    public void setMinimalStock(int minimalStock) { this.minimalStock = minimalStock; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}