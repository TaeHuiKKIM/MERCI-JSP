<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Access Control
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    String root = request.getContextPath() + "/project";
%>
<style>
    /* Admin Header Specific Overrides - Light Theme */
    .header.admin-header {
        background: #fff;
        border-bottom: 1px solid #eee;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
        height: 70px;
    }
    .header.admin-header .header-inner {
        max-width: 1400px;
        min-width: 600px;
        margin: 0 auto;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 40px;
    }
    .header.admin-header .header-logo a {
        color: #111;
        font-weight: 800;
        font-size: 20px;
        text-decoration: none;
        letter-spacing: 2px;
    }
    .header.admin-header .header-nav a {
        color: #888;
        font-size: 13px;
        font-weight: 500;
        text-decoration: none;
        transition: color 0.2s;
        margin-left: 20px;
    }
    .header.admin-header .header-nav a:hover,
    .header.admin-header .header-nav a.active {
        color: #111;
        font-weight: 700;
    }
    /* Add padding to body to prevent content hiding behind fixed header */
    body { padding-top: 70px; }
</style>

<header class="header admin-header">
    <div class="header-inner">
        <div class="header-logo">
            <a href="index.jsp">
                <img src="<%=root%>/images/mainlogo.png" alt="MERCI" style="height: 25px; vertical-align: middle; margin-right: 5px;">
                <span style="font-size: 20px; font-weight: 300; vertical-align: middle;">ADMIN</span>
            </a>
        </div>

        <nav class="header-nav">
            <a href="index.jsp">DASHBOARD</a>
            <a href="manageabout.jsp">ABOUT</a>
            <a href="manageproduct.jsp">PRODUCT</a>
            <a href="manageorder.jsp">ORDER</a>
            <a href="manageqna.jsp">Q&A</a>
            <a href="<%=root%>/index.jsp" style="color: #666; margin-left: 20px;">[SHOP VIEW]</a>
            <a href="<%=root%>/user/logout_proc.jsp" style="color: #e74c3c;">LOGOUT</a>
        </nav>
    </div>
</header>