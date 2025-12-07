<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.util.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    
    if (userId == null || !"admin".equals(userId)) {
        out.println("<script>alert('관리자 권한이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }

    String qnaIdStr = request.getParameter("qnaId");
    String answer = request.getParameter("answer");

    if (qnaIdStr == null || answer == null) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    int qnaId = Integer.parseInt(qnaIdStr);

    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        QnaDao dao = new QnaDao();
        dao.updateAnswer(conn, qnaId, answer);
        
        response.sendRedirect("manageqna.jsp");
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('답변 등록 실패: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn);
    }
%>