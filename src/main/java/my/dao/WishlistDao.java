package my.dao;

import java.sql.*;
import java.util.*;
import my.model.*;
import my.util.JdbcUtil;

public class WishlistDao {
    
    // 찜 추가/삭제 토글
    public boolean toggle(Connection conn, String userId, int clothId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean isAdded = false;
        
        try {
            // 1. 존재 여부 확인
            pstmt = conn.prepareStatement("SELECT wishId FROM wishlist WHERE userId=? AND clothId=?");
            pstmt.setString(1, userId);
            pstmt.setInt(2, clothId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // 이미 존재하면 삭제
                int wishId = rs.getInt(1);
                JdbcUtil.close(pstmt); // 닫고 새로 생성
                pstmt = conn.prepareStatement("DELETE FROM wishlist WHERE wishId=?");
                pstmt.setInt(1, wishId);
                pstmt.executeUpdate();
                isAdded = false;
            } else {
                // 없으면 추가
                JdbcUtil.close(pstmt);
                pstmt = conn.prepareStatement("INSERT INTO wishlist (userId, clothId, regdate) VALUES (?, ?, NOW())");
                pstmt.setString(1, userId);
                pstmt.setInt(2, clothId);
                pstmt.executeUpdate();
                isAdded = true;
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return isAdded;
    }

    // 찜 목록 조회 (상품 정보 조인)
    public List<Wishlist> selectList(Connection conn, String userId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Wishlist> list = new ArrayList<>();
        try {
            String sql = "SELECT w.*, c.title, c.img_body, c.price " +
                         "FROM wishlist w " +
                         "JOIN cloth c ON w.clothId = c.id " +
                         "WHERE w.userId = ? " +
                         "ORDER BY w.wishId DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Wishlist w = new Wishlist();
                w.setWishId(rs.getInt("wishId"));
                w.setUserId(rs.getString("userId"));
                w.setClothId(rs.getInt("clothId"));
                w.setRegdate(rs.getTimestamp("regdate"));
                
                w.setClothTitle(rs.getString("title"));
                w.setClothImg(rs.getString("img_body"));
                w.setClothPrice(rs.getInt("price"));
                list.add(w);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    
    // 특정 상품 찜 여부 확인
    public boolean isWished(Connection conn, String userId, int clothId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement("SELECT 1 FROM wishlist WHERE userId=? AND clothId=?");
            pstmt.setString(1, userId);
            pstmt.setInt(2, clothId);
            rs = pstmt.executeQuery();
            return rs.next();
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }
}
