<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // [1] 세션 체크
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>PRODUCT REGISTRATION - MERCI</title>
<link rel="stylesheet" href="../style.css">
<style>
    /* product_update_form.jsp와 동일한 스타일 */
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
        <h2>새 상품 등록</h2>
        <form action="product_insert_proc.jsp" method="post" enctype="multipart/form-data">
            
            <div class="form-group">
                <label>상품명 (Title)</label>
                <input type="text" name="title" required placeholder="상품명을 입력하세요">
            </div>
            
            <div class="form-group">
                <label>제작사 (Maker)</label>
                <input type="text" name="maker" required placeholder="제작사를 입력하세요">
            </div>
            
            <div class="form-group">
                <label>가격 (Price)</label>
                <input type="number" name="price" required placeholder="가격을 입력하세요">
            </div>
            
            <div class="form-group">
                <label>카테고리 (Type)</label>
                <input type="text" name="clothType" required placeholder="예: outer, top, pants...">
            </div>
            
            <div class="form-group">
                <label>상품 이미지 (필수)</label>
                <input type="file" name="poster" accept="image/*" required>
            </div>
            
            <button type="submit" class="btn-submit">등록 하기</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        </form>
    </div>

</body>
</html>