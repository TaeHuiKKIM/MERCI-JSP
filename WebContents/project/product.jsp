<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
// [1] 세션 확인
String userName = (String) session.getAttribute("userName");
boolean isLogin = (userName != null);

// [2] 파라미터 수신
String category = request.getParameter("category"); // Top, Bottom, Outer, Acc
String sort = request.getParameter("sort"); // price_asc, price_desc, freq, date
String search = request.getParameter("search"); // Search Keyword

// [3] 데이터 조회
Connection conn = null;
List<Cloth> list = null;
try {
	conn = ConnectionProvider.getConnection();
	ClothDao dao = new ClothDao();
	list = dao.selectListMulti(conn, category, sort, search);
} catch (Exception e) {
	e.printStackTrace();
} finally {
	JdbcUtil.close(conn);
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>PRODUCT – MERCI</title>
<link rel="icon" href="images/favicon.ico">
<link rel="stylesheet" href="style.css">
<style>
/* 추가된 검색/필터 UI 스타일 */
.product-controls {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	padding-bottom: 20px;
	border-bottom: 1px solid #eee;
}

.search-box {
	display: flex;
	align-items: center;
}

.search-input {
	padding: 8px 12px;
	border: 1px solid #ccc;
	border-right: none;
	font-size: 12px;
	outline: none;
	width: 200px;
}

.search-btn {
	padding: 8px 14px;
	border: 1px solid #ccc;
	background: #fff;
	cursor: pointer;
	font-size: 12px;
	font-weight: 600;
}

.search-btn:hover {
	background: #f5f5f5;
}

.filter-options a {
	margin-right: 15px;
	font-size: 12px;
	color: #888;
	font-weight: 500;
	cursor: pointer;
}

.filter-options a.active {
	color: #111;
	font-weight: 700;
	text-decoration: underline;
}

.sort-select {
	padding: 6px 10px;
	border: 1px solid #ccc;
	font-size: 12px;
	cursor: pointer;
}

.category-nav {
	display: flex;
	gap: 20px;
}
</style>
</head>

<body class="product-page">

	<!-- HEADER -->
	<jsp:include page="header.jsp" />


	<main class="product-main">

		<!-- TOP CONTROL BAR -->
		<div class="product-top">
			<h2>ALL PRODUCTS</h2>

			<div class="product-controls">

				<!-- Category Filter -->
				<div class="category-nav">
					<a href="product.jsp"
						class="<%=category == null ? "active" : ""%>">ALL</a> <a
						href="product.jsp?category=Top&sort=<%=sort != null ? sort : ""%>"
						class="<%="Top".equals(category) ? "active" : ""%>">TOP</a> <a
						href="product.jsp?category=Bottom&sort=<%=sort != null ? sort : ""%>"
						class="<%="Bottom".equals(category) ? "active" : ""%>">BOTTOM</a>
					<a
						href="product.jsp?category=Outer&sort=<%=sort != null ? sort : ""%>"
						class="<%="Outer".equals(category) ? "active" : ""%>">OUTER</a>
					<a
						href="product.jsp?category=Acc&sort=<%=sort != null ? sort : ""%>"
						class="<%="Acc".equals(category) ? "active" : ""%>">ACC</a>
				</div>

				<div style="display: flex; gap: 15px; align-items: center;">
					<!-- Sort Select -->
					<form name="sortForm" action="product.jsp" method="get"
						style="margin: 0;">
						<%
						if (category != null) {
						%><input type="hidden" name="category"
							value="<%=category%>">
						<%
						}
						%>
						<%
						if (search != null) {
						%><input type="hidden" name="search"
							value="<%=search%>">
						<%
						}
						%>
						<select name="sort" class="sort-select"
							onchange="this.form.submit()">
							<option value="date" <%="date".equals(sort) ? "selected" : ""%>>Newest</option>
							<option value="freq" <%="freq".equals(sort) ? "selected" : ""%>>Popular</option>
							<option value="price_asc"
								<%="price_asc".equals(sort) ? "selected" : ""%>>Price:
								Low to High</option>
							<option value="price_desc"
								<%="price_desc".equals(sort) ? "selected" : ""%>>Price:
								High to Low</option>
						</select>
					</form>

					<!-- Search Box -->
					<form action="product.jsp" method="get" class="search-box">
						<input type="text" name="search" class="search-input"
							placeholder="Search..."
							value="<%=search != null ? search : ""%>">
						<button type="submit" class="search-btn">SEARCH</button>
					</form>
				</div>
			</div>
		</div>

		<!-- PRODUCT GRID -->
		<div class="product-grid">
			<c:set var="list" value="<%=list%>" />
			<c:choose>
				<c:when test="${list != null && not empty list}">
					<c:forEach var="cloth" items="${list}">
						<a href="catalogdetail.jsp?clothId=${cloth.id}"
							class="product-link">
							<div class="product-card">
								<img src="uploadfile/${cloth.imgBody}" alt="${cloth.title}">
								<div class="product-info">
									<h3>${cloth.title}</h3>
									<p class="price">
										₩
										<fmt:formatNumber value="${cloth.price}" type="number" />
									</p>
								</div>
							</div>
						</a>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<p
						style="grid-column: 1/-1; text-align: center; padding: 100px 0; color: #999;">
						등록된 상품이 없습니다.</p>
				</c:otherwise>
			</c:choose>
		</div>
		<!-- product-grid 끝 -->

	</main>

	<!-- ========== FOOTER ========== -->
	<jsp:include page="footer.jsp" />

	<!-- 로그인 패널 (index.jsp와 동일한 로직 사용을 위해 id 유지) -->
	<!-- header.jsp에 포함됨 -->

	<script src="style.js"></script>

	<!-- style.css에 .active 클래스 스타일이 메뉴용으로만 되어있을 수 있어 추가 스타일 정의 -->
	<style>
/* 카테고리 active 상태 스타일 보강 */
.category-nav a.active {
	font-weight: bold;
	border-bottom: 2px solid #111;
	padding-bottom: 2px;
}
</style>
</body>
</html>