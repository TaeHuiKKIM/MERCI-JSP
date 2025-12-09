<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB 업데이트 - MERCI</title>
</head>
<body>
    <h2>DB 테이블 구조 업데이트 (비밀번호 찾기 기능)</h2>
    <hr>
    <ul>
<%
    Connection conn = null;
    Statement stmt = null;
    
    try {
        conn = ConnectionProvider.getConnection();
        stmt = conn.createStatement();
        
        // 1. user 테이블에 find_q, find_a 컬럼 추가
        // 이미 존재할 경우 에러가 날 수 있으므로 try-catch로 감싸거나 IF NOT EXISTS 로직 사용(MySQL 버전에 따라 다름)
        // 여기서는 간단히 실행하고 결과를 출력합니다.
        
        try {
            String sql1 = "ALTER TABLE user ADD COLUMN find_q VARCHAR(100) DEFAULT '기억에 남는 추억의 장소는?'";
            stmt.executeUpdate(sql1);
            out.println("<li>[성공] user 테이블에 find_q 컬럼 추가 완료</li>");
        } catch(SQLException e) {
            out.println("<li>[정보] find_q 컬럼이 이미 존재하거나 추가 실패 (" + e.getMessage() + ")</li>");
        }
        
        try {
            String sql2 = "ALTER TABLE user ADD COLUMN find_a VARCHAR(100) DEFAULT 'merci'";
            stmt.executeUpdate(sql2);
            out.println("<li>[성공] user 테이블에 find_a 컬럼 추가 완료</li>");
        } catch(SQLException e) {
            out.println("<li>[정보] find_a 컬럼이 이미 존재하거나 추가 실패 (" + e.getMessage() + ")</li>");
        }
        
    } catch(Exception e) {
        out.println("<h3>치명적 오류 발생: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    } finally {
        JdbcUtil.close(stmt);
        JdbcUtil.close(conn);
    }
%>
    </ul>
    <p>업데이트 작업이 완료되었습니다.</p>
    <a href="index.jsp">메인으로 돌아가기</a>
</body>
</html>