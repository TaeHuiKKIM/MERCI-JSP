<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }
    
    String clothIdStr = request.getParameter("clothId");
    String title = request.getParameter("title");
    String orderIdStr = request.getParameter("orderId");
    
    if (clothIdStr == null) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WRITE REVIEW</title>
<link rel="stylesheet" href="../style.css">
<style>
    .review-container { width: 500px; margin: 50px auto; padding: 30px; border: 1px solid #ddd; }
    .review-title { font-size: 20px; font-weight: bold; margin-bottom: 20px; text-align: center; }
    .product-name { text-align: center; color: #666; margin-bottom: 20px; font-size: 14px; }
    
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: bold; font-size: 13px; }
    .form-control { width: 100%; padding: 10px; border: 1px solid #ddd; box-sizing: border-box; }
    textarea.form-control { height: 150px; resize: none; }
    
    .rating-select { width: 100%; padding: 10px; border: 1px solid #ddd; }
    
    .btn-submit { width: 100%; padding: 12px; background: #333; color: white; border: none; cursor: pointer; margin-top: 10px; }
</style>
</head>
<body>
    <div class="review-container">
        <div class="review-title">WRITE REVIEW</div>
        <div class="product-name"><%=title%></div>
        
        <form action="review_write_proc.jsp" method="post">
            <input type="hidden" name="clothId" value="<%=clothIdStr%>">
            <input type="hidden" name="orderId" value="<%=orderIdStr != null ? orderIdStr : ""%>">
            
            <div class="form-group">
                <label>Rating</label>
                <select name="rating" class="rating-select">
                    <option value="5">★★★★★ (5)</option>
                    <option value="4">★★★★☆ (4)</option>
                    <option value="3">★★★☆☆ (3)</option>
                    <option value="2">★★☆☆☆ (2)</option>
                    <option value="1">★☆☆☆☆ (1)</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Content</label>
                <textarea name="content" class="form-control" required placeholder="리뷰 내용을 입력해주세요."></textarea>
            </div>
            
            <button type="submit" class="btn-submit">SUBMIT REVIEW</button>
            <button type="button" class="btn-submit" style="background: #fff; color: #333; border: 1px solid #ddd;" onclick="history.back()">CANCEL</button>
        </form>
    </div>
</body>
</html>