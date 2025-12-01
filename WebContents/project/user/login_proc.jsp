<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 처리</title>
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

		// 1. 로그인 성공 조건 (유저가 있고 + 비밀번호가 맞으면)
		if (user != null && user.getPassword().equals(userPw)) {

			// 세션에 정보 저장 (이름, 아이디)
			session.setAttribute("userName", user.getName());
			session.setAttribute("userId", user.getUserId());
	%>
	<script>
                alert("<%=user.getName()%>님 환영합니다!");
    </script>

	<%
	if (user.getUserId().equals("admin"))
		response.sendRedirect("../admin/index.jsp");
	else
		response.sendRedirect("../index.jsp");
	} else {
	// 2. 로그인 실패 (아이디 없거나 비번 틀림)
	%>
	<script>
                alert("아이디 또는 비밀번호를 확인해주세요.");
                history.back();
            </script>
	<%
	}
	} catch (Exception e) {
	e.printStackTrace();
	%>
	<script>
            alert("오류가 발생했습니다: <%=e.getMessage().replace("\"", "'")%>
		");
		history.back();
	</script>
	<%
	} finally {
	if (conn != null)
		try {
			conn.close();
		} catch (SQLException ex) {
		}
	}
	%>
</body>
</html>