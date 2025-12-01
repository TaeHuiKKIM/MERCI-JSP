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
			pstmt = conn.prepareStatement(
					"insert into cloth (title,maker,price,poster,freq,opendate,clothType)" + " values(?,?,?,?,?,?,?)");
			pstmt.setString(1, cloth.getTitle());
			pstmt.setString(2, cloth.getMaker());
			pstmt.setInt(3, cloth.getPrice());
			pstmt.setString(4, cloth.getPoster());
			pstmt.setInt(5, cloth.getFreq());
			pstmt.setTimestamp(6, new Timestamp(cloth.getOpenDate().getTime()));
			pstmt.setString(7, cloth.getClothType());
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
				cloth = new Cloth();
				cloth.setId(rs.getInt(1));
				cloth.setTitle(rs.getString(2));
				cloth.setMaker(rs.getString(3));
				cloth.setPrice(rs.getInt(4));
				cloth.setPoster(rs.getString(5));
				cloth.setFreq(rs.getInt(6));
				cloth.setOpenDate(rs.getTimestamp(7));
				cloth.setClothType(rs.getString(8));
			}
		} finally {
			JdbcUtil.close(pstmt);
			JdbcUtil.close(rs);
		}
		return cloth;
	}
    
    // ... (select methods omitted) ...

	public void update(Connection conn, Cloth cloth) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			// poster 필드 업데이트 추가
			pstmt = conn.prepareStatement("update cloth set title=?,maker=?,price=?,clothType=?,poster=? where id=?");
			pstmt.setString(1, cloth.getTitle());
			pstmt.setString(2, cloth.getMaker());
			pstmt.setInt(3, cloth.getPrice());
			pstmt.setString(4, cloth.getClothType());
			pstmt.setString(5, cloth.getPoster());
			pstmt.setInt(6, cloth.getId());
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
		List<Cloth> clothList = null;
		try {
			pstmt = conn.prepareStatement("select * from cloth ");
			rs = pstmt.executeQuery();
			clothList = new ArrayList<Cloth>();
			while (rs.next()) {
				Cloth cloth = new Cloth();
				cloth.setId(rs.getInt(1));
				cloth.setTitle(rs.getString(2));
				cloth.setMaker(rs.getString(3));
				cloth.setPrice(rs.getInt(4));
				cloth.setPoster(rs.getString(5));
				cloth.setFreq(rs.getInt(6));
				cloth.setOpenDate(rs.getTimestamp(7));
				cloth.setClothType(rs.getString(8));
				clothList.add(cloth);
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}

	public List<Cloth> selectListOrders(Connection conn, String target, String direct) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> clothList = null;
		try {
			pstmt = conn.prepareStatement("select * from cloth order by " + target + " " + direct);
			rs = pstmt.executeQuery();
			clothList = new ArrayList<Cloth>();
			while (rs.next()) {
				Cloth cloth = new Cloth();
				cloth.setId(rs.getInt(1));
				cloth.setTitle(rs.getString(2));
				cloth.setMaker(rs.getString(3));
				cloth.setPrice(rs.getInt(4));
				cloth.setPoster(rs.getString(5));
				cloth.setFreq(rs.getInt(6));
				cloth.setOpenDate(rs.getTimestamp(7));
				cloth.setClothType(rs.getString(8));
				clothList.add(cloth);
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
		List<Cloth> clothList = null;
		try {
			pstmt = conn.prepareStatement("select * from cloth order by " + target + " desc");
			rs = pstmt.executeQuery();
			clothList = new ArrayList<Cloth>();
			while (rs.next()) {
				Cloth cloth = new Cloth();
				cloth.setId(rs.getInt(1));
				cloth.setTitle(rs.getString(2));
				cloth.setMaker(rs.getString(3));
				cloth.setPrice(rs.getInt(4));
				cloth.setPoster(rs.getString(5));
				cloth.setFreq(rs.getInt(6));
				cloth.setOpenDate(rs.getTimestamp(7));
				cloth.setClothType(rs.getString(8));
				clothList.add(cloth);
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}

	public List<Cloth> selectListLimit(Connection conn, int offset, int count) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> clothList = null;
		try {
			pstmt = conn.prepareStatement("select * from cloth limit ?,?");
			pstmt.setInt(1, offset);
			pstmt.setInt(2, count);
			rs = pstmt.executeQuery();
			clothList = new ArrayList<Cloth>();
			while (rs.next()) {
				Cloth cloth = new Cloth();
				cloth.setId(rs.getInt(1));
				cloth.setTitle(rs.getString(2));
				cloth.setMaker(rs.getString(3));
				cloth.setPrice(rs.getInt(4));
				cloth.setPoster(rs.getString(5));
				cloth.setFreq(rs.getInt(6));
				cloth.setOpenDate(rs.getTimestamp(7));
				cloth.setClothType(rs.getString(8));
				clothList.add(cloth);
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}

	public List<String> selectClothType(Connection conn) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<String> clothTypeList = new ArrayList<String>();
		try {
			pstmt = conn.prepareStatement(
					"select clothType, count(*) as cnt from cloth2 group by clothType order by cnt desc");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				String clothType = rs.getString("clothType");
				clothTypeList.add(clothType);
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothTypeList;
	}

	public List<Cloth> selectListByClothType(Connection conn, String clothType) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<Cloth> clothList = null;
		try {
			pstmt = conn.prepareStatement("select * from cloth where clothType= " + clothType);
			rs = pstmt.executeQuery();
			clothList = new ArrayList<Cloth>();
			while (rs.next()) {
				Cloth cloth = new Cloth();
				cloth.setId(rs.getInt(1));
				cloth.setTitle(rs.getString(2));
				cloth.setMaker(rs.getString(3));
				cloth.setPrice(rs.getInt(4));
				cloth.setPoster(rs.getString(5));
				cloth.setFreq(rs.getInt(6));
				cloth.setOpenDate(rs.getTimestamp(7));
				cloth.setClothType(rs.getString(8));
				clothList.add(cloth);
			}
		} finally {
			JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return clothList;
	}
}
