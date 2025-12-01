<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>1:1문의하기</title>
<link href="qnadesign.css" rel="stylesheet" type="text/css">
<style type="text/css"></style>
</head>

<body>
	<div class="page_header">
		<div class="toplogo">
			<a href="#"><img src="images/top_logo.jpg" width="276"
				height="40" alt="beautifullife"></a>
		</div>
		<div class="topnav">
			<ul>
				<li><a href="#"><img src="images/top_menu1.jpg" width="72"
						height="24" alt="ArtStory"></a></li>
				<li><a href="#"><img src="images/top_menu2.jpg" width="76"
						height="24" alt="ArtStory"></a></li>
				<li><a href="#"><img src="images/top_menu3.jpg" width="64"
						height="24" alt="ArtStory"></a></li>
				<li><a href="#"><img src="images/top_menu4.jpg" width="134"
						height="24" alt="ArtStory"></a></li>
				<li><a href="#"><img src="images/top_menu5.jpg" width="99"
						height="24" alt="ArtStory"></a></li>
				<li><a href="#"><img src="images/top_menu6.jpg" width="52"
						height="24" alt="ArtStory"></a></li>
			</ul>
		</div>
	</div>
	<div class="page_subimg">
		<div class="subimgline"></div>
		<div class="subimg">
			<div id="apDivSubimg"></div>
		</div>
	</div>
	<div class="page_content">
		<div class="leftmenu">
			<img src="images/left_title.jpg" width="152" height="24"
				alt="membership">
			<ul>
				<li></li>
				<li><a href="#">고객등록</a></li>
				<li><a href="#">아이디찾기</a></li>
				<li><a href="#">비번찾기</a></li>
				<li><a href="#">마이페이지</a></li>
				<li><a href="#">1:1문의하기</a></li>
				<li><a href="#">질문내역</a></li>
				<li><a href="#">후기내역</a></li>
				<li><a href="#">쿠폰내역</a></li>
				<li><a href="#">적립금내역</a></li>
			</ul>
		</div>
		<div class="rightcon">
			<%
			Connection conn = ConnectionProvider.getConnection();
			Movie movie = null;
			int movieId = Integer.parseInt(request.getParameter("movieId"));
			try {
				MovieDao dao = new MovieDao();
				movie = dao.selectById(conn, movieId);
			} catch (SQLException e) {
			}
			%>
			<c:set var="movie" value="<%=movie%>" />
			<img src="images/title2.jpg" width="464" height="58" alt="고객등록">
			<div class="tablestyle">
				<div class="bigcatalogitem">
					<form method="post" action="update.jsp">
						<input type="text" name="id" value="${movie.id}"><br>
						<input type="text" name="title" value="${movie.title}"><br>
						<input type="text" name="maker" value="${movie.maker}"><br>
						<input type="text" name="price" value="${movie.price}"><br>
						<input type="text" name="poster" value="${movie.poster}"><br>
						<input type="submit" value="수정하기">
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
