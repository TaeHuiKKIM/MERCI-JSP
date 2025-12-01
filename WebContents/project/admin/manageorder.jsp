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
<title>PRODUCT - MERCI</title>
<link rel="stylesheet" href="../style.css">
</head>

<body class="product-page">

	<!-- HEADER -->
	<header class="header">
	<div class="header-inner">
		<div class="header-logo">
			<a href="index.jsp"><img src="../images/mainlogo.png"
				alt="logo"></a>
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

	<main class="product-main"> <!-- TOP -->
	<div class="product-top">
		<h2>ALL PRODUCTS</h2>
	</div>

	<!-- PRODUCT GRID -->
	<div class="product-grid">

		<!-- 1행 (제품 4개 + FILTER 칸) -->
		<a href="catalogdetail.html" class="product-link">
			<div class="product-card">
				<img src="images/product01.jpg" alt="">
				<div class="product-info">
					<h3>Fur Jacket Grey</h3>
					<p class="price">₩ 238,400</p>
				</div>
			</div>
		</a> <a href="catalogdetail.html" class="product-link">
			<div class="product-card">
				<img src="images/product02.jpg" alt="">
				<div class="product-info">
					<h3>Long Patch Zip Up Burgundy</h3>
					<p class="price">₩ 118,400</p>
				</div>
			</div>
		</a> <a href="catalogdetail.html" class="product-link">
			<div class="product-card">
				<img src="images/product03.jpg" alt="">
				<div class="product-info">
					<h3>Thinsulate Padded Jacket Brown</h3>
					<p class="price">₩ 214,400</p>
				</div>
			</div>
		</a> <a href="catalogdetail.html" class="product-link">
			<div class="product-card">
				<img src="images/product04.jpg" alt="">
				<div class="product-info">
					<h3>Flower Graphic Long Sleeve White</h3>
					<p class="price">₩ 66,300</p>
				</div>
			</div>
		</a>


		<!-- 필터 버튼 자리 -->
		<div class="filter-slot">
			<button class="filter-btn">FILTER</button>
		</div>

		<!-- 2행 -->
		<a href="catalogdetail.html" class="product-link">
			<div class="product-card">
				<img src="images/product05.jpg" alt="">
				<div class="product-info">
					<h3>Fur Jacket Camel</h3>
					<p class="price">₩ 238,400</p>
				</div>
			</div>
		</a>

		<div class="product-card">
			<img src="images/product06.jpg" alt="">
			<div class="product-info">
				<h3>Wave Down Jacket Blue</h3>
				<p class="price">₩ 202,300</p>
			</div>
		</div>

		<div class="product-card">
			<img src="images/product07.jpg" alt="">
			<div class="product-info">
				<h3>Brush Symbol Knit Multi Brown</h3>
				<p class="price">₩ 124,200</p>
			</div>
		</div>

		<div class="product-card">
			<img src="images/product08.jpg" alt="">
			<div class="product-info">
				<h3>Fur Cowichan Hoodie Charcoal</h3>
				<p class="price">₩ 268,200</p>
			</div>
		</div>

		<div class="product-card">
			<img src="images/product09.jpg" alt="">
			<div class="product-info">
				<h3>Oversized Balaclava Knit Brown</h3>
				<p class="price">₩ 127,800</p>
			</div>
		</div>

		<!-- 3행 -->
		<div class="product-card">
			<img src="images/product10.jpg" alt="">
			<div class="product-info">
				<h3>Shaggy Cuff Beanie Lavender</h3>
				<p class="price">₩ 61,200</p>
			</div>
		</div>

		<div class="product-card">
			<img src="images/product11.jpg" alt="">
			<div class="product-info">
				<h3>Chearing Fur Hoddie Grey</h3>
				<p class="price">₩ 254,400</p>
			</div>
		</div>

		<div class="product-card">
			<img src="images/product12.jpg" alt="">
			<div class="product-info">
				<h3>Technical Comfort Slacks Brown</h3>
				<p class="price">₩ 134,300</p>
			</div>
		</div>

		<div class="product-card">
			<img src="images/product13.jpg" alt="">
			<div class="product-info">
				<h3>WBE Logo Muffler Black</h3>
				<p class="price">₩ 68,500</p>
			</div>
		</div>

		<div class="product-card">
			<img src="images/product14.jpg" alt="">
			<div class="product-info">
				<h3>Insulated Cap Gray</h3>
				<p class="price">₩ 57,600</p>
			</div>
		</div>

	</div>

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
	}
	%> <!-- product-grid --> <section class="product-section">
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
							type="text" id="keyword" size="10"> <input type="submit"
							name="btn" id="btn" value="검색">
						</td>
					</form>
				</tr>
			</table>
		</c:if>
	</div>
	</section> </main>
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
	<script src="../style.js"></script>
</body>
</html>