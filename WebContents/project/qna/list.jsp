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
<title>문의 게시판 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=request.getContextPath()%>/project/style.css">
</head>
<body>

    <!-- HEADER -->
    <jsp:include page="../header.jsp" />

    <div class="qna-container">
        <div class="qna-header">
            <div class="qna-title">문의 게시판</div>
            <a href="write.jsp" class="btn-write">문의 작성</a>
        </div>

        <table class="qna-list">
            <thead>
                <tr>
                    <th width="60">번호</th>
                    <th width="100">상태</th>
                    <th>제목</th>
                    <th width="100">작성자</th>
                    <th width="120">작성일</th>
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
                                                <span style="color: #999;">🔒 비밀글입니다.</span>
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
                                <td>${q.userName}</td>
                                <td><fmt:formatDate value="${q.regdate}" pattern="yyyy-MM-dd"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="5" style="padding: 50px; color: #999;">게시글이 없습니다.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- FOOTER -->
    <jsp:include page="../footer.jsp" />

</body>
</html>