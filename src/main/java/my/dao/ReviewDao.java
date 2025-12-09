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
            String sql = "SELECT r.*, u.name as userName FROM review r " +
                         "LEFT JOIN user u ON r.userId = u.userId " +
                         "WHERE r.clothId = ? ORDER BY r.reviewId DESC";
            pstmt = conn.prepareStatement(sql);
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
                
                String uName = rs.getString("userName");
                r.setUserName(uName != null ? uName : r.getUserId());
                
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
    
    // 사용자별 상품 리뷰 조회 (작성 여부 확인용)
    public Review selectByUserIdAndClothId(Connection conn, String userId, int clothId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT r.*, u.name as userName FROM review r " +
                         "LEFT JOIN user u ON r.userId = u.userId " +
                         "WHERE r.userId = ? AND r.clothId = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, clothId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("reviewId"));
                r.setUserId(rs.getString("userId"));
                r.setClothId(rs.getInt("clothId"));
                r.setRating(rs.getInt("rating"));
                r.setContent(rs.getString("content"));
                r.setRegdate(rs.getTimestamp("regdate"));
                
                String uName = rs.getString("userName");
                r.setUserName(uName != null ? uName : r.getUserId());
                
                return r;
            }
            return null;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }
    
    // 리뷰 수정
    public void update(Connection conn, Review review) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement("UPDATE review SET rating = ?, content = ? WHERE reviewId = ? AND userId = ?");
            pstmt.setInt(1, review.getRating());
            pstmt.setString(2, review.getContent());
            pstmt.setInt(3, review.getReviewId());
            pstmt.setString(4, review.getUserId());
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
    
    // 리뷰 삭제
    public void delete(Connection conn, int reviewId, String userId) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement("DELETE FROM review WHERE reviewId = ? AND userId = ?");
            pstmt.setInt(1, reviewId);
            pstmt.setString(2, userId);
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
}
