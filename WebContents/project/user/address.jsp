<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// [1] 세션 확인
String userName = (String) session.getAttribute("userName");
boolean isLogin = (userName != null);
String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>배송지 정보 입력</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="style.css">
</head>

<body class="address-page">

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

	<!-- 배송지 입력 폼 -->
	<div class="address-container">

		<h2>배송지 정보 입력</h2>

		<form action="address_proc.jsp" method="post" class="address-form">

			<label>주소명</label> <input type="text" name="addressName"
				placeholder="예: 집, 회사" required> <label>받는 사람</label> <input
				type="text" name="receiver" required> <label>전화번호</label> <input
				type="text" name="phone" placeholder="01000000000" required>

			<label>주소</label>
			<div class="address-input-group"
				style="display: flex; gap: 10px; margin-bottom: 10px;">
				<input type="text" id="postcode" placeholder="우편번호"
					style="width: 150px;" readonly> <input type="button"
					onclick="execDaumPostcode()" value="우편번호 찾기"
					style="width: 120px; background: #333; color: #fff; border: none; cursor: pointer;">
			</div>

			<input type="text" id="roadAddress" name="roadAddress"
				placeholder="도로명주소" readonly required> <input type="hidden"
				id="extraAddress" placeholder="참고항목"> <label>상세주소</label> <input
				type="text" id="detailAddress" name="detailAddress"
				placeholder="상세주소를 입력하세요 (예: 101동 101호)">

			<button type="submit" class="btn save-btn">저장하기</button>
		</form>

	</div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />
    
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="style.js"></script>
</body>
</html>