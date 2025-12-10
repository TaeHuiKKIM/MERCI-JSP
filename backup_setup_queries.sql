-- Backup of SQL queries from setup JSP files

-- From setup_tables_v2.jsp (Review and QnA Tables)
CREATE TABLE IF NOT EXISTS review (
    reviewId INT AUTO_INCREMENT PRIMARY KEY,
    userId VARCHAR(50),
    clothId INT,
    rating INT,
    content TEXT,
    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE,
    FOREIGN KEY (clothId) REFERENCES cloth(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS qna (
    qnaId INT AUTO_INCREMENT PRIMARY KEY,
    userId VARCHAR(50),
    subject VARCHAR(200),
    content TEXT,
    status VARCHAR(20) DEFAULT '대기중',
    answer TEXT,
    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE
);

-- From setup_tables_v3.jsp (Site Settings and QnA Secret Option)
CREATE TABLE IF NOT EXISTS site_settings (setting_key VARCHAR(50) PRIMARY KEY, setting_value TEXT);

-- Insert default about text (Logic was conditional in JSP, represented here as INSERT IGNORE or standard INSERT)
-- Default Text: MERCI BRINGS SUBURBAN VITALITY INTO THE CITY...
INSERT IGNORE INTO site_settings (setting_key, setting_value) VALUES ('about_text', 'MERCI BRINGS SUBURBAN VITALITY INTO THE CITY, OFFERING WOMEN AN ACTIVE LIFESTYLE AND FASHION THAT FUSE EVERYDAY URBAN LIFE WITH EXTRAORDINARY ENERGY.

MERCI는 도시에 사는 여성들에게 교외적인 생동감을 불어넣을 수 있는 새로운 라이프스타일과 패션을 제안합니다. 자연과 도시가 만나는 순간을 담아내며, 일상 속에서 편안하게 입을 수 있는 실루엣과 활동적인 에너지를 동시에 전달합니다.');

ALTER TABLE qna ADD COLUMN IF NOT EXISTS isSecret INT DEFAULT 0; -- 0: public, 1: secret (Note: IF NOT EXISTS syntax might depend on MySQL version, original JSP caught exceptions)

-- From setup_db_update.jsp (User Find Password Columns)
ALTER TABLE user ADD COLUMN IF NOT EXISTS find_q VARCHAR(100) DEFAULT '기억에 남는 추억의 장소는?';
ALTER TABLE user ADD COLUMN IF NOT EXISTS find_a VARCHAR(100) DEFAULT 'merci';

-- From setup_tracking.jsp (Order Tracking Columns)
ALTER TABLE orders ADD COLUMN IF NOT EXISTS tracking_carrier VARCHAR(50) DEFAULT NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS tracking_num VARCHAR(100) DEFAULT NULL;
