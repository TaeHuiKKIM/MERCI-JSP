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
    String status = request.getParameter("status");
    String keyword = request.getParameter("keyword");
    
    try {
        conn = ConnectionProvider.getConnection();
        QnaDao dao = new QnaDao();
        list = dao.selectListAdmin(conn, status, keyword);
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
<title>문의 관리 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
<script src="<%=root%>/style.js"></script>
</head>
<body class="admin-body">

    <!-- HEADER -->
    <jsp:include page="header.jsp" />

    <div class="admin-container">
        <div class="admin-page-title">
            <span>문의 관리</span>
        </div>

        <div class="admin-card">
            <!-- Search & Filter -->
            <form action="manageqna.jsp" method="get" class="admin-form-group" style="display: flex; gap: 10px; align-items: center; margin-bottom: 20px;">
                <select name="status" class="admin-select" style="width: auto;">
                    <option value="All">전체 상태</option>
                    <option value="대기중" <%= "대기중".equals(status) ? "selected" : "" %>>대기중</option>
                    <option value="답변완료" <%= "답변완료".equals(status) ? "selected" : "" %>>답변완료</option>
                </select>
                <input type="text" name="keyword" placeholder="작성자 또는 제목" class="admin-input" style="width: 200px;" value="<%= keyword != null ? keyword : "" %>">
                <button type="submit" class="btn-admin btn-admin-dark">검색</button>
            </form>

            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="50">ID</th>
                        <th width="100">작성자</th>
                        <th>제목</th>
                        <th width="200">작성일</th>
                        <th width="100">상태</th>
                        <th width="150">관리</th>
                    </tr>
                </thead>
                <tbody>
                <c:set var="list" value="<%=list%>" />
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="q" items="${list}">
                            <tr>
                                <td>${q.qnaId}</td>
                                <td>${q.userName}</td>
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
                                    <button class="btn-admin btn-admin-dark" onclick="toggleAnswer('ans_${q.qnaId}')">답변하기</button>
                                </td>
                            </tr>
                            <!-- Answer Form Row -->
                            <tr id="ans_${q.qnaId}" class="answer-row">
                                <td colspan="6">
                                    <div class="answer-box">
                                        <form action="qna_answer_proc.jsp" method="post">
                                            <input type="hidden" name="qnaId" value="${q.qnaId}">
                                            <label class="admin-label">관리자 답변</label>
                                            <textarea name="answer" class="admin-textarea" style="margin-bottom: 10px;">${q.answer != null ? q.answer : ''}</textarea>
                                            <button type="submit" class="btn-admin btn-admin-primary">답변 저장</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="6" style="text-align: center; padding: 50px;">문의 내역이 없습니다.</td></tr>
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