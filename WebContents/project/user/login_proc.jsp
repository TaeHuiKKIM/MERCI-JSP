<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>
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
	Connection conn = null;
	UserDao dao = new UserDao();
	
	try {
		conn = ConnectionProvider.getConnection();
		User user = dao.selectById(conn, userId);
		
		if(user != null && user.getPassword().equals(userPw)) {
			session.setAttribute("userName", user.getName());
%>
			<script>
				alert("<%=user.getName()%>님 환영합니다!");
				// [상대 경로 수정]
				location.href = "../index.jsp";
			</script>
<%
		} else {
%>
			<script>
				alert("아이디 또는 비밀번호를 확인해주세요.");
				history.back();
			</script>
<%
		}
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(conn != null) try { conn.close(); } catch(SQLException ex) {}
	}
%>
</body>
</html>