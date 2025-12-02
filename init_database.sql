DROP TABLE IF EXISTS cloth;

CREATE TABLE cloth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    maker VARCHAR(100),
    price INT NOT NULL,
    img_body VARCHAR(255),    -- 전신 사진 (기존 poster 역할)
    img_front VARCHAR(255),   -- 정면 사진
    img_back VARCHAR(255),    -- 뒷면 사진
    img_detail VARCHAR(255),  -- 상세 사진
    description TEXT,         -- 상세 설명
    stock INT DEFAULT 0,      -- 재고
    sizes VARCHAR(100),       -- 사이즈 목록 (예: "S,M,L")
    colors VARCHAR(100),      -- 색상 목록 (예: "Black,White")
    clothType VARCHAR(50),    -- 카테고리 (Outer, Top 등)
    freq INT DEFAULT 0,       -- 조회수/인기순
    opendate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 샘플 데이터 추가
INSERT INTO cloth (title, maker, price, img_body, img_front, img_back, img_detail, description, stock, sizes, colors, clothType, freq, opendate)
VALUES 
('Fur Jacket Grey', 'MERCI', 238400, 'product01.jpg', 'product01.jpg', 'product01.jpg', 'product01.jpg', '고급스러운 퍼 소재로 제작된 그레이 자켓입니다.\n보온성이 뛰어나며 스타일리시한 연출이 가능합니다.', 50, 'S,M,L', 'Grey,Black', 'Outer', 10, NOW()),
('Long Patch Zip Up Burgundy', 'MERCI', 118400, 'product02.jpg', 'product02.jpg', 'product02.jpg', 'product02.jpg', '유니크한 패치 디테일이 돋보이는 버건디 집업입니다.\n편안한 착용감과 트렌디한 디자인을 제공합니다.', 30, 'FREE', 'Burgundy', 'Outer', 5, NOW()),
('Thinsulate Padded Jacket Brown', 'MERCI', 214400, 'product03.jpg', 'product03.jpg', 'product03.jpg', 'product03.jpg', '신슐레이트 소재를 사용하여 가볍지만 따뜻한 패딩 자켓입니다.\n겨울철 데일리 아이템으로 추천합니다.', 40, 'M,L,XL', 'Brown,Khaki', 'Outer', 15, NOW()),
('Flower Graphic Long Sleeve White', 'MERCI', 66300, 'product04.jpg', 'product04.jpg', 'product04.jpg', 'product04.jpg', '감각적인 플라워 그래픽이 프린팅된 긴팔 티셔츠입니다.\n단독으로 입거나 레이어드하기 좋습니다.', 100, 'S,M,L', 'White', 'Top', 20, NOW()),
('Fur Jacket Camel', 'MERCI', 238400, 'product05.jpg', 'product05.jpg', 'product05.jpg', 'product05.jpg', '부드러운 터치감의 카멜 컬러 퍼 자켓입니다.\n고급스러운 분위기를 연출해줍니다.', 25, 'S,M', 'Camel', 'Outer', 8, NOW()),
('Wave Down Jacket Blue', 'MERCI', 202300, 'product06.jpg', 'product06.jpg', 'product06.jpg', 'product06.jpg', '웨이브 퀼팅 디자인이 매력적인 다운 자켓입니다.\n경쾌한 블루 컬러가 돋보입니다.', 35, 'M,L', 'Blue', 'Outer', 12, NOW()),
('Brush Symbol Knit Multi Brown', 'MERCI', 124200, 'product07.jpg', 'product07.jpg', 'product07.jpg', 'product07.jpg', '브러쉬 텍스처가 돋보이는 니트입니다.\n따뜻한 색감으로 가을, 겨울에 잘 어울립니다.', 60, 'FREE', 'Brown', 'Top', 18, NOW()),
('Fur Cowichan Hoodie Charcoal', 'MERCI', 268200, 'product08.jpg', 'product08.jpg', 'product08.jpg', 'product08.jpg', '코위찬 스타일의 후드 퍼 자켓입니다.\n캐주얼하면서도 빈티지한 무드를 느낄 수 있습니다.', 20, 'L,XL', 'Charcoal', 'Outer', 7, NOW()),
('Oversized Balaclava Knit Brown', 'MERCI', 127800, 'product09.jpg', 'product09.jpg', 'product09.jpg', 'product09.jpg', '바라클라바 디자인이 적용된 오버사이즈 니트입니다.\n유니크한 스타일링이 가능합니다.', 45, 'FREE', 'Brown', 'Top', 25, NOW()),
('Shaggy Cuff Beanie Lavender', 'MERCI', 61200, 'product10.jpg', 'product10.jpg', 'product10.jpg', 'product10.jpg', '섀기한 질감의 비니입니다.\n라벤더 컬러로 포인트 주기 좋습니다.', 80, 'FREE', 'Lavender', 'Acc', 30, NOW()),
('Chearing Fur Hoddie Grey', 'MERCI', 254400, 'product11.jpg', 'product11.jpg', 'product11.jpg', 'product11.jpg', '응원단 로고가 자수된 퍼 후드입니다.\n귀엽고 따뜻한 느낌을 줍니다.', 30, 'S,M', 'Grey', 'Top', 11, NOW()),
('Technical Comfort Slacks Brown', 'MERCI', 134300, 'product12.jpg', 'product12.jpg', 'product12.jpg', 'product12.jpg', '기능성 원단으로 제작된 편안한 슬랙스입니다.\n데일리 오피스룩으로 적합합니다.', 55, 'S,M,L,XL', 'Brown,Black', 'Bottom', 14, NOW()),
('WBE Logo Muffler Black', 'MERCI', 68500, 'product13.jpg', 'product13.jpg', 'product13.jpg', 'product13.jpg', '심플한 로고가 들어간 블랙 머플러입니다.\n어떤 코디에도 잘 어울리는 기본 아이템입니다.', 100, 'FREE', 'Black', 'Acc', 40, NOW()),
('Insulated Cap Gray', 'MERCI', 57600, 'product14.jpg', 'product14.jpg', 'product14.jpg', 'product14.jpg', '보온성이 뛰어난 패딩 캡입니다.\n겨울철 야외 활동 시 유용합니다.', 70, 'FREE', 'Gray', 'Acc', 22, NOW());