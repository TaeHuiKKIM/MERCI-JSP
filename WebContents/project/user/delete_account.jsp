<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // 1. 로그인 체크
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
%>
        <script>
            alert("잘못된 접근입니다.");
            location.href = "../index.jsp";
        </script>
<%
        return;
    }

    Connection conn = null;
    UserDao dao = new UserDao();

    try {
        conn = ConnectionProvider.getConnection();
        
        // 2. 삭제 실행
        int result = dao.deleteUser(conn, userId);
        
        if (result > 0) {
            // 3. 성공 시 세션 파기 (로그아웃 처리)
            session.invalidate();
%>
            <script>
                alert("계정이 안전하게 삭제되었습니다.\n이용해 주셔서 감사합니다.");
                location.href = "../index.jsp"; // 메인으로 이동
            </script>
<%
        } else {
            throw new Exception("삭제 실패");
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("오류가 발생했습니다: <%=e.getMessage()%>");
            history.back();
        </script>
<%
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ex) {}
    }
%>
<script src="style.js"></script>