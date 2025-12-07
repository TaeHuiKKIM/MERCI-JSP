<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp?login=open';</script>");
        return;
    }

    List<Wishlist> list = null;
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        WishlistDao dao = new WishlistDao();
        list = dao.selectList(conn, userId);
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
<title>MY WISHLIST - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="../style.css">
<style>
    .wish-container { max-width: 1000px; margin: 80px auto; padding: 20px; min-height: 500px; }
    .page-title { font-size: 24px; font-weight: bold; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    
    .wish-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
    .wish-item { border: 1px solid #eee; position: relative; }
    .wish-item img { width: 100%; height: 250px; object-fit: cover; cursor: pointer; }
    .wish-info { padding: 15px; text-align: center; }
    .wish-title { font-size: 14px; font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .wish-price { font-size: 13px; color: #111; }
    
    .btn-remove { position: absolute; top: 10px; right: 10px; background: rgba(255,255,255,0.8); border: none; width: 30px; height: 30px; border-radius: 50%; cursor: pointer; font-size: 16px; line-height: 30px; color: #e74c3c; }
    .btn-remove:hover { background: #fff; }
    
    @media (max-width: 900px) { .wish-grid { grid-template-columns: repeat(2, 1fr); } }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function removeWish(clothId, element) {
        if(!confirm("삭제하시겠습니까?")) return;
        
        $.ajax({
            url: '../wishlist_proc_ajax.jsp',
            type: 'POST',
            data: { clothId: clothId },
            dataType: 'json',
            success: function(res) {
                if(res.status === 'success') {
                    $(element).closest('.wish-item').remove();
                } else {
                    alert(res.message);
                }
            },
            error: function() { alert("Error occurred"); }
        });
    }
</script>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="wish-container">
        <h2 class="page-title">MY WISHLIST</h2>
        
        <div class="wish-grid">
            <c:set var="list" value="<%=list%>" />
            <c:choose>
                <c:when test="${not empty list}">
                    <c:forEach var="w" items="${list}">
                        <div class="wish-item">
                            <button class="btn-remove" onclick="removeWish(${w.clothId}, this)">×</button>
                            <a href="../catalogdetail.jsp?clothId=${w.clothId}">
                                <img src="../uploadfile/${w.clothImg}" alt="${w.clothTitle}">
                            </a>
                            <div class="wish-info">
                                <div class="wish-title">${w.clothTitle}</div>
                                <div class="wish-price">₩ <fmt:formatNumber value="${w.clothPrice}" type="number"/></div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="grid-column: 1/-1; text-align: center; padding: 50px; color: #999;">
                        위시리스트가 비어있습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>