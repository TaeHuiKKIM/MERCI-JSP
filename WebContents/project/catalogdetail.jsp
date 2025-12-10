<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String errorMessage = null;
    Cloth cloth = null;
    List<Review> reviewList = null;
    double avgRating = 0.0;
    boolean isWished = false; // 찜 여부

    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    boolean isLogin = (userName != null);

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
            
            // 리뷰 가져오기
            ReviewDao reviewDao = new ReviewDao();
            reviewList = reviewDao.selectListByClothId(conn, id);
            avgRating = reviewDao.getAverageRating(conn, id);
            
            // 찜 여부 확인
            if(isLogin) {
                WishlistDao wishDao = new WishlistDao();
                isWished = wishDao.isWished(conn, userId, id);
            }
        } catch(Exception ex) {
            errorMessage = ex.getMessage();
            ex.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }
    } catch(Exception e) {
        errorMessage = "Request Error: " + e.getMessage();
    }
    
    // 장바구니 추가 성공 여부 확인
    boolean cartAdded = "added".equals(request.getParameter("cart"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= (cloth != null) ? cloth.getTitle() : "Error" %> - MERCI</title>
    <link rel="stylesheet" href="style.css">
    <link rel="icon" href="images/favicon.ico">
    <style>
        .container {
            width: 90%;
            max-width: 1400px;
            min-width: 600px;
            margin: 0 auto;
            padding-top: 100px; /* 헤더와 겹치지 않게 여백 조정 */
            padding-bottom: 80px;
            display: flex;
            gap: 40px;
        }
        /* ... (기존 스타일 유지) ... */
        .left-section { width: 50%; }
        .main-img { width: 100%; height: auto; display: block; object-fit: cover; }
        .right-section { width: 50%; display: flex; gap: 30px; }
        .sub-images { width: 90px; display: flex; flex-direction: column; gap: 10px; flex-shrink: 0; }
        .sub-images img { width: 100%; height: auto; cursor: pointer; opacity: 0.8; border: 1px solid #eee; }
        .sub-images img:hover { opacity: 1; border-color: #000; }
        .product-info { flex-grow: 1; padding: 0 40px 0 0; }
        
        /* Title with Wish Button */
        .title-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; margin-top: 0; }
        .p-title { font-size: 20px; font-weight: 700; margin: 0; }
        .btn-wish { background: none; border: none; font-size: 24px; cursor: pointer; color: #ccc; transition: color 0.2s; padding: 0; }
        .btn-wish.active { color: #e74c3c; } /* Red heart */
        
        .p-price { font-size: 15px; font-weight: 600; margin-bottom: 15px; color: #111; }
        .p-desc { font-size: 12.5px; line-height: 1.5; color: #555; margin-bottom: 25px; white-space: pre-line; padding-bottom: 15px; border-bottom: 1px solid #eee;}
        .opt-label { font-size: 12px; font-weight: 700; margin-bottom: 8px; display: block; margin-top: 15px;}
        .opt-row { display: flex; flex-wrap: wrap; gap: 6px; }
        .opt-btn { padding: 8px 12px; background: #fff; border: 1px solid #ddd; font-size: 12px; cursor: pointer; }
        .opt-btn.selected { background: #000; color: #fff; border-color: #000; }
        .cart-btn { width: 100%; padding: 12px 15px; background: #111; color: #fff; border: none; font-size: 13px; font-weight: 700; cursor: pointer; margin-top: 30px; }
        .error-box { width: 80%; margin: 150px auto; padding: 20px; border: 2px solid red; background: #fff0f0; color: red; text-align: center; }
        
        .qty-row { display: flex; align-items: center; margin-top: 15px; gap: 10px; }
        .qty-input { width: 50px; padding: 5px; text-align: center; border: 1px solid #ddd; }
        
        /* Review Section */
        .review-section { width: 90%; max-width: 1400px; min-width: 600px; margin: 0 auto; padding-top: 50px; border-top: 1px solid #eee; padding-bottom: 100px; }
        .review-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .review-avg { font-size: 18px; font-weight: bold; }
        .review-form { background: #f9f9f9; padding: 20px; margin-bottom: 30px; border: 1px solid #eee; }
        .review-form textarea { width: 100%; height: 80px; padding: 10px; border: 1px solid #ddd; resize: vertical; margin-bottom: 10px; font-size: 13px; }
        .review-list { list-style: none; padding: 0; }
        .review-item { border-bottom: 1px solid #eee; padding: 15px 0; }
        .review-meta { font-size: 12px; color: #888; margin-bottom: 5px; }
        .star-rating { color: #f5a623; font-weight: bold; }

        /* Custom Cart Added Popup */
        .cart-added-popup-backdrop {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease;
        }
        .cart-added-popup-backdrop.show {
            opacity: 1;
            visibility: visible;
        }
        .cart-added-popup {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            width: 350px;
            transform: translateY(20px);
            opacity: 0;
            transition: transform 0.3s ease, opacity 0.3s ease;
        }
        .cart-added-popup-backdrop.show .cart-added-popup {
            transform: translateY(0);
            opacity: 1;
        }
        .cart-added-popup h3 {
            font-size: 20px;
            margin-bottom: 15px;
            color: #333;
        }
        .cart-added-popup p {
            font-size: 14px;
            color: #666;
            margin-bottom: 25px;
        }
        .cart-added-popup-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .cart-added-popup-buttons button {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: background 0.2s;
        }
        .cart-added-popup-buttons .btn-continue {
            background: #eee;
            color: #333;
        }
        .cart-added-popup-buttons .btn-continue:hover {
            background: #e0e0e0;
        }
        .cart-added-popup-buttons .btn-view-cart {
            background: #000;
            color: #fff;
        }
        .cart-added-popup-buttons .btn-view-cart:hover {
            background: #333;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            if(!f.size.value) { showMsg("사이즈를 선택해주세요."); return; }
            if(!f.color.value) { showMsg("색상을 선택해주세요."); return; }
            if(f.quantity.value < 1) { showMsg("수량은 1개 이상이어야 합니다."); return; }
            
            f.action = "cart_proc.jsp";
            f.submit();
        }
        function changeMainImage(src) {
            document.getElementById('mainImage').src = src;
        }
        function checkReviewForm() {
            var f = document.reviewForm;
            if(!f.rating.value) { showMsg("별점을 선택해주세요."); return false; }
            if(!f.content.value) { showMsg("내용을 입력해주세요."); return false; }
            return true;
        }
        function toggleWish(clothId) {
            <% if(!isLogin) { %>
                showMsg("로그인이 필요합니다.");
                setTimeout(showLoginMode, 1000); // 1초 후 로그인 창 띄우기
                return;
            <% } else { %>
                $.ajax({
                    url: 'wishlist_proc_ajax.jsp',
                    type: 'POST',
                    data: { clothId: clothId },
                    dataType: 'json',
                    success: function(res) {
                        if(res.status === 'success') {
                            var btn = $('#btnWish');
                            if(res.added) {
                                btn.addClass('active');
                                btn.html('♥'); // Filled heart logic or same char
                                showMsg("위시리스트에 추가되었습니다.");
                            } else {
                                btn.removeClass('active');
                                btn.html('♥'); 
                                showMsg("위시리스트에서 삭제되었습니다.");
                            }
                        } else {
                            showMsg(res.message);
                        }
                    },
                    error: function() { showMsg("오류가 발생했습니다."); }
                });
            <% } %>
        }
        
        // Custom Cart Added Popup Logic
        $(document).ready(function() {
            <% if (cartAdded) { %>
                $('#cartAddedPopupBackdrop').addClass('show');
                
                // Remove 'cart' query parameter from URL to prevent popup on reload
                if (history.replaceState) {
                    var newUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                    var searchParams = new URLSearchParams(window.location.search);
                    searchParams.delete("cart");
                    if (searchParams.toString() !== "") {
                        newUrl += "?" + searchParams.toString();
                    }
                    window.history.replaceState({path: newUrl}, '', newUrl);
                }
            <% } %>

            $('#popupCloseBtn').click(function() {
                $('#cartAddedPopupBackdrop').removeClass('show');
            });

            $('#viewCartBtn').click(function() {
                // Assuming cart_popup.jsp is the actual cart popup.
                // If it's a separate page, redirect: location.href = 'cart.jsp';
                $('#stickyCartBtn').click(); // Simulate click on the floating cart button
                $('#cartAddedPopupBackdrop').removeClass('show');
            });
        });
    </script>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <% if (errorMessage != null || cloth == null) { %>
        <div class="error-box">
            <h3>상품을 불러오지 못했습니다.</h3>
            <p>원인: <%= errorMessage %></p>
            <button onclick="history.back()">돌아가기</button>
        </div>
    <% } else { %>
        <div class="container">
            <div class="left-section">
                <img src="uploadfile/<%=cloth.getImgBody()%>" id="mainImage" class="main-img" alt="Main">
            </div>

            <div class="right-section">
                <div class="sub-images">
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

                <div class="product-info">
                    <div class="title-row">
                        <h1 class="p-title"><%=cloth.getTitle()%></h1>
                        <button id="btnWish" class="btn-wish <%= isWished ? "active" : "" %>" onclick="toggleWish(<%=cloth.getId()%>)">♥</button>
                    </div>
                    <p class="p-price">₩ <fmt:formatNumber value="<%=cloth.getPrice()%>" type="number"/></p>
                    <div class="p-desc"><%=cloth.getDescription()%></div>

                    <form name="cartForm" method="post">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="<%=cloth.getId()%>">
                        <input type="hidden" name="title" value="<%=cloth.getTitle()%>">
                        <input type="hidden" name="img" value="<%=cloth.getImgBody()%>">
                        <input type="hidden" name="price" value="<%=cloth.getPrice()%>">
                        
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
                        
                        <span class="opt-label">QUANTITY (Stock: <%=cloth.getStock()%>)</span>
                        <div class="qty-row">
                            <input type="number" name="quantity" class="qty-input" value="1" min="1" max="<%=cloth.getStock()%>">
                        </div>

                        <button type="button" class="cart-btn" onclick="addToCart()">ADD TO CART</button>
                    </form>
                </div>
            </div>
        </div>
    <% } %>

    <!-- REVIEW SECTION -->
    <% if (cloth != null) { %>
    <section class="review-section">
        <div class="review-header">
            <h3>REVIEWS</h3>
            <span class="review-avg">Average Rating: <span class="star-rating">★ <%= String.format("%.1f", avgRating) %></span></span>
        </div>

        <ul class="review-list">
            <c:set var="reviews" value="<%=reviewList%>" />
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="r" items="${reviews}">
                        <li class="review-item">
                            <div class="review-meta">
                                <strong>${r.userName}</strong> | <fmt:formatDate value="${r.regdate}" pattern="yyyy-MM-dd"/>
                            </div>
                            <div style="margin-bottom: 5px;">
                                <span class="star-rating">
                                    <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                                </span>
                            </div>
                            <div>${fn:replace(r.content, "
", "<br>")}</div>
                        </li>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <li style="text-align: center; padding: 30px; color: #999;">No reviews yet.</li>
                </c:otherwise>
            </c:choose>
        </ul>
    </section>
    <% } %>

    <!-- FOOTER & POPUPS -->
    <jsp:include page="footer.jsp" />
    
    <jsp:include page="cart_popup.jsp" />
    <script src="style.js"></script>

    <!-- Custom Cart Added Popup HTML -->
    <div class="cart-added-popup-backdrop" id="cartAddedPopupBackdrop">
        <div class="cart-added-popup">
            <h3>장바구니에 상품이 담겼습니다.</h3>
            <p>선택하신 상품이 장바구니에 추가되었습니다.</p>
            <div class="cart-added-popup-buttons">
                <button class="btn-continue" id="popupCloseBtn">쇼핑 계속하기</button>
                <button class="btn-view-cart" id="viewCartBtn">장바구니 확인</button>
            </div>
        </div>
    </div>
</body>
</html>