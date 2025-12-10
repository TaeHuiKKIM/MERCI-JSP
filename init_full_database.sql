-- 1. Cloth Table & Data (From init_database.sql & insert_product_data.sql)
DROP TABLE IF EXISTS cloth;

CREATE TABLE cloth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    maker VARCHAR(100),
    price INT NOT NULL,
    img_body VARCHAR(255),
    img_front VARCHAR(255),
    img_back VARCHAR(255),
    img_detail VARCHAR(255),
    description TEXT,
    stock INT DEFAULT 0,
    sizes VARCHAR(100),
    colors VARCHAR(100),
    clothType VARCHAR(50),
    freq INT DEFAULT 0,
    opendate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO cloth (title, maker, price, img_body, img_front, img_back, img_detail, description, stock, sizes, colors, clothType, freq, opendate) VALUES
('Quilted String Backpack Brown', 'Made In Korea', 128000, 'product01_body.jpg', 'product01_front.jpg', 'product01_back.jpg', 'product01_detail.jpg', '', 100, 'FREE', 'BROWN', 'acc', 0, NOW()),
('Crochet Wool Knit Shawl Grey', 'Made In Korea', 78000, 'product02_body.jpg', 'product02_front.jpg', 'product02_back.jpg', 'product02_detail.jpg', '', 100, 'FREE', 'GREY, BROWN', 'acc', 0, NOW()),
('Fleece Beanie Sky Blue', 'Made In China', 48000, 'product03_body.jpg', 'product03_front.jpg', 'product03_back.jpg', 'product03_detail.jpg', '', 100, 'FREE', 'SKY, BLUE', 'acc', 0, NOW()),
('Flower Jacquard Beanie Black', 'Made In China', 68000, 'product04_body.jpg', 'product04_front.jpg', 'product04_back.jpg', 'product04_detail.jpg', '', 100, 'FREE', 'BLACK, IVORY', 'acc', 0, NOW()),
('Two Way Cross Bag Grey', 'Made In China', 108000, 'product05_body.jpg', 'product05_front.jpg', 'product05_back.jpg', 'product05_detail.jpg', '', 100, 'FREE', 'GREY, BLACK', 'acc', 0, NOW()),
('Patched Oversized Cotton Shirts Pale Pink', 'Made In China', 138000, 'product06_body.jpg', 'product06_front.jpg', 'product06_back.jpg', 'product06_detail.jpg', '', 100, 'FREE', 'PINK', 'top', 0, NOW()),
('Stripe Pocket Shirts Charcoal', 'Made In Korea', 148000, 'product07_body.jpg', 'product07_front.jpg', 'product07_back.jpg', 'product07_detail.jpg', '', 100, 'S, M', 'CHARCOAL', 'top', 0, NOW()),
('Blocked Check Shirt Blue', 'Made In Vietnam', 148000, 'product08_body.jpg', 'product08_front.jpg', 'product08_back.jpg', 'product08_detail.jpg', '', 100, 'FREE', 'BLUE', 'top', 0, NOW()),
('Oversized Mesh Print Shirts Sky Blue', 'Made In China', 128000, 'product09_body.jpg', 'product09_front.jpg', 'product09_back.jpg', 'product09_detail.jpg', '', 100, 'S, M', 'SKY BLUE', 'top', 0, NOW()),
('Concentration Sweatshirt Black', 'Made In China', 109000, 'product10_body.jpg', 'product10_front.jpg', 'product10_back.jpg', 'product10_detail.jpg', '', 100, 'S, M', 'BLACK, CHARCOAL', 'top', 0, NOW()),
('Sports Jersey Top Grey', 'Made In China', 78000, 'product11_body.jpg', 'product11_front.jpg', 'product11_back.jpg', 'product11_detail.jpg', '', 100, 'S, M', 'GREY', 'top', 0, NOW()),
('Boucle Hoodie Grey', 'Made In China', 128000, 'product12_body.jpg', 'product12_front.jpg', 'product12_back.jpg', 'product12_detail.jpg', '', 100, 'S, M', 'GREY', 'top', 0, NOW()),
('Fleece Sports Hoodie Mint', 'Made In China', 87000, 'product13_body.jpg', 'product13_front.jpg', 'product13_back.jpg', 'product13_detail.jpg', '', 100, 'S, M', 'MINT, GREY', 'top', 0, NOW()),
('Layered Edge Top Charcoal', 'Made In China', 68000, 'product14_body.jpg', 'product14_front.jpg', 'product14_back.jpg', 'product14_detail.jpg', '', 100, 'S, M', 'CHARCOAL', 'top', 0, NOW()),
('Oversized Balaclava Knit Beige', 'Made In China', 142000, 'product15_body.jpg', 'product15_front.jpg', 'product15_back.jpg', 'product15_detail.jpg', '', 100, 'FREE', 'BEIGE', 'top', 0, NOW()),
('Hybrid Tattoo Jacquard Knit Blue', 'Made In China', 105000, 'product16_body.jpg', 'product16_front.jpg', 'product16_back.jpg', 'product16_detail.jpg', '', 100, 'FREE', 'BLUE', 'top', 0, NOW()),
('Logo Patch Zip Up Burgundy', 'Made In China', 148000, 'product17_body.jpg', 'product17_front.jpg', 'product17_back.jpg', 'product17_detail.jpg', '', 100, 'FREE', 'RED, BLACK', 'outer', 0, NOW()),
('Embroidered Wool Jacket Blue Navy', 'Made in Vietnam', 286000, 'product18_body.jpg', 'product18_front.jpg', 'product18_back.jpg', 'product18_detail.jpg', '', 100, 'FREE', 'BLUE NAVY, BROWN', 'outer', 0, NOW()),
('Message Sweat Pants Ash Beige', 'Made In China', 158000, 'product19_body.jpg', 'product19_front.jpg', 'product19_back.jpg', 'product19_detail.jpg', '', 100, 'S, M, L', 'ASH BEIGE', 'outer', 0, NOW()),
('Button Detail Pants Beige', 'Made In Korea', 172000, 'product20_body.jpg', 'product20_front.jpg', 'product20_back.jpg', 'product20_detail.jpg', '', 100, 'S, M, L', 'BEIGE', 'bottom', 0, NOW()),
('Fur Jacket Grey', 'Made In Vietnam', 298000, 'product21_body.jpg', 'product21_front.jpg', 'product21_back.jpg', 'product21_detail.jpg', '', 100, 'FREE', 'GREY', 'bottom', 0, NOW()),
('Technical Comfort Slacks Black', 'Made In Vietnam', 158000, 'product22_body.jpg', 'product22_front.jpg', 'product22_back.jpg', 'product22_detail.jpg', '', 100, 'S, M, L', 'BLACK, BROWN', 'bottom', 0, NOW()),
('Color Blocked Nylon Pants Blue', 'Made In Vietnam', 148000, 'product23_body.jpg', 'product23_front.jpg', 'product23_back.jpg', 'product23_detail.jpg', '', 100, 'S, M, L', 'BLUE', 'bottom', 0, NOW()),
('Embroidered Patch Jeans Light Blue', 'Made In China', 158000, 'product24_body.jpg', 'product24_front.jpg', 'product24_back.jpg', 'product24_detail.jpg', '', 100, 'S, M, L', 'LIGHT BLUE, BLACK', 'bottom', 0, NOW()),
('Middle Length Windbreaker Light Grey', 'Made in Vietnam', 268000, 'product25_body.jpg', 'product25_front.jpg', 'product25_back.jpg', 'product25_detail.jpg', '', 100, 'FREE', 'LIGHT GREY, BLACK', 'outer', 0, NOW());

-- 2. Review & QnA Tables (From backup_setup_queries.sql)
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

-- 3. Site Settings (From backup_setup_queries.sql)
CREATE TABLE IF NOT EXISTS site_settings (setting_key VARCHAR(50) PRIMARY KEY, setting_value TEXT);

INSERT IGNORE INTO site_settings (setting_key, setting_value) VALUES ('about_text', 'MERCI BRINGS SUBURBAN VITALITY INTO THE CITY, OFFERING WOMEN AN ACTIVE LIFESTYLE AND FASHION THAT FUSE EVERYDAY URBAN LIFE WITH EXTRAORDINARY ENERGY.

MERCI는 도시에 사는 여성들에게 교외적인 생동감을 불어넣을 수 있는 새로운 라이프스타일과 패션을 제안합니다. 자연과 도시가 만나는 순간을 담아내며, 일상 속에서 편안하게 입을 수 있는 실루엣과 활동적인 에너지를 동시에 전달합니다.');

-- 4. Schema Updates (ALTER Statements)
-- QnA Secret Option
-- Note: 'IF NOT EXISTS' for columns is syntax-dependent. If running on standard MySQL 5.7/8.0 without specific procedure, direct ALTER might fail if column exists.
-- For a consolidated script, it is safer to rely on 'CREATE TABLE' or ignore errors if running manually, or wrap in procedure.
-- Assuming this script is run for initialization or migration.

-- Add isSecret to qna (Check if exists logic is complex in pure SQL script without procedures, so we assume these are needed updates)
-- Uncomment if running on a fresh DB where qna table might not have it, or ignore error if it exists.
-- ALTER TABLE qna ADD COLUMN isSecret INT DEFAULT 0;

-- User Find Password Columns
-- ALTER TABLE user ADD COLUMN find_q VARCHAR(100) DEFAULT '기억에 남는 추억의 장소는?';
-- ALTER TABLE user ADD COLUMN find_a VARCHAR(100) DEFAULT 'merci';

-- Payment & Tracking Columns (From backup_setup_queries_v2.sql)
-- ALTER TABLE orders ADD COLUMN pay_method VARCHAR(50);
-- ALTER TABLE orders ADD COLUMN payment_id VARCHAR(100);
-- ALTER TABLE orders ADD COLUMN tracking_carrier VARCHAR(50);
-- ALTER TABLE orders ADD COLUMN tracking_num VARCHAR(100);

-- Zipcode Column (From backup_setup_queries_v2.sql)
-- ALTER TABLE deliveryaddr ADD COLUMN zipcode VARCHAR(10);
