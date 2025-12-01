-- 기존 테이블 삭제 (초기화)
DROP TABLE IF EXISTS cloth;

-- 테이블 생성
CREATE TABLE cloth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    maker VARCHAR(100),
    price INT,
    poster VARCHAR(100),
    freq INT DEFAULT 0,
    opendate DATETIME DEFAULT CURRENT_TIMESTAMP,
    clothType VARCHAR(50)
);

-- 샘플 데이터 10개 삽입
INSERT INTO cloth (title, maker, price, poster, freq, clothType) VALUES 
('Classic Trench Coat', 'Burberry', 250000, 'product01.jpg', 10, 'outer'),
('Silk Blouse', 'Chanel', 120000, 'product02.jpg', 5, 'top'),
('Denim Jeans', 'Levi\'s', 89000, 'product03.jpg', 20, 'pants'),
('Floral Summer Dress', 'Zara', 75000, 'product04.jpg', 15, 'dress'),
('Leather Jacket', 'AllSaints', 450000, 'product05.jpg', 8, 'outer'),
('Cashmere Sweater', 'Uniqlo', 99000, 'product06.jpg', 25, 'top'),
('Pleated Skirt', 'H&M', 55000, 'product07.jpg', 12, 'skirt'),
('Running Shoes', 'Nike', 130000, 'product08.jpg', 30, 'shoes'),
('Canvas Tote Bag', 'Gucci', 1500000, 'product09.jpg', 40, 'bag'),
('Wool Scarf', 'Acne Studios', 210000, 'product10.jpg', 18, 'accessory');

-- 확인용 조회
SELECT * FROM cloth;
