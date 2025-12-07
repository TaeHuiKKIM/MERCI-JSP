<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.io.*, my.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB Setup</title>
</head>
<body>
<h2>Database Setup</h2>
<pre>
<% 
    Connection conn = null;
    Statement stmt = null;
    try {
        conn = ConnectionProvider.getConnection();
        conn.setAutoCommit(false);
        stmt = conn.createStatement();
        
        // Disable foreign key checks
        stmt.executeUpdate("SET FOREIGN_KEY_CHECKS = 0");

        // Drop tables if they exist (in reverse dependency order)
        stmt.executeUpdate("DROP TABLE IF EXISTS wishlist");
        out.println("Executed: DROP TABLE IF EXISTS wishlist");
        
        stmt.executeUpdate("DROP TABLE IF EXISTS qna");
        out.println("Executed: DROP TABLE IF EXISTS qna");
        
        stmt.executeUpdate("DROP TABLE IF EXISTS review");
        out.println("Executed: DROP TABLE IF EXISTS review");
        
        stmt.executeUpdate("DROP TABLE IF EXISTS order_item");
        out.println("Executed: DROP TABLE IF EXISTS order_item");
        
        stmt.executeUpdate("DROP TABLE IF EXISTS orders");
        out.println("Executed: DROP TABLE IF EXISTS orders");
        
        stmt.executeUpdate("DROP TABLE IF EXISTS deliveryaddr");
        out.println("Executed: DROP TABLE IF EXISTS deliveryaddr");
        
        stmt.executeUpdate("DROP TABLE IF EXISTS user");
        out.println("Executed: DROP TABLE IF EXISTS user");
        
        stmt.executeUpdate("DROP TABLE IF EXISTS cloth");
        out.println("Executed: DROP TABLE IF EXISTS cloth");
        
        // Enable foreign key checks
        stmt.executeUpdate("SET FOREIGN_KEY_CHECKS = 1");

        String[] sqls = {
            // 1. Cloth Table
            "CREATE TABLE cloth (" +
            "    id INT AUTO_INCREMENT PRIMARY KEY," +
            "    title VARCHAR(100) NOT NULL," +
            "    maker VARCHAR(100)," +
            "    price INT NOT NULL," +
            "    img_body VARCHAR(255)," +
            "    img_front VARCHAR(255)," +
            "    img_back VARCHAR(255)," +
            "    img_detail VARCHAR(255)," +
            "    description TEXT," +
            "    stock INT DEFAULT 0," +
            "    sizes VARCHAR(100)," +
            "    colors VARCHAR(100)," +
            "    clothType VARCHAR(50)," +
            "    freq INT DEFAULT 0," +
            "    opendate TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")",
            
            // 2. User Table
            "CREATE TABLE user (" +
            "   userId VARCHAR(50) PRIMARY KEY," +
            "   password VARCHAR(50) NOT NULL," +
            "   name VARCHAR(50)," +
            "   registerTime TIMESTAMP" +
            ")",
            
            "INSERT INTO user (userId, password, name, registerTime) VALUES ('admin', '1234', '관리자', NOW())",

            // 3. Order Table
            "CREATE TABLE orders (" +
            "   orderId INT AUTO_INCREMENT PRIMARY KEY," +
            "   userId VARCHAR(50)," +
            "   totalAmount INT," +
            "   status VARCHAR(20) DEFAULT '결제대기'," +
            "   receiverName VARCHAR(50)," +
            "   receiverPhone VARCHAR(20)," +
            "   address VARCHAR(200)," +
            "   depositor VARCHAR(50)," +
            "   orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
            ")",

            // 4. Order Item Table
            "CREATE TABLE order_item (" +
            "   itemId INT AUTO_INCREMENT PRIMARY KEY," +
            "   orderId INT," +
            "   clothId INT," +
            "   quantity INT," +
            "   price INT," +
            "   FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE" +
            ")",

            // 5. DeliveryAddr Table
            "CREATE TABLE IF NOT EXISTS deliveryaddr (" +
            "   addrId INT AUTO_INCREMENT PRIMARY KEY," +
            "   userId VARCHAR(50)," +
            "   addrName VARCHAR(50)," +
            "   recipient VARCHAR(50)," +
            "   phone VARCHAR(20)," +
            "   addrRoad VARCHAR(200)," +
            "   addrDetail VARCHAR(200)," +
            "   isDefault INT DEFAULT 0" +
            ")",

            // 6. Review Table
            "CREATE TABLE IF NOT EXISTS review (" +
            "    reviewId INT AUTO_INCREMENT PRIMARY KEY," +
            "    userId VARCHAR(50)," +
            "    clothId INT," +
            "    rating INT," +
            "    content TEXT," +
            "    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE," +
            "    FOREIGN KEY (clothId) REFERENCES cloth(id) ON DELETE CASCADE" +
            ")",

            // 7. QnA Table
            "CREATE TABLE IF NOT EXISTS qna (" +
            "    qnaId INT AUTO_INCREMENT PRIMARY KEY," +
            "    userId VARCHAR(50)," +
            "    subject VARCHAR(200)," +
            "    content TEXT," +
            "    status VARCHAR(20) DEFAULT '대기중'," +
            "    answer TEXT," +
            "    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE" +
            ")",
            
            // 8. Wishlist Table
            "CREATE TABLE IF NOT EXISTS wishlist (" +
            "    wishId INT AUTO_INCREMENT PRIMARY KEY," +
            "    userId VARCHAR(50)," +
            "    clothId INT," +
            "    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
            "    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE," +
            "    FOREIGN KEY (clothId) REFERENCES cloth(id) ON DELETE CASCADE" +
            ")",
            
            // Sample Data for Cloth (20 items)
            "INSERT INTO cloth (title, maker, price, img_body, img_front, img_back, img_detail, description, stock, sizes, colors, clothType, freq, opendate) VALUES " +
            "('Fur Jacket Grey', 'MERCI', 238400, 'product01.jpg', 'product01.jpg', 'product01.jpg', 'product01.jpg', '고급스러운 퍼 소재로 제작된 그레이 자켓입니다.\\n보온성이 뛰어나며 스타일리시한 연출이 가능합니다.', 50, 'S,M,L', 'Grey,Black', 'Outer', 10, NOW())," +
            "('Long Patch Zip Up Burgundy', 'MERCI', 118400, 'product02.jpg', 'product02.jpg', 'product02.jpg', 'product02.jpg', '유니크한 패치 디테일이 돋보이는 버건디 집업입니다.\\n편안한 착용감과 트렌디한 디자인을 제공합니다.', 30, 'FREE', 'Burgundy', 'Outer', 5, NOW())," +
            "('Thinsulate Padded Jacket Brown', 'MERCI', 214400, 'product03.jpg', 'product03.jpg', 'product03.jpg', 'product03.jpg', '신슐레이트 소재를 사용하여 가볍지만 따뜻한 패딩 자켓입니다.\\n겨울철 데일리 아이템으로 추천합니다.', 40, 'M,L,XL', 'Brown,Khaki', 'Outer', 15, NOW())," +
            "('Flower Graphic Long Sleeve White', 'MERCI', 66300, 'product04.jpg', 'product04.jpg', 'product04.jpg', 'product04.jpg', '감각적인 플라워 그래픽이 프린팅된 긴팔 티셔츠입니다.\\n단독으로 입거나 레이어드하기 좋습니다.', 100, 'S,M,L', 'White', 'Top', 20, NOW())," +
            "('Fur Jacket Camel', 'MERCI', 238400, 'product05.jpg', 'product05.jpg', 'product05.jpg', 'product05.jpg', '부드러운 터치감의 카멜 컬러 퍼 자켓입니다.\\n고급스러운 분위기를 연출해줍니다.', 25, 'S,M', 'Camel', 'Outer', 8, NOW())," +
            "('Wave Down Jacket Blue', 'MERCI', 202300, 'product06.jpg', 'product06.jpg', 'product06.jpg', 'product06.jpg', '웨이브 퀼팅 디자인이 매력적인 다운 자켓입니다.\\n경쾌한 블루 컬러가 돋보입니다.', 35, 'M,L', 'Blue', 'Outer', 12, NOW())," +
            "('Brush Symbol Knit Multi Brown', 'MERCI', 124200, 'product07.jpg', 'product07.jpg', 'product07.jpg', 'product07.jpg', '브러쉬 텍스처가 돋보이는 니트입니다.\\n따뜻한 색감으로 가을, 겨울에 잘 어울립니다.', 60, 'FREE', 'Brown', 'Top', 18, NOW())," +
            "('Fur Cowichan Hoodie Charcoal', 'MERCI', 268200, 'product08.jpg', 'product08.jpg', 'product08.jpg', 'product08.jpg', '코위찬 스타일의 후드 퍼 자켓입니다.\\n캐주얼하면서도 빈티지한 무드를 느낄 수 있습니다.', 20, 'L,XL', 'Charcoal', 'Outer', 7, NOW())," +
            "('Oversized Balaclava Knit Brown', 'MERCI', 127800, 'product09.jpg', 'product09.jpg', 'product09.jpg', 'product09.jpg', '바라클라바 디자인이 적용된 오버사이즈 니트입니다.\\n유니크한 스타일링이 가능합니다.', 45, 'FREE', 'Brown', 'Top', 25, NOW())," +
            "('Shaggy Cuff Beanie Lavender', 'MERCI', 61200, 'product10.jpg', 'product10.jpg', 'product10.jpg', 'product10.jpg', '섀기한 질감의 비니입니다.\\n라벤더 컬러로 포인트 주기 좋습니다.', 80, 'FREE', 'Lavender', 'Acc', 30, NOW())," +
            "('Chearing Fur Hoddie Grey', 'MERCI', 254400, 'product11.jpg', 'product11.jpg', 'product11.jpg', 'product11.jpg', '응원단 로고가 자수된 퍼 후드입니다.\\n귀엽고 따뜻한 느낌을 줍니다.', 30, 'S,M', 'Grey', 'Top', 11, NOW())," +
            "('Technical Comfort Slacks Brown', 'MERCI', 134300, 'product12.jpg', 'product12.jpg', 'product12.jpg', 'product12.jpg', '기능성 원단으로 제작된 편안한 슬랙스입니다.\\n데일리 오피스룩으로 적합합니다.', 55, 'S,M,L,XL', 'Brown,Black', 'Bottom', 14, NOW())," +
            "('WBE Logo Muffler Black', 'MERCI', 68500, 'product13.jpg', 'product13.jpg', 'product13.jpg', 'product13.jpg', '심플한 로고가 들어간 블랙 머플러입니다.\\n어떤 코디에도 잘 어울리는 기본 아이템입니다.', 100, 'FREE', 'Black', 'Acc', 40, NOW())," +
            "('Insulated Cap Gray', 'MERCI', 57600, 'product14.jpg', 'product14.jpg', 'product14.jpg', 'product14.jpg', '보온성이 뛰어난 패딩 캡입니다.\\n겨울철 야외 활동 시 유용합니다.', 70, 'FREE', 'Gray', 'Acc', 22, NOW())," +
            "('Classic Denim Jacket', 'MERCI', 89000, 'product02.jpg', 'product02.jpg', 'product02.jpg', 'product02.jpg', '클래식한 디자인의 데님 자켓입니다.\\n사계절 내내 활용하기 좋은 아이템입니다.', 60, 'M,L', 'Blue', 'Outer', 10, NOW())," +
            "('Striped Cotton Shirt', 'MERCI', 45000, 'product04.jpg', 'product04.jpg', 'product04.jpg', 'product04.jpg', '깔끔한 스트라이프 패턴의 코튼 셔츠입니다.\\n오피스룩이나 캐주얼룩으로 좋습니다.', 80, 'S,M,L', 'White,Blue', 'Top', 15, NOW())," +
            "('Wool Blended Coat Black', 'MERCI', 150000, 'product05.jpg', 'product05.jpg', 'product05.jpg', 'product05.jpg', '울 혼방 소재로 제작된 블랙 코트입니다.\\n모던하고 시크한 분위기를 연출합니다.', 30, 'M,L,XL', 'Black', 'Outer', 20, NOW())," +
            "('Casual Hoodie Navy', 'MERCI', 62000, 'product08.jpg', 'product08.jpg', 'product08.jpg', 'product08.jpg', '편안한 착용감의 네이비 후드티입니다.\\n데일리 아이템으로 추천합니다.', 90, 'FREE', 'Navy', 'Top', 25, NOW())," +
            "('Slim Fit Chinos Beige', 'MERCI', 54000, 'product12.jpg', 'product12.jpg', 'product12.jpg', 'product12.jpg', '슬림한 핏의 베이지 치노 팬츠입니다.\\n어디에나 매치하기 쉽습니다.', 70, '30,32,34', 'Beige', 'Bottom', 18, NOW())," +
            "('Leather Belt Brown', 'MERCI', 32000, 'product13.jpg', 'product13.jpg', 'product13.jpg', 'product13.jpg', '천연 소가죽으로 제작된 브라운 벨트입니다.\\n내구성이 뛰어나고 고급스럽습니다.', 100, 'FREE', 'Brown', 'Acc', 30, NOW())"
        };

        for (String sql : sqls) {
            stmt.executeUpdate(sql);
            out.println("Executed: " + sql.substring(0, Math.min(sql.length(), 50)) + "...");
        }
        
        conn.commit();
        out.println("\nSUCCESS: Database initialized.");
        out.println("<a href='index.jsp'>Go to Main Page</a>");

    } catch (Exception e) {
        if (conn != null) try { conn.rollback(); } catch(SQLException ex) {}
        e.printStackTrace();
        out.println("\nERROR: " + e.getMessage());
    } finally {
        JdbcUtil.close(stmt);
        JdbcUtil.close(conn);
    }
%>
</pre>
</body>
</html>