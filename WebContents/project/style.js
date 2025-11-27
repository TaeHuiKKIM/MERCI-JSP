/* =========================================
   1. 화면 전환 함수 (전역 함수 - HTML onclick에서 호출 가능)
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
   2. 유효성 검사 및 전송 (전역 함수)
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

/* =========================================
   3. 패널 열기/닫기 및 초기화 (핵심 수정됨)
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

    // [요소 가져오기]
    const loginMenu = document.getElementById("loginMenu");
    const loginPanel = document.getElementById("loginPanel");
    const loginCloseBtn = document.getElementById("loginCloseBtn");
    const joinCloseBtn = document.getElementById("joinCloseBtn");
    
    const loginView = document.getElementById("loginView");
    const joinView = document.getElementById("joinView");

    // [★중요★] 메인 LOGIN 버튼 클릭 시 -> 무조건 로그인 창으로 초기화 후 열기
    if (loginMenu) {
        loginMenu.addEventListener("click", (e) => {
            e.preventDefault();
            
            // 1. 화면 상태를 '로그인'으로 강제 초기화
            if(loginView && joinView) {
                loginView.style.display = "block";
                joinView.style.display = "none";
            }
            
            // 2. 패널 열기
            loginPanel.classList.add("active");
        });
    }

    // [로그인 창에서 CLOSE 클릭] -> 그냥 닫기
    if (loginCloseBtn) {
        loginCloseBtn.addEventListener("click", () => {
            loginPanel.classList.remove("active");
        });
    }

    // [회원가입 창에서 CLOSE 클릭] -> 그냥 닫기 (다음에 열면 위 코드 때문에 로그인창 뜸)
    if (joinCloseBtn) {
        joinCloseBtn.addEventListener("click", (e) => {
            e.preventDefault(); // 새로고침 방지
            loginPanel.classList.remove("active");
        });
    }
});
document.addEventListener('DOMContentLoaded', () => {
    
    // ... (기존 로고 스크롤, 버튼 클릭 이벤트 코드들) ...

    // [★추가할 코드] 주소창에 ?login=open이 있으면 로그인 패널 강제 열기
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('login') === 'open') {
        const loginPanel = document.getElementById("loginPanel");
        // 로그인 화면 보여주기 (혹시 회원가입 화면일 수 있으니 초기화)
        const loginView = document.getElementById('loginView');
        const joinView = document.getElementById('joinView');
        
        if (loginView && joinView) {
            loginView.style.display = 'block';
            joinView.style.display = 'none';
        }
        
        // 패널 스르륵 열기
        if (loginPanel) {
            setTimeout(() => {
                loginPanel.classList.add("active");
            }, 100); // 자연스럽게 보이기 위해 0.1초 뒤 실행
        }
    }
});
/* =========================================
   4. 비밀번호 변경 유효성 검사 (추가됨)
   ========================================= */
function checkPasswordChange() {
    var f = document.pwForm; // 폼 이름(name="pwForm")으로 가져오기
    
    // 폼이 없는 경우 에러 방지
    if (!f) {
        alert("비밀번호 변경 폼을 찾을 수 없습니다.");
        return;
    }

    var current = f.currentPw.value;
    var newPw = f.newPw.value;
    var confirmPw = f.confirmPw.value;

    // 1. 빈칸 검사
    if (!current || !newPw || !confirmPw) {
        alert("모든 정보를 입력해주세요.");
        return;
    }

    // 2. 새 비밀번호 일치 검사
    if (newPw !== confirmPw) {
        alert("새 비밀번호가 일치하지 않습니다.\n다시 확인해주세요.");
        f.confirmPw.value = ""; // 틀린 부분 비우기
        f.confirmPw.focus();
        return;
    }
    
    // 3. 비밀번호 길이 검사
    if (newPw.length < 4) {
        alert("비밀번호는 4자리 이상이어야 합니다.");
        f.newPw.focus();
        return;
    }

    // 4. 모든 검사 통과 시 서버로 전송
    f.submit();
}