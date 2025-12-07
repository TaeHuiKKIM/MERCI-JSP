<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userName"); // Assuming userName is userId for simplicity or using userId attr
    // Re-check userId attr just in case
    String sUserId = (String) session.getAttribute("userId");
    if (sUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); history.back();</script>");
        return;
    }

    String subject = request.getParameter("subject");
    String content = request.getParameter("content");

    if (subject == null || content == null) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        QnaDao dao = new QnaDao();
        Qna qna = new Qna();
        qna.setUserId(sUserId);
        qna.setSubject(subject);
        qna.setContent(content);
        
        dao.insert(conn, qna);
        
        response.sendRedirect("list.jsp");
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('등록 실패: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn);
    }
%>