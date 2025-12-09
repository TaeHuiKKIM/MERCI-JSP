<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String qnaIdStr = request.getParameter("qnaId");
    if (qnaIdStr == null) {
        response.sendRedirect("list.jsp");
        return;
    }
    
    int qnaId = Integer.parseInt(qnaIdStr);
    Qna qna = null;
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        QnaDao dao = new QnaDao();
        qna = dao.selectById(conn, qnaId);
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(conn);
    }
    
    if (qna == null) {
        out.println("<script>alert('Deleted or non-existent post.'); location.href='list.jsp';</script>");
        return;
    }
    
    // Check for Secret Post permission
    String currentUserId = (String) session.getAttribute("userId");
    boolean isAdmin = (currentUserId != null && currentUserId.equals("admin"));
    boolean isOwner = (currentUserId != null && currentUserId.equals(qna.getUserId()));
    
    if (qna.getIsSecret() == 1 && !isAdmin && !isOwner) {
        out.println("<script>alert('This is a secret post. You do not have permission to view it.'); location.href='list.jsp';</script>");
        return;
    }
    
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>VIEW Q&A - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/project/style.css">
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="qna-container">
        <div class="qna-title">문의 상세</div>
        
        <table class="view-table">
            <tr>
                <th>제목</th>
                <td colspan="3"><%=qna.getSubject()%></td>
            </tr>
            <tr>
                <th>작성자</th>
                <td><%=qna.getUserName()%></td>
                <th>작성일</th>
                <td><fmt:formatDate value="<%=qna.getRegdate()%>" pattern="yyyy-MM-dd HH:mm"/></td>
            </tr>
            <tr>
                <td colspan="4" class="view-content">
                    <%=qna.getContent().replace("\n", "<br>")%>
                </td>
            </tr>
        </table>
        
        <% if (qna.getAnswer() != null) { %>
            <div class="answer-box">
                <div class="answer-header">[관리자 답변]</div>
                <div class="answer-text"><%=qna.getAnswer().replace("\n", "<br>")%></div>
            </div>
        <% } %>
        
        <div class="btn-group">
            <a href="list.jsp" class="btn-list">목록</a>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>
