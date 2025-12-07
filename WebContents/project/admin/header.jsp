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
    /* Admin Header Specific Overrides */
    .header.admin-header {
        background: #1a1a1a;
        border-bottom: 1px solid #333;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
    }
    .header.admin-header .header-logo a {
        color: #fff;
        font-weight: 800;
        font-size: 20px;
        text-decoration: none;
        letter-spacing: 2px;
    }
    .header.admin-header .header-nav a {
        color: #ccc;
        font-size: 13px;
        font-weight: 500;
        text-decoration: none;
        transition: color 0.2s;
    }
    .header.admin-header .header-nav a:hover,
    .header.admin-header .header-nav a.active {
        color: #fff;
    }
    /* Add padding to body to prevent content hiding behind fixed header */
    body { padding-top: 70px; }
</style>

<header class="header admin-header">
    <div class="header-inner">
        <div class="header-logo">
            <a href="index.jsp">MERCI ADMIN</a>
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