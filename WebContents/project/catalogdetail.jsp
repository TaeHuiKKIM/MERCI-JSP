<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    // 에러 디버깅을 위한 변수
    String errorMessage = null;
    Cloth cloth = null;

    try {
        String idStr = request.getParameter("clothId");
        if (idStr == null) {
            response.sendRedirect("product.jsp");
            return;
        }
        
        int id = Integer.parseInt(idStr);
        Connection conn = ConnectionProvider.getConnection();
        try {
            ClothDao dao = new ClothDao();
            dao.updateFreq(conn, id);
            cloth = dao.selectById(conn, id);
        } catch(Exception ex) {
            errorMessage = ex.getMessage(); // 에러 메시지 저장
            ex.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }
    } catch(Exception e) {
        errorMessage = "Request Error: " + e.getMessage();
    }

    // 로그인 체크
    String userName = (String) session.getAttribute("userName");
    boolean isLogin = (userName != null);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= (cloth != null) ? cloth.getTitle() : "Error" %> - MERCI</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* 레이아웃 스타일 */
        body {
            background-color: #fff;
            color: #333;
        }
        .container {
            width: 50%; /* 양옆 25%씩 여백 확보 */
            max-width: 700px; /* 너무 작아지지 않도록 최소 너비 제한 추가 (예상치) */
            min-width: 600px; /* 너무 작아지지 않도록 최소 너비 제한 (예상치) */
            margin: 0 auto;
            padding-top: 70px; /* 헤더 높이만큼 여백 */
            padding-bottom: 80px;
            display: flex;
            gap: 40px; /* 섹션 간격 */
        }
        
        /* 왼쪽: 큰 메인 사진 */
        .left-section {
            width: 50%; /* 왼쪽 이미지 영역 너비 재조정 */
        }
        .main-img {
            width: 100%;
            height: auto;
            display: block;
            object-fit: cover;
        }

        /* 오른쪽: 작은 사진들 + 정보 */
        .right-section {
            width: 50%; /* 오른쪽 정보 영역 너비 재조정 */
            display: flex;
            gap: 30px; /* 작은 사진과 정보 사이 간격 */
        }

        /* 상세 이미지 리스트 (작게 세로로) */
        .sub-images {
            width: 90px; /* 작은 썸네일 너비 추가 축소 */
            display: flex;
            flex-direction: column;
            gap: 10px; /* 썸네일 간 간격 */
            flex-shrink: 0;
        }
        .sub-images img {
            width: 100%;
            height: auto;
            cursor: pointer;
            opacity: 0.8;
            transition: opacity 0.2s;
            border: 1px solid #eee;
        }
        .sub-images img:hover { opacity: 1; border-color: #000; }

        /* 상품 정보 영역 */
        .product-info {
            flex-grow: 1;
            padding: 0 40px 0 0; /* 오른쪽에 40px 여백 추가 */
        }

        .p-title { font-size: 20px; font-weight: 700; margin-bottom: 8px; margin-top: 0;} /* 제목 글씨 크기 추가 축소 */
        .p-price { font-size: 15px; font-weight: 600; margin-bottom: 15px; color: #111; } /* 가격 글씨 크기 추가 축소 */
        .p-desc { font-size: 12.5px; line-height: 1.5; color: #555; margin-bottom: 25px; white-space: pre-line; padding-bottom: 15px; border-bottom: 1px solid #eee;} /* 설명 글씨 크기 및 여백 추가 축소 */

        /* 옵션 스타일 */
        .opt-label { font-size: 12px; font-weight: 700; margin-bottom: 8px; display: block; margin-top: 15px;} /* 옵션 라벨 글씨 크기 및 여백 유지 */
        .opt-row { display: flex; flex-wrap: wrap; gap: 6px; } /* 옵션 버튼 간격 유지 */
        .opt-btn {
            padding: 8px 12px; /* 옵션 버튼 패딩 유지 */
            background: #fff;
            border: 1px solid #ddd;
            font-size: 12px; /* 옵션 버튼 글씨 크기 추가 축소 */
            cursor: pointer;
        }
        .opt-btn.selected { background: #000; color: #fff; border-color: #000; }

        .cart-btn {
            width: 100%;
            padding: 12px 15px; /* 장바구니 버튼 패딩 유지 */
            background: #111;
            color: #fff;
            border: none;
            font-size: 13px; /* 장바구니 버튼 글씨 크기 유지 */
            font-weight: 700;
            cursor: pointer;
            margin-top: 30px; /* 장바구니 버튼 상단 여백 유지 */
        }

        /* 에러 메시지 박스 */
        .error-box {
            width: 80%;
            margin: 150px auto;
            padding: 20px;
            border: 2px solid red;
            background: #fff0f0;
            color: red;
            text-align: center;
        }
    </style>
    <script>
        function selectSize(btn, val) {
            document.querySelectorAll('.size-group .opt-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            document.cartForm.size.value = val;
        }
        function selectColor(btn, val) {
            document.querySelectorAll('.color-group .opt-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            document.cartForm.color.value = val;
        }
        function addToCart() {
            var f = document.cartForm;
            if(!f.size.value) { alert("사이즈를 선택해주세요."); return; }
            if(!f.color.value) { alert("색상을 선택해주세요."); return; }
            alert("장바구니에 담았습니다.");
        }
        function changeMainImage(src) {
            document.getElementById('mainImage').src = src;
        }
    </script>
</head>
<body>

    <!-- HEADER -->
    <header class="header">
        <div class="header-inner">
            <div class="header-logo">
                <a href="index.jsp"><img src="images/mainlogo.png" alt="logo"></a>
            </div>
            <nav class="header-nav">
                <a href="index.jsp">HOME</a>
                <a href="about.html">ABOUT</a>
                <a href="product.jsp">PRODUCT</a>
                <% if (isLogin) { %>
                    <a href="user/account.jsp">MY PAGE</a> <a href="user/logout_proc.jsp">LOGOUT</a>
                <% } else { %>
                    <a href="#" id="loginMenu">LOGIN</a>
                <% } %>
            </nav>
        </div>
    </header>

    <% if (errorMessage != null || cloth == null) { %>
        <!-- 에러 발생 시 출력되는 영역 -->
        <div class="error-box">
            <h3>상품을 불러오지 못했습니다.</h3>
            <p>원인: <%= errorMessage %></p>
            <p>팁: DB 컬럼(img_body 등)이 존재하는지 확인하거나, <a href="setup_db.jsp">DB 초기화(setup_db.jsp)</a>를 실행해보세요.</p>
            <button onclick="history.back()">돌아가기</button>
        </div>
    <% } else { %>
        <!-- 정상 출력 영역 -->
        <div class="container">
            <!-- 1. 왼쪽: 큰 메인 사진 -->
            <div class="left-section">
                <img src="uploadfile/<%=cloth.getImgBody()%>" id="mainImage" class="main-img" alt="Main">
            </div>

            <!-- 2. 오른쪽: 상세 이미지 + 정보 -->
            <div class="right-section">
                
                <!-- 2-1. 작은 썸네일들 -->
                <div class="sub-images">
                    <!-- 클릭하면 메인 이미지 변경됨 -->
                    <img src="uploadfile/<%=cloth.getImgBody()%>" onclick="changeMainImage(this.src)">
                    <% if(cloth.getImgFront() != null && !cloth.getImgFront().isEmpty()) { %>
                        <img src="uploadfile/<%=cloth.getImgFront()%>" onclick="changeMainImage(this.src)">
                    <% } %>
                    <% if(cloth.getImgBack() != null && !cloth.getImgBack().isEmpty()) { %>
                        <img src="uploadfile/<%=cloth.getImgBack()%>" onclick="changeMainImage(this.src)">
                    <% } %>
                    <% if(cloth.getImgDetail() != null && !cloth.getImgDetail().isEmpty()) { %>
                        <img src="uploadfile/<%=cloth.getImgDetail()%>" onclick="changeMainImage(this.src)">
                    <% } %>
                </div>

                <!-- 2-2. 상품 정보 -->
                <div class="product-info">
                    <h1 class="p-title"><%=cloth.getTitle()%></h1>
                    <p class="p-price">₩ <%=cloth.getPrice()%></p>
                    <div class="p-desc"><%=cloth.getDescription()%></div>

                    <form name="cartForm">
                        <input type="hidden" name="size" value="">
                        <input type="hidden" name="color" value="">
                        
                        <span class="opt-label">SIZE</span>
                        <div class="opt-row size-group">
                            <c:set var="sizeStr" value="<%=cloth.getSizes()%>" />
                            <c:forEach var="s" items="${fn:split(sizeStr, ',')}">
                                <button type="button" class="opt-btn" onclick="selectSize(this, '${s.trim()}')">${s.trim()}</button>
                            </c:forEach>
                        </div>

                        <span class="opt-label">COLOR</span>
                        <div class="opt-row color-group">
                            <c:set var="colorStr" value="<%=cloth.getColors()%>" />
                            <c:forEach var="c" items="${fn:split(colorStr, ',')}">
                                <button type="button" class="opt-btn" onclick="selectColor(this, '${c.trim()}')">${c.trim()}</button>
                            </c:forEach>
                        </div>

                        <button type="button" class="cart-btn" onclick="addToCart()">ADD TO CART</button>
                    </form>
                </div>
            </div>
        </div>
    <% } %>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-columns">
            <div class="footer-col">
                <h3>CUSTOMER SERVICE</h3> <p>MEMBERSHIP</p> <p>CONTACT</p>
            </div>
            <div class="footer-col">
                <h3>COMPANY</h3> <p>MERCI</p>
            </div>
            <div class="footer-col">
                <h3>SOCIAL</h3> <p>INSTAGRAM</p>
            </div>
        </div>
        <div class="footer-bottom"><span>© MERCI 2025</span></div>
    </footer>
    
    <!-- 로그인 패널 포함 (style.js 필요) -->
    <div class="login-panel" id="loginPanel">
        <div id="loginView">
            <div class="login-header"><h2>LOGIN</h2><button class="login-close" id="loginCloseBtn">CLOSE</button></div>
            <form class="login-box"><input type="button" value="LOGIN" class="login-btn black" onclick="loginCheck()"></form>
        </div>
    </div>
    <script src="style.js"></script>
</body>
</html>