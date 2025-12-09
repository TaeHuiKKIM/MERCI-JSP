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
<title>소개글 관리 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
</head>
<body class="admin-body">

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <div class="admin-container">
        <div class="admin-page-title">
            <span>소개 페이지 관리</span>
        </div>

        <div class="admin-card">
            <h3>현재 소개 이미지</h3>
            <p style="margin-bottom: 20px; color: #666; font-size: 13px;">이 이미지는 사용자 소개 페이지에 표시됩니다.</p>
            
            <div style="border: 1px solid #ddd; padding: 10px; display: inline-block; margin-bottom: 30px;">
                <img src="<%=root%>/images/about_custom.png?t=<%=new java.util.Date().getTime()%>" 
                     style="max-width: 100%; height: auto; display: block; max-height: 400px;" 
                     alt="Current About Image">
            </div>

            <form action="upload_about_image.jsp" method="post" enctype="multipart/form-data">
                <div class="admin-form-group">
                    <label class="admin-label">새 이미지 업로드 (PNG만 가능)</label>
                    <input type="file" name="aboutImage" accept="image/png" class="admin-input" required>
                </div>
                
                <button type="submit" class="btn-admin btn-admin-primary">이미지 업데이트</button>
            </form>
        </div>
        
        <div class="admin-card">
            <h3>소개글 수정</h3>
            <p style="color: #666; font-size: 14px; margin-bottom: 15px;">
                소개 페이지에 표시될 텍스트를 수정하세요.
            </p>
            
            <%
                String aboutText = "";
                Connection conn = null;
                try {
                    conn = ConnectionProvider.getConnection();
                    SiteSettingsDao settingsDao = new SiteSettingsDao();
                    aboutText = settingsDao.getSetting(conn, "about_text");
                    if (aboutText == null) aboutText = "";
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    JdbcUtil.close(conn);
                }
            %>
            
            <form action="update_about_text_proc.jsp" method="post">
                <textarea name="aboutText" style="width: 100%; height: 200px; padding: 10px; border: 1px solid #ddd; margin-bottom: 15px;"><%=aboutText%></textarea>
                <button type="submit" class="btn-admin btn-admin-primary">텍스트 업데이트</button>
            </form>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>