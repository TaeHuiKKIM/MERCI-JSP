<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB Setup V3</title>
</head>
<body>
<% 
    Connection conn = null;
    Statement stmt = null;
    try {
        conn = ConnectionProvider.getConnection();
        stmt = conn.createStatement();

        // 1. site_settings table
        stmt.executeUpdate("CREATE TABLE IF NOT EXISTS site_settings (setting_key VARCHAR(50) PRIMARY KEY, setting_value TEXT)");
        
        // Insert default about text if not exists
        String defaultAbout = "MERCI BRINGS SUBURBAN VITALITY INTO THE CITY, OFFERING WOMEN AN ACTIVE LIFESTYLE AND FASHION THAT FUSE EVERYDAY URBAN LIFE WITH EXTRAORDINARY ENERGY.\n\nMERCI는 도시에 사는 여성들에게 교외적인 생동감을 불어넣을 수 있는 새로운 라이프스타일과 패션을 제안합니다. 자연과 도시가 만나는 순간을 담아내며, 일상 속에서 편안하게 입을 수 있는 실루엣과 활동적인 에너지를 동시에 전달합니다.";
        // Simple check to see if it exists
        ResultSet rs = stmt.executeQuery("SELECT count(*) FROM site_settings WHERE setting_key='about_text'");
        if (rs.next() && rs.getInt(1) == 0) {
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO site_settings (setting_key, setting_value) VALUES ('about_text', ?)");
            pstmt.setString(1, defaultAbout);
            pstmt.executeUpdate();
            pstmt.close();
        }
        rs.close();

        // 2. Add isSecret to qna table
        // Check if column exists
        boolean colExists = false;
        rs = stmt.executeQuery("SHOW COLUMNS FROM qna LIKE 'isSecret'");
        if (rs.next()) colExists = true;
        rs.close();
        
        if (!colExists) {
            stmt.executeUpdate("ALTER TABLE qna ADD COLUMN isSecret INT DEFAULT 0"); // 0: public, 1: secret
        }

        out.println("<h3>Database Updated Successfully (V3)</h3>");
        out.println("<ul><li>Created site_settings table</li><li>Added isSecret to qna table</li></ul>");

    } catch(Exception e) {
        e.printStackTrace();
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        JdbcUtil.close(stmt);
        JdbcUtil.close(conn);
    }
%>
</body>
</html>