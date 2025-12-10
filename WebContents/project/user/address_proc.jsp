<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 로그인된 사용자 ID 가져오기 (가장 중요!)
    String userId = (String) session.getAttribute("userId");

    // 로그인이 안 되어 있다면 튕겨내기
    if (userId == null) {
%>
        <script>
            alert("로그인이 필요한 서비스입니다.");
            location.href = "../index.jsp?login=open";
        </script>
<%
        return;
    }

    // 2. 입력한 주소 정보 받기 (HTML name 속성과 일치해야 함)
    String addrName = request.getParameter("addressName");
    String recipient = request.getParameter("receiver");
    String phone = request.getParameter("phone");
    String zipcode = request.getParameter("zipcode");
    String roadAddr = request.getParameter("roadAddress");
    String detailAddr = request.getParameter("detailAddress");

    // 3. 데이터베이스에 저장
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        DeliveryAddressDao dao = new DeliveryAddressDao();
        
        // 모델 객체 생성 및 데이터 세팅
        DeliveryAddress addr = new DeliveryAddress();
        addr.setUserId(userId);          // ★ 세션에서 가져온 ID 저장
        addr.setAddrName(addrName);
        addr.setRecipientName(recipient);
        addr.setPhone(phone);
        addr.setZipcode(zipcode);
        addr.setAddrRoad(roadAddr);
        addr.setAddrDetail(detailAddr);
        
        // DAO를 통해 DB에 저장 (insert)
        dao.insert(conn, addr);
        
%>
        <script>
            alert("배송지가 성공적으로 등록되었습니다.");
            location.href = "address_list.jsp"; 
        </script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("저장 중 오류가 발생했습니다: <%=e.getMessage().replace("\"", "'")%>");
            history.back();
        </script>
<%
    } finally {
        JdbcUtil.close(conn);
    }
%>