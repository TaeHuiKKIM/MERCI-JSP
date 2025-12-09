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
    if (orderIdStr == null) {
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
<link rel="stylesheet" href="../style.css">
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
        <h2 class="page-title">ORDER DETAILS</h2>
        
        <!-- 주문 기본 정보 -->
        <div class="info-section">
            <h3 class="info-title">주문 정보</h3>
            <table class="info-table">
                <tr>
                    <th>Order No.</th>
                    <td><%=order.getOrderId()%></td>
                    <th>Date</th>
                    <td><fmt:formatDate value="<%=order.getOrderDate()%>" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>
                        <strong style="color: #e74c3c;"><%=order.getStatus()%></strong>
                        <% if ("배송중".equals(order.getStatus()) || "배송완료".equals(order.getStatus())) { %>
                            <div style="font-size: 12px; color: #666; margin-top: 5px;">
                                <%=order.getTrackingCarrier() != null ? order.getTrackingCarrier() : "" %> 
                                <%=order.getTrackingNum() != null ? order.getTrackingNum() : "" %>
                            </div>
                        <% } %>
                    </td>
                    <th>Total Amount</th>
                    <td>₩ <fmt:formatNumber value="<%=order.getTotalAmount()%>" /></td>
                </tr>
            </table>
            
            <% if ("결제대기".equals(order.getStatus())) { %>
            <div style="margin-top: 15px; padding: 15px; background: #fff8f8; border: 1px solid #ffcccc; color: #d63031; font-size: 13px;">
                <strong>[Payment Required]</strong><br>
                Please deposit <strong>₩ <fmt:formatNumber value="<%=order.getTotalAmount()%>" /></strong> to:<br>
                Bank: KB Kookmin Bank 123-456-7890<br>
                Account Holder: MERCI<br>
                Depositor Name: <%=order.getDepositor()%>
            </div>
            <% } %>
        </div>
        
        <!-- 배송지 정보 -->
        <div class="info-section">
            <h3 class="info-title">배송지 정보</h3>
            <table class="info-table">
                <tr>
                    <th>Receiver</th>
                    <td><%=order.getReceiverName()%></td>
                </tr>
                <tr>
                    <th>Phone</th>
                    <td><%=order.getReceiverPhone()%></td>
                </tr>
                <tr>
                    <th>Address</th>
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
                        <th>Product Info</th>
                        <th width="100">Price</th>
                        <th width="80">Qty</th>
                        <th width="120">Review</th>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="items" value="<%=items%>" />
                    <c:set var="reviewMap" value="<%=reviewMap%>" />
                    <c:set var="status" value="<%=order.getStatus()%>" />
                    
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>
                                <div class="item-info">
                                    <a href="../catalogdetail.jsp?clothId=${item.clothId}">
                                        <img src="../images/${item.clothImg}" alt="img">
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
                                                    onclick="openReviewEdit(${review.reviewId}, '${item.clothTitle}')">Edit</button>
                                                <button type="button" class="btn-delete" 
                                                    onclick="deleteReview(${review.reviewId})">Del</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- 없으면 작성 -->
                                            <button type="button" class="btn-review" 
                                                onclick="openReviewWrite(${item.clothId}, '${item.clothTitle}', ${order.orderId})">Write Review</button>
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
            <a href="order_list.jsp" class="btn" style="background: #fff; border: 1px solid #ddd; padding: 10px 30px; color: #333; text-decoration: none;">BACK TO LIST</a>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>