package my.dao;

import java.sql.*;
import java.util.*;
import my.model.Qna;
import my.util.JdbcUtil;

public class QnaDao {
    
    public void insert(Connection conn, Qna qna) throws SQLException {
        PreparedStatement pstmt = null;
        try {
            pstmt = conn.prepareStatement("INSERT INTO qna (userId, subject, content, status, regdate) VALUES (?, ?, ?, '대기중', NOW())");
            pstmt.setString(1, qna.getUserId());
            pstmt.setString(2, qna.getSubject());
            pstmt.setString(3, qna.getContent());
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
            // 간단한 페이징
            pstmt = conn.prepareStatement("SELECT * FROM qna ORDER BY qnaId DESC LIMIT ?, ?");
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
            pstmt = conn.prepareStatement("SELECT * FROM qna WHERE qnaId = ?");
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
}
