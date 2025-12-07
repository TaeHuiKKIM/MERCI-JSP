<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, my.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Setup Tracking Columns</title>
</head>
<body>
    <h2>Adding Tracking Columns to 'orders' table...</h2>
    <%
        Connection conn = null;
        Statement stmt = null;
        try {
            conn = ConnectionProvider.getConnection();
            stmt = conn.createStatement();
            
            // Add tracking_carrier column if not exists (MySQL syntax specific)
            // Note: 'IF NOT EXISTS' for columns is not standard in simple ALTER TABLE, 
            // but we can try-catch or just run it. 
            // Better approach: Check metadata or just run it and ignore "Duplicate column" error.
            
            String sql1 = "ALTER TABLE orders ADD COLUMN tracking_carrier VARCHAR(50) DEFAULT NULL";
            try {
                stmt.executeUpdate(sql1);
                out.println("<p>Added 'tracking_carrier' column.</p>");
            } catch(SQLException e) {
                out.println("<p>'tracking_carrier' column might already exist or error: " + e.getMessage() + "</p>");
            }
            
            String sql2 = "ALTER TABLE orders ADD COLUMN tracking_num VARCHAR(100) DEFAULT NULL";
            try {
                stmt.executeUpdate(sql2);
                out.println("<p>Added 'tracking_num' column.</p>");
            } catch(SQLException e) {
                out.println("<p>'tracking_num' column might already exist or error: " + e.getMessage() + "</p>");
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p>Critical Error: " + e.getMessage() + "</p>");
        } finally {
            JdbcUtil.close(stmt);
            JdbcUtil.close(conn);
        }
    %>
    <p>Setup Complete. You can delete this file.</p>
    <a href="index.jsp">Go to Home</a>
</body>
</html>