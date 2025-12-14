<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="../style.css">
<style>
    .find-container { width: 500px; margin: 150px auto; padding: 40px; border: 1px solid #eee; background: #fff; }
    .find-title { font-size: 24px; font-weight: 400; text-align: center; margin-bottom: 40px; }
    
    .input-group { margin-bottom: 20px; }
    .input-group label { display: block; margin-bottom: 8px; font-size: 13px; color: #555; }
    .input-group input, .input-group select { width: 100%; padding: 12px; border: 1px solid #ddd; font-size: 13px; }
    
    .find-btn { width: 100%; padding: 14px; background: #111; color: #fff; border: none; font-size: 14px; cursor: pointer; margin-top: 10px; }
    .find-btn:hover { background: #333; }
    
    .home-btn { display: block; text-align: center; margin-top: 20px; font-size: 12px; text-decoration: underline; color: #666; }
    .info-text { font-size: 13px; color: #666; margin-bottom: 30px; text-align: center; line-height: 1.5; }
</style>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="find-container">
        <h2 class="find-title">비밀번호 찾기</h2>
        
        <p class="info-text">
            가입 시 등록한 질문과 답변을 입력해 주세요.<br>
            일치하면 즉시 비밀번호를 재설정할 수 있습니다.
        </p>
        
        <form action="find_proc.jsp" method="post">
            <input type="hidden" name="mode" value="checkRecovery">
            
            <div class="input-group">
                <label>아이디</label>
                <input type="text" name="userId" required placeholder="아이디를 입력하세요">
            </div>
            
            <div class="input-group">
                <label>비밀번호 찾기 질문</label>
                <select name="findQ" required>
                    <option value="">질문을 선택하세요</option>
                    <option value="기억에 남는 추억의 장소는?">기억에 남는 추억의 장소는?</option>
                    <option value="자신의 보물 제1호는?">자신의 보물 제1호는?</option>
                    <option value="가장 기억에 남는 선생님 성함은?">가장 기억에 남는 선생님 성함은?</option>
                    <option value="내가 좋아하는 캐릭터는?">내가 좋아하는 캐릭터는?</option>
                    <option value="다시 태어나면 되고 싶은 것은?">다시 태어나면 되고 싶은 것은?</option>
                </select>
            </div>
            
            <div class="input-group">
                <label>답변</label>
                <input type="text" name="findA" required placeholder="답변을 입력하세요">
            </div>
            
            <button type="submit" class="find-btn">확인</button>
        </form>
        
        <a href="../index.jsp" class="home-btn">메인으로 돌아가기</a>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>