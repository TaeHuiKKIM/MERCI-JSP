<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); history.back();</script>");
        return;
    }

    String clothIdStr = request.getParameter("clothId");
    String ratingStr = request.getParameter("rating");
    String content = request.getParameter("content");

    if (clothIdStr == null || ratingStr == null || content == null) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    int clothId = Integer.parseInt(clothIdStr);
    int rating = Integer.parseInt(ratingStr);

    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        ReviewDao dao = new ReviewDao();
        Review review = new Review();
        review.setUserId(userId);
        review.setClothId(clothId);
        review.setRating(rating);
        review.setContent(content);
        
        dao.insert(conn, review);
        
        response.sendRedirect("catalogdetail.jsp?clothId=" + clothId);
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('리뷰 등록 실패: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn);
    }
%>