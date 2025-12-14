<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String userId = (String) session.getAttribute("userId");
    String orderIdStr = request.getParameter("orderId");
    
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp?login=open';</script>");
        return;
    }
    if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }
    
    int orderId = Integer.parseInt(orderIdStr);
    Order order = null;
    List<OrderItem> items = null;
    Map<Integer, Review> reviewMap = new HashMap<>(); // clothId -> Review
    
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        OrderDao orderDao = new OrderDao();
        order = orderDao.selectById(conn, orderId);
        
        // 본인 주문 확인
        if (order == null || !order.getUserId().equals(userId)) {
            out.println("<script>alert('주문 정보를 찾을 수 없습니다.'); history.back();</script>");
            JdbcUtil.close(conn);
            return;
        }
        
        items = orderDao.selectOrderItemsByOrderId(conn, orderId);
        
        // 각 아이템에 대한 리뷰 존재 여부 확인
        ReviewDao reviewDao = new ReviewDao();
        for (OrderItem item : items) {
            Review r = reviewDao.selectByUserIdAndClothId(conn, userId, item.getClothId());
            if (r != null) {
                reviewMap.put(item.getClothId(), r);
            }
        }
        
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
<title>ORDER DETAILS - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/project/style.css">
<style>
    .order-detail-container { max-width: 1000px; margin: 80px auto; padding: 20px; }
    .page-title { font-size: 24px; font-weight: bold; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    
    .info-section { margin-bottom: 40px; }
    .info-title { font-size: 16px; font-weight: bold; margin-bottom: 15px; border-bottom: 1px solid #ddd; padding-bottom: 8px; }
    .info-table { width: 100%; border-collapse: collapse; font-size: 13px; }
    .info-table th, .info-table td { padding: 12px 10px; border-bottom: 1px solid #eee; text-align: left; }
    .info-table th { width: 150px; background: #f9f9f9; color: #555; }
    
    .item-list { width: 100%; border-collapse: collapse; margin-top: 10px; }
    .item-list th, .item-list td { padding: 15px 10px; border-bottom: 1px solid #eee; text-align: center; font-size: 13px; }
    .item-list th { background: #f9f9f9; font-weight: 600; }
    .item-info { display: flex; align-items: center; text-align: left; }
    .item-info img { width: 60px; height: 80px; object-fit: cover; margin-right: 15px; }
    
    .btn-review { background: #333; color: white; padding: 5px 10px; text-decoration: none; font-size: 12px; border-radius: 3px; display: inline-block; }
    .btn-edit { background: #555; color: white; padding: 5px 10px; text-decoration: none; font-size: 12px; border-radius: 3px; }
    .btn-delete { background: #e74c3c; color: white; padding: 5px 10px; text-decoration: none; font-size: 12px; border-radius: 3px; }
</style>
<script>
    function openReviewWrite(clothId, clothTitle, orderId) {
        location.href = 'review_write.jsp?clothId=' + clothId + '&title=' + encodeURIComponent(clothTitle) + '&orderId=' + orderId;
    }
    function openReviewEdit(reviewId, clothTitle) {
        location.href = 'review_edit.jsp?reviewId=' + reviewId + '&title=' + encodeURIComponent(clothTitle);
    }
    function deleteReview(reviewId) {
        if(confirm('리뷰를 삭제하시겠습니까?')) {
            location.href = 'review_delete_proc.jsp?reviewId=' + reviewId;
        }
    }
</script>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="order-detail-container">
        <h2 class="page-title">주문 상세 내역</h2>
        
        <!-- 주문 기본 정보 -->
        <div class="info-section">
            <h3 class="info-title">주문 정보</h3>
            <table class="info-table">
                <tr>
                    <th>주문 번호</th>
                    <td><%=order.getOrderId()%></td>
                    <th>주문 일시</th>
                    <td><fmt:formatDate value="<%=order.getOrderDate()%>" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>주문 상태</th>
                    <td>
                        <strong style="color: #e74c3c;"><%=order.getStatus()%></strong>
                        <% if ("배송중".equals(order.getStatus()) || "배송완료".equals(order.getStatus())) { %>
                            <div style="font-size: 12px; color: #666; margin-top: 5px;">
                                <%=order.getTrackingCarrier() != null ? order.getTrackingCarrier() : "" %> 
                                <%=order.getTrackingNum() != null ? order.getTrackingNum() : "" %>
                            </div>
                        <% } %>
                    </td>
                    <th>총 결제 금액</th>
                    <td>₩ <fmt:formatNumber value="<%=order.getTotalAmount()%>" /></td>
                </tr>
                <tr>
                    <th>결제 수단</th>
                    <td colspan="3">
                        <%= (order.getPayMethod() != null) ? order.getPayMethod() : "-" %>
                        <% if (order.getPaymentId() != null && !order.getPaymentId().isEmpty()) { %>
                            <span style="font-size: 11px; color: #888; margin-left: 10px;">(ID: <%=order.getPaymentId()%>)</span>
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>
        
        <!-- 배송지 정보 -->
        <div class="info-section">
            <h3 class="info-title">배송지 정보</h3>
            <table class="info-table">
                <tr>
                    <th>받는 분</th>
                    <td><%=order.getReceiverName()%></td>
                </tr>
                <tr>
                    <th>휴대전화</th>
                    <td><%=order.getReceiverPhone()%></td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td><%=order.getAddress()%></td>
                </tr>
            </table>
        </div>

        <!-- 주문 상품 목록 -->
        <div class="info-section">
            <h3 class="info-title">주문 상품</h3>
            <table class="item-list">
                <thead>
                    <tr>
                        <th>상품 정보</th>
                        <th width="100">가격</th>
                        <th width="80">수량</th>
                        <th width="120">리뷰</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="items" value="<%=items%>" />
                    <c:set var="reviewMap" value="<%=reviewMap%>" />
                    <c:set var="status" value="<%=order.getStatus()%>" />
                    <c:set var="order" value="<%=order%>" />
                    
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>
                                <div class="item-info">
                                    <a href="../catalogdetail.jsp?clothId=${item.clothId}">
                                        <img src="../uploadfile/${item.clothImg}" alt="img">
                                    </a>
                                    <div>
                                        <a href="../catalogdetail.jsp?clothId=${item.clothId}" style="color: #333; text-decoration: none;">
                                            ${item.clothTitle}
                                        </a>
                                    </div>
                                </div>
                            </td>
                            <td>₩ <fmt:formatNumber value="${item.price}"/></td>
                            <td>${item.quantity}</td>
                            <td>
                                <!-- 배송완료 상태일 때만 리뷰 작성 가능 -->
                                <c:if test="${status == '배송완료'}">
                                    <c:set var="review" value="${reviewMap[item.clothId]}" />
                                    <c:choose>
                                        <c:when test="${not empty review}">
                                            <!-- 리뷰가 있으면 수정/삭제 -->
                                            <div style="display: flex; gap: 5px; justify-content: center;">
                                                <button type="button" class="btn-edit" 
                                                    onclick="openReviewEdit(${review.reviewId}, '${item.clothTitle}')">수정</button>
                                                <button type="button" class="btn-delete" 
                                                    onclick="deleteReview(${review.reviewId})">삭제</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- 없으면 작성 -->
                                            <button type="button" class="btn-review" 
                                                onclick="openReviewWrite(${item.clothId}, '${item.clothTitle}', ${order.orderId})">리뷰 작성</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:if test="${status != '배송완료'}">
                                    <span style="color: #aaa; font-size: 11px;">-</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="order_list.jsp" class="btn" style="background: #fff; border: 1px solid #ddd; padding: 10px 30px; color: #333; text-decoration: none;">목록으로 돌아가기</a>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>