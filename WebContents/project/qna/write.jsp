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
<title>문의 작성 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/project/style.css">
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="qna-container">
        <div class="qna-title">문의 작성</div>
        
        <form action="write_proc.jsp" method="post" class="write-form">
            <table>
                <tr>
                    <th>제목</th>
                    <td>
                        <input type="text" name="subject" required placeholder="제목을 입력하세요">
                        <div style="margin-top: 5px;">
                            <input type="checkbox" name="isSecret" value="1" id="secretCheck"> 
                            <label for="secretCheck" style="font-size: 13px; color: #555;">비밀글</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td><textarea name="content" required placeholder="내용을 입력하세요"></textarea></td>
                </tr>
            </table>
            
            <div class="btn-group">
                <button type="submit" class="btn-submit">등록</button>
                <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>