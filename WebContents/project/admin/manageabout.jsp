<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Check
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MANAGE ABOUT - MERCI ADMIN</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
</head>
<body class="admin-body">

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <div class="admin-container">
        <div class="admin-page-title">
            <span>MANAGE ABOUT PAGE</span>
        </div>

        <div class="admin-card">
            <h3>Current About Image</h3>
            <p style="margin-bottom: 20px; color: #666; font-size: 13px;">This image is displayed on the user-facing About page.</p>
            
            <div style="border: 1px solid #ddd; padding: 10px; display: inline-block; margin-bottom: 30px;">
                <img src="<%=root%>/images/about_custom.png?t=<%=new java.util.Date().getTime()%>" 
                     style="max-width: 100%; height: auto; display: block; max-height: 400px;" 
                     alt="Current About Image">
            </div>

            <form action="upload_about_image.jsp" method="post" enctype="multipart/form-data">
                <div class="admin-form-group">
                    <label class="admin-label">Upload New Image (PNG only)</label>
                    <input type="file" name="aboutImage" accept="image/png" class="admin-input" required>
                </div>
                
                <button type="submit" class="btn-admin btn-admin-primary">UPDATE IMAGE</button>
            </form>
        </div>
        
        <div class="admin-card">
            <h3>About Page Preview Text</h3>
            <p style="color: #666; font-size: 14px; line-height: 1.6;">
                MERCI BRINGS SUBURBAN VITALITY INTO THE CITY, OFFERING WOMEN AN ACTIVE LIFESTYLE AND FASHION THAT FUSE EVERYDAY URBAN LIFE WITH EXTRAORDINARY ENERGY.<br><br>
                MERCI는 도시에 사는 여성들에게 교외적인 생동감을 불어넣을 수 있는 새로운 라이프스타일과 패션을 제안합니다. 자연과 도시가 만나는 순간을 담아내며, 일상 속에서 편안하게 입을 수 있는 실루엣과 활동적인 에너지를 동시에 전달합니다.
            </p>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>