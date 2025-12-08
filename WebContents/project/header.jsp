<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("userName");
    boolean isLogin = (userName != null);
    // 프로젝트의 웹 루트 경로 (예: /ShoppingAddict/project)
    String root = request.getContextPath() + "/project";
%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.0/kakao.min.js" integrity="sha384-l+xbElFSnPZ2rOaPrU//2FF5B4LB8FiX5q4fXYTlfcG4PGpMkE1vcL7kNXI6Cci0" crossorigin="anonymous"></script>
    <script>
        // [필수] 카카오 디벨로퍼스에서 발급받은 JavaScript 키를 입력하세요.
        // 예: Kakao.init('a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6');
        try {
            if (!Kakao.isInitialized()) {
                Kakao.init('8c1c432cd0b5cfcdbf5606741211ecd8'); 
            }
        } catch(e) { console.log(e); }

        function loginWithKakao() {
            Kakao.Auth.authorize({
                // 로그인 후 돌아올 콜백 페이지 경로 (동적 Context Path 적용)
                redirectUri: window.location.origin + '<%=request.getContextPath()%>/project/kakao_login_proc.jsp'
            });
        }
    </script>
    <script>
        $(document).ready(function() {
            // Login Panel Toggle
            $('#loginMenu').click(function(e) {
                e.preventDefault();
                $('#loginPanel').addClass('active');
            });
            $('.login-close').click(function() {
                $('#loginPanel').removeClass('active');
            });
        });

        function showJoinMode() {
            $('#loginView').hide();
            $('#joinView').show();
        }

        function showLoginMode() {
            $('#joinView').hide();
            $('#loginView').show();
        }

        function loginCheck() {
            var f = document.loginForm;
            if(!f.userId.value) { alert("아이디를 입력하세요."); f.userId.focus(); return; }
            if(!f.password.value) { alert("비밀번호를 입력하세요."); f.password.focus(); return; }
            f.submit();
        }

        function joinCheck() {
            var f = document.joinForm;
            if(!f.userId.value) { alert("아이디를 입력하세요."); f.userId.focus(); return; }
            if(!f.name.value) { alert("이름을 입력하세요."); f.name.focus(); return; }
            if(!f.password.value) { alert("비밀번호를 입력하세요."); f.password.focus(); return; }
            if(f.password.value !== f.passwordConfirm.value) { alert("비밀번호가 일치하지 않습니다."); return; }
            f.submit();
        }
    </script>
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
            
            <!-- KAKAO LOGIN BUTTON -->
            <div style="margin-top: 10px; cursor: pointer; text-align: center; background-color: #fee500;" onclick="loginWithKakao()">
                <img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" width="150px" alt="카카오 로그인 버튼" style="border-radius: 4px;">
            </div>
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