package my.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import my.model.User;
import my.util.JdbcUtil;

public class UserDao {

	public void insert(Connection conn, User user) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("insert into user (userId, password, name, registerTime, findQ, findA) values(?,?,?,?,?,?)");
			pstmt.setString(1, user.getUserId());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(3, user.getName());
			pstmt.setTimestamp(4, new Timestamp(user.getRegisterTime().getTime()));
			pstmt.setString(5, user.getFindQ());
			pstmt.setString(6, user.getFindA());
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}

	// [추가] 비밀번호 찾기 (질문/답변 검증)
	public boolean verifyUserForRecovery(Connection conn, String userId, String findQ, String findA) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// find_q는 고정된 질문이므로 사용자가 선택한 질문과 DB에 저장된 질문이 일치하는지,
			// 그리고 답변이 일치하는지 확인해야 합니다.
			// 하지만 보통 DB에 질문 자체를 저장하거나 질문 키를 저장합니다.
			// 여기서는 텍스트 그대로 비교합니다.
			String sql = "SELECT count(*) FROM user WHERE userId = ? AND findQ = ? AND findA = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, findQ);
			pstmt.setString(3, findA);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) > 0;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return false;
	}

	public User selectById(Connection conn, String userId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = null;
		try {
			pstmt = conn.prepareStatement("select * from user where userId = ?");
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				user = new User();
				user.setUserId(rs.getString(1));
				user.setPassword(rs.getString(2));
				user.setName(rs.getString(3));
				user.setRegisterTime(rs.getTimestamp(4));
				user.setFindQ(rs.getString(5));
				user.setFindA(rs.getString(6));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
			JdbcUtil.close(rs);
		}
		return user;
	}

	public boolean checkPassword(Connection conn, String userId, String password) throws SQLException {
		User user = selectById(conn, userId);
		if (user.getPassword().equals(password) == true)
			return true;
		else
			return false;
	}

	public boolean idCheck(Connection conn, String userId) throws SQLException {
		boolean rst = false;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			String sql = "select * from user where userId=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, userId);
			rs = ps.executeQuery();
			if (rs.next()) {
				rst = true; // 이미 아이디가 DB에 존재한다는 의미
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// JdbcUtil.close(conn);
			JdbcUtil.close(ps);
			JdbcUtil.close(rs);
		}
		return rst;

	}

	public List<User> selectLike(Connection conn, String target, String keyword) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		User user = null;
		List<User> users = new ArrayList<User>();
		try {
			pstmt = conn.prepareStatement("select * from user where " + target + " like ?");
			pstmt.setString(1, "%" + keyword + "%");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				user = new User();
				user.setUserId(rs.getString(1));
				user.setPassword(rs.getString(2));
				user.setName(rs.getString(3));
				user.setRegisterTime(rs.getTimestamp(4));
				users.add(user);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
			JdbcUtil.close(rs);
		}
		return users;
	}

	public void update(Connection conn, User user) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			pstmt = conn.prepareStatement("update user set password=?,name=? where userId=?");
			pstmt.setString(1, user.getPassword());
			pstmt.setString(2, user.getName());
			pstmt.setString(3, user.getUserId());
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// JdbcUtil.close(conn);
			JdbcUtil.close(pstmt);
		}
	}

	// [추가] 회원 탈퇴 (삭제)
	public int deleteUser(Connection conn, String userId) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			// 외래키 설정(CASCADE)이 되어 있다면, 회원만 지워도 배송지까지 싹 지워집니다.
			String sql = "DELETE FROM user WHERE userId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);

			return pstmt.executeUpdate(); // 성공 시 1 반환
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	public int selectCount(Connection conn) throws SQLException {
		Statement stmt = null;
		ResultSet rs = null;
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery("select count(*) from user");
			rs.next();
			return rs.getInt(1);
		} finally {
			// JdbcUtil.close(conn);
			JdbcUtil.close(rs);
		}
	}

	public List<User> selectList(Connection conn) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<User> userList = null;
		try {
			pstmt = conn.prepareStatement("select * from user ");
			rs = pstmt.executeQuery();
			userList = new ArrayList<User>();
			while (rs.next()) {
				User user = new User();
				user.setUserId(rs.getString(1));
				user.setPassword(rs.getString(2));
				user.setName(rs.getString(3));
				user.setRegisterTime(rs.getTimestamp(4));
				user.setFindQ(rs.getString(5));
				user.setFindA(rs.getString(6));
				userList.add(user);
			}
		} finally {
			// JdbcUtil.close(conn);
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return userList;
	}

	// [추가] 비밀번호 변경 메소드
	public int updatePassword(Connection conn, String userId, String newPassword) throws SQLException {
		PreparedStatement pstmt = null;
		int result = 0;
		try {
			// user 테이블의 password 컬럼을 업데이트합니다.
			String sql = "UPDATE user SET password = ? WHERE userId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, newPassword);
			pstmt.setString(2, userId);

			result = pstmt.executeUpdate(); // 성공하면 1 반환
		} finally {
			JdbcUtil.close(pstmt);
		}
		return result;
	}

	// [추가] 카카오 로그인 전용 회원가입
	public void insertKakaoUser(Connection conn, String kakaoId, String nickname) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			// userId를 kakaoId로, 비밀번호는 임의의 값(kakao_user), 이름은 닉네임 사용
			pstmt = conn.prepareStatement("insert into user (userId, password, name, registerTime, findQ, findA) values(?,?,?,?,?,?)");
			pstmt.setString(1, kakaoId);
			pstmt.setString(2, "kakao_user"); // 비밀번호는 더미값
			pstmt.setString(3, nickname);
			pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(5, "카카오톡 가입 사용자"); // findQ의 기본값
			pstmt.setString(6, "카카오"); // findA의 기본값
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	// [추가] 아이디 찾기 (이름으로 검색)
	public List<String> findIdsByName(Connection conn, String name) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<String> list = new ArrayList<>();
		try {
			String sql = "SELECT userId FROM user WHERE name = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				list.add(rs.getString("userId"));
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return list;
	}

	// [추가] 비밀번호 찾기용 사용자 확인 (아이디 + 이름 일치 여부)
	public boolean verifyUser(Connection conn, String userId, String name) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT count(*) FROM user WHERE userId = ? AND name = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, name);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) > 0;
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return false;
	}
}
