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
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MERCI</title>
<link rel="stylesheet" href="style.css">
</head>

<body>

	<!-- ========== HEADER ========== -->
	<header class="header">
		<div class="header-inner">
			<div class="header-logo">
				<a href="index.jsp"><img src="images/mainlogo.png" alt="logo"></a>
			</div>

			<nav class="header-nav">
				<a href="index.jsp">HOME</a> <a href="about.html">ABOUT</a> <a
					href="product.html">PRODUCT</a>
				<%
				if (isLogin) {
				%>
				<a href="user/account.jsp">MY PAGE</a> <a
					href="user/logout_proc.jsp">LOGOUT</a>
				<%
				} else {
				%>
				<a href="#" id="loginMenu">LOGIN</a>
				<%
				}
				%>
			</nav>
		</div>
	</header>

	<main>

		<!-- ========== HERO INTERACTION AREA (최상단) ========== -->
		<!-- 중앙 고정 로고 (항상 hero 위에 있어야 함) -->
		<img src="images/mainlogo.svg" class="hero-logo" alt="logo">

		<section class="hero">
			<div class="hero-inner">

				<!-- 왼쪽 큰 이미지 -->
				<div class="hero-left">
					<img src="images/heromain.png" class="hero-left-img" alt="">
				</div>

				<!-- 오른쪽 두 개 이미지 -->
				<div class="hero-right">
					<div class="hero-right-top">
						<img src="images/herorighttop.png" alt="sub look 1">
					</div>

				</div>

			</div>
		</section>





		<!-- ========== SECTION 2 : 상품 5개 (옷 리스트) ========== -->

		<%
		Connection conn = ConnectionProvider.getConnection();
		List<Cloth> list = null;
		String target = request.getParameter("target");
		try {
			ClothDao dao = new ClothDao();
			if (target == null)
				list = dao.selectList(conn); //모든 옷 목록 가져오기
			else
				list = dao.selectListFreq(conn, target);
		} catch (SQLException e) {
		} finally{
			JdbcUtil.close(conn);
		}
		%>
		<section class="product-section">
			<h2 class="section-title">PRODUCTS</h2>
			<div class="product-grid main-grid">
				<c:set var="list" value="<%=list%>" />
				<c:if test="${list != null}">
					<c:forEach var="cloth" items="${list}">
						<div class="product-item">
							<a href="catalogdetail.html?clothId=${cloth.id}"> <img
								src="uploadfile/${cloth.img_body}" width="200" height="250">
							</a>
							<h3>${cloth.title}</h3>
							<p>₩ ${cloth.price}</p>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</section>



		<!-- ========== SECTION 3 : 콜라주 3장 (Editorial / Collage) ========== -->
		<section class="collage-section">
			<div class="collage-wrapper">

				<div class="collage-img img1">
					<img src="images/collage01.png" />
				</div>

				<div class="collage-img img2">
					<img src="images/collage02.png" />
				</div>

				<div class="collage-img img3">
					<img src="images/collage03.png" />
				</div>

			</div>
		</section>

	</main>



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
		<div id="loginView">
			<div class="login-header">
				<h2>LOGIN</h2>
				<button class="login-close" id="loginCloseBtn">CLOSE</button>
			</div>
			<form action="user/login_proc.jsp" method="post" name="loginForm"
				class="login-box">
				<input type="text" name="userId" placeholder="ID"
					class="login-input"> <input type="password" name="password"
					placeholder="PASSWORD" class="login-input"> <input
					type="button" value="LOGIN" class="login-btn black"
					onclick="loginCheck()"> <input type="button"
					value="CREATE ACCOUNT" class="login-btn gray"
					onclick="showJoinMode()">
			</form>
		</div>


		<div id="joinView" style="display: none;">
			<div class="login-header">
				<h2>SIGN UP</h2>
				<button class="login-close" id="joinCloseBtn">CLOSE</button>
			</div>

			<form action="user/join_proc.jsp" method="post" name="joinForm"
				class="login-box">
				<input type="text" name="userId" class="login-input"
					placeholder="ID (EMAIL)"> <input type="text" name="name"
					class="login-input" placeholder="NAME"> <input
					type="password" name="password" class="login-input"
					placeholder="PASSWORD"> <input type="password"
					name="passwordConfirm" class="login-input"
					placeholder="CONFIRM PASSWORD"> <input type="button"
					value="CREATE ACCOUNT" class="login-btn gray" onclick="joinCheck()">

				<input type="button" value="BACK TO LOGIN" class="login-btn gray"
					style="margin-top: 10px; background-color: black; color: white;"
					onclick="showLoginMode()">
			</form>
		</div>
	</div>
	<script src="style.js"></script>
</body>
</html>