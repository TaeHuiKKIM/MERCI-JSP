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
			// DB컬럼명: userId, addrName, recipient, phone, addrRoad, addrDetail
			String sql = "INSERT INTO deliveryaddr (userId, addrName, recipient, phone, addrRoad, addrDetail, isDefault) VALUES (?, ?, ?, ?, ?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, addr.getUserId());
			pstmt.setString(2, addr.getAddrName());
			pstmt.setString(3, addr.getRecipientName());
			pstmt.setString(4, addr.getPhone());
			pstmt.setString(5, addr.getAddrRoad());
			pstmt.setString(6, addr.getAddrDetail());
			pstmt.setInt(7, addr.getIsDefault());

			pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	// 2. 특정 회원의 배송지 목록 조회 (selectList)
	public List<DeliveryAddress> selectList(Connection conn, String userId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<DeliveryAddress> list = new ArrayList<>();

		try {
			String sql = "SELECT * FROM deliveryaddr WHERE userId = ? ORDER BY addrId DESC";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				DeliveryAddress addr = new DeliveryAddress();
				addr.setAddrId(rs.getInt("addrId"));
				addr.setUserId(rs.getString("userId"));
				addr.setAddrName(rs.getString("addrName"));
				addr.setRecipientName(rs.getString("recipient"));
				addr.setPhone(rs.getString("phone"));
				addr.setAddrRoad(rs.getString("addrRoad"));
				addr.setAddrDetail(rs.getString("addrDetail"));
				addr.setIsDefault(rs.getInt("isDefault"));

				list.add(addr);
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return list;
	}

	// 3. 배송지 삭제 (delete)
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

	// [추가됨] 4. 배송지 수정 (update)
	public int update(Connection conn, DeliveryAddress addr) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			// 주소 고유번호(addrId)가 일치하는 행의 정보를 수정합니다.
			String sql = "UPDATE deliveryaddr SET addrName=?, recipient=?, phone=?, addrRoad=?, addrDetail=? WHERE addrId=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, addr.getAddrName());
			pstmt.setString(2, addr.getRecipientName());
			pstmt.setString(3, addr.getPhone());
			pstmt.setString(4, addr.getAddrRoad());
			pstmt.setString(5, addr.getAddrDetail());
			pstmt.setInt(6, addr.getIsDefault());

			// WHERE 조건절 (수정할 대상)
			pstmt.setInt(6, addr.getAddrId());

			return pstmt.executeUpdate(); // 성공 시 1 반환

		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	// [추가됨] 5. 배송지 한 건 조회 (selectOne) - 수정 화면에 기존 정보 띄울 때 필요
	public DeliveryAddress selectOne(Connection conn, int addrId) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DeliveryAddress addr = null;

		try {
			String sql = "SELECT * FROM deliveryaddr WHERE addrId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, addrId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				addr = new DeliveryAddress();
				addr.setAddrId(rs.getInt("addrId"));
				addr.setUserId(rs.getString("userId"));
				addr.setAddrName(rs.getString("addrName"));
				addr.setRecipientName(rs.getString("recipient"));
				addr.setPhone(rs.getString("phone"));
				addr.setAddrRoad(rs.getString("addrRoad"));
				addr.setAddrDetail(rs.getString("addrDetail"));
				addr.setIsDefault(rs.getInt("isDefault"));
			}
		} finally {
			JdbcUtil.close(rs);
			JdbcUtil.close(pstmt);
		}
		return addr;
	}

//[추가] 6. 기본 배송지 1건 조회 (없으면 null 반환)
	// [수정됨] 6. 기본 배송지 1건 조회
    public DeliveryAddress selectDefault(Connection conn, String userId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        DeliveryAddress addr = null;
        try {
            // [수정 포인트] is_default -> isDefault (DB 컬럼명과 일치해야 함)
            String sql = "SELECT * FROM deliveryaddr WHERE userId = ? AND isDefault = 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                addr = new DeliveryAddress();
                addr.setAddrId(rs.getInt("addrId"));
                addr.setUserId(rs.getString("userId"));
                addr.setAddrName(rs.getString("addrName"));
                addr.setRecipientName(rs.getString("recipient"));
                addr.setPhone(rs.getString("phone"));
                addr.setAddrRoad(rs.getString("addrRoad"));
                addr.setAddrDetail(rs.getString("addrDetail"));
                // 모델에 값 넣기
                addr.setIsDefault(rs.getInt("isDefault")); 
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return addr;
    }

    // [수정됨] 7. 기본 배송지 변경
    public void setDefault(Connection conn, String userId, int addrId) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            // [수정 포인트] is_default -> isDefault
            // 1단계: 기존 것 초기화
            String sqlReset = "UPDATE deliveryaddr SET isDefault = 0 WHERE userId = ?";
            pstmt = conn.prepareStatement(sqlReset);
            pstmt.setString(1, userId);
            pstmt.executeUpdate();
            pstmt.close();

            // 2단계: 선택한 것 설정
            String sqlSet = "UPDATE deliveryaddr SET isDefault = 1 WHERE userId = ? AND addrId = ?";
            pstmt = conn.prepareStatement(sqlSet);
            pstmt.setString(1, userId);
            pstmt.setInt(2, addrId);
            pstmt.executeUpdate();
            
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
} // 클래스 끝