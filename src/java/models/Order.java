package models;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int id;
    private String customerName;
    private String customerPhone;
    private String customerAddress;
    private String notes;
    private String paymentMethod;
    private long subtotal;
    private long ppnAmount;
    private long shippingFee;
    private long totalAmount; // Gunakan satu variabel ini saja
    private String paymentProofPath;
    private String status;
    private int userId;
    private Timestamp createdAt;
    private List<OrderDetail> details;

    public Order() {}

    // GETTER AND SETTER
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    
    public String getCustomerAddress() { return customerAddress; }
    public void setCustomerAddress(String customerAddress) { this.customerAddress = customerAddress; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public long getSubtotal() { return subtotal; }
    public void setSubtotal(long subtotal) { this.subtotal = subtotal; }
    
    public long getPpnAmount() { return ppnAmount; }
    public void setPpnAmount(long ppnAmount) { this.ppnAmount = ppnAmount; }
    
    public long getShippingFee() { return shippingFee; }
    public void setShippingFee(long shippingFee) { this.shippingFee = shippingFee; }
    
    public long getTotalAmount() { return totalAmount; }
    public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }
    
    public String getPaymentProofPath() { return paymentProofPath; }
    public void setPaymentProofPath(String paymentProofPath) { this.paymentProofPath = paymentProofPath; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public List<OrderDetail> getDetails() { return details; }
    public void setDetails(List<OrderDetail> details) { this.details = details; }

    // Menambahkan alias getter untuk kompatibilitas jika JSP memanggil total_amount
    public long getTotal_amount() { return totalAmount; }
    public void setTotal_amount(long totalAmount) { this.totalAmount = totalAmount; }
}