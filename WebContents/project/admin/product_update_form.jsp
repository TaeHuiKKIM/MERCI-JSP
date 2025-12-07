<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Check
    if (userId == null || !"admin".equals(userId)) {
        out.println("<script>alert('관리자 권한이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }
    String root = request.getContextPath() + "/project";

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
<link rel="stylesheet" href="<%=root%>/style.css">
<style>
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
    .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        font-size: 13px;
    }
    .form-group textarea {
        height: 150px;
        resize: vertical;
    }
    .current-img-box {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-bottom: 10px;
        background: #f9f9f9;
        padding: 10px;
    }
    .current-img-box img {
        width: 60px;
        height: 80px;
        object-fit: cover;
        border: 1px solid #ddd;
    }
    .current-img-info {
        font-size: 12px;
        color: #666;
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
    .radio-group label {
        display: inline-block;
        margin-right: 15px;
        font-weight: normal;
        cursor: pointer;
    }
</style>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <div class="update-container">
        <h2>상품 정보 수정</h2>
        <form action="product_update_proc.jsp" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%=cloth.getId()%>">
            
            <!-- 기존 이미지 파일명 보존 (변경 안할 시 사용) -->
            <input type="hidden" name="oldImgBody" value="<%=cloth.getImgBody()%>">
            <input type="hidden" name="oldImgFront" value="<%=cloth.getImgFront()%>">
            <input type="hidden" name="oldImgBack" value="<%=cloth.getImgBack()%>">
            <input type="hidden" name="oldImgDetail" value="<%=cloth.getImgDetail()%>">
            
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
                <label>재고 (Stock)</label>
                <input type="number" name="stock" value="<%=cloth.getStock()%>" required>
            </div>
            
            <div class="form-group">
                <label>사이즈 (Sizes)</label>
                <input type="text" name="sizes" value="<%=cloth.getSizes()%>">
            </div>

            <div class="form-group">
                <label>색상 (Colors)</label>
                <input type="text" name="colors" value="<%=cloth.getColors()%>">
            </div>
            
            <div class="form-group">
                <label>카테고리 (Type)</label>
                <div class="radio-group" style="margin-top: 5px;">
                    <label><input type="radio" name="clothType" value="Outer" <%= "Outer".equalsIgnoreCase(cloth.getClothType()) ? "checked" : "" %>> Outer</label>
                    <label><input type="radio" name="clothType" value="Top" <%= "Top".equalsIgnoreCase(cloth.getClothType()) ? "checked" : "" %>> Top</label>
                    <label><input type="radio" name="clothType" value="Bottom" <%= "Bottom".equalsIgnoreCase(cloth.getClothType()) ? "checked" : "" %>> Bottom</label>
                    <label><input type="radio" name="clothType" value="Acc" <%= "Acc".equalsIgnoreCase(cloth.getClothType()) ? "checked" : "" %>> Acc</label>
                </div>
            </div>

            <div class="form-group">
                <label>상품 설명 (Description)</label>
                <textarea name="description"><%=cloth.getDescription() != null ? cloth.getDescription() : ""%></textarea>
            </div>
            
            <!-- Image Update -->
            <div class="form-group">
                <label>전신 사진 (Main Body)</label>
                <div class="current-img-box">
                    <img src="../uploadfile/<%=cloth.getImgBody()%>" alt="Current">
                    <span class="current-img-info">현재: <%=cloth.getImgBody()%></span>
                </div>
                <input type="file" name="imgBody" accept="image/*">
            </div>

            <div class="form-group">
                <label>정면 사진 (Front)</label>
                <div class="current-img-box">
                    <img src="../uploadfile/<%=cloth.getImgFront()%>" alt="Current">
                    <span class="current-img-info">현재: <%=cloth.getImgFront()%></span>
                </div>
                <input type="file" name="imgFront" accept="image/*">
            </div>

            <div class="form-group">
                <label>뒷면 사진 (Back)</label>
                <div class="current-img-box">
                    <img src="../uploadfile/<%=cloth.getImgBack()%>" alt="Current">
                    <span class="current-img-info">현재: <%=cloth.getImgBack()%></span>
                </div>
                <input type="file" name="imgBack" accept="image/*">
            </div>

            <div class="form-group">
                <label>디테일 사진 (Detail)</label>
                <div class="current-img-box">
                    <img src="../uploadfile/<%=cloth.getImgDetail()%>" alt="Current">
                    <span class="current-img-info">현재: <%=cloth.getImgDetail()%></span>
                </div>
                <input type="file" name="imgDetail" accept="image/*">
            </div>
            
            <button type="submit" class="btn-submit">수정 완료</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        </form>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>