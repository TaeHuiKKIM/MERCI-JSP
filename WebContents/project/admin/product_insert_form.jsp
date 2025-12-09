<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Check
    if (userId == null || !"admin".equals(userId)) {
        out.println("<script>alert('관리자 권한이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 등록 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
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
    .form-group input[type="file"] {
        margin-top: 5px;
        font-size: 12px;
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
        <h2>새 상품 등록</h2>
        <form action="product_insert_proc.jsp" method="post" enctype="multipart/form-data">
            
            <div class="form-group">
                <label>상품명 (Title)</label>
                <input type="text" name="title" required>
            </div>
            
            <div class="form-group">
                <label>제작사 (Maker)</label>
                <input type="text" name="maker" required>
            </div>
            
            <div class="form-group">
                <label>가격 (Price)</label>
                <input type="number" name="price" required>
            </div>

            <div class="form-group">
                <label>재고 (Stock)</label>
                <input type="number" name="stock" value="0" required>
            </div>
            
            <div class="form-group">
                <label>사이즈 (Sizes - 콤마로 구분, 예: S,M,L)</label>
                <input type="text" name="sizes" value="FREE">
            </div>

            <div class="form-group">
                <label>색상 (Colors - 콤마로 구분, 예: Black,White)</label>
                <input type="text" name="colors">
            </div>
            
            <div class="form-group">
                <label>카테고리 (Type)</label>
                <div class="radio-group" style="margin-top: 5px;">
                    <label><input type="radio" name="clothType" value="Outer" required> Outer</label>
                    <label><input type="radio" name="clothType" value="Top"> Top</label>
                    <label><input type="radio" name="clothType" value="Bottom"> Bottom</label>
                    <label><input type="radio" name="clothType" value="Acc"> Acc</label>
                </div>
            </div>
            
            <div class="form-group">
                <label>상품 설명 (Description)</label>
                <textarea name="description"></textarea>
            </div>
            
            <!-- Image Uploads -->
            <div class="form-group">
                <label>전신 사진 (Main Body) *필수</label>
                <input type="file" name="imgBody" accept="image/*" required>
            </div>
            <div class="form-group">
                <label>정면 사진 (Front) *필수</label>
                <input type="file" name="imgFront" accept="image/*" required>
            </div>
            <div class="form-group">
                <label>뒷면 사진 (Back)</label>
                <input type="file" name="imgBack" accept="image/*">
            </div>
            <div class="form-group">
                <label>디테일 사진 (Detail)</label>
                <input type="file" name="imgDetail" accept="image/*">
            </div>
            
            <button type="submit" class="btn-submit">등록 하기</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        </form>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>