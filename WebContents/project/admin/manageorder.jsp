<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Check
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    Connection conn = null;
    List<Order> list = null;
    try {
        conn = ConnectionProvider.getConnection();
        OrderDao dao = new OrderDao();
        list = dao.selectOrderList(conn, request.getParameter("status"), request.getParameter("keyword"));
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(conn);
    }
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문 관리 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
<script src="<%=root%>/style.js"></script>
</head>
<body class="admin-body">

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <div class="admin-container">
        <div class="admin-page-title">
            <span>주문 관리</span>
        </div>

        <div class="admin-card">
            <!-- Search & Filter -->
            <form action="manageorder.jsp" method="get" class="admin-form-group" style="display: flex; gap: 10px; align-items: center; margin-bottom: 20px;">
                <select name="status" class="admin-select" style="width: auto;">
                    <option value="All">전체 상태</option>
                    <option value="결제대기">결제대기</option>
                    <option value="결제완료">결제완료</option>
                    <option value="배송중">배송중</option>
                    <option value="배송완료">배송완료</option>
                </select>
                <input type="text" name="keyword" placeholder="입금자명 또는 아이디" class="admin-input" style="width: 200px;">
                <button type="submit" class="btn-admin btn-admin-dark">검색</button>
            </form>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="50">ID</th>
                        <th width="100">주문자</th>
                        <th width="100">결제금액</th>
                        <th width="120">주문일</th>
                        <th width="120">결제수단</th>
                        <th width="200">배송 정보</th>
                        <th>상태 / 운송장</th>
                        <th width="120">관리</th>
                    </tr>
                </thead>
                <tbody>
                <c:set var="list" value="<%=list%>" />
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="o" items="${list}">
                            <tr>
                                <td>${o.orderId}</td>
                                <td>${o.userName}</td>
                                <td><fmt:formatNumber value="${o.totalAmount}" type="number"/></td>
                                <td><fmt:formatDate value="${o.orderDate}" pattern="yyyy-MM-dd"/></td>
                                <td style="font-size: 12px;">
                                    <strong>${o.payMethod != null ? o.payMethod : '-'}</strong><br>
                                    <span style="color: #888; font-size: 11px;">${o.paymentId != null ? o.paymentId : ''}</span>
                                </td>
                                <td style="font-size: 12px; line-height: 1.4;">
                                    <strong>${o.receiverName}</strong><br>
                                    ${o.address}
                                </td>
                                <td>
                                    <form action="order_status_proc.jsp" method="post" id="form_${o.orderId}">
                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                        <div style="display: flex; gap: 5px; align-items: center; flex-wrap: wrap;">
                                            <select name="status" class="status-select" onchange="toggleTrackingInput(this, ${o.orderId})">
                                                <option value="결제대기" ${o.status == '결제대기' ? 'selected' : ''}>결제대기</option>
                                                <option value="결제완료" ${o.status == '결제완료' ? 'selected' : ''}>결제완료</option>
                                                <option value="배송중" ${o.status == '배송중' ? 'selected' : ''}>배송중</option>
                                                <option value="배송완료" ${o.status == '배송완료' ? 'selected' : ''}>배송완료</option>
                                                <option value="주문취소" ${o.status == '주문취소' ? 'selected' : ''}>주문취소</option>
                                            </select>
                                            
                                            <!-- Tracking Inputs (Shown if Shipping/Delivered) -->
                                            <input type="text" name="carrier" id="carrier_${o.orderId}" 
                                                   class="tracking-input" placeholder="택배사" 
                                                   value="${o.trackingCarrier != null ? o.trackingCarrier : ''}"
                                                   style="${(o.status == '배송중' || o.status == '배송완료') ? 'display:inline-block;' : ''}">
                                                   
                                            <input type="text" name="trackNum" id="trackNum_${o.orderId}" 
                                                   class="tracking-input" placeholder="운송장 번호" 
                                                   value="${o.trackingNum != null ? o.trackingNum : ''}"
                                                   style="${(o.status == '배송중' || o.status == '배송완료') ? 'display:inline-block;' : ''}">
                                        </div>
                                    </form>
                                </td>
                                <td>
                                    <button type="button" class="btn-admin btn-admin-primary" onclick="document.getElementById('form_${o.orderId}').submit()">수정</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="8" style="text-align: center; padding: 50px;">주문 내역이 없습니다.</td></tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>