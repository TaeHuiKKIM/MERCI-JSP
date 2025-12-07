<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.util.*"%>
<%
    String userId = (String) session.getAttribute("userId");
    
    // JSON 응답을 위한 설정
    response.setContentType("application/json");
    
    if (userId == null) {
        out.print("{\"status\":\"fail\", \"message\":\"Login required\"}");
        return;
    }

    String clothIdStr = request.getParameter("clothId");
    if (clothIdStr == null) {
        out.print("{\"status\":\"error\", \"message\":\"Invalid parameter\"}");
        return;
    }

    int clothId = Integer.parseInt(clothIdStr);
    boolean isAdded = false;

    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        WishlistDao dao = new WishlistDao();
        isAdded = dao.toggle(conn, userId, clothId);
    } catch(Exception e) {
        e.printStackTrace();
        out.print("{\"status\":\"error\", \"message\":\"DB Error\"}");
        return;
    } finally {
        JdbcUtil.close(conn);
    }
    
    // 결과 반환 (added: true면 찜 등록됨, false면 해제됨)
    out.print("{\"status\":\"success\", \"added\":" + isAdded + "}");
%>