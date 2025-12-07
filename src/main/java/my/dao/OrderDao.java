package my.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import my.model.Order;
import my.model.OrderItem;
import my.util.JdbcUtil;

public class OrderDao {

    // 1. 주문 생성 (트랜잭션 처리 필요)
    public int insertOrder(Connection conn, Order order) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "INSERT INTO orders (userId, totalAmount, status, receiverName, receiverPhone, address, depositor, orderDate) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, order.getUserId());
            pstmt.setInt(2, order.getTotalAmount());
            pstmt.setString(3, "결제대기");
            pstmt.setString(4, order.getReceiverName());
            pstmt.setString(5, order.getReceiverPhone());
            pstmt.setString(6, order.getAddress());
            pstmt.setString(7, order.getDepositor());
            pstmt.executeUpdate();

            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // 생성된 orderId 반환
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return 0;
    }

    // 2. 주문 상세 생성
    public void insertOrderItem(Connection conn, OrderItem item) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "INSERT INTO order_item (orderId, clothId, quantity, price) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, item.getOrderId());
            pstmt.setInt(2, item.getClothId());
            pstmt.setInt(3, item.getQuantity());
            pstmt.setInt(4, item.getPrice());
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    // 3. 재고 감소
    public void decreaseStock(Connection conn, int clothId, int quantity) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE cloth SET stock = stock - ? WHERE id = ? AND stock >= ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, clothId);
            pstmt.setInt(3, quantity);
            int updated = pstmt.executeUpdate();
            if (updated == 0) {
                throw new SQLException("재고 부족으로 주문할 수 없습니다.");
            }
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    // 4. 주문 목록 조회 (관리자용 - 검색 포함)
    public List<Order> selectOrderList(Connection conn, String status, String keyword) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Order> list = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder("SELECT * FROM orders WHERE 1=1 ");
            if (status != null && !status.isEmpty() && !"All".equals(status)) {
                sql.append("AND status = ? ");
            }
            if (keyword != null && !keyword.isEmpty()) {
                sql.append("AND (depositor LIKE ? OR userId LIKE ?) ");
            }
            sql.append("ORDER BY orderId DESC");

            pstmt = conn.prepareStatement(sql.toString());
            
            int idx = 1;
            if (status != null && !status.isEmpty() && !"All".equals(status)) {
                pstmt.setString(idx++, status);
            }
            if (keyword != null && !keyword.isEmpty()) {
                pstmt.setString(idx++, "%" + keyword + "%");
                pstmt.setString(idx++, "%" + keyword + "%");
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("orderId"));
                o.setUserId(rs.getString("userId"));
                o.setTotalAmount(rs.getInt("totalAmount"));
                o.setStatus(rs.getString("status"));
                o.setReceiverName(rs.getString("receiverName"));
                o.setReceiverPhone(rs.getString("receiverPhone"));
                o.setAddress(rs.getString("address"));
                o.setDepositor(rs.getString("depositor"));
                o.setOrderDate(rs.getTimestamp("orderDate"));
                o.setTrackingCarrier(rs.getString("tracking_carrier")); // Added
                o.setTrackingNum(rs.getString("tracking_num"));         // Added
                list.add(o);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }

    // 5. 주문 상태 변경
    public void updateStatus(Connection conn, int orderId, String newStatus) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE orders SET status = ? WHERE orderId = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
    
    // 5-1. 주문 상태 및 운송장 정보 변경 (Overloaded)
    public void updateStatus(Connection conn, int orderId, String newStatus, String carrier, String trackNum) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE orders SET status = ?, tracking_carrier = ?, tracking_num = ? WHERE orderId = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setString(2, carrier);
            pstmt.setString(3, trackNum);
            pstmt.setInt(4, orderId);
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
    
    // 6. 사용자별 주문 목록 조회
    public List<Order> selectListByUserId(Connection conn, String userId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Order> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM orders WHERE userId = ? ORDER BY orderId DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("orderId"));
                o.setUserId(rs.getString("userId"));
                o.setTotalAmount(rs.getInt("totalAmount"));
                o.setStatus(rs.getString("status"));
                o.setReceiverName(rs.getString("receiverName"));
                o.setReceiverPhone(rs.getString("receiverPhone"));
                o.setAddress(rs.getString("address"));
                o.setDepositor(rs.getString("depositor"));
                o.setOrderDate(rs.getTimestamp("orderDate"));
                o.setTrackingCarrier(rs.getString("tracking_carrier"));
                o.setTrackingNum(rs.getString("tracking_num"));
                list.add(o);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
    
    // 7. 주문 단건 조회 (상세)
    public Order selectById(Connection conn, int orderId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Order o = null;
        try {
            String sql = "SELECT * FROM orders WHERE orderId = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                o = new Order();
                o.setOrderId(rs.getInt("orderId"));
                o.setUserId(rs.getString("userId"));
                o.setTotalAmount(rs.getInt("totalAmount"));
                o.setStatus(rs.getString("status"));
                o.setReceiverName(rs.getString("receiverName"));
                o.setReceiverPhone(rs.getString("receiverPhone"));
                o.setAddress(rs.getString("address"));
                o.setDepositor(rs.getString("depositor"));
                o.setOrderDate(rs.getTimestamp("orderDate"));
                o.setTrackingCarrier(rs.getString("tracking_carrier"));
                o.setTrackingNum(rs.getString("tracking_num"));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return o;
    }

    // 최근 7일 매출 통계
    public Map<String, Integer> getDailySales(Connection conn) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Map<String, Integer> map = new LinkedHashMap<>();
        try {
            String sql = "SELECT DATE_FORMAT(orderDate, '%Y-%m-%d') as d, SUM(totalAmount) " +
                         "FROM orders " +
                         "WHERE orderDate >= DATE_SUB(NOW(), INTERVAL 7 DAY) " +
                         "AND status != '결제대기' " +
                         "GROUP BY d " +
                         "ORDER BY d ASC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                map.put(rs.getString(1), rs.getInt(2));
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return map;
    }
}
