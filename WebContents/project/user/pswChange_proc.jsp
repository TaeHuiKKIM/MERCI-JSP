<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 세션에서 로그인한 아이디 가져오기
    String userId = (String) session.getAttribute("userId");
    
    // 로그인이 풀려있다면 튕겨내기
    if(userId == null) {
%>
        <script>
            alert("로그인이 필요한 서비스입니다.");
            location.href = "../index.jsp?login=open";
        </script>
<%
        return;
    }

    // 2. 입력한 값 가져오기
    String currentPw = request.getParameter("currentPw"); // 입력한 기존 비번
    String newPw = request.getParameter("newPw");         // 바꿀 새 비번

    Connection conn = null;
    UserDao dao = new UserDao();

    try {
        conn = ConnectionProvider.getConnection();
        
        // 3. 현재 비밀번호가 맞는지 DB에서 확인
        User user = dao.selectById(conn, userId);
        
        if(user != null && user.getPassword().equals(currentPw)) {
            // 4. 비밀번호가 일치하면 -> 새 비밀번호로 업데이트 실행
            int result = dao.updatePassword(conn, userId, newPw);
            
            if(result > 0) {
%>
                <script>
                    alert("비밀번호가 성공적으로 변경되었습니다.");
                    location.href = "account.jsp"; 
                </script>
<%
            } else {
                throw new Exception("변경 실패");
            }
        } else {
            // 5. 기존 비밀번호가 틀린 경우
%>
            <script>
                alert("현재 비밀번호가 일치하지 않습니다.");
                location.href='account.jsp';
            </script>
<%
        }
    } catch(Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("오류가 발생했습니다: <%=e.getMessage()%>");
            history.back();
        </script>
<%
    } finally {
        if(conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>