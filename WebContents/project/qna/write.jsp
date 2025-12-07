<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp?login=open';</script>");
        return;
    }
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>WRITE Q&A - MERCI</title>
<link rel="stylesheet" href="../style.css">
<style>
    .qna-container { max-width: 800px; margin: 80px auto; padding: 20px; min-height: 500px; }
    .qna-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    
    .write-form table { width: 100%; border-collapse: collapse; }
    .write-form th, .write-form td { padding: 15px; border-bottom: 1px solid #eee; }
    .write-form th { width: 120px; text-align: left; background: #f9f9f9; font-weight: 600; }
    .write-form input[type="text"], .write-form textarea { width: 100%; border: 1px solid #ddd; padding: 10px; font-size: 13px; }
    .write-form textarea { height: 300px; resize: vertical; }
    
    .btn-group { margin-top: 30px; text-align: center; }
    .btn-submit { background: #333; color: #fff; padding: 12px 30px; border: none; font-size: 14px; cursor: pointer; }
    .btn-cancel { background: #fff; color: #333; border: 1px solid #ddd; padding: 12px 30px; font-size: 14px; cursor: pointer; margin-left: 10px; }
</style>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="qna-container">
        <div class="qna-title">WRITE Q&A</div>
        
        <form action="write_proc.jsp" method="post" class="write-form">
            <table>
                <tr>
                    <th>Subject</th>
                    <td><input type="text" name="subject" required placeholder="제목을 입력하세요"></td>
                </tr>
                <tr>
                    <th>Content</th>
                    <td><textarea name="content" required placeholder="내용을 입력하세요"></textarea></td>
                </tr>
            </table>
            
            <div class="btn-group">
                <button type="submit" class="btn-submit">SUBMIT</button>
                <button type="button" class="btn-cancel" onclick="history.back()">CANCEL</button>
            </div>
        </form>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>