<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// [1] 세션 확인
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");

if (userId == null) {
	out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp?login=open';</script>");
	return;
}

boolean isLogin = (userName != null);

if (userName == null) {
    userName = "고객";
}

// [2] 배송지 가져오기
DeliveryAddressDao deliveryDao = new DeliveryAddressDao();
DeliveryAddress defaultAddr = null;
List<DeliveryAddress> addrList = null;

Connection conn = null;
try {
    if (userId != null) {
        conn = ConnectionProvider.getConnection();
        
        // 1. 기본 배송지 조회
        defaultAddr = deliveryDao.selectDefault(conn, userId);
        
        // 2. 전체 목록 조회 (fallback 용도)
        addrList = deliveryDao.selectList(conn, userId);
        
        // 3. 기본 배송지가 없는데 목록은 있다면? -> 첫 번째 주소를 보여줌
        if (defaultAddr == null && addrList != null && !addrList.isEmpty()) {
            defaultAddr = addrList.get(0);
        }
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    JdbcUtil.close(conn);
}

String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MYPAGE</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/project/style.css">
</head>
<body>
    
    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

	<div class="mypage-banner">
		<img src="../images/banner.jpg" alt="banner">
	</div>

	<div class="mypage-container">
		<h2 class="welcome-text"><%=userName%>님 환영합니다!
		</h2>

		<div style="text-align: center; margin-bottom: 30px;">
			<a href="wishlist.jsp" class="btn" style="background: #e74c3c; color: white; padding: 10px 20px; text-decoration: none; border: none; font-size: 14px;">❤️ MY WISHLIST</a>
			<a href="order_list.jsp" class="btn" style="background: #2ecc71; color: white; padding: 10px 20px; text-decoration: none; border: none; font-size: 14px; margin-left: 10px;">📦 ORDER HISTORY</a>
		</div>

		<div class="address-section">
			<h3 class="section-title"
				style="display: flex; justify-content: space-between; align-items: center;">
				기본 배송지
				<button type="button" onclick="location.href='address_list.jsp'"
					style="font-size: 12px; background: none; border: none; cursor: pointer; text-decoration: underline; color: #555;">
					배송지 관리 ></button>
			</h3>

			<%
			if (defaultAddr != null) {
			%>
			<div class="address-card">
				<div class="addr-info" style="text-align: left;">

					<div style="margin-bottom: 10px;">
						<span class="badge"><%=defaultAddr.getAddrName()%></span>
					</div>

					<div style="margin-bottom: 5px;">
						<strong class="recipient">수령인 : </strong><%=defaultAddr.getRecipientName()%>
					</div>

					<p class="phone" style="margin-bottom: 8px;">
						전화번호 :
						<%=defaultAddr.getPhone()%>
					</p>

					<p class="address-text">
						주소 :
						[<%=defaultAddr.getZipcode()%>]
						<%=defaultAddr.getAddrRoad()%>
						(<%=defaultAddr.getAddrDetail()%>)
					</p>
				</div>
			</div>
			<%
			} else {
			%>
			<div class="no-address">
				<p style="margin-bottom: 15px; color: #888;">등록된 배송지가 없습니다.</p>
				<a href="address.jsp" class="btn address-btn">새 배송지 등록</a>
			</div>
			<%
			}
			%>
		</div>

		<%
		// Check if user is logged in via Kakao (starts with "kakao_")
		boolean isKakaoUser = (userId != null && userId.startsWith("kakao_"));
		if (!isKakaoUser) {
		%>
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
		<%
		}
		%>

		<h3 class="section-title">계정 삭제</h3>
		<button type="button" class="btn delete-btn" onclick="deleteAccount()">DELETE ACCOUNT</button>
	</div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />
    
	<script src="style.js"></script>
</body>
</html>