package my.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import my.model.Cloth;
import my.util.JdbcUtil;

public class ClothDao {

    // 1. 옷 등록 (insert) - 모든 필드 포함
    public void insert(Connection conn, Cloth cloth) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            // DB 컬럼명: title, maker, price, img_body, img_front, img_back, img_detail, description, stock, sizes, colors, clothType, freq, opendate
            String sql = "INSERT INTO cloth (title, maker, price, img_body, img_front, img_back, img_detail, description, stock, sizes, colors, clothType, freq, opendate) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, cloth.getTitle());
            pstmt.setString(2, cloth.getMaker());
            pstmt.setInt(3, cloth.getPrice());
            pstmt.setString(4, cloth.getImg_body());
            pstmt.setString(5, cloth.getImg_front());
            pstmt.setString(6, cloth.getImg_back());
            pstmt.setString(7, cloth.getImg_detail());
            pstmt.setString(8, cloth.getDescription());
            pstmt.setInt(9, cloth.getStock());
            pstmt.setString(10, cloth.getSizes());
            pstmt.setString(11, cloth.getColors());
            pstmt.setString(12, cloth.getClothType());
            pstmt.setInt(13, cloth.getFreq());
            pstmt.setTimestamp(14, new Timestamp(cloth.getOpenDate().getTime()));
            
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    // 2. ID로 조회 (selectById)
    public Cloth selectById(Connection conn, int clothId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Cloth cloth = null;
        try {
            pstmt = conn.prepareStatement("SELECT * FROM cloth WHERE id = ?");
            pstmt.setInt(1, clothId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                cloth = makeClothFromResultSet(rs); // 중복 코드 제거용 메서드 호출
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return cloth;
    }

    // 3. 전체 목록 조회 (selectList)
    public List<Cloth> selectList(Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Cloth> clothList = new ArrayList<>();
        try {
            pstmt = conn.prepareStatement("SELECT * FROM cloth ORDER BY id DESC");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                clothList.add(makeClothFromResultSet(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return clothList;
    }
    
    // 4. 카테고리별 조회 (selectListByClothType)
    public List<Cloth> selectListByClothType(Connection conn, String clothType) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Cloth> clothList = new ArrayList<>();
        try {
            // 문자열은 홑따옴표(')로 감싸야 함
            pstmt = conn.prepareStatement("SELECT * FROM cloth WHERE clothType = ?");
            pstmt.setString(1, clothType);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                clothList.add(makeClothFromResultSet(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return clothList;
    }

    // [헬퍼 메서드] ResultSet에서 Cloth 객체 생성 (중복 제거용)
    private Cloth makeClothFromResultSet(ResultSet rs) throws SQLException {
        Cloth cloth = new Cloth();
        cloth.setId(rs.getInt("id"));
        cloth.setTitle(rs.getString("title"));
        cloth.setMaker(rs.getString("maker"));
        cloth.setPrice(rs.getInt("price"));
        cloth.setImg_body(rs.getString("img_body"));
        cloth.setImg_front(rs.getString("img_front"));
        cloth.setImg_back(rs.getString("img_back"));
        cloth.setImg_detail(rs.getString("img_detail"));
        cloth.setDescription(rs.getString("description"));
        cloth.setStock(rs.getInt("stock"));
        cloth.setSizes(rs.getString("sizes"));
        cloth.setColors(rs.getString("colors"));
        cloth.setClothType(rs.getString("clothType"));
        cloth.setFreq(rs.getInt("freq"));
        cloth.setOpenDate(rs.getTimestamp("opendate"));
        return cloth;
    }

    // 5. 검색 (selectLike)
    public List<Cloth> selectLike(Connection conn, String target, String keyword) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Cloth> cloths = new ArrayList<>();
        try {
            pstmt = conn.prepareStatement("SELECT * FROM cloth WHERE " + target + " LIKE ?");
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                cloths.add(makeClothFromResultSet(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return cloths;
    }

    // 6. 조회수 증가 (updateFreq)
    public void updateFreq(Connection conn, int id) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement("UPDATE cloth SET freq = freq + 1 WHERE id = ?");
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
    
    // 7. 인기순 정렬 조회 (selectListFreq)
    public List<Cloth> selectListFreq(Connection conn, String target) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Cloth> clothList = new ArrayList<>();
        try {
            // target 컬럼 기준으로 내림차순 정렬 (freq, price 등)
            // SQL Injection 방지를 위해 target 검증 로직이 있으면 더 좋음
            pstmt = conn.prepareStatement("SELECT * FROM cloth ORDER BY " + target + " DESC");
            rs = pstmt.executeQuery();
            while (rs.next()) {
                clothList.add(makeClothFromResultSet(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return clothList;
    }
}