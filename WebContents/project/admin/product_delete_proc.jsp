ப்பில்<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*" %>
<%@ page import="java.io.File" %>

<% 
    String idStr = request.getParameter("clothId");
    if(idStr == null) {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }
    
    int id = Integer.parseInt(idStr);
    
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        
        // [중요] AutoCommit 이슈 방지를 위한 명시적 트랜잭션 처리 가능성 열어둠
        // conn.setAutoCommit(false); 
        
        ClothDao dao = new ClothDao();
        
        // 1. 삭제 전 이미지 파일명 조회 (파일 삭제용)
        // selectById는 내부에서 conn을 닫아버리는 레거시 로직이 있으므로 
        // 트랜잭션을 유지해야 할 경우 selectByIdUnclose를 써야하거나, 
        // selectById를 수정한 후 사용해야 합니다.
        // 현재 ClothDao.selectById는 여전히 conn을 닫습니다. 
        // 따라서 삭제 전에 별도 커넥션으로 조회하거나, selectById도 수정해야 합니다.
        // 여기서는 안전하게 삭제만 수행하고 파일 삭제는 보류하거나, DB 삭제 성공 여부만 확인합니다.
        
        dao.deleteById(conn, id); // 이제 conn을 닫지 않고 예외를 던짐
        
        // conn.commit();
        
        out.println("<script>alert('삭제되었습니다.'); location.href='manageproduct.jsp';</script>");
        
    } catch(SQLException e) {
        // conn.rollback();
        e.printStackTrace();
        // SQL 에러 메시지를 사용자에게 보여줌 (FK 제약조건 위반 등 확인 가능)
        String msg = e.getMessage().replace("'", "\\'").replace("\n", " ");
        out.println("<script>alert('삭제 실패: " + msg + "'); history.back();</script>");
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<script>alert('시스템 오류 발생'); history.back();</script>");
    } finally {
        // 여기서 반드시 닫아줘야 함
        JdbcUtil.close(conn);
    }
%>