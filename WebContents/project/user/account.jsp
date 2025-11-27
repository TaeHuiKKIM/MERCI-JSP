<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// [1] 맨 위: 세션에서 저장된 이름(userName)을 가져옵니다.
String userName = (String) session.getAttribute("userName");

// 로그인이 안 된 상태(null)라면 "고객"이라고 기본값을 줍니다.
if (userName == null) {
	userName = "고객";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYPAGE</title>
<link rel="stylesheet" type="text/css" href="style.css">

</head>
<body>
	<header class="header">
		<div class="header-inner">
			<div class="header-logo">
				<a href="index.jsp"><img src="images/mainlogo.png" alt="logo"></a>
			</div>

			<nav class="header-nav">
				<a href="index.jsp">HOME</a> <a href="about.html">ABOUT</a> <a
					href="product.html">PRODUCT</a> <a href="account.jsp">MYPAGE </a> <a
					href="#" id="loginMenu">LOGIN</a>

			</nav>
		</div>
	</header>




	<div class="mypage-banner">
		<!-- 여기에 배너 이미지 -->
		<img src="images/banner.jpg" alt="banner">
	</div>

	<div class="mypage-container">

		<!-- 아이디 환영 문구 -->
		<h2 class="welcome-text"><%=userName%>님 환영합니다!
		</h2>

		<!-- 배송지 정보 버튼 -->
		<a href="address.jsp" class="btn address-btn">배송지 정보 입력</a>

		<!-- 비밀번호 변경 -->
		<h3 class="section-title">비밀번호 변경</h3>

		<form action="user/password_change_proc.jsp" method="post"
			name="pwForm" class="password-box">

			<label>기존 비밀번호</label> <input type="password" name="currentPw"
				placeholder="현재 사용중인 비밀번호"> <label>새 비밀번호</label> <input
				type="password" name="newPw" placeholder="변경할 비밀번호"> <label>비밀번호
				확인</label> <input type="password" name="confirmPw" placeholder="변경할 비밀번호 확인">

			<button type="button" class="btn change-btn"
				onclick="checkPasswordChange()">비밀번호 변경</button>
		</form>

		<h3 class="section-title">계정 삭제</h3>
		<button class="btn delete-btn">DELETE ACCOUNT</button>
	</div>
	<script src="style.js"></script>
</body>
</html>