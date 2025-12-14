<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.util.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String mode = request.getParameter("mode");
    
    Connection conn = null;
    UserDao dao = new UserDao();
    
    try {
        conn = ConnectionProvider.getConnection();
        
        if ("checkRecovery".equals(mode)) {
            // [1단계] 아이디 + 질문 + 답변 검증
            String userId = request.getParameter("userId");
            String findQ = request.getParameter("findQ");
            String findA = request.getParameter("findA");
            
            boolean isValid = dao.verifyUserForRecovery(conn, userId, findQ, findA);
            
            if (isValid) {
                // 검증 성공 -> 비밀번호 재설정 폼으로 이동
                request.setAttribute("targetUserId", userId);
                request.setAttribute("resultMode", "pwResetForm");
            } else {
                // 검증 실패
                request.setAttribute("resultMode", "recoveryFail");
            }
            
        } else if ("resetPw".equals(mode)) {
            // [2단계] 비밀번호 변경 실행
            String userId = request.getParameter("userId");
            String newPw = request.getParameter("newPw");
            
            int result = dao.updatePassword(conn, userId, newPw);
            if (result > 0) {
                out.println("<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body>");
                out.println("<script>alert('비밀번호가 성공적으로 변경되었습니다.\\n로그인 해주세요.'); location.href='../index.jsp?login=open';</script>");
                out.println("</body></html>");
                return;
            } else {
                out.println("<script>alert('비밀번호 변경 실패.'); history.back();</script>");
                return;
            }
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류 발생: " + e.getMessage() + "'); history.back();</script>");
        return;
    } finally {
        JdbcUtil.close(conn);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 재설정 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="../style.css">
<style>
    .find-container { width: 500px; margin: 150px auto; padding: 40px; border: 1px solid #eee; background: #fff; text-align: center; }
    .find-title { font-size: 24px; font-weight: 400; margin-bottom: 30px; }
    .msg-box { padding: 20px; background: #f9f9f9; margin-bottom: 20px; font-size: 14px; line-height: 1.6; color: #333; }
    .btn { display: inline-block; padding: 12px 25px; background: #111; color: #fff; text-decoration: none; font-size: 13px; border: none; cursor: pointer; }
    .input-group { margin-bottom: 15px; text-align: left; }
    .input-group label { display: block; font-size: 12px; margin-bottom: 5px; color: #555; }
    .input-group input { width: 100%; padding: 10px; border: 1px solid #ddd; }
</style>
<script>
    function validateReset() {
        var p1 = document.resetForm.newPw.value;
        var p2 = document.resetForm.confirmPw.value;
        var pwPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,}$/;
        
        if(!pwPattern.test(p1)) {
            alert("비밀번호는 8자리 이상이어야 하며, 영문/숫자/특수문자를 포함해야 합니다.");
            return false;
        }
        if(p1 !== p2) {
            alert("비밀번호가 일치하지 않습니다.");
            return false;
        }
        return true;
    }
</script>
</head>
<body>
    
    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="find-container">
        <% 
            String resultMode = (String) request.getAttribute("resultMode");
            String targetId = (String) request.getAttribute("targetUserId");
            
            if ("pwResetForm".equals(resultMode)) {
        %>
            <h2 class="find-title">비밀번호 재설정</h2>
            <p style="font-size: 13px; color: #666; margin-bottom: 20px;">
                본인 확인이 완료되었습니다.<br>새로운 비밀번호를 설정해 주세요.
            </p>
            
            <form name="resetForm" action="find_proc.jsp" method="post" onsubmit="return validateReset()">
                <input type="hidden" name="mode" value="resetPw">
                <input type="hidden" name="userId" value="<%=targetId%>">
                
                <div class="input-group">
                    <label>새 비밀번호</label>
                    <input type="password" name="newPw" required placeholder="영문/숫자/특수문자 포함 8자 이상">
                </div>
                <div class="input-group">
                    <label>비밀번호 확인</label>
                    <input type="password" name="confirmPw" required placeholder="비밀번호 재입력">
                </div>
                
                <button type="submit" class="btn" style="width: 100%;">비밀번호 변경</button>
            </form>
            
        <% } else if ("recoveryFail".equals(resultMode)) { %>
            <h2 class="find-title">본인 확인 실패</h2>
            <div class="msg-box">
                입력하신 정보(아이디, 질문, 답변)가 일치하지 않습니다.<br>
                다시 확인해 주세요.
            </div>
            <a href="find_account.jsp" class="btn" style="background: #999;">다시 시도</a>
        <% } %>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>