package my.dao;

import java.sql.*;
import java.util.*;
import my.model.Review;
import my.util.JdbcUtil;

public class ReviewDao {
    
    public void insert(Connection conn, Review review) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement("INSERT INTO review (userId, clothId, rating, content, regdate) VALUES (?, ?, ?, ?, NOW())");
            pstmt.setString(1, review.getUserId());
            pstmt.setInt(2, review.getClothId());
            pstmt.setInt(3, review.getRating());
            pstmt.setString(4, review.getContent());
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    public List<Review> selectListByClothId(Connection conn, int clothId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Review> list = new ArrayList<>();
        try {
            pstmt = conn.prepareStatement("SELECT * FROM review WHERE clothId = ? ORDER BY reviewId DESC");
            pstmt.setInt(1, clothId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("reviewId"));
                r.setUserId(rs.getString("userId"));
                r.setClothId(rs.getInt("clothId"));
                r.setRating(rs.getInt("rating"));
                r.setContent(rs.getString("content"));
                r.setRegdate(rs.getTimestamp("regdate"));
                list.add(r);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    
    // 평균 별점 구하기
    public double getAverageRating(Connection conn, int clothId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement("SELECT AVG(rating) FROM review WHERE clothId = ?");
            pstmt.setInt(1, clothId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
            return 0.0;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }
}
