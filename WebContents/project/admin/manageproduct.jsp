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
<title>PRODUCT</title>
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
	<div class="product-top" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
		<h2>MANAGE PRODUCTS</h2>
		<input type="button" value="REGISTER NEW PRODUCT" 
		       onclick="location.href='product_insert_form.jsp'"
		       style="padding: 12px 24px; background: #111; color: #fff; border: none; cursor: pointer; font-weight: 600;">
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
	%> <!-- product-grid --> <section class="manage-product-section">
	<div class="manage-product-grid main-grid">

		<c:set var="list" value="<%=list%>" />
		<c:if test="${list != null}">
			<table>
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
								src="../uploadfile/${cloth.poster}?t=<%=new java.util.Date().getTime()%>" width="30" height="35">
						</a></td>
						<td>${cloth.clothType}</td>
						<td><input type="button" value="수정"
							onclick="location.href='product_update_form.jsp?clothId=${cloth.id}'"></td>
						<td><input type="button" value="삭제"
							onclick="if(confirm('정말로 삭제하시겠습니까?')) location.href='product_delete_proc.jsp?clothId=${cloth.id}'"></td>
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