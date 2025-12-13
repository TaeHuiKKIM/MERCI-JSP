<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.util.*" %>
<%
    // 1. 검사할 아이디 받기
    String userId = request.getParameter("userId");
    
    // JSON 응답 준비
    StringBuilder jsonResponse = new StringBuilder();
    
    if (userId == null || userId.trim().isEmpty()) {
        out.print("{\"status\": \"empty\"}");
        return;
    }

    Connection conn = null;
    UserDao dao = new UserDao();
    boolean isExist = false;

    try {
        conn = ConnectionProvider.getConnection();
        // 2. DB에서 중복 확인 (기존 DAO 재사용)
        isExist = dao.idCheck(conn, userId);
        
        // 3. 결과 JSON 생성
        if (isExist) {
            // 중복됨
            out.print("{\"status\": \"duplicate\"}");
        } else {
            // 사용 가능
            out.print("{\"status\": \"available\"}");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"status\": \"error\"}");
    } finally {
        if(conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>