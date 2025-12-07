<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("userName");
    boolean isLogin = (userName != null);
    // 프로젝트의 웹 루트 경로 (예: /ShoppingAddict/project)
    String root = request.getContextPath() + "/project";
%>
<header class="header">
    <div class="header-inner">
        <div class="header-logo">
            <a href="<%=root%>/index.jsp"><img src="<%=root%>/images/mainlogo.png" alt="logo"></a>
        </div>

        <nav class="header-nav">
            <%
                String currentUri = request.getRequestURI();
                boolean isHome = currentUri.endsWith("index.jsp") || currentUri.endsWith("/");
                boolean isAbout = currentUri.endsWith("about.jsp");
                boolean isProduct = currentUri.contains("product.jsp") || currentUri.contains("catalogdetail.jsp");
            %>
            <a href="<%=root%>/index.jsp" class="<%= isHome ? "active" : "" %>">HOME</a>
            <a href="<%=root%>/about.jsp" class="<%= isAbout ? "active" : "" %>">ABOUT</a>
            <a href="<%=root%>/product.jsp" class="<%= isProduct ? "active" : "" %>">PRODUCT</a>
            <% if (isLogin && "admin".equals(userName)) { %>
                <a href="<%=root%>/admin/index.jsp" style="color: red; font-weight: bold;">ADMIN</a>
            <% } %>
            
            <% if (isLogin) { %>
                <a href="<%=root%>/user/account.jsp">MY PAGE</a>
                <a href="<%=root%>/user/logout_proc.jsp">LOGOUT</a>
            <% } else { %>
                <a href="#" id="loginMenu">LOGIN</a>
            <% } %>
        </nav>
    </div>
</header>

<!-- LOGIN MODAL (Available on all pages) -->
<div class="login-panel" id="loginPanel">
    <div id="loginView">
        <div class="login-header">
            <h2>LOGIN</h2>
            <button class="login-close" id="loginCloseBtn">CLOSE</button>
        </div>
        <form action="<%=root%>/user/login_proc.jsp" method="post" name="loginForm" class="login-box">
            <input type="text" name="userId" placeholder="ID" class="login-input">
            <input type="password" name="password" placeholder="PASSWORD" class="login-input" onkeypress="if(event.keyCode==13) loginCheck();"> 
            <input type="button" value="LOGIN" class="login-btn black" onclick="loginCheck()">
            <input type="button" value="CREATE ACCOUNT" class="login-btn gray" onclick="showJoinMode()">
        </form>
    </div>

    <div id="joinView" style="display: none;">
        <div class="login-header">
            <h2>SIGN UP</h2>
            <button class="login-close" id="joinCloseBtn">CLOSE</button>
        </div>
        <form action="<%=root%>/user/join_proc.jsp" method="post" name="joinForm" class="login-box">
            <input type="text" name="userId" class="login-input" placeholder="ID (EMAIL)">
            <input type="text" name="name" class="login-input" placeholder="NAME">
            <input type="password" name="password" class="login-input" placeholder="PASSWORD">
            <input type="password" name="passwordConfirm" class="login-input" placeholder="CONFIRM PASSWORD">
            <input type="button" value="CREATE ACCOUNT" class="login-btn gray" onclick="joinCheck()">
            <input type="button" value="BACK TO LOGIN" class="login-btn gray" style="margin-top: 10px; background-color: black; color: white;" onclick="showLoginMode()">
        </form>
    </div>
</div>