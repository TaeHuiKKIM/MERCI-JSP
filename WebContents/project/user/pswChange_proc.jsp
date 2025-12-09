<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*, my.dao.*, my.model.*"%>

<%
    // 1. 한글 처리 및 세션 확인
    request.setCharacterEncoding("UTF-8");
    String userId = (String) session.getAttribute("userId");

    // 로그인이 안 된 상태면 튕겨내기
    if (userId == null) {
%>
        <script>
            alert("로그인이 필요한 서비스입니다.");
            location.href = "../index.jsp?login=open";
        </script>
<%
        return; 
    }

    // [KAKAO CHECK] 카카오 계정 비밀번호 변경 차단
    if (userId.startsWith("kakao_")) {
%>
        <script>
            alert("카카오 계정은 비밀번호를 변경할 수 없습니다.");
            history.back();
        </script>
<%
        return;
    }

    // 2. 입력 데이터 받기
    String currentPw = request.getParameter("currentPw"); // 사용자가 입력한 '기존 비밀번호'
    String newPw = request.getParameter("newPw");         // 사용자가 입력한 '새 비밀번호'

    Connection conn = null;
    UserDao dao = new UserDao();

    try {
        conn = ConnectionProvider.getConnection();
        
        // 3. DB에서 현재 로그인한 사람의 '진짜 비밀번호' 가져오기
        User user = dao.selectById(conn, userId);

        if (user != null) {
            // 4. 비밀번호 비교 로직
            if (user.getPassword().equals(currentPw)) {
                // [CASE 1] 비밀번호가 일치함 -> 변경 진행
                int result = dao.updatePassword(conn, userId, newPw);
                
                if (result > 0) {
%>
                    <script>
                        alert("비밀번호가 성공적으로 변경되었습니다.");
                        location.href = "account.jsp"; // 마이페이지로 이동
                    </script>
<%
                } else {
                    throw new Exception("DB 업데이트 실패");
                }
                
            } else {
                // [CASE 2] 비밀번호가 틀림 (요청하신 부분!) -> 알림창 띄우기
%>
                <script>
                    alert("기존 비밀번호가 일치하지 않습니다.\n다시 확인해주세요.");
                    history.back(); // 이전 화면으로 돌아가기
                </script>
<%
            }
        } else {
            // 유저 정보가 없는 경우 (거의 없겠지만 예외처리)
%>
            <script>
                alert("회원 정보를 찾을 수 없습니다.");
                location.href = "../index.jsp";
            </script>
<%
        }

    } catch (Exception e) {
        // 5. 에러 발생 시 처리
        e.printStackTrace(); // 이클립스 콘솔에 에러 출력
%>
        <script>
            alert("시스템 에러가 발생했습니다: <%=e.getMessage().replace("\"", "'")%>");
            history.back();
        </script>
<%
    } finally {
        // 6. 자원 해제
        if (conn != null) try { conn.close(); } catch (SQLException ex) {}
    }
%>