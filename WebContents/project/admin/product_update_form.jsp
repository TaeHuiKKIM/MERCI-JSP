<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // [1] 세션 체크
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }

    // [2] 파라미터 수신 및 데이터 조회
    int id = Integer.parseInt(request.getParameter("clothId"));
    Cloth cloth = null;
    Connection conn = ConnectionProvider.getConnection();
    try {
        ClothDao dao = new ClothDao();
        cloth = dao.selectById(conn, id);
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(conn);
    }
    
    if(cloth == null) {
         out.println("<script>alert('존재하지 않는 상품입니다.'); history.back();</script>");
         return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>PRODUCT UPDATE - MERCI</title>
<link rel="stylesheet" href="../style.css">
<style>
    /* 간단한 폼 스타일 (기존 admin 스타일과 통일감 유지) */
    .update-container {
        max-width: 800px;
        margin: 120px auto;
        padding: 40px;
        background: #fff;
        border: 1px solid #eee;
    }
    .update-container h2 {
        text-align: center;
        margin-bottom: 30px;
        font-size: 22px;
        font-weight: 700;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        font-size: 13px;
    }
    .form-group input[type="text"],
    .form-group input[type="number"], 
    .form-group select {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        font-size: 13px;
    }
    .current-img {
        margin: 10px 0;
        max-width: 150px;
        border: 1px solid #ccc;
        display: block;
    }
    .btn-submit {
        width: 100%;
        padding: 14px;
        background: #111;
        color: #fff;
        border: none;
        font-weight: 600;
        cursor: pointer;
        margin-top: 20px;
    }
    .btn-cancel {
        width: 100%;
        padding: 14px;
        background: #eee;
        color: #333;
        border: none;
        font-weight: 600;
        cursor: pointer;
        margin-top: 10px;
    }
</style>
</head>
<body>

    <!-- HEADER -->
    <header class="header">
        <div class="header-inner">
            <div class="header-logo">
                <a href="index.jsp"><img src="../images/mainlogo.png" alt="logo"></a>
            </div>
            <nav class="header-nav">
                <a href="index.jsp">HOME</a>
                <a href="manageabout.jsp">MANAGE ABOUT</a>
                <a href="manageproduct.jsp">MANAGE PRODUCT</a>
                <a href="manageorder.jsp">MANAGE ORDER</a>
                <a href="../user/logout_proc.jsp">LOGOUT</a>
            </nav>
        </div>
    </header>

    <div class="update-container">
        <h2>상품 정보 수정</h2>
        <form action="product_update_proc.jsp" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%=cloth.getId()%>">
            <input type="hidden" name="existingPoster" value="<%=cloth.getPoster()%>">
            
            <div class="form-group">
                <label>상품명 (Title)</label>
                <input type="text" name="title" value="<%=cloth.getTitle()%>" required>
            </div>
            
            <div class="form-group">
                <label>제작사 (Maker)</label>
                <input type="text" name="maker" value="<%=cloth.getMaker()%>" required>
            </div>
            
            <div class="form-group">
                <label>가격 (Price)</label>
                <input type="number" name="price" value="<%=cloth.getPrice()%>" required>
            </div>
            
            <div class="form-group">
                <label>카테고리 (Type)</label>
                <!-- 예시 카테고리, 실제 DB에 맞게 수정 가능 -->
                <input type="text" name="clothType" value="<%=cloth.getClothType()%>" required>
            </div>
            
            <div class="form-group">
                <label>상품 이미지</label>
                <% if(cloth.getPoster() != null && !cloth.getPoster().isEmpty()) { %>
                    <img src="../uploadfile/<%=cloth.getPoster()%>" class="current-img" alt="현재 이미지">
                    <p style="font-size: 12px; color: #888;">현재 파일: <%=cloth.getPoster()%></p>
                <% } %>
                <input type="file" name="newPoster" accept="image/*">
                <p style="font-size: 11px; color: #aaa; margin-top: 5px;">이미지를 변경하지 않으려면 비워두세요.</p>
            </div>
            
            <button type="submit" class="btn-submit">수정 완료</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        </form>
    </div>

</body>
</html>