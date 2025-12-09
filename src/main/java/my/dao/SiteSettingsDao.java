package my.dao;

import java.sql.*;
import my.util.JdbcUtil;

public class SiteSettingsDao {
    
    public String getSetting(Connection conn, String key) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement("SELECT setting_value FROM site_settings WHERE setting_key = ?");
            pstmt.setString(1, key);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
            return null;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }

    public void updateSetting(Connection conn, String key, String value) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            // Upsert (MySQL syntax)
            String sql = "INSERT INTO site_settings (setting_key, setting_value) VALUES (?, ?) " +
                         "ON DUPLICATE KEY UPDATE setting_value = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, key);
            pstmt.setString(2, value);
            pstmt.setString(3, value);
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }
}
