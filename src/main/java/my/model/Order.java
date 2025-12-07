package my.model;

import java.util.Date;

public class Order {
    private int orderId;
    private String userId;
    private int totalAmount;
    private String status;
    private String receiverName;
    private String receiverPhone;
    private String address;
    private String depositor;
    private Date orderDate;
    private String trackingCarrier;
    private String trackingNum;

    public Order() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getTotalAmount() { return totalAmount; }
    public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }
    public String getReceiverPhone() { return receiverPhone; }
    public void setReceiverPhone(String receiverPhone) { this.receiverPhone = receiverPhone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getDepositor() { return depositor; }
    public void setDepositor(String depositor) { this.depositor = depositor; }
    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
    public String getTrackingCarrier() { return trackingCarrier; }
    public void setTrackingCarrier(String trackingCarrier) { this.trackingCarrier = trackingCarrier; }
    public String getTrackingNum() { return trackingNum; }
    public void setTrackingNum(String trackingNum) { this.trackingNum = trackingNum; }
}
