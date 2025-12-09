<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    Connection conn = null;
    List<Qna> list = null;
    try {
        conn = ConnectionProvider.getConnection();
        QnaDao dao = new QnaDao();
        list = dao.selectList(conn, 0, 20); // Top 20 for simplicity
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(conn);
    }
    
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Q&A BOARD - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="../style.css">
<style>
    .qna-container { max-width: 1000px; margin: 80px auto; padding: 20px; min-height: 500px; }
    .qna-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 10px; }
    .qna-title { font-size: 24px; font-weight: bold; }
    .btn-write { background: #333; color: #fff; padding: 10px 20px; text-decoration: none; font-size: 14px; }
    
    .qna-list { width: 100%; border-collapse: collapse; }
    .qna-list th, .qna-list td { border-bottom: 1px solid #eee; padding: 15px 10px; font-size: 13px; text-align: center; }
    .qna-list th { background: #f9f9f9; font-weight: 600; }
    .qna-list td.subject { text-align: left; padding-left: 20px; }
    .qna-list a { color: #333; text-decoration: none; }
    .qna-list a:hover { text-decoration: underline; }
    
    .status-badge { display: inline-block; padding: 2px 6px; border-radius: 3px; font-size: 11px; color: #fff; margin-left: 5px;}
    .status-waiting { background: #ccc; }
    .status-completed { background: #333; }
</style>
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="qna-container">
        <div class="qna-header">
            <div class="qna-title">Q&A BOARD</div>
            <a href="write.jsp" class="btn-write">WRITE Q&A</a>
        </div>

        <table class="qna-list">
            <thead>
                <tr>
                    <th width="60">No</th>
                    <th width="100">Status</th>
                    <th>Subject</th>
                    <th width="100">Writer</th>
                    <th width="120">Date</th>
                </tr>
            </thead>
<%
    // Get current logged in user (for checking secret posts)
    String currentUserId = (String) session.getAttribute("userId");
    boolean isAdmin = (currentUserId != null && currentUserId.equals("admin"));
%>
            <tbody>
                <c:set var="list" value="<%=list%>" />
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="q" items="${list}">
                            <tr>
                                <td>${q.qnaId}</td>
                                <td>
                                    <span class="status-badge ${q.status == '답변완료' ? 'status-completed' : 'status-waiting'}">
                                        ${q.status}
                                    </span>
                                </td>
                                <td class="subject">
                                    <%
                                        my.model.Qna q = (my.model.Qna) pageContext.getAttribute("q");
                                        boolean isSecret = (q.getIsSecret() == 1);
                                        boolean canView = isAdmin || (currentUserId != null && currentUserId.equals(q.getUserId()));
                                        
                                        if (isSecret) {
                                            if (canView) {
                                    %>
                                                <a href="view.jsp?qnaId=${q.qnaId}">
                                                    🔒 ${q.subject}
                                                </a>
                                    <%
                                            } else {
                                    %>
                                                <span style="color: #999;">🔒 Secret Post</span>
                                    <%
                                            }
                                        } else {
                                    %>
                                            <a href="view.jsp?qnaId=${q.qnaId}">
                                                ${q.subject}
                                            </a>
                                    <%
                                        }
                                    %>
                                </td>
                                <td>${q.userId}</td>
                                <td><fmt:formatDate value="${q.regdate}" pattern="yyyy-MM-dd"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="5" style="padding: 50px; color: #999;">No posts found.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>