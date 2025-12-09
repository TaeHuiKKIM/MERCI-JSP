<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }

    String reviewIdStr = request.getParameter("reviewId");
    
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        ReviewDao dao = new ReviewDao();
        
        dao.delete(conn, Integer.parseInt(reviewIdStr), userId);
        
        out.println("<script>alert('리뷰가 삭제되었습니다.'); history.back();</script>");
        
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn);
    }
%>