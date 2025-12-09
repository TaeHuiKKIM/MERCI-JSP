<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }
    
    String reviewIdStr = request.getParameter("reviewId");
    String title = request.getParameter("title");
    
    if (reviewIdStr == null) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }
    
    // 기존 리뷰 가져오기
    // (Dao에 selectById가 없지만, userId로 검증하는 로직이 필요하므로 그냥 여기서 쿼리하거나 Dao에 추가해도 됨.
    //  ReviewDao에 update 메서드만 있고 selectById는 없지만 selectByUserIdAndClothId는 있음.
    //  일단 간단하게 쿼리 작성하거나 Dao에 추가가 정석이나 시간 관계상 selectByUserIdAndClothId를 쓰려면 clothId를 알아야 함.
    //  selectById가 낫겠다. 하지만 reviewId만 넘어오므로...
    //  Let's add selectById to ReviewDao? Or just direct query here.)
    
    // Wait, I only added selectByUserIdAndClothId. I should check if I can fetch by ID.
    // I will do direct query here for simplicity as I didn't add selectById to ReviewDao yet.
    
    Review review = null;
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        conn = ConnectionProvider.getConnection();
        String sql = "SELECT * FROM review WHERE reviewId = ? AND userId = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(reviewIdStr));
        pstmt.setString(2, userId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            review = new Review();
            review.setReviewId(rs.getInt("reviewId"));
            review.setRating(rs.getInt("rating"));
            review.setContent(rs.getString("content"));
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(rs);
        JdbcUtil.close(pstmt);
        JdbcUtil.close(conn);
    }

    if (review == null) {
        out.println("<script>alert('리뷰를 찾을 수 없거나 수정 권한이 없습니다.'); history.back();</script>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EDIT REVIEW</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/project/style.css">
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
        <div class="review-title">EDIT REVIEW</div>
        <div class="product-name"><%=title%></div>
        
        <form action="review_edit_proc.jsp" method="post">
            <input type="hidden" name="reviewId" value="<%=review.getReviewId()%>">
            
            <div class="form-group">
                <label>Rating</label>
                <select name="rating" class="rating-select">
                    <option value="5" <%=review.getRating()==5?"selected":""%>>★★★★★ (5)</option>
                    <option value="4" <%=review.getRating()==4?"selected":""%>>★★★★☆ (4)</option>
                    <option value="3" <%=review.getRating()==3?"selected":""%>>★★★☆☆ (3)</option>
                    <option value="2" <%=review.getRating()==2?"selected":""%>>★★☆☆☆ (2)</option>
                    <option value="1" <%=review.getRating()==1?"selected":""%>>★☆☆☆☆ (1)</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Content</label>
                <textarea name="content" class="form-control" required><%=review.getContent()%></textarea>
            </div>
            
            <button type="submit" class="btn-submit">UPDATE REVIEW</button>
            <button type="button" class="btn-submit" style="background: #fff; color: #333; border: 1px solid #ddd;" onclick="history.back()">CANCEL</button>
        </form>
    </div>
</body>
</html>