<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>ABOUT - MERCI</title>
    <link rel="stylesheet" href="style.css">
    <link rel="icon" href="images/favicon.ico">
    <style>
        /* 초기화 및 레이아웃 */
        body, html { height: 100%; margin: 0; }
        
        .about-hero {
            position: relative;
            width: 100%;
            height: 100vh; /* 화면 꽉 차게 */
            background-image: url('images/about_custom.png?t=<%=new java.util.Date().getTime()%>');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* 텍스트 가독성을 위한 어두운 오버레이 */
        .about-overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.4); 
            z-index: 1;
        }
        
        .about-text-container {
            position: relative;
            z-index: 2; /* 오버레이 위로 배치 */
            max-width: 1000px;
            padding: 0 40px;
            text-align: left; /* 전체 텍스트 컨테이너는 왼쪽 정렬 */
            color: #fff;
            display: flex; /* 플렉스 컨테이너로 설정 */
            justify-content: center; /* 가운데 정렬 */
            align-items: center; /* 세로 중앙 정렬 */
            gap: 40px; /* 컬럼 간 간격 */
        }
        
        .about-column {
            flex: 1; /* 가용한 공간을 균등하게 분배 */
            max-width: 45%; /* 각 컬럼의 최대 너비 */
        }

        .about-eng {
            font-size: 24px; /* 데스크탑에서 글자 크기 줄임 */
            font-weight: 700;
            line-height: 1.4;
            letter-spacing: 0.02em;
            margin-bottom: 20px; /* 간격 조정 */
            text-transform: uppercase;
            word-break: keep-all;
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        
        .about-kor {
            font-size: 16px; /* 데스크탑에서 글자 크기 줄임 */
            line-height: 1.8;
            font-weight: 400;
            opacity: 0.9;
            word-break: keep-all;
            text-shadow: 0 1px 5px rgba(0,0,0,0.3);
        }
        
        /* 반응형 처리 */
        @media (max-width: 768px) {
            .about-eng { font-size: 20px; margin-bottom: 15px; } /* 모바일에서 글자 크기 다시 조정 및 간격 */
            .about-kor { font-size: 14px; } /* 모바일에서 글자 크기 다시 조정 */
            .about-text-container {
                flex-direction: column; /* 모바일에서는 컬럼을 세로로 쌓음 */
                text-align: center; /* 모바일에서는 다시 중앙 정렬 */
                gap: 20px;
            }
            .about-column {
                max-width: 100%; /* 모바일에서는 전체 너비 사용 */
                padding: 0;
            }
        }
    </style>
</head>
<body>

    <!-- HEADER -->
    <!-- 헤더 배경을 투명하게 하거나 스타일을 덮어쓰기 위해 style 추가 가능 -->
    <jsp:include page="header.jsp" />

    <main>
        <section class="about-hero">
            <div class="about-overlay"></div>
            
            <div class="about-text-container">
                <div class="about-column">
                    <div class="about-eng">
                        MERCI BRINGS SUBURBAN VITALITY INTO THE CITY,<br>
                        OFFERING WOMEN AN ACTIVE LIFESTYLE AND FASHION<br>
                        THAT FUSE EVERYDAY URBAN LIFE WITH EXTRAORDINARY ENERGY.
                    </div>
                </div>
                <div class="about-column">
                    <div class="about-kor">
                        MERCI는 도시에 사는 여성들에게 교외적인 생동감을 불어넣을 수 있는 새로운 라이프스타일과 패션을 제안합니다.<br>
                        자연과 도시가 만나는 순간을 담아내며, 일상 속에서 편안하게 입을 수 있는 실루엣과 활동적인 에너지를 동시에 전달합니다.
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- FOOTER -->
    <jsp:include page="footer.jsp" />
    
    <jsp:include page="cart_popup.jsp" />
    <script src="style.js"></script>
    
    <!-- 헤더 스타일 오버라이드 (이 페이지에서만 헤더가 이미지 위에 겹치도록) -->
    <style>
        /* about 페이지에서는 헤더가 투명하거나 자연스럽게 어우러지도록 설정 */
        .header {
            background: rgba(0,0,0,0.3) !important;
            border-bottom: none !important;
        }
        .header-logo a, .header-nav a {
            color: #fff !important;
        }
        .header-nav a:hover {
            opacity: 0.8;
        }
        /* 메인 컨텐츠 상단 여백 제거 (이미지가 최상단부터 시작하도록) */
        main { margin-top: 0 !important; }
    </style>
</body>
</html>