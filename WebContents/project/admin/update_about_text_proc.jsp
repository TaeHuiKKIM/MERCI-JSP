<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.util.*"%>
<%
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String aboutText = request.getParameter("aboutText");
    
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        SiteSettingsDao dao = new SiteSettingsDao();
        dao.updateSetting(conn, "about_text", aboutText);
        
        out.println("<script>alert('About text updated successfully.'); location.href='manageabout.jsp';</script>");
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn);
    }
%>