<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// [1] 세션 확인
String userName = (String) session.getAttribute("userName");
boolean isLogin = (userName != null);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ABOUT – MERCI</title>
<link rel="stylesheet" href="../style.css">
<style>
/* 인라인 스타일로 배경 이미지 동적 처리 */
.about-visual {
	background-image: url('../images/about_custom.png?t=<%=new java.util.Date().getTime()%>');
}
</style>
</head>
<div id="login-container"></div>

<body class="about-page">

	<!-- ========== HEADER (OPTIONAL) ========== -->
	<header class="header">
	<div class="header-inner">
		<div class="header-logo">
			<a href="index.jsp"><img src="../images/mainlogo.png" alt="logo"></a>
		</div>

		<nav class="header-nav"> <a href="index.jsp">HOME</a> <a
			href="manageabout.jsp">MANAGE ABOUT</a> <a href="manageproduct.jsp">MANAGE
			PRODUCT</a> <a href="manageorder.jsp">MANAGE ORDER</a> <%
 if (isLogin) {
 %><a href="../user/logout_proc.jsp">LOGOUT</a> <%
 } else {
 %> <a href="#" id="loginMenu">LOGIN</a> <%
 }
 %> </nav>
	</div>
	</header>



	<!-- ========== ABOUT MAIN VISUAL ========== -->
	<section class="about-visual">
	<div class="about-text">
		<h2>
			MERCI BRINGS SUBURBAN VITALITY INTO THE CITY,<br> OFFERING WOMEN
			AN ACTIVE LIFESTYLE AND FASHION<br> THAT FUSE EVERYDAY URBAN
			LIFE WITH EXTRAORDINARY ENERGY.
		</h2>

		<p>MERCI는 도시에 사는 여성들에게 교외적인 생동감을 불어넣을 수 있는 새로운 라이프스타일과 패션을 제안합니다.
			자연과 도시가 만나는 순간을 담아내며, 일상 속에서 편안하게 입을 수 있는 실루엣과 활동적인 에너지를 동시에 전달합니다.</p>
	</div>
	</section>

	<main class="admin-main">
	<div class="about-image-upload">
		<h3>UPDATE ABOUT IMAGE</h3>

		<div style="margin-bottom: 30px; text-align: center;">
			<p style="margin-bottom: 10px; font-size: 12px; color: #aaa; letter-spacing: 0.05em;">CURRENT IMAGE PREVIEW</p>
			<!-- CSS background 스타일로 미리보기 -->
			<div
				style="width: 100%; height: 300px; 
			            background-image: url('../images/about_custom.png?t=<%=new java.util.Date().getTime()%>'); 
			            background-size: cover; background-position: center; 
			            border: 1px solid #333; margin: 0 auto;">
			</div>
		</div>

		<form action="upload_about_image.jsp" method="post" enctype="multipart/form-data">
			
			<div class="file-input-wrapper">
				<input type="file" id="fileInput" name="aboutImage" accept="image/png" required onchange="displayFileName()">
				<label for="fileInput" class="file-input-label">CHOOSE PNG IMAGE</label>
				<span id="fileNameDisplay" class="file-name-display">NO FILE CHOSEN</span>
			</div>
			
			<input type="submit" value="UPLOAD IMAGE">
		</form>
	</div>
	</main>
	
	<script>
		function displayFileName() {
			var input = document.getElementById('fileInput');
			var display = document.getElementById('fileNameDisplay');
			if (input.files && input.files.length > 0) {
				display.textContent = input.files[0].name;
			} else {
				display.textContent = "NO FILE CHOSEN";
			}
		}
	</script>
	<!-- ========== FOOTER ========== -->
	<footer class="footer">
	<div class="footer-columns">

		<div class="footer-col">
			<h3>CUSTOMER SERVICE</h3>
			<p>MEMBERSHIP</p>
			<p>CONTACT</p>
			<p>SHIPPING & RETURNS</p>
		</div>

		<div class="footer-col">
			<h3>COMPANY</h3>
			<p>MERCI</p>
			<p>대표 : 김태희, 김소희, 방현익 | 사업자등록번호 : 123-45-67890</p>
			<p>주소 : 경기도 시흥시 산기대학로</p>
			<p>이메일 :MERCI@gmail.com</p>
			<p>고객센터 : 070-1234-5678</p>
		</div>

		<div class="footer-col">
			<h3>LEGAL</h3>
			<p>PRIVACY POLICY</p>

			<h3 style="margin-top: 30px;">SOCIAL</h3>
			<p>INSTAGRAM</p>
			<p>KAKAOTALK</p>
		</div>

	</div>

	<div class="footer-bottom">
		<span>© MERCI 2025</span>
	</div>
	</footer>

	<div class="login-panel" id="loginPanel">

		<div class="login-header">
			<h2>LOGIN</h2>
			<button class="login-close" id="loginCloseBtn">CLOSE</button>
		</div>

		<form class="login-box">
			<input type="text" placeholder="EMAIL" class="login-input"> <input
				type="password" placeholder="PASSWORD" class="login-input">

			<input type="button" value="LOGIN" class="login-btn black"> <input
				type="button" value="CREATE ACCOUNT" class="login-btn gray"
				onclick="location.href='joinform.html'">
		</form>

		<h3 class="social-title">SOCIAL LOGIN</h3>

		<div class="social-login">
			<input type="button" value="GOOGLE" class="social-btn"> <input
				type="button" value="KAKAO" class="social-btn"> <input
				type="button" value="NAVER" class="social-btn">
		</div>

	</div>




</body>
<script src="../style.js"></script>

</html>
