package my.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import my.model.Cloth;
import my.util.JdbcUtil;

public class ClothDao {

	public void insert(Connection conn, Cloth cloth) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			String sql = "insert into cloth (title, maker, price, img_body, img_front, img_back, img_detail, "
					+ "description, stock, sizes, colors, freq, opendate, clothType) "
					+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
			pstmt.setInt(12, cloth.getFreq());
			pstmt.setTimestamp(13, new Timestamp(cloth.getOpenDate().getTime()));
			pstmt.setString(14, cloth.getClothType());
			pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public Cloth selectById(Connection conn, int clothId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Cloth cloth = null;
		try {
			pstmt = conn.prepareStatement("select * from cloth where id = ?");
			pstmt.setInt(1, clothId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				cloth = mapResultSetToCloth(rs);
			}
		} finally {
			JdbcUtil.close(pstmt);
			JdbcUtil.close(rs);
		}
		return cloth;
	}
	
	public List<Cloth> selectLike(Connection conn, String target, String keyword) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> cloths = new ArrayList<Cloth>();
		try {
			pstmt = conn.prepareStatement("select * from cloth where " + target + " like ?");
			pstmt.setString(1, "%" + keyword + "%");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				cloths.add(mapResultSetToCloth(rs));
			}
		} finally {
			JdbcUtil.close(pstmt);
			JdbcUtil.close(rs);
		}
		return cloths;
	}

	public void update(Connection conn, Cloth cloth) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			String sql = "update cloth set title=?, maker=?, price=?, clothType=?, "
					+ "img_body=?, img_front=?, img_back=?, img_detail=?, "
					+ "description=?, stock=?, sizes=?, colors=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, cloth.getTitle());
			pstmt.setString(2, cloth.getMaker());
			pstmt.setInt(3, cloth.getPrice());
			pstmt.setString(4, cloth.getClothType());
			pstmt.setString(5, cloth.getImgBody());
			pstmt.setString(6, cloth.getImgFront());
			pstmt.setString(7, cloth.getImgBack());
			pstmt.setString(8, cloth.getImgDetail());
			pstmt.setString(9, cloth.getDescription());
			pstmt.setInt(10, cloth.getStock());
			pstmt.setString(11, cloth.getSizes());
			pstmt.setString(12, cloth.getColors());
			pstmt.setInt(13, cloth.getId());
			pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public void updateFreq(Connection conn, int id) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("update cloth set freq = freq + 1 where id=?");
			pstmt.setInt(1, id);
			pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public void deleteById(Connection conn, int clothId) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("delete from cloth where id = ?");
			pstmt.setInt(1, clothId);
			pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public int selectCount(Connection conn) throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select count(*) from cloth");
			rs.next();
			return rs.getInt(1);
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
		}
	}

	public List<Cloth> selectList(Connection conn) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> clothList = new ArrayList<Cloth>();
		try {
			pstmt = conn.prepareStatement("select * from cloth");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				clothList.add(mapResultSetToCloth(rs));
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}

	public List<Cloth> selectListFreq(Connection conn, String target) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> clothList = new ArrayList<Cloth>();
		try {
			pstmt = conn.prepareStatement("select * from cloth order by " + target + " desc");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				clothList.add(mapResultSetToCloth(rs));
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}
    
    public List<Cloth> selectListByClothType(Connection conn, String clothType) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> clothList = new ArrayList<Cloth>();
		try {
			// Note: Using direct string concat here as per original code style, usually prepared statement params are safer
			pstmt = conn.prepareStatement("select * from cloth where clothType = ?");
            pstmt.setString(1, clothType);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				clothList.add(mapResultSetToCloth(rs));
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}

	public List<Cloth> selectListMulti(Connection conn, String category, String sort, String search) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> clothList = new ArrayList<>();
		StringBuilder sql = new StringBuilder("select * from cloth where 1=1");

		if (category != null && !category.isEmpty()) {
			sql.append(" and clothType = ?");
		}
		if (search != null && !search.isEmpty()) {
			sql.append(" and (title like ? or maker like ?)");
		}

		if ("price_asc".equals(sort)) {
			sql.append(" order by price asc");
		} else if ("price_desc".equals(sort)) {
			sql.append(" order by price desc");
		} else if ("freq".equals(sort)) {
			sql.append(" order by freq desc");
		} else {
			sql.append(" order by opendate desc");
		}

		try {
			pstmt = conn.prepareStatement(sql.toString());
			int index = 1;
			
			if (category != null && !category.isEmpty()) {
				pstmt.setString(index++, category);
			}
			if (search != null && !search.isEmpty()) {
				String keyword = "%" + search + "%";
				pstmt.setString(index++, keyword);
				pstmt.setString(index++, keyword);
			}

			rs = pstmt.executeQuery();
			while (rs.next()) {
				clothList.add(mapResultSetToCloth(rs));
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}
	
	// Helper method to map ResultSet to Cloth object to avoid code duplication
	private Cloth mapResultSetToCloth(ResultSet rs) throws SQLException {
		Cloth cloth = new Cloth();
		cloth.setId(rs.getInt("id"));
		cloth.setTitle(rs.getString("title"));
		cloth.setMaker(rs.getString("maker"));
		cloth.setPrice(rs.getInt("price"));
		cloth.setImgBody(rs.getString("img_body"));
		cloth.setImgFront(rs.getString("img_front"));
		cloth.setImgBack(rs.getString("img_back"));
		cloth.setImgDetail(rs.getString("img_detail"));
		cloth.setDescription(rs.getString("description"));
		cloth.setStock(rs.getInt("stock"));
		cloth.setSizes(rs.getString("sizes"));
		cloth.setColors(rs.getString("colors"));
		cloth.setFreq(rs.getInt("freq"));
		cloth.setOpenDate(rs.getTimestamp("opendate"));
		cloth.setClothType(rs.getString("clothType"));
		return cloth;
	}
}