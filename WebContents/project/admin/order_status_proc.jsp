<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.util.*"%>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Check
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String orderIdStr = request.getParameter("orderId");
    String status = request.getParameter("status");
    String carrier = request.getParameter("carrier");
    String trackNum = request.getParameter("trackNum");

    if (orderIdStr != null && status != null) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            OrderDao dao = new OrderDao();
            // Call the overloaded method to update tracking info as well
            dao.updateStatus(conn, Integer.parseInt(orderIdStr), status, carrier, trackNum);
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }
    }
    
    response.sendRedirect("manageorder.jsp");
%>