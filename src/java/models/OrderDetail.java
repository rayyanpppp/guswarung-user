package models;

public class OrderDetail {
    private int id;
    private int orderId;
    private int menuId;
    private String productName;
    private int quantity;
    private long pricePerUnit;
    private long totalPrice;

    public OrderDetail() {}

    // GETTER AND SETTER
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public long getPricePerUnit() { return pricePerUnit; }
    public void setPricePerUnit(long pricePerUnit) { this.pricePerUnit = pricePerUnit; }

    public long getTotalPrice() { return totalPrice; }
    public void setTotalPrice(long totalPrice) { this.totalPrice = totalPrice; }
}