<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*"%>
<%
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='../index.jsp';</script>");
        return;
    }

    String mode = request.getParameter("mode"); // delete 또는 default
    int addrId = Integer.parseInt(request.getParameter("id"));

    Connection conn = null;
    DeliveryAddressDao dao = new DeliveryAddressDao();

    try {
        conn = ConnectionProvider.getConnection();
        
        if ("delete".equals(mode)) {
            // 삭제 처리
            dao.delete(conn, addrId);
        } else if ("default".equals(mode)) {
            // 기본 배송지 설정 처리
            dao.setDefault(conn, userId, addrId);
        }
        
        // 처리 후 마이페이지로 복귀
        response.sendRedirect("account.jsp");

    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>alert("오류 발생"); history.back();</script>
<%
    } finally {
        JdbcUtil.close(conn);
    }
%>