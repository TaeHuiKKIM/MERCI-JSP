<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*, my.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB Update</title>
</head>
<body>
<h2>Database Schema Update (Review & QnA)</h2>
<pre>
<% 
    Connection conn = null;
    Statement stmt = null;
    try {
        conn = ConnectionProvider.getConnection();
        conn.setAutoCommit(false);
        stmt = conn.createStatement();

        // 1. Review Table
        String sql1 = "CREATE TABLE IF NOT EXISTS review (" +
                      "    reviewId INT AUTO_INCREMENT PRIMARY KEY," +
                      "    userId VARCHAR(50)," +
                      "    clothId INT," +
                      "    rating INT," +
                      "    content TEXT," +
                      "    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                      "    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE," +
                      "    FOREIGN KEY (clothId) REFERENCES cloth(id) ON DELETE CASCADE" +
                      ")";
        stmt.executeUpdate(sql1);
        out.println("Executed: Create Review Table");

        // 2. QnA Table
        String sql2 = "CREATE TABLE IF NOT EXISTS qna (" +
                      "    qnaId INT AUTO_INCREMENT PRIMARY KEY," +
                      "    userId VARCHAR(50)," +
                      "    subject VARCHAR(200)," +
                      "    content TEXT," +
                      "    status VARCHAR(20) DEFAULT '대기중'," +
                      "    answer TEXT," +
                      "    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                      "    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE" +
                      ")";
        stmt.executeUpdate(sql2);
        out.println("Executed: Create QnA Table");

        conn.commit();
        out.println("\nSUCCESS: Tables created.");

    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch(SQLException ex) {}
        e.printStackTrace();
        out.println("\nERROR: " + e.getMessage());
    } finally {
        JdbcUtil.close(stmt);
        JdbcUtil.close(conn);
    }
%>
</pre>
</body>
</html>