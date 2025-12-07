<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.net.*, java.util.*" %>
<%@ page import="java.sql.*, my.dao.*, my.util.*, my.model.*" %>
<%
    // [1] 인가 코드 받기
    String code = request.getParameter("code");
    if (code == null) {
        out.println("<script>alert('카카오 로그인 실패: 코드가 없습니다.'); history.back();</script>");
        return;
    }

    // [필수] 카카오 디벨로퍼스 REST API 키 (발급받은 키 확인 필요)
    String restApiKey = "6db1f1bdd047283a89303c0efd877ce1"; 
    
    // [필수] Redirect URI (반드시 카카오 개발자 센터 설정과 일치해야 함)
    // request.getContextPath()를 사용하여 현재 서버 설정(/pro1013 등)에 맞게 동적으로 생성
    String redirectUri = "http://localhost:8080" + request.getContextPath() + "/project/kakao_login_proc.jsp"; 

    // [2] 토큰 발급 요청
    String reqURL = "https://kauth.kakao.com/oauth/token";
    String accessToken = "";
    
    try {
        URL url = new URL(reqURL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true); // POST 요청에 필요

        String params = "grant_type=authorization_code" +
                        "&client_id=" + restApiKey +
                        "&redirect_uri=" + redirectUri +
                        "&code=" + code;

        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
        bw.write(params);
        bw.flush();

        int responseCode = conn.getResponseCode();
        System.out.println("Kakao Token Response Code: " + responseCode);

        if(responseCode != 200) {
            // 에러 읽기
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            String line;
            StringBuilder errorResult = new StringBuilder();
            while ((line = errorReader.readLine()) != null) {
                errorResult.append(line);
            }
            System.out.println("Kakao Token Error: " + errorResult.toString());
            out.println("Token Request Failed. Response Code: " + responseCode);
            return; 
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line = "";
        StringBuilder resultBuilder = new StringBuilder();
        while ((line = br.readLine()) != null) {
            resultBuilder.append(line);
        }
        String result = resultBuilder.toString();
        System.out.println("Kakao Token Result: " + result);
        
        // JSON 파싱 (String 문자열 처리)
        // "access_token":"...token..." 형태 찾기
        String target = "\"access_token\":\"";
        int index = result.indexOf(target);
        if(index != -1) {
            int start = index + target.length();
            int end = result.indexOf("\"", start);
            if (end != -1) {
                accessToken = result.substring(start, end);
            }
        }
        
        bw.close();
        br.close();
    } catch (IOException e) {
        e.printStackTrace();
        out.println("Connection Error during Token Request: " + e.getMessage());
        return;
    }

    if (accessToken == null || accessToken.isEmpty()) {
        out.println("<script>alert('토큰 발급에 실패했습니다.'); location.href='index.jsp';</script>");
        return;
    }

    // [3] 사용자 정보 요청
    String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
    String kakaoId = "";
    String nickname = "Kakao User"; // 기본값

    try {
        URL url = new URL(userInfoUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        int responseCode = conn.getResponseCode();
        System.out.println("Kakao UserInfo Response Code: " + responseCode);

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        String line = "";
        StringBuilder resultBuilder = new StringBuilder();
        while ((line = br.readLine()) != null) {
            resultBuilder.append(line);
        }
        String result = resultBuilder.toString();
        System.out.println("Kakao UserInfo Result: " + result);
        
        // JSON 파싱 (문자열 처리)
        // 1. ID 추출 ("id":12345 or "id":"12345")
        // 숫자로 올 수도 있고 문자열로 올 수도 있음. 보통 숫자.
        String idTarget = "\"id\":";
        int idIndex = result.indexOf(idTarget);
        if(idIndex != -1) {
            int start = idIndex + idTarget.length();
            // 값의 끝 찾기 (콤마 또는 닫는 중괄호)
            int endComma = result.indexOf(",", start);
            int endBrace = result.indexOf("}", start);
            int end = -1;
            
            if (endComma == -1) end = endBrace;
            else if (endBrace == -1) end = endComma;
            else end = Math.min(endComma, endBrace);
            
            if (end != -1) {
                kakaoId = result.substring(start, end).trim();
            }
        }

        // 2. 닉네임 추출 ("nickname":"...")
        // 닉네임은 properties 또는 kakao_account 내부에 있을 수 있음.
        // 단순히 "nickname":" 문자열을 찾으면 가장 먼저 나오는 것을 사용.
        String nickTarget = "\"nickname\":\"";
        int nickIndex = result.indexOf(nickTarget);
        if(nickIndex != -1) {
            int start = nickIndex + nickTarget.length();
            int end = result.indexOf("\"", start);
            if (end != -1) {
                nickname = result.substring(start, end);
                // 유니코드 변환 등이 필요할 수 있으나 일단 그대로 사용
            }
        }

        br.close();
    } catch (IOException e) {
        e.printStackTrace();
        out.println("Connection Error during User Info Request: " + e.getMessage());
        return;
    }

    // [4] DB 처리 및 로그인 세션 설정
    if(kakaoId != null && !kakaoId.equals("")) {
        Connection dbConn = null;
        try {
            dbConn = ConnectionProvider.getConnection();
            UserDao dao = new UserDao();
            // kakaoId를 userId로 사용. 중복 방지를 위해 접두어 붙일 수도 있음. 
            String dbUserId = "kakao_" + kakaoId; 
            
            User user = dao.selectById(dbConn, dbUserId); 

            if (user == null) {
                // 비회원이면 자동 회원가입
                dao.insertKakaoUser(dbConn, dbUserId, nickname);
                user = new User();
                user.setUserId(dbUserId);
                user.setName(nickname);
            }

            // 로그인 세션 처리
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            
            // 메인 페이지로 이동
            out.println("<script>alert('카카오 계정(" + user.getName() + ")으로 로그인되었습니다.'); location.href='index.jsp';</script>");
            
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<script>alert('DB 처리 중 오류 발생: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            JdbcUtil.close(dbConn);
        }
    } else {
        out.println("<script>alert('카카오 사용자 정보를 가져오지 못했습니다. 다시 시도해주세요.'); location.href='index.jsp';</script>");
    }
%>