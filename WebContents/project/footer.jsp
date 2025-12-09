<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .footer {
        background-color: #1b0f0a;
        color: #fff;
        padding: 80px 0 60px;
        margin-top: 150px;
    }
    .footer-columns {
        max-width: 1600px;
        margin: 0 auto;
        padding: 0 60px;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 80px;
    }
    .footer-col { flex: 1; }
    .footer-col h3 {
        font-size: 16px;
        margin-bottom: 18px;
        font-weight: 700;
    }
    .footer-col p, .footer-col a {
        font-size: 14px;
        line-height: 1.8;
        color: #fff;
        text-decoration: none;
    }
    .footer-col a:hover { opacity: 0.7; }
    .footer-bottom {
        max-width: 1600px;
        margin: 50px auto 0;
        padding: 0 60px;
        display: flex;
        justify-content: space-between;
        font-size: 13px;
        color: #ccc;
    }
</style>
<footer class="footer">
    <div class="footer-columns">
        <div class="footer-col">
            <h3>CUSTOMER SERVICE</h3>
            <p>MEMBERSHIP</p>
            <p>CONTACT</p>
            <p><a href="${pageContext.request.contextPath}/project/qna/list.jsp" style="color: inherit; text-decoration: none;">Q&A BOARD</a></p>
            <p>SHIPPING & RETURNS</p>
        </div>

        <div class="footer-col">
            <h3>COMPANY</h3>
            <p>MERCI</p>
            <p>대표 : 김태희, 김소희, 방현익 | 사업자등록번호 : 123-45-67890</p>
            <p>주소 : 경기도 시흥시 산기대학로</p>
            <p>이메일 :MERCI@gmail.com</p>
            <p>고객센터 : 070-1234-5678</p>
        </div>

        <div class="footer-col">
            <h3>LEGAL</h3>
            <p>PRIVACY POLICY</p>

            <h3 style="margin-top: 30px;">SOCIAL</h3>
            <p>INSTAGRAM</p>
            <p>KAKAOTALK</p>
        </div>
    </div>

    <div class="footer-bottom">
        <span>© MERCI 2025</span>
    </div>
</footer>