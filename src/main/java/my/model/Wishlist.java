package my.model;

import java.util.Date;

public class Wishlist {
    private int wishId;
    private String userId;
    private int clothId;
    private Date regdate;
    
    // Join용 (상품 정보)
    private String clothTitle;
    private String clothImg;
    private int clothPrice;

    public Wishlist() {}

    public int getWishId() { return wishId; }
    public void setWishId(int wishId) { this.wishId = wishId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getClothId() { return clothId; }
    public void setClothId(int clothId) { this.clothId = clothId; }
    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }

    public String getClothTitle() { return clothTitle; }
    public void setClothTitle(String clothTitle) { this.clothTitle = clothTitle; }
    public String getClothImg() { return clothImg; }
    public void setClothImg(String clothImg) { this.clothImg = clothImg; }
    public int getClothPrice() { return clothPrice; }
    public void setClothPrice(int clothPrice) { this.clothPrice = clothPrice; }
}
