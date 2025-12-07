<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Check
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    Connection conn = null;
    List<Qna> list = null;
    try {
        conn = ConnectionProvider.getConnection();
        QnaDao dao = new QnaDao();
        list = dao.selectList(conn, 0, 100); // 100 recent
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
<title>MANAGE Q&A - MERCI ADMIN</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
<style>
    .answer-row { background: #fcfcfc; text-align: left; display: none; }
    .answer-box { padding: 20px 30px; border-left: 3px solid #333; margin: 10px 0; background: #fff; }
</style>
<script>
    function toggleAnswer(rowId) {
        var row = document.getElementById(rowId);
        if(row.style.display === 'none' || row.style.display === '') {
            row.style.display = 'table-row';
        } else {
            row.style.display = 'none';
        }
    }
</script>
</head>
<body class="admin-body">

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <div class="admin-container">
        <div class="admin-page-title">
            <span>MANAGE Q&A</span>
        </div>

        <div class="admin-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="50">ID</th>
                        <th width="100">User</th>
                        <th>Subject</th>
                        <th width="100">Date</th>
                        <th width="100">Status</th>
                        <th width="100">Action</th>
                    </tr>
                </thead>
                <tbody>
                <c:set var="list" value="<%=list%>" />
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="q" items="${list}">
                            <tr>
                                <td>${q.qnaId}</td>
                                <td>${q.userId}</td>
                                <td style="text-align: left;">
                                    <a href="javascript:toggleAnswer('ans_${q.qnaId}')" style="font-weight: 600; color: #333;">
                                        ${q.subject}
                                    </a>
                                    <div style="font-size: 13px; color: #777; margin-top: 5px;">${q.content}</div>
                                </td>
                                <td><fmt:formatDate value="${q.regdate}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <span class="badge ${q.status == '답변완료' ? 'badge-success' : 'badge-danger'}">
                                        ${q.status}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn-admin btn-admin-dark" onclick="toggleAnswer('ans_${q.qnaId}')">Answer</button>
                                </td>
                            </tr>
                            <!-- Answer Form Row -->
                            <tr id="ans_${q.qnaId}" class="answer-row">
                                <td colspan="6">
                                    <div class="answer-box">
                                        <form action="qna_answer_proc.jsp" method="post">
                                            <input type="hidden" name="qnaId" value="${q.qnaId}">
                                            <label class="admin-label">Admin Answer</label>
                                            <textarea name="answer" class="admin-textarea" style="margin-bottom: 10px;">${q.answer != null ? q.answer : ''}</textarea>
                                            <button type="submit" class="btn-admin btn-admin-primary">Save Answer</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="6" style="text-align: center; padding: 50px;">No Q&A found.</td></tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>