<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>
<%
    // 1. 로그인 체크
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
%>
        <script>
            alert("로그인이 필요한 서비스입니다.");
            location.href = "../index.jsp?login=open";
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
        addr = dao.selectOne(conn, addrId); // DAO에 이 메서드 있어야 함 (어제 추가해드림)
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
<link rel="stylesheet" href="style.css">
</head>
<body class="address-page">

    <header class="header">
        <div class="header-inner">
            <div class="header-logo">
                <a href="../index.jsp"><img src="images/mainlogo.png" alt="logo"></a>
            </div>
            <nav class="header-nav">
                <a href="../index.jsp">HOME</a>
                <a href="../about.html">ABOUT</a>
                <a href="../product.html">PRODUCT</a>
                <a href="account.jsp">MY PAGE</a>
                <a href="logout_proc.jsp">LOGOUT</a>
            </nav>
        </div>
    </header>

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

            <label>도로명 주소</label>
            <input type="text" name="roadAddress" value="<%=addr.getAddrRoad()%>" required>

            <label>상세주소</label>
            <input type="text" name="detailAddress" value="<%=addr.getAddrDetail()%>">

            <button type="submit" class="btn save-btn">수정 완료</button>
        </form>
    </div>
    
    <script src="style.js"></script>
</body>
</html>