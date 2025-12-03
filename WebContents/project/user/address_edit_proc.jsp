<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
%>
        <script>alert("로그인이 필요합니다."); location.href="../index.jsp";</script>
<%
        return;
    }

    // 파라미터 받기 (수정할 데이터)
    int addrId = Integer.parseInt(request.getParameter("addrId"));
    String addrName = request.getParameter("addressName");
    String recipient = request.getParameter("receiver");
    String phone = request.getParameter("phone");
    String roadAddr = request.getParameter("roadAddress");
    String detailAddr = request.getParameter("detailAddress");

    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        DeliveryAddressDao dao = new DeliveryAddressDao();
        
        // 객체에 담기
        DeliveryAddress addr = new DeliveryAddress();
        addr.setAddrId(addrId); // ★ 누구를 수정할지 ID 필수
        addr.setAddrName(addrName);
        addr.setRecipientName(recipient);
        addr.setPhone(phone);
        addr.setAddrRoad(roadAddr);
        addr.setAddrDetail(detailAddr);
        
        // DB 업데이트 실행
        int result = dao.update(conn, addr); // DAO에 update 메소드 있어야 함
        
        if(result > 0) {
%>
            <script>
                alert("배송지가 수정되었습니다.");
                location.href = "address_list.jsp"; 
            </script>
<%
        } else {
            throw new Exception("수정 실패");
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("오류 발생: <%=e.getMessage().replace("\"", "'")%>");
            history.back();
        </script>
<%
    } finally {
        JdbcUtil.close(conn);
    }
%>