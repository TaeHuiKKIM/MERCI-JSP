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

        // Custom Message Modal Function
        function showMsg(message) {
            $('#msgPopupContent').text(message);
            $('#msgPopupBackdrop').addClass('show');
        }

        function closeMsg() {
            $('#msgPopupBackdrop').removeClass('show');
        }

        function loginCheck() {
            var f = document.loginForm;
            if(!f.userId.value) { showMsg("아이디를 입력하세요."); return; }
            if(!f.password.value) { showMsg("비밀번호를 입력하세요."); return; }
            f.submit();
        }

        function joinCheck() {
            var f = document.joinForm;
            if(!f.userId.value) { showMsg("아이디를 입력하세요."); return; }
            if(!f.name.value) { showMsg("이름을 입력하세요."); return; }
            if(!f.password.value) { showMsg("비밀번호를 입력하세요."); return; }
            if(f.password.value !== f.passwordConfirm.value) { showMsg("비밀번호가 일치하지 않습니다."); return; }
            f.submit();
        }
    </script>
    <style>
        /* Shared Message Popup Style */
        .msg-popup-backdrop {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 20000; /* Higher than login panel */
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease;
        }
        .msg-popup-backdrop.show {
            opacity: 1;
            visibility: visible;
        }
        .msg-popup {
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            width: 300px;
            transform: translateY(20px);
            opacity: 0;
            transition: transform 0.3s ease, opacity 0.3s ease;
        }
        .msg-popup-backdrop.show .msg-popup {
            transform: translateY(0);
            opacity: 1;
        }
        .msg-popup p {
            font-size: 14px;
            color: #333;
            margin-bottom: 25px;
            line-height: 1.5;
            word-break: keep-all;
        }
        .msg-popup button {
            padding: 10px 25px;
            background: #000;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }
        .msg-popup button:hover {
            background: #333;
        }
    </style>
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
                boolean isQna = currentUri.contains("qna/list.jsp") || currentUri.contains("qna/view.jsp") || currentUri.contains("qna/write.jsp");
            %>
            <a href="<%=root%>/index.jsp" class="<%= isHome ? "active" : "" %>">HOME</a>
            <a href="<%=root%>/about.jsp" class="<%= isAbout ? "active" : "" %>">ABOUT</a>
            <a href="<%=root%>/product.jsp" class="<%= isProduct ? "active" : "" %>">PRODUCT</a>
            <a href="<%=root%>/qna/list.jsp" class="<%= isQna ? "active" : "" %>">Q&A</a>
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
            <div style="cursor: pointer; text-align: center; background-color: #fee500; margin-top: 10px; height: 45px; line-height: 45px; border-radius: 4px;" onclick="loginWithKakao()">
                <img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" width="150px" alt="카카오 로그인 버튼" style="vertical-align: middle;">
            </div>

            <a href="<%=root%>/user/find_account.jsp" style="font-size: 12px; color: #555; text-decoration: underline; margin-top: 10px; display: block; text-align: center;">
                비밀번호 찾기
            </a>
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
            
            <!-- Password Recovery Info -->
            <select name="findQ" class="login-input" style="height: 45px;">
                <option value="">비밀번호 찾기 질문 선택</option>
                <option value="기억에 남는 추억의 장소는?">기억에 남는 추억의 장소는?</option>
                <option value="자신의 보물 제1호는?">자신의 보물 제1호는?</option>
                <option value="가장 기억에 남는 선생님 성함은?">가장 기억에 남는 선생님 성함은?</option>
                <option value="내가 좋아하는 캐릭터는?">내가 좋아하는 캐릭터는?</option>
                <option value="다시 태어나면 되고 싶은 것은?">다시 태어나면 되고 싶은 것은?</option>
            </select>
            <input type="text" name="findA" class="login-input" placeholder="답변 입력">
            
            <input type="button" value="CREATE ACCOUNT" class="login-btn gray" onclick="joinCheck()">
            <input type="button" value="BACK TO LOGIN" class="login-btn gray" style="margin-top: 10px; background-color: black; color: white;" onclick="showLoginMode()">
        </form>
    </div>
</div>

<!-- Message Popup HTML -->
<div class="msg-popup-backdrop" id="msgPopupBackdrop">
    <div class="msg-popup">
        <p id="msgPopupContent">Message goes here</p>
        <button onclick="closeMsg()">확인</button>
    </div>
</div>