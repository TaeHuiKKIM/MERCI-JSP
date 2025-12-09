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
            <h3>Edit About Page Text</h3>
            <p style="color: #666; font-size: 14px; margin-bottom: 15px;">
                Update the text displayed on the About page.
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
                <button type="submit" class="btn-admin btn-admin-primary">UPDATE TEXT</button>
            </form>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>