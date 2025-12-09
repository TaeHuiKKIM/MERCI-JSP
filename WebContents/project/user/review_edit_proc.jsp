<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }

    String reviewIdStr = request.getParameter("reviewId");
    String ratingStr = request.getParameter("rating");
    String content = request.getParameter("content");
    
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        ReviewDao dao = new ReviewDao();
        
        Review r = new Review();
        r.setReviewId(Integer.parseInt(reviewIdStr));
        r.setUserId(userId);
        r.setRating(Integer.parseInt(ratingStr));
        r.setContent(content);
        
        dao.update(conn, r);
        
        out.println("<script>alert('리뷰가 수정되었습니다.'); location.href='order_list.jsp';</script>");
        
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn);
    }
%>