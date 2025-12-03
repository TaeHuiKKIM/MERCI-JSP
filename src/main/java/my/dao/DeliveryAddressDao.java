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
			// DB컬럼명: userId, addrName, recipient, phone, addrRoad, addrDetail, isDefault
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
				// [확인] DB 컬럼명 isDefault 맞음
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

	// 4. 배송지 수정 (update) - [수정됨: 6번 파라미터 중복 해결]
	public int update(Connection conn, DeliveryAddress addr) throws SQLException {
		PreparedStatement pstmt = null;
		try {
			// 수정할 항목: 이름, 수령인, 전화번호, 주소, 상세주소 (기본배송지 여부는 여기서 수정 안 함)
			String sql = "UPDATE deliveryaddr SET addrName=?, recipient=?, phone=?, addrRoad=?, addrDetail=? WHERE addrId=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, addr.getAddrName());
			pstmt.setString(2, addr.getRecipientName());
			pstmt.setString(3, addr.getPhone());
			pstmt.setString(4, addr.getAddrRoad());
			pstmt.setString(5, addr.getAddrDetail());
			
			// 6번째 물음표는 WHERE addrId=? 입니다.
			pstmt.setInt(6, addr.getAddrId());
			
			return pstmt.executeUpdate(); 
		} finally {
			JdbcUtil.close(pstmt);
		}
	}

	// 5. 배송지 한 건 조회 (selectOne)
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

	// 6. 기본 배송지 1건 조회 (selectDefault)
    public DeliveryAddress selectDefault(Connection conn, String userId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        DeliveryAddress addr = null;
        try {
            // [확인] DB 컬럼명 isDefault 맞음
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
                addr.setIsDefault(rs.getInt("isDefault")); 
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return addr;
    }

    // 7. 기본 배송지 변경 (setDefault)
    public void setDefault(Connection conn, String userId, int addrId) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            // [확인] DB 컬럼명 isDefault 맞음
            
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
}