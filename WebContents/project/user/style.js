document.addEventListener("DOMContentLoaded", () => {
    // 1. 히어로 로고 스크롤 효과
    const logo = document.querySelector('.hero-logo');
    const hero = document.querySelector('.hero');
    
    if(hero && logo) { // 요소가 존재할 때만 실행
        window.addEventListener('scroll', () => {
            const heroBottom = hero.offsetHeight;
            const scrollY = window.scrollY;
            if (scrollY > heroBottom * 0.6) {
                logo.classList.add('scrolled');
            } else {
                logo.classList.remove('scrolled');
            }
        });
    }

    // 2. 패널 열기/닫기 제어 변수
    const loginMenuBtn = document.getElementById("loginMenu");
    const loginPanel = document.getElementById("loginPanel");
    
    // 닫기 버튼들 (로그인화면 닫기, 회원가입화면 닫기)
    const loginCloseBtn = document.getElementById("loginCloseBtn");
    const joinCloseBtn = document.getElementById("joinCloseBtn");

    // 패널 열기
    loginMenuBtn.addEventListener("click", (e) => {
        e.preventDefault();
        loginPanel.classList.add("open");
        document.body.style.overflow = "hidden"; // 스크롤 막기
        
        // 패널 열 때 항상 로그인 화면으로 초기화
        document.getElementById("loginView").style.display = "block";
        document.getElementById("joinView").style.display = "none";
    });

    // 패널 닫기 함수
    function closePanel() {
        loginPanel.classList.remove("open");
        document.body.style.overflow = ""; // 스크롤 허용
    }

    // 닫기 버튼 이벤트 연결
    if(loginCloseBtn) loginCloseBtn.addEventListener("click", closePanel);
    if(joinCloseBtn) joinCloseBtn.addEventListener("click", closePanel);


    // 3. 로그인 <-> 회원가입 화면 전환 로직
    const loginView = document.getElementById("loginView");
    const joinView = document.getElementById("joinView");
    const btnToJoin = document.getElementById("btnToJoin");
    const btnToLogin = document.getElementById("btnToLogin");

    // 'CREATE ACCOUNT' 클릭 시 -> 회원가입 뷰 보여주기
    if(btnToJoin) {
        btnToJoin.addEventListener("click", () => {
            loginView.style.display = "none";
            joinView.style.display = "block";
        });
    }

    // 'BACK TO LOGIN' 클릭 시 -> 로그인 뷰 보여주기
    if(btnToLogin) {
        btnToLogin.addEventListener("click", () => {
            joinView.style.display = "none";
            loginView.style.display = "block";
        });
    }

    // 4. 로그인 동작 (데모용 알림)
    const loginSubmitBtn = document.querySelector("#loginView .login-btn.black");
    if(loginSubmitBtn) {
        loginSubmitBtn.addEventListener("click", () => {
            alert("로그인 성공!");
            closePanel();
        });
    }
});