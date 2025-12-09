<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>
<%
    String root = request.getContextPath() + "/project";
    // 1. 로그인 체크
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
%>
        <script>
            alert("로그인이 필요한 서비스입니다.");
            location.href = "<%=root%>/index.jsp?login=open";
        </script>
<%
        return;
    }

    // 2. 수정할 배송지 ID 받기
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
%>
        <script>alert("잘못된 접근입니다."); history.back();</script>
<%
        return;
    }
    int addrId = Integer.parseInt(idStr);

    // 3. DB에서 기존 정보 가져오기
    DeliveryAddress addr = null;
    try {
        Connection conn = ConnectionProvider.getConnection();
        DeliveryAddressDao dao = new DeliveryAddressDao();
        addr = dao.selectOne(conn, addrId);
        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }

    // 4. 본인 확인 (남의 주소 수정 방지)
    if (addr == null || !addr.getUserId().equals(userId)) {
%>
        <script>alert("존재하지 않는 주소이거나 권한이 없습니다."); history.back();</script>
<%
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>배송지 수정</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/project/style.css">
</head>
<body class="address-page">

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="address-container">
        <h2>배송지 수정</h2>

        <form action="address_edit_proc.jsp" method="post" class="address-form">
            
            <input type="hidden" name="addrId" value="<%=addr.getAddrId()%>">

            <label>주소명</label>
            <input type="text" name="addressName" value="<%=addr.getAddrName()%>" required>

            <label>받는 사람</label>
            <input type="text" name="receiver" value="<%=addr.getRecipientName()%>" required>

            <label>전화번호</label>
            <input type="text" name="phone" value="<%=addr.getPhone()%>" required>

            <label>주소</label>
            <div class="address-input-group" style="display: flex; gap: 10px; margin-bottom: 10px;">
                <input type="text" id="postcode" placeholder="우편번호" style="width: 150px;" readonly>
                <input type="button" onclick="execDaumPostcode()" value="우편번호 찾기" 
                       style="width: 120px; background: #333; color: #fff; border: none; cursor: pointer;">
            </div>

            <input type="text" id="roadAddress" name="roadAddress" value="<%=addr.getAddrRoad()%>" readonly required>
            
            <input type="hidden" id="extraAddress" placeholder="참고항목">

            <label>상세주소</label>
            <input type="text" id="detailAddress" name="detailAddress" value="<%=addr.getAddrDetail()%>">

            <button type="submit" class="btn save-btn">수정 완료</button>
        </form>
    </div>
    
    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="style.js"></script>
</body>
</html>