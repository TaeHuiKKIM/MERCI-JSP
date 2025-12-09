package my.model;

import java.util.Date;

public class Review {
    private int reviewId;
    private String userId;
    private int clothId;
    private int rating;
    private String content;
    private Date regdate;
    private String userName; // Join with User table

    public Review() {}

    public Review(int reviewId, String userId, int clothId, int rating, String content, Date regdate) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.clothId = clothId;
        this.rating = rating;
        this.content = content;
        this.regdate = regdate;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public int getClothId() { return clothId; }
    public void setClothId(int clothId) { this.clothId = clothId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
