package my.model;

public class OrderItem {
    private int itemId;
    private int orderId;
    private int clothId;
    private int quantity;
    private int price;
    
    // 조인용 필드 (상품명, 이미지)
    private String clothTitle;
    private String clothImg;

    public OrderItem() {}

    public OrderItem(int clothId, int quantity, int price) {
        this.clothId = clothId;
        this.quantity = quantity;
        this.price = price;
    }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getClothId() { return clothId; }
    public void setClothId(int clothId) { this.clothId = clothId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
    public String getClothTitle() { return clothTitle; }
    public void setClothTitle(String clothTitle) { this.clothTitle = clothTitle; }
    public String getClothImg() { return clothImg; }
    public void setClothImg(String clothImg) { this.clothImg = clothImg; }
}
