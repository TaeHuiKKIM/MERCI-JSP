/* =========================================
   1. 스크롤 및 패널 이벤트 (로드 후 실행)
   ========================================= */
document.addEventListener('DOMContentLoaded', () => {
    // [로고 스크롤 효과]
    const logo = document.querySelector('.hero-logo');
    const hero = document.querySelector('.hero');
    if (logo && hero) {
        window.addEventListener('scroll', () => {
            const heroBottom = hero.offsetHeight;
            if (window.scrollY > heroBottom * 0.6) logo.classList.add('scrolled');
            else logo.classList.remove('scrolled');
        });
    }

    // [로그인 패널 열기/닫기]
    const loginMenu = document.getElementById("loginMenu");     // 헤더 LOGIN
    const loginPanel = document.getElementById("loginPanel");   // 패널 전체
    const loginCloseBtn = document.getElementById("loginCloseBtn"); // 로그인창 닫기
    const joinCloseBtn = document.getElementById("joinCloseBtn");   // 가입창 닫기

    // 열기
    if (loginMenu) {
        loginMenu.addEventListener("click", (e) => {
            e.preventDefault();
            loginPanel.classList.add("active");
        });
    }
    // 닫기 (로그인창)
    if (loginCloseBtn) {
        loginCloseBtn.addEventListener("click", () => {
            loginPanel.classList.remove("active");
        });
    }
    // 닫기 (가입창)
    if (joinCloseBtn) {
        joinCloseBtn.addEventListener("click", (e) => {
            e.preventDefault();
            loginPanel.classList.remove("active");
        });
    }
});

/* =========================================
   2. 화면 전환 함수 (전역 함수 - HTML onclick에서 호출 가능)
   ========================================= */
// 로그인 화면 -> 회원가입 화면 보여주기
function showJoinMode() {
    const loginView = document.getElementById('loginView');
    const joinView = document.getElementById('joinView');
    if(loginView && joinView) {
        loginView.style.display = 'none';
        joinView.style.display = 'block';
    }
}

// 회원가입 화면 -> 로그인 화면 보여주기
function showLoginMode() {
    const loginView = document.getElementById('loginView');
    const joinView = document.getElementById('joinView');
    if(loginView && joinView) {
        joinView.style.display = 'none';
        loginView.style.display = 'block';
    }
}

/* =========================================
   3. 유효성 검사 및 전송 (전역 함수)
   ========================================= */
// 정규식 패턴 정의
const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
// 비밀번호: 영문, 숫자, 특수문자 포함 8자 이상
const pwPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,}$/;

// [로그인 체크]
function loginCheck() {
    var f = document.loginForm;
    if (!f.userId.value) {
        alert("아이디를 입력하세요.");
        f.userId.focus();
        return;
    }
    if (!f.password.value) {
        alert("비밀번호를 입력하세요.");
        f.password.focus();
        return;
    }
    f.submit();
}

// [회원가입 체크]
function joinCheck() {
    var f = document.joinForm;
    var id = f.userId.value;
    var pw = f.password.value;
    var pwConfirm = f.passwordConfirm.value;
    var name = f.name.value;

    // 1. 빈칸 체크
    if (!id || !name || !pw || !pwConfirm) {
        alert("모든 정보를 입력하세요.");
        return;
    }

    // 2. 이메일 형식 체크
    if (!emailPattern.test(id)) {
        alert("아이디는 이메일 형식(예: abc@site.com)이어야 합니다.");
        f.userId.focus();
        return;
    }

    // 3. 비밀번호 복잡도 체크
    if (!pwPattern.test(pw)) {
        alert("비밀번호는 8자리 이상이며 영문, 숫자, 특수문자를 포함해야 합니다.");
        f.password.value = "";
        f.passwordConfirm.value = "";
        f.password.focus();
        return;
    }

    // 4. 비밀번호 일치 체크
    if (pw !== pwConfirm) {
        alert("비밀번호 확인이 일치하지 않습니다.");
        f.passwordConfirm.value = "";
        f.passwordConfirm.focus();
        return;
    }

    f.submit();
}