<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*, my.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB Update v3</title>
</head>
<body>
<h2>Database Schema Update (Wishlist)</h2>
<pre>
<% 
    Connection conn = null;
    Statement stmt = null;
    try {
        conn = ConnectionProvider.getConnection();
        conn.setAutoCommit(false);
        stmt = conn.createStatement();

        // 8. Wishlist Table
        String sql = "CREATE TABLE IF NOT EXISTS wishlist (" +
                      "    wishId INT AUTO_INCREMENT PRIMARY KEY," +
                      "    userId VARCHAR(50)," +
                      "    clothId INT," +
                      "    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                      "    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE," +
                      "    FOREIGN KEY (clothId) REFERENCES cloth(id) ON DELETE CASCADE" +
                      ")";
        stmt.executeUpdate(sql);
        out.println("Executed: Create Wishlist Table");

        conn.commit();
        out.println("\nSUCCESS: Wishlist table created.");

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
