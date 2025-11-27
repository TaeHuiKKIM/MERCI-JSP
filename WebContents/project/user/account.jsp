<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// [1] 맨 위: 세션에서 저장된 이름(userName)을 가져옵니다.
String userName = (String) session.getAttribute("userName");
boolean isLogin = (userName != null);
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
					href="product.html">PRODUCT</a>
					<%
				if (isLogin) {
				%>
				<a href="account.jsp">MY PAGE</a> <a
					href="logout_proc.jsp">LOGOUT</a>
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




	<div class="mypage-banner">
		<!-- 여기에 배너 이미지 -->
		<img src="images/banner.jpg" alt="banner">
	</div>

	<div class="mypage-container">

		<!-- 아이디 환영 문구 -->
		<h2 class="welcome-text"><%=userName%>님 환영합니다!
		</h2>

		<!-- 배송지 정보 버튼 -->
		<%
    DeliveryAddressDao deliveryDao = new DeliveryAddressDao();
    List<DeliveryAddress> addrList = null;
    
    try {
        Connection conn = ConnectionProvider.getConnection();
        // 로그인한 유저의 배송지 목록 조회
        addrList = deliveryDao.selectList(conn, userName); // userName 대신 userId를 써야한다면 변수명 확인 필요!
        // (주의: selectList 메서드가 userId를 받도록 되어 있다면, 위에서 session.getAttribute("userId")로 받은 변수를 넣으세요)
        // 예: addrList = deliveryDao.selectList(conn, (String)session.getAttribute("userId"));
        
        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<div class="address-section">
    <% 
    // 1. 등록된 주소가 없을 때 -> 기존 '입력 버튼' 표시
    if (addrList == null || addrList.isEmpty()) { 
    %>
        <div class="no-address">
            <p>등록된 배송지가 없습니다.</p>
            <a href="address.jsp" class="btn address-btn">배송지 정보 입력</a>
        </div>
    <% 
    // 2. 주소가 있을 때 -> '주소 박스' 반복 출력
    } else { 
        for (DeliveryAddress addr : addrList) {
    %>
        <div class="address-card">
            <div class="addr-info">
                <span class="badge"><%= addr.getAddrName() %></span> <strong class="recipient"><%= addr.getRecipientName() %></strong>
                <p class="phone"><%= addr.getPhone() %></p>
                <p class="address-text">
                    <%= addr.getAddrRoad() %> <br> 
                    <%= addr.getAddrDetail() %>
                </p>
            </div>

            <div class="addr-actions">
                <button type="button" class="btn-select">선택</button>
                <button type="button" class="btn-edit" onclick="location.href='address_edit.jsp?id=<%=addr.getAddrId()%>'">수정</button>
            </div>
        </div>
    <% 
        } 
    } 
    %>
</div>

		<!-- 비밀번호 변경 -->
		<h3 class="section-title">비밀번호 변경</h3>

		<form action="pswChange_proc.jsp" method="post"
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