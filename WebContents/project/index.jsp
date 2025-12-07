<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>MERCI</title>
<link rel="stylesheet" href="style.css">
<link rel="icon" href="images/favicon.ico">
</head>

<body>

	<!-- ========== HEADER ========== -->
	<jsp:include page="header.jsp" />

	<main>

		<!-- ========== HERO INTERACTION AREA (최상단) ========== -->
		<!-- 중앙 고정 로고 (항상 hero 위에 있어야 함) -->
		<img src="images/mainlogo.svg" class="hero-logo" alt="logo">

		<section class="hero">
			<div class="hero-inner">

				<!-- 왼쪽 큰 이미지 -->
				<div class="hero-left">
					<img src="images/heromain.png" class="hero-left-img" alt="">
				</div>

				<!-- 오른쪽 두 개 이미지 -->
				<div class="hero-right">
					<div class="hero-right-top">
						<img src="images/herorighttop.png" alt="sub look 1">
					</div>

				</div>

			</div>
		</section>


		<!-- ========== SECTION 2 : 상품 슬라이더 (옷 리스트) ========== -->

		<%
		Connection conn = null;
		List<Cloth> list = null;
		String target = request.getParameter("target");
		String errorMsg = null;
		try {
			conn = ConnectionProvider.getConnection();
			ClothDao dao = new ClothDao();
			// 메인에서는 인기순 혹은 최신순으로 가져오는 것이 일반적이지만, 여기서는 기본 리스트 사용
			list = dao.selectList(conn); 
		} catch (Exception e) {
			e.printStackTrace(); // 콘솔 로그
			errorMsg = e.getMessage(); // 화면 출력용 메시지
		} finally{
			if (conn != null) {
				try { conn.close(); } catch(SQLException ex) {}
			}
		}
		%>
		<section class="product-section">
			<h2 class="section-title">PRODUCTS</h2>
			
			<c:set var="list" value="<%=list%>" />
			<c:set var="errorMsg" value="<%=errorMsg%>" />
			
			<c:choose>
				<c:when test="${list != null && not empty list}">
					<div class="product-slider-wrapper">
						<!-- 왼쪽 화살표 -->
						<button class="slider-btn prev-btn" onclick="moveSlide(-1)">❮</button>
						
						<!-- 슬라이더 트랙 -->
						<div class="product-slider-track" id="sliderTrack">
							<c:forEach var="cloth" items="${list}">
								<div class="slider-item product-item">
									<a href="catalogdetail.jsp?clothId=${cloth.id}"> 
										<img src="uploadfile/${cloth.imgBody}" width="200" height="250">
									</a>
									<h3>${cloth.title}</h3>
									<p>₩ <fmt:formatNumber value="${cloth.price}" type="number"/></p>
								</div>
							</c:forEach>
						</div>

						<!-- 오른쪽 화살표 -->
						<button class="slider-btn next-btn" onclick="moveSlide(1)">❯</button>
					</div>
				</c:when>
				<c:otherwise>
					<div style="text-align: center; width: 100%; padding: 50px 0;">
						<p style="color: red;">데이터를 불러올 수 없습니다.</p>
						<c:if test="${not empty errorMsg}">
							<p style="color: #999; font-size: 12px;">(Error: ${errorMsg})</p>
						</c:if>
						<p><a href="setup_db.jsp" style="text-decoration: underline; font-weight: bold;">[DB 초기화 페이지로 이동]</a></p>
					</div>
				</c:otherwise>
			</c:choose>
		</section>



		<!-- ========== SECTION 3 : 콜라주 3장 (Editorial / Collage) ========== -->
		<section class="collage-section">
			<div class="collage-wrapper">

				<div class="collage-img img1">
					<img src="images/collage01.png" />
				</div>

				<div class="collage-img img2">
					<img src="images/collage02.png" />
				</div>

				<div class="collage-img img3">
					<img src="images/collage03.png" />
				</div>

			</div>
		</section>

	</main>



	<!-- ========== FOOTER ========== -->
	<jsp:include page="footer.jsp" />
	
	<!-- 장바구니 팝업 포함 -->
    <jsp:include page="cart_popup.jsp" />
    
	<script src="style.js"></script>
	<script>
        // 슬라이더 로직
        let currentIdx = 0;
        
        function moveSlide(dir) {
            const track = document.getElementById('sliderTrack');
            const items = document.querySelectorAll('.slider-item');
            const totalItems = items.length;
            
            // 화면 너비에 따라 보여지는 아이템 개수 계산 (CSS와 맞춰야 함)
            let itemsToShow = 5;
            const w = window.innerWidth;
            if(w <= 900) itemsToShow = 3;
            else if(w <= 1200) itemsToShow = 4;
            
            // 이동할 최대 인덱스
            const maxIndex = totalItems - itemsToShow;
            if (maxIndex < 0) return; // 아이템이 보여줄 개수보다 적으면 이동 안함

            // 인덱스 변경
            currentIdx += dir;
            
            // 경계 처리
            if(currentIdx < 0) currentIdx = 0;
            if(currentIdx > maxIndex) currentIdx = maxIndex;
            
            // 이동 거리 계산 (아이템 너비 + 간격 20px)
            // 정확한 계산을 위해 첫 번째 아이템의 너비를 가져옴
            const itemWidth = items[0].getBoundingClientRect().width;
            const gap = 20; 
            const moveDist = (itemWidth + gap) * currentIdx;
            
            track.style.transform = 'translateX(' + (-moveDist) + 'px)';
        }
        
        // 리사이즈 시 위치 초기화 (반응형 대응)
        window.addEventListener('resize', () => {
             moveSlide(0); 
        });
    </script>
</body>
</html>