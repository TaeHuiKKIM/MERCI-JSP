package my.model;

import java.util.Date;

public class Qna {
    private int qnaId;
    private String userId;
    private String subject;
    private String content;
    private String status; // '대기중', '답변완료'
    private String answer;
    private Date regdate;

    public Qna() {}

    public int getQnaId() { return qnaId; }
    public void setQnaId(int qnaId) { this.qnaId = qnaId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getAnswer() { return answer; }
    public void setAnswer(String answer) { this.answer = answer; }
    public Date getRegdate() { return regdate; }
    public void setRegdate(Date regdate) { this.regdate = regdate; }
}
