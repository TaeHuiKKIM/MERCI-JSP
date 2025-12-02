<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // [1] 세션 확인
    String userName = (String) session.getAttribute("userName");
    boolean isLogin = (userName != null);

    // [2] 파라미터 수신
    String category = request.getParameter("category"); // Top, Bottom, Outer, Acc
    String sort = request.getParameter("sort");         // price_asc, price_desc, freq, date
    String search = request.getParameter("search");     // Search Keyword

    // [3] 데이터 조회
    Connection conn = ConnectionProvider.getConnection();
    List<Cloth> list = null;
    try {
        ClothDao dao = new ClothDao();
        list = dao.selectListMulti(conn, category, sort, search);
    } catch (SQLException e) {
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
<header class="header product-header">
    <div class="header-inner">
        <div class="header-logo">
            <a href="index.jsp"><img src="images/mainlogo.png" alt="logo"></a>
        </div>

        <nav class="header-nav">
            <a href="index.jsp">HOME</a>
            <a href="about.html">ABOUT</a>
            <a href="product.jsp" class="active">PRODUCT</a>
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


<main class="product-main">

    <!-- TOP CONTROL BAR -->
    <div class="product-top">
        <h2>ALL PRODUCTS</h2>
        
        <div class="product-controls">
            
            <!-- Category Filter -->
            <div class="category-nav">
                <a href="product.jsp" class="<%= category == null ? "active" : "" %>">ALL</a>
                <a href="product.jsp?category=Top&sort=<%=sort != null ? sort : ""%>" class="<%= "Top".equals(category) ? "active" : "" %>">TOP</a>
                <a href="product.jsp?category=Bottom&sort=<%=sort != null ? sort : ""%>" class="<%= "Bottom".equals(category) ? "active" : "" %>">BOTTOM</a>
                <a href="product.jsp?category=Outer&sort=<%=sort != null ? sort : ""%>" class="<%= "Outer".equals(category) ? "active" : "" %>">OUTER</a>
                <a href="product.jsp?category=Acc&sort=<%=sort != null ? sort : ""%>" class="<%= "Acc".equals(category) ? "active" : "" %>">ACC</a>
            </div>

            <div style="display: flex; gap: 15px; align-items: center;">
                <!-- Sort Select -->
                <form name="sortForm" action="product.jsp" method="get" style="margin:0;">
                    <% if(category != null) { %><input type="hidden" name="category" value="<%=category%>"><% } %>
                    <% if(search != null) { %><input type="hidden" name="search" value="<%=search%>"><% } %>
                    <select name="sort" class="sort-select" onchange="this.form.submit()">
                        <option value="date" <%= "date".equals(sort) ? "selected" : "" %>>Newest</option>
                        <option value="freq" <%= "freq".equals(sort) ? "selected" : "" %>>Popular</option>
                        <option value="price_asc" <%= "price_asc".equals(sort) ? "selected" : "" %>>Price: Low to High</option>
                        <option value="price_desc" <%= "price_desc".equals(sort) ? "selected" : "" %>>Price: High to Low</option>
                    </select>
                </form>

                <!-- Search Box -->
                <form action="product.jsp" method="get" class="search-box">
                    <input type="text" name="search" class="search-input" placeholder="Search..." value="<%= search != null ? search : "" %>">
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
                    <a href="catalogdetail.jsp?clothId=${cloth.id}" class="product-link">
                        <div class="product-card">
                            <img src="uploadfile/${cloth.imgBody}" alt="${cloth.title}">
                            <div class="product-info">
                                <h3>${cloth.title}</h3>
                                <p class="price">₩ ${cloth.price}</p>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="grid-column: 1 / -1; text-align: center; padding: 100px 0; color: #999;">
                    등록된 상품이 없습니다.
                </p>
            </c:otherwise>
        </c:choose>
    </div> 
    <!-- product-grid 끝 -->

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
   
   <!-- 로그인 패널 (index.jsp와 동일한 로직 사용을 위해 id 유지) -->
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