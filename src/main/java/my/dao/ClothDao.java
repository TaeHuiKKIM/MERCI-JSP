package my.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import my.model.Cloth;
import my.util.JdbcUtil;

public class ClothDao {

    // 1. 옷 등록 (insert)
    public void insert(Connection conn, Cloth cloth) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "INSERT INTO cloth (title, maker, price, imgBody, imgFront, imgBack, imgDetail, description, stock, sizes, colors, clothType, freq, openDate) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, cloth.getTitle());
            pstmt.setString(2, cloth.getMaker());
            pstmt.setInt(3, cloth.getPrice());
            pstmt.setString(4, cloth.getImgBody());
            pstmt.setString(5, cloth.getImgFront());
            pstmt.setString(6, cloth.getImgBack());
            pstmt.setString(7, cloth.getImgDetail());
            pstmt.setString(8, cloth.getDescription());
            pstmt.setInt(9, cloth.getStock());
            pstmt.setString(10, cloth.getSizes());
            pstmt.setString(11, cloth.getColors());
            pstmt.setString(12, cloth.getClothType());
            pstmt.setInt(13, cloth.getFreq());
            pstmt.setTimestamp(14, new Timestamp(cloth.getOpenDate().getTime()));
            
            pstmt.executeUpdate();
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
                cloth = makeClothFromResultSet(rs);
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

    // 5. 검색 (selectLike)
    public List<Cloth> selectLike(Connection conn, String target, String keyword) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Cloth> cloths = new ArrayList<>();
        try {
            String sql = "SELECT * FROM cloth WHERE " + target + " LIKE ?";
            pstmt = conn.prepareStatement(sql);
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
            String sql = "SELECT * FROM cloth ORDER BY " + target + " DESC";
            pstmt = conn.prepareStatement(sql);
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

    // 8. 다중 필터 검색 (selectListMulti)
    public List<Cloth> selectListMulti(Connection conn, String category, String sort, String search) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Cloth> list = new ArrayList<>();
        
        try {
            StringBuilder sql = new StringBuilder("SELECT * FROM cloth WHERE 1=1 ");
            List<Object> params = new ArrayList<>();

            // 카테고리 필터
            if (category != null && !category.isEmpty() && !"All".equalsIgnoreCase(category)) {
                sql.append("AND clothType = ? ");
                params.add(category);
            }

            // 검색 필터
            if (search != null && !search.isEmpty()) {
                sql.append("AND (title LIKE ? OR maker LIKE ?) ");
                params.add("%" + search + "%");
                params.add("%" + search + "%");
            }

            // 정렬
            if ("date".equals(sort)) {
                sql.append("ORDER BY opendate DESC");
            } else if ("freq".equals(sort)) {
                sql.append("ORDER BY freq DESC");
            } else if ("price_asc".equals(sort)) {
                sql.append("ORDER BY price ASC");
            } else if ("price_desc".equals(sort)) {
                sql.append("ORDER BY price DESC");
            } else {
                sql.append("ORDER BY id DESC"); // Default
            }

            pstmt = conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(makeClothFromResultSet(rs));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }

    // 9. 정보 수정 (update)
    public void update(Connection conn, Cloth cloth) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE cloth SET title=?, maker=?, price=?, imgBody=?, imgFront=?, imgBack=?, imgDetail=?, description=?, stock=?, sizes=?, colors=?, clothType=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, cloth.getTitle());
            pstmt.setString(2, cloth.getMaker());
            pstmt.setInt(3, cloth.getPrice());
            pstmt.setString(4, cloth.getImgBody());
            pstmt.setString(5, cloth.getImgFront());
            pstmt.setString(6, cloth.getImgBack());
            pstmt.setString(7, cloth.getImgDetail());
            pstmt.setString(8, cloth.getDescription());
            pstmt.setInt(9, cloth.getStock());
            pstmt.setString(10, cloth.getSizes());
            pstmt.setString(11, cloth.getColors());
            pstmt.setString(12, cloth.getClothType());
            pstmt.setInt(13, cloth.getId());
            
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    // 10. 삭제 (deleteById)
    public void deleteById(Connection conn, int id) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "DELETE FROM cloth WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    // [헬퍼 메서드] ResultSet에서 Cloth 객체 생성
    private Cloth makeClothFromResultSet(ResultSet rs) throws SQLException {
        Cloth cloth = new Cloth();
        cloth.setId(rs.getInt("id"));
        cloth.setTitle(rs.getString("title"));
        cloth.setMaker(rs.getString("maker"));
        cloth.setPrice(rs.getInt("price"));
        cloth.setImgBody(rs.getString("imgBody"));
        cloth.setImgFront(rs.getString("imgFront"));
        cloth.setImgBack(rs.getString("imgBack"));
        cloth.setImgDetail(rs.getString("imgDetail"));
        cloth.setDescription(rs.getString("description"));
        cloth.setStock(rs.getInt("stock"));
        cloth.setSizes(rs.getString("sizes"));
        cloth.setColors(rs.getString("colors"));
        cloth.setClothType(rs.getString("clothType"));
        cloth.setFreq(rs.getInt("freq"));
        cloth.setOpenDate(rs.getTimestamp("opendate"));
        return cloth;
    }

    // 카테고리별 상품 수 통계
    public java.util.Map<String, Integer> getCategoryCount(Connection conn) throws SQLException {
        Statement stmt = null;
        ResultSet rs = null;
        java.util.Map<String, Integer> map = new java.util.HashMap<>();
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT clothType, COUNT(*) FROM cloth GROUP BY clothType");
            while (rs.next()) {
                String type = rs.getString(1);
                if(type == null) type = "Etc";
                map.put(type, rs.getInt(2));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(stmt);
        }
        return map;
    }
}