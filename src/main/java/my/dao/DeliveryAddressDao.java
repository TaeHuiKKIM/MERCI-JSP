package my.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import my.model.DeliveryAddress;
import my.util.JdbcUtil;

public class DeliveryAddressDao {

	// 1. 배송지 추가 (insert)
	public void insert(Connection conn, DeliveryAddress addr) throws SQLException {
		PreparedStatement pstmt = null;
		try {

			String sql = "INSERT INTO deliveryaddr (userId, addrName, recipient, phone, addrRoad, addrDetail) VALUES (?, ?, ?, ?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, addr.getUserId());
			pstmt.setString(2, addr.getAddrName());
			pstmt.setString(3, addr.getRecipientName()); // 모델:recipientName -> DB:recipient
			pstmt.setString(4, addr.getPhone());
			pstmt.setString(5, addr.getAddrRoad());
			pstmt.setString(6, addr.getAddrDetail());

			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
			throw e; // 에러가 나면 호출한 곳(JSP)에서 알 수 있게 던져줍니다.
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	// 2. 특정 회원의 배송지 목록 조회 (selectList)
	// 2. 특정 회원의 배송지 목록 조회
	public List<DeliveryAddress> selectList(Connection conn, String userId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// 1. 리스트 생성 (이게 있어야 담을 수 있습니다)
		List<DeliveryAddress> list = new ArrayList<>();

		try {
			String sql = "SELECT * FROM deliveryaddr WHERE userId = ? ORDER BY addrId DESC";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				DeliveryAddress addr = new DeliveryAddress();

				// DB 컬럼명("문자열")과 모델의 Setter 메서드를 매칭
				addr.setAddrId(rs.getInt("addrId"));
				addr.setUserId(rs.getString("userId"));
				addr.setAddrName(rs.getString("addrName"));
				addr.setRecipientName(rs.getString("recipient")); // DB컬럼: recipient
				addr.setPhone(rs.getString("phone"));
				addr.setAddrRoad(rs.getString("addrRoad")); // DB컬럼: addrRoad
				addr.setAddrDetail(rs.getString("addrDetail")); // DB컬럼: addrDetail

				// [중요] 다 만든 객체를 리스트에 추가해야 합니다! (이 줄이 없으면 오류남)
				list.add(addr);
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		// 3. 꽉 채운 리스트 반환
		return list;
	}

	// 3. 배송지 삭제 (delete) - 나중에 필요할 기능
	public void delete(Connection conn, int addrId) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			String sql = "DELETE FROM deliveryaddr WHERE addrId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, addrId);
			pstmt.executeUpdate();
		} finally {
			JdbcUtil.close(pstmt);
		}
	}
}