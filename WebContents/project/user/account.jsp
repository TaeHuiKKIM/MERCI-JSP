<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// [1] 세션 확인 및 초기화
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
boolean isLogin = (userName != null);

if (userName == null) {
	userName = "고객";
}

// [2] 배송지 목록 가져오기 (수정됨)
DeliveryAddressDao deliveryDao = new DeliveryAddressDao();
List<DeliveryAddress> addrList = null;
DeliveryAddress defaultAddr = null; // [추가] 기본 배송지 변수

try {
	if (userId != null) {
		Connection conn = ConnectionProvider.getConnection();

		// 1. 기본 배송지 1개 조회
		defaultAddr = deliveryDao.selectDefault(conn, userId);
		// 2. 전체 목록 조회 (팝업창용)
		addrList = deliveryDao.selectList(conn, userId);

		conn.close();
	}
} catch (Exception e) {
	e.printStackTrace();
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
				<a href="../index.jsp"><img src="images/mainlogo.png" alt="logo"></a>
			</div>
			<nav class="header-nav">
				<a href="../index.jsp">HOME</a> <a href="../about.html">ABOUT</a> <a
					href="../product.jsp">PRODUCT</a>
				<%
				if (isLogin) {
				%>
				<a href="account.jsp">MY PAGE</a> <a href="logout_proc.jsp">LOGOUT</a>
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
		<img src="images/banner.jpg" alt="banner">
	</div>

	<div class="mypage-container">
		<h2 class="welcome-text"><%=userName%>님 환영합니다!
		</h2>

		<div class="address-section">
			<h3 class="section-title"
				style="display: flex; justify-content: space-between; align-items: center;">
				기본 배송지
				<button type="button" onclick="openAddrModal()"
					style="font-size: 12px; background: none; border: none; cursor: pointer; text-decoration: underline; color: #555;">
					배송지 관리 ></button>
			</h3>

			<%
			if (defaultAddr != null) {
			%>
			<div class="address-card">
				<div class="addr-info">
					<span class="badge"><%=defaultAddr.getAddrName()%></span> <strong
						class="recipient"><%=defaultAddr.getRecipientName()%></strong>
					<p class="phone"><%=defaultAddr.getPhone()%></p>
					<p class="address-text">
						<%=defaultAddr.getAddrRoad()%>
						<br>
						<%=defaultAddr.getAddrDetail()%>
					</p>
				</div>
			</div>
			<%
			} else {
			%>
			<div class="no-address">
				<p style="margin-bottom: 15px; color: #888;">등록된 기본 배송지가 없습니다.</p>
				<a href="address.jsp" class="btn address-btn">새 배송지 등록</a>
			</div>
			<%
			}
			%>
		</div>

		<h3 class="section-title">비밀번호 변경</h3>
		<form action="pswChange_proc.jsp" method="post" name="pwForm"
			class="password-box">
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
	<div id="addrModal" class="modal-overlay">
		<div class="modal-window">
			<div
				style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #222; padding-bottom: 10px;">
				<h3 class="modal-title" style="margin: 0; border: none;">배송지 관리</h3>
				<button class="close-modal-btn" onclick="closeAddrModal()"
					style="font-size: 24px; border: none; background: none; cursor: pointer;">×</button>
			</div>

			<button onclick="location.href='address.jsp'" class="btn"
				style="margin-bottom: 20px; background: #333; color: #fff;">+
				새 배송지 추가</button>

			<div class="addr-list-scroll"
				style="max-height: 60vh; overflow-y: auto;">
				<%
				if (addrList != null) {
					for (DeliveryAddress addr : addrList) {
						// 현재 이 주소가 기본 배송지인지 확인
						boolean isDef = (defaultAddr != null && addr.getAddrId() == defaultAddr.getAddrId());
				%>
				<div class="addr-item <%=isDef ? "default" : ""%>">
					<div class="info">
						<span class="badge"><%=addr.getAddrName()%></span> <strong><%=addr.getRecipientName()%></strong>
						<%
						if (isDef) {
						%><span class="badge-default">기본</span>
						<%
						}
						%>
						<br> <span style="font-size: 13px; color: #666;"><%=addr.getAddrRoad()%>
							<%=addr.getAddrDetail()%></span> <br> <span
							style="font-size: 12px; color: #888;"><%=addr.getPhone()%></span>
					</div>
					<div class="addr-actions-small"
						style="margin-top: 10px; text-align: right;">
						<%
						if (!isDef) {
						%>
						<a
							href="address_action.jsp?mode=default&id=<%=addr.getAddrId()%>">기본설정</a>
						<%
						}
						%>
						<a href="address_edit.jsp?id=<%=addr.getAddrId()%>">수정</a> <a
							href="address_action.jsp?mode=delete&id=<%=addr.getAddrId()%>"
							onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
					</div>
				</div>
				<%
				}
				}
				%>
			</div>
		</div>
	</div>
	<script src="style.js"></script>
</body>
</html>