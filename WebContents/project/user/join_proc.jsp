<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Date, my.util.*, my.dao.*, my.model.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String userPw = request.getParameter("password");
    String userName = request.getParameter("name");

    Connection conn = null;
    UserDao dao = new UserDao();

    try {
        conn = ConnectionProvider.getConnection();
        boolean isExist = dao.idCheck(conn, userId);

        if (isExist) {
            %>
            <script>
                alert("이미 존재하는 계정입니다.");
                // [상대 경로 수정] 상위 폴더(project)로 이동 -> index.jsp
                location.href = "../index.jsp";
            </script>
            <%
        } else {
            User newUser = new User();
            newUser.setUserId(userId);
            newUser.setPassword(userPw);
            newUser.setName(userName);
            newUser.setRegisterTime(new Date()); 
            dao.insert(conn, newUser); 
            %>
            <script>
                alert("회원가입이 완료되었습니다.\n로그인 해주세요.");
                // [상대 경로 수정]
                location.href = "../index.jsp";
            </script>
            <%
        }
    } catch (Exception e) {
        e.printStackTrace();
        %>
        <script>
            alert("시스템 에러가 발생했습니다: <%=e.getMessage().replace("\"", "'")%>");
            history.back();
        </script>
        <%
    } finally {
        if(conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>
</body>
</html>