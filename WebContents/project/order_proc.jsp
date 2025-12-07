<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, my.dao.*, my.model.*, my.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    
    // 장바구니 데이터
    List<Map<String, Object>> cartList = (List<Map<String, Object>>) session.getAttribute("cartList");
    if(userId == null || cartList == null || cartList.isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 파라미터 수신
    String receiverName = request.getParameter("receiverName");
    String receiverPhone = request.getParameter("receiverPhone");
    String addr1 = request.getParameter("addr1");
    String addr2 = request.getParameter("addr2");
    String address = addr1 + " " + addr2;
    String depositor = request.getParameter("depositor");
    int totalAmount = Integer.parseInt(request.getParameter("totalAmount"));

    Connection conn = null;
    boolean success = false;
    
    try {
        conn = ConnectionProvider.getConnection();
        conn.setAutoCommit(false); // 트랜잭션 시작

        OrderDao orderDao = new OrderDao();

        // 1. 주문 마스터 생성
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setReceiverName(receiverName);
        order.setReceiverPhone(receiverPhone);
        order.setAddress(address);
        order.setDepositor(depositor);
        
        int orderId = orderDao.insertOrder(conn, order);
        
        // 2. 주문 상세 생성 및 재고 차감
        for(Map<String, Object> item : cartList) {
            int clothId = (Integer) item.get("id");
            int quantity = (Integer) item.get("quantity");
            int price = (Integer) item.get("price");

            OrderItem orderItem = new OrderItem(clothId, quantity, price);
            orderItem.setOrderId(orderId);
            
            // 상세 저장
            orderDao.insertOrderItem(conn, orderItem);
            
            // 재고 차감
            orderDao.decreaseStock(conn, clothId, quantity);
        }

        conn.commit();
        success = true;
        
        // 장바구니 비우기
        session.removeAttribute("cartList");

    } catch(Exception e) {
        if(conn != null) try { conn.rollback(); } catch(SQLException ex) {}
        e.printStackTrace();
        out.println("<script>alert('주문 처리 중 오류가 발생했습니다: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
        return;
    } finally {
        JdbcUtil.close(conn);
    }

    if(success) {
        out.println("<script>alert('주문이 완료되었습니다.'); location.href='user/order_list.jsp';</script>");
    }
%>
