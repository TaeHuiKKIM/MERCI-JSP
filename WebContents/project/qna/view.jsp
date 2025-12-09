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
<link rel="stylesheet" href="../style.css">
<style>
    .qna-container { max-width: 800px; margin: 80px auto; padding: 20px; min-height: 500px; }
    .qna-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    
    .view-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    .view-table th, .view-table td { padding: 15px; border-bottom: 1px solid #eee; }
    .view-table th { width: 120px; text-align: left; background: #f9f9f9; color: #555; }
    .view-content { min-height: 200px; padding: 20px 10px; line-height: 1.6; }
    
    .answer-box { background: #f5f5f5; padding: 20px; border: 1px solid #ddd; margin-top: 30px; }
    .answer-header { font-weight: bold; margin-bottom: 10px; color: #333; }
    .answer-text { line-height: 1.6; color: #444; }
    
    .btn-group { margin-top: 30px; text-align: center; }
    .btn-list { background: #333; color: #fff; padding: 12px 30px; text-decoration: none; font-size: 14px; }
</style>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="qna-container">
        <div class="qna-title">Q&A DETAIL</div>
        
        <table class="view-table">
            <tr>
                <th>Subject</th>
                <td colspan="3"><%=qna.getSubject()%></td>
            </tr>
            <tr>
                <th>Writer</th>
                <td><%=qna.getUserId()%></td>
                <th>Date</th>
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
                <div class="answer-header">[ADMIN ANSWER]</div>
                <div class="answer-text"><%=qna.getAnswer().replace("\n", "<br>")%></div>
            </div>
        <% } %>
        
        <div class="btn-group">
            <a href="list.jsp" class="btn-list">LIST</a>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>
