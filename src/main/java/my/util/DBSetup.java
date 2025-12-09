package my.util;

import java.sql.*;

public class DBSetup {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/shoppingaddict?useSSL=false";
        String user = "root";
        String pass = "1234";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {

            System.out.println("Connected to database.");

            // 1. site_settings
            try {
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS site_settings (setting_key VARCHAR(50) PRIMARY KEY, setting_value TEXT)");
                System.out.println("Checked/Created site_settings table.");
            } catch (SQLException e) {
                System.out.println("Error creating site_settings: " + e.getMessage());
            }

            // Insert default about text
            try {
                ResultSet rs = stmt.executeQuery("SELECT count(*) FROM site_settings WHERE setting_key='about_text'");
                if (rs.next() && rs.getInt(1) == 0) {
                     String defaultAbout = "MERCI BRINGS SUBURBAN VITALITY INTO THE CITY, OFFERING WOMEN AN ACTIVE LIFESTYLE AND FASHION THAT FUSE EVERYDAY URBAN LIFE WITH EXTRAORDINARY ENERGY.\n\nMERCI는 도시에 사는 여성들에게 교외적인 생동감을 불어넣을 수 있는 새로운 라이프스타일과 패션을 제안합니다. 자연과 도시가 만나는 순간을 담아내며, 일상 속에서 편안하게 입을 수 있는 실루엣과 활동적인 에너지를 동시에 전달합니다.";
                     PreparedStatement pstmt = conn.prepareStatement("INSERT INTO site_settings (setting_key, setting_value) VALUES ('about_text', ?)");
                     pstmt.setString(1, defaultAbout);
                     pstmt.executeUpdate();
                     pstmt.close();
                     System.out.println("Inserted default about text.");
                }
                rs.close();
            } catch (SQLException e) {
                System.out.println("Error inserting about text: " + e.getMessage());
            }

            // 2. isSecret in qna
            try {
                // Check if column exists
                ResultSet rs = stmt.executeQuery("SHOW COLUMNS FROM qna LIKE 'isSecret'");
                boolean exists = rs.next();
                rs.close();
                
                if (!exists) {
                    stmt.executeUpdate("ALTER TABLE qna ADD COLUMN isSecret INT DEFAULT 0");
                    System.out.println("Added isSecret column to qna table.");
                } else {
                    System.out.println("isSecret column already exists.");
                }
            } catch (SQLException e) {
                System.out.println("Error adding isSecret: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
