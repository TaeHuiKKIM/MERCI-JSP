<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp?login=open';</script>");
        return;
    }

    List<Order> list = null;
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        OrderDao dao = new OrderDao();
        list = dao.selectListByUserId(conn, userId);
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(conn);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>나의 주문 목록 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/project/style.css">
<style>
    .order-container { max-width: 1000px; margin: 80px auto; padding: 20px; min-height: 500px; }
    .page-title { font-size: 24px; font-weight: bold; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    
    .order-item { border: 1px solid #eee; padding: 20px; margin-bottom: 20px; }
    .order-header { display: flex; justify-content: space-between; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px; }
    .order-date { font-weight: bold; font-size: 14px; }
    .order-status { font-weight: bold; color: #e74c3c; }
    
    .order-info { font-size: 13px; line-height: 1.6; }
    .info-label { display: inline-block; width: 100px; color: #888; }
    
    .tracking-box { margin-top: 15px; padding: 10px; background: #f9f9f9; border-radius: 4px; font-size: 13px; }
    .payment-msg { margin-top: 15px; padding: 15px; background: #fff8f8; border: 1px solid #ffcccc; color: #d63031; font-size: 13px; }
</style>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="order-container">
        <h2 class="page-title">나의 주문 목록</h2>
        
        <c:set var="list" value="<%=list%>" />
        <c:choose>
            <c:when test="${not empty list}">
                <c:forEach var="o" items="${list}">
                    <div class="order-item">
                        <div class="order-header">
                            <span class="order-date">
                                <fmt:formatDate value="${o.orderDate}" pattern="yyyy.MM.dd"/> 
                                (주문번호: <a href="order_detail.jsp?orderId=${o.orderId}" style="color: #333; text-decoration: underline;">${o.orderId}</a>)
                            </span>
                            <span class="order-status">${o.status}</span>
                        </div>
                        
                        <div class="order-info">
                            <div><span class="info-label">수령인</span> ${o.receiverName}</div>
                            <div><span class="info-label">주소</span> ${o.address}</div>
                            <div><span class="info-label">총 결제 금액</span> ₩ <fmt:formatNumber value="${o.totalAmount}" type="number"/></div>
                            <div style="margin-top: 10px;">
                                <a href="order_detail.jsp?orderId=${o.orderId}" class="btn" style="background: #333; color: white; padding: 5px 10px; font-size: 12px; text-decoration: none;">상세보기</a>
                            </div>
                        </div>

                        <!-- Status Messages -->
                        <c:if test="${o.status == '배송중' || o.status == '배송완료'}">
                            <div class="tracking-box">
                                <strong>[배송 정보]</strong><br>
                                택배사: ${o.trackingCarrier != null ? o.trackingCarrier : '정보 없음'}<br>
                                운송장 번호: ${o.trackingNum != null ? o.trackingNum : '정보 없음'}
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 50px; color: #999;">
                    주문 내역이 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>