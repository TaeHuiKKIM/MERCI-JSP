package my.dao;

import java.sql.*;
import java.util.*;
import my.model.Qna;
import my.util.JdbcUtil;

public class QnaDao {
    
    public void insert(Connection conn, Qna qna) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement("INSERT INTO qna (userId, subject, content, status, regdate, isSecret) VALUES (?, ?, ?, '대기중', NOW(), ?)");
            pstmt.setString(1, qna.getUserId());
            pstmt.setString(2, qna.getSubject());
            pstmt.setString(3, qna.getContent());
            pstmt.setInt(4, qna.getIsSecret());
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    public List<Qna> selectList(Connection conn, int startRow, int size) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Qna> list = new ArrayList<>();
        try {
            // Join with user table to get userName
            String sql = "SELECT q.*, u.name as userName FROM qna q " +
                         "LEFT JOIN user u ON q.userId = u.userId " +
                         "ORDER BY q.qnaId DESC LIMIT ?, ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, startRow);
            pstmt.setInt(2, size);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Qna q = new Qna();
                q.setQnaId(rs.getInt("qnaId"));
                q.setUserId(rs.getString("userId"));
                q.setSubject(rs.getString("subject"));
                q.setContent(rs.getString("content"));
                q.setStatus(rs.getString("status"));
                q.setAnswer(rs.getString("answer"));
                q.setRegdate(rs.getTimestamp("regdate"));
                q.setIsSecret(rs.getInt("isSecret"));
                
                String uName = rs.getString("userName");
                q.setUserName(uName != null ? uName : q.getUserId()); // Fallback to ID if name is null
                
                list.add(q);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }

    public int selectCount(Connection conn) throws SQLException {
        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT count(*) FROM qna");
            if (rs.next()) return rs.getInt(1);
            return 0;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(stmt);
        }
    }
    
    public Qna selectById(Connection conn, int qnaId) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT q.*, u.name as userName FROM qna q " +
                         "LEFT JOIN user u ON q.userId = u.userId " +
                         "WHERE q.qnaId = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, qnaId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Qna q = new Qna();
                q.setQnaId(rs.getInt("qnaId"));
                q.setUserId(rs.getString("userId"));
                q.setSubject(rs.getString("subject"));
                q.setContent(rs.getString("content"));
                q.setStatus(rs.getString("status"));
                q.setAnswer(rs.getString("answer"));
                q.setRegdate(rs.getTimestamp("regdate"));
                q.setIsSecret(rs.getInt("isSecret"));
                
                String uName = rs.getString("userName");
                q.setUserName(uName != null ? uName : q.getUserId());
                
                return q;
            }
            return null;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }
    
    // 답변 등록 (관리자용)
    public void updateAnswer(Connection conn, int qnaId, String answer) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement("UPDATE qna SET answer = ?, status = '답변완료' WHERE qnaId = ?");
            pstmt.setString(1, answer);
            pstmt.setInt(2, qnaId);
            pstmt.executeUpdate();
        } finally {
            JdbcUtil.close(pstmt);
        }
    }

    // 관리자용 목록 조회 (상태 및 검색어 필터)
    public List<Qna> selectListAdmin(Connection conn, String status, String keyword) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Qna> list = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder("SELECT q.*, u.name as userName FROM qna q ");
            sql.append("LEFT JOIN user u ON q.userId = u.userId ");
            sql.append("WHERE 1=1 ");
            
            if (status != null && !status.isEmpty() && !"All".equals(status)) {
                sql.append("AND q.status = ? ");
            }
            if (keyword != null && !keyword.isEmpty()) {
                sql.append("AND (q.subject LIKE ? OR u.name LIKE ?) ");
            }
            sql.append("ORDER BY q.qnaId DESC");

            pstmt = conn.prepareStatement(sql.toString());
            
            int idx = 1;
            if (status != null && !status.isEmpty() && !"All".equals(status)) {
                pstmt.setString(idx++, status);
            }
            if (keyword != null && !keyword.isEmpty()) {
                pstmt.setString(idx++, "%" + keyword + "%");
                pstmt.setString(idx++, "%" + keyword + "%");
            }

            rs = pstmt.executeQuery();
            while (rs.next()) {
                Qna q = new Qna();
                q.setQnaId(rs.getInt("qnaId"));
                q.setUserId(rs.getString("userId"));
                q.setSubject(rs.getString("subject"));
                q.setContent(rs.getString("content"));
                q.setStatus(rs.getString("status"));
                q.setAnswer(rs.getString("answer"));
                q.setRegdate(rs.getTimestamp("regdate"));
                q.setIsSecret(rs.getInt("isSecret"));
                
                String uName = rs.getString("userName");
                q.setUserName(uName != null ? uName : q.getUserId());
                
                list.add(q);
            }
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
        return list;
    }
}
