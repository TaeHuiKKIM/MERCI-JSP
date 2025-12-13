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
                                        // pageContext에서 현재 반복문의 q 객체를 가져옴
                                        my.model.Qna qObj = (my.model.Qna) pageContext.getAttribute("q");
                                        boolean isSecret = (qObj.getIsSecret() == 1);
                                        boolean canView = isAdmin || (currentUserId != null && currentUserId.equals(qObj.getUserId()));
                                        
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
                                
                                <td>
                                <%
                                    String name = qObj.getUserName();
                                    
                                    // 비밀글이면서 이름이 null이 아닐 때 마스킹 처리
                                    if (isSecret && name != null && name.length() >= 1) {
                                        String maskedName = "";
                                        
                                        if (name.length() == 1) {
                                            maskedName = "*"; // 외자인데 1글자만 잡히는 경우(거의 없음)
                                        } else if (name.length() == 2) {
                                            // 이름이 2글자일 때 (예: 이산 -> 이*)
                                            maskedName = name.substring(0, 1) + "*";
                                        } else {
                                            // 이름이 3글자 이상일 때 (예: 홍길동 -> 홍*동, 남궁민수 -> 남**수)
                                            String first = name.substring(0, 1);
                                            String last = name.substring(name.length() - 1);
                                            String stars = "";
                                            // 중간 글자 수만큼 별표 생성
                                            for(int i = 0; i < name.length() - 2; i++) {
                                                stars += "*";
                                            }
                                            maskedName = first + stars + last;
                                        }
                                        out.print(maskedName);
                                    } else {
                                        // 비밀글이 아니면 그대로 출력
                                        out.print(name);
                                    }
                                %>
                                </td>
                                
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