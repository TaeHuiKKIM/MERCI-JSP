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
<title>MANAGE ORDER - MERCI ADMIN</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
<style>
    .tracking-input {
        width: 100px; padding: 4px; font-size: 12px; border: 1px solid #ccc;
        display: none; /* Initially hidden */
    }
    .status-select {
        padding: 4px; border: 1px solid #ccc;
    }
</style>
<script>
    function toggleTrackingInput(select, orderId) {
        var val = select.value;
        var carrier = document.getElementById('carrier_' + orderId);
        var trackNum = document.getElementById('trackNum_' + orderId);
        
        if(val === '배송중' || val === '배송완료') {
            carrier.style.display = 'inline-block';
            trackNum.style.display = 'inline-block';
        } else {
            carrier.style.display = 'none';
            trackNum.style.display = 'none';
        }
    }
</script>
</head>
<body class="admin-body">

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <div class="admin-container">
        <div class="admin-page-title">
            <span>MANAGE ORDERS</span>
        </div>

        <div class="admin-card">
            <!-- Search & Filter -->
            <form action="manageorder.jsp" method="get" class="admin-form-group" style="display: flex; gap: 10px; align-items: center; margin-bottom: 20px;">
                <select name="status" class="admin-select" style="width: auto;">
                    <option value="All">All Status</option>
                    <option value="결제대기">결제대기</option>
                    <option value="결제완료">결제완료</option>
                    <option value="배송중">배송중</option>
                    <option value="배송완료">배송완료</option>
                </select>
                <input type="text" name="keyword" placeholder="Depositor or User ID" class="admin-input" style="width: 200px;">
                <button type="submit" class="btn-admin btn-admin-dark">SEARCH</button>
            </form>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="50">ID</th>
                        <th width="100">User</th>
                        <th width="100">Total</th>
                        <th width="120">Date</th>
                        <th width="100">Depositor</th>
                        <th width="200">Delivery Info</th>
                        <th>Status / Tracking</th>
                        <th width="80">Action</th>
                    </tr>
                </thead>
                <tbody>
                <c:set var="list" value="<%=list%>" />
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="o" items="${list}">
                            <tr>
                                <td>${o.orderId}</td>
                                <td>${o.userId}</td>
                                <td><fmt:formatNumber value="${o.totalAmount}" type="number"/></td>
                                <td><fmt:formatDate value="${o.orderDate}" pattern="yyyy-MM-dd"/></td>
                                <td>${o.depositor}</td>
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
                                                   class="tracking-input" placeholder="Carrier (e.g. CJ)" 
                                                   value="${o.trackingCarrier != null ? o.trackingCarrier : ''}"
                                                   style="${(o.status == '배송중' || o.status == '배송완료') ? 'display:inline-block;' : ''}">
                                                   
                                            <input type="text" name="trackNum" id="trackNum_${o.orderId}" 
                                                   class="tracking-input" placeholder="Tracking Number" 
                                                   value="${o.trackingNum != null ? o.trackingNum : ''}"
                                                   style="${(o.status == '배송중' || o.status == '배송완료') ? 'display:inline-block;' : ''}">
                                        </div>
                                    </form>
                                </td>
                                <td>
                                    <button type="button" class="btn-admin btn-admin-primary" onclick="document.getElementById('form_${o.orderId}').submit()">Update</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="8" style="text-align: center; padding: 50px;">No orders found.</td></tr>
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