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
<link rel="stylesheet" href="../style.css">
</head>

<body>

	<!-- ========== HEADER ========== -->
	<header class="header">
		<div class="header-inner">
			<div class="header-logo">
				<img src="../images/mainlogo.png" alt="logo">
			</div>

			<nav class="header-nav">
				<a href="#">HOME</a> <a href="../about.html">ABOUT</a> <a
					href="../product.html">PRODUCT</a> <a href="#" id="loginMenu">LOGIN</a>
				<%
				if (isLogin) {
				%>
				<span style="font-weight: bold; margin-right: 10px; color: #333;">
					<button type="button" onclick="location.href='../account.jsp'"><%=userName%>님
					</button>
				</span> <a href="user/logout_proc.jsp">LOGOUT</a>
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
		<img src="../images/mainlogo.svg" class="hero-logo" alt="logo">

		<section class="hero">
			<div class="hero-inner">

				<!-- 왼쪽 큰 이미지 -->
				<div class="hero-left">
					<img src="../images/heromain.png" class="hero-left-img" alt="">
				</div>

				<!-- 오른쪽 두 개 이미지 -->
				<div class="hero-right">
					<div class="hero-right-top">
						<img src="../images/herorighttop.png" alt="sub look 1">
					</div>

				</div>

			</div>
		</section>





		<!-- ========== SECTION 2 : 상품 5개 (옷 리스트) ========== -->

		<%
		String keyword = request.getParameter("keyword"); //한글
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
		}
		%>
		<section class="product-section">
			<h2 class="section-title">PRODUCTS</h2>
			<div class="product-grid main-grid">

				<c:set var="list" value="<%=list%>" />
				<c:if test="${list != null}">
					<table width="400" border="1" cellpadding="3" cellspacing="0"
						id="listtable">
						<tr>
							<th scope="col">아이디</th>
							<th scope="col">이름</th>
							<th scope="col">제작사</th>
							<th scope="col">가격</th>
							<th scope="col">사진</th>
							<th scope="col">종류</th>
							<th scope="col">수정</th>
							<th scope="col">삭제</th>
						</tr>
						<c:forEach var="cloth" items="${list}">
							<tr>
								<td>${cloth.id}</td>
								<td>${cloth.title}</td>
								<td>${cloth.maker}</td>
								<td>${cloth.price}</td>
								<td><a href="../catalogdetail.jsp?id=${cloth.id}"> <img
										src="../uploadfile/${cloth.poster}" width="30" , height="35">
								</a></td>
								<td><input type="button" value="수정"
									onclick="location.href='updateForm.jsp?clothId=${cloth.id}'"></td>
								<td><input type="button" value="삭제"
									onclick="location.href='delete.jsp?clothId=${cloth.id}'"></td>
							</tr>
						</c:forEach>
						<tr>
							<form action="" method="post">
								<%--action이 null이면 자신에게 데이터를 넘김 --%>
								<td colspan="7">검색대상: <select name="target" id="target">
										<option value="title">타이틀</option>
										<option value="maker">제작사</option>
								</select> 검색어: <label for="keyword"></label> <input name="keyword"
									type="text" id="keyword" size="10"> <input
									type="submit" name="btn" id="btn" value="검색">
								</td>
							</form>
						</tr>
					</table>
				</c:if>
			</div>
		</section>



		<!-- ========== SECTION 3 : 콜라주 3장 (Editorial / Collage) ========== -->
		<section class="collage-section">
			<div class="collage-wrapper">

				<div class="collage-img img1">
					<img src="../images/collage01.png" />
				</div>

				<div class="collage-img img2">
					<img src="../images/collage02.png" />
				</div>

				<div class="collage-img img3">
					<img src="../images/collage03.png" />
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

		<div class="login-header">
			<h2>LOGIN</h2>
			<button class="login-close" id="loginCloseBtn">CLOSE</button>
		</div>

		<form class="login-box">
			<input type="text" placeholder="EMAIL" class="login-input"> <input
				type="password" placeholder="PASSWORD" class="login-input">

			<input type="button" value="LOGIN" class="login-btn black"> <input
				type="button" value="CREATE ACCOUNT" class="login-btn gray"
				onclick="location.href='join.html'">
		</form>

		<h3 class="social-title">SOCIAL LOGIN</h3>

		<div class="social-login">
			<input type="button" value="GOOGLE" class="social-btn"> <input
				type="button" value="KAKAO" class="social-btn"> <input
				type="button" value="NAVER" class="social-btn">
		</div>

	</div>
	<script src="style.js"></script>
</body>
</html>