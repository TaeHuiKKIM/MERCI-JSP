<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }

    String clothIdStr = request.getParameter("clothId");
    String ratingStr = request.getParameter("rating");
    String content = request.getParameter("content");
    String orderIdStr = request.getParameter("orderId");
    
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        ReviewDao dao = new ReviewDao();
        
        // 중복 체크
        Review exist = dao.selectByUserIdAndClothId(conn, userId, Integer.parseInt(clothIdStr));
        if (exist != null) {
             out.println("<script>alert('이미 리뷰를 작성하셨습니다.'); history.back();</script>");
             return;
        }

        Review r = new Review();
        r.setUserId(userId);
        r.setClothId(Integer.parseInt(clothIdStr));
        r.setRating(Integer.parseInt(ratingStr));
        r.setContent(content);
        
        dao.insert(conn, r);
        
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            out.println("<script>alert('리뷰가 등록되었습니다.'); location.href='order_detail.jsp?orderId=" + orderIdStr + "';</script>");
        } else {
            out.println("<script>alert('리뷰가 등록되었습니다.'); location.href='order_list.jsp';</script>");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn);
    }
%>