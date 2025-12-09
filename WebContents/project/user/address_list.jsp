<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String userId = (String) session.getAttribute("userId");
    String root = request.getContextPath() + "/project";
    
    if (userId == null) {
%>
    <script>alert("로그인이 필요합니다."); location.href = "<%=root%>/index.jsp?login=open";</script>
<%
        return;
    }

    DeliveryAddressDao dao = new DeliveryAddressDao();
    List<DeliveryAddress> addrList = null;
    DeliveryAddress defaultAddr = null;

    try {
        Connection conn = ConnectionProvider.getConnection();
        addrList = dao.selectList(conn, userId);
        defaultAddr = dao.selectDefault(conn, userId);
        conn.close();
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>배송지 관리</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
    
    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="addr-list-container">
        <h2 class="page-title">배송지 관리</h2>
        
        <% 
        if (addrList != null && !addrList.isEmpty()) { 
            int index = 1; 
            for (DeliveryAddress addr : addrList) {
                boolean isDef = (defaultAddr != null && addr.getAddrId() == defaultAddr.getAddrId());
        %>
            <div class="addr-item" id="addr_<%=addr.getAddrId()%>" onclick="selectAddr(this, <%=addr.getAddrId()%>)">
                <div class="addr-num"><%= index++ %></div>
                <div class="addr-content">
                    <strong style="font-size:16px;"><%= addr.getAddrName() %></strong> 
                    <span style="margin-left:5px;"><%= addr.getRecipientName() %></span>
                    <% if(isDef) { %><span class="badge-default">기본</span><% } %>
                    <p style="margin:8px 0; color:#444;"><%= addr.getAddrRoad() %> <%= addr.getAddrDetail() %></p>
                    <p style="color:#888; font-size:13px;"><%= addr.getPhone() %></p>
                </div>
            </div>
        <% 
            } 
        } else { 
        %>
            <div style="text-align:center; padding:50px; border:1px dashed #ddd; color:#999;">등록된 배송지가 없습니다.</div>
        <% } %>
        
        <div style="height: 100px;"></div>
    </div>

    <div class="bottom-action-bar">
        <button type="button" class="action-btn" onclick="location.href='address.jsp'">+ 새 배송지</button>
        <button type="button" class="action-btn" onclick="doAction('default')">기본 설정</button>
        <button type="button" class="action-btn" onclick="doAction('edit')">수정</button>
        <button type="button" class="action-btn black" onclick="doAction('delete')">삭제</button>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />
    
    <script src="style.js"></script>
</body>
</html>