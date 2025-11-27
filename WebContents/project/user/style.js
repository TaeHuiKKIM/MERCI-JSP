/* =========================================
   1. 화면 전환 및 유효성 검사 (전역 함수)
   ========================================= */

// [화면 전환] 로그인 -> 회원가입
function showJoinMode() {
    const loginView = document.getElementById('loginView');
    const joinView = document.getElementById('joinView');
    if(loginView && joinView) {
        loginView.style.display = 'none';
        joinView.style.display = 'block';
    }
}

// [화면 전환] 회원가입 -> 로그인
function showLoginMode() {
    const loginView = document.getElementById('loginView');
    const joinView = document.getElementById('joinView');
    if(loginView && joinView) {
        joinView.style.display = 'none';
        loginView.style.display = 'block';
    }
}

// [로그인 폼 검사]
function loginCheck() {
    var f = document.loginForm;
    if (!f) return;
    if (!f.userId.value) { alert("아이디를 입력하세요."); f.userId.focus(); return; }
    if (!f.password.value) { alert("비밀번호를 입력하세요."); f.password.focus(); return; }
    f.submit();
}

// [회원가입 폼 검사]
function joinCheck() {
    var f = document.joinForm;
    if (!f) return;

    var id = f.userId.value;
    var pw = f.password.value;
    var pwConfirm = f.passwordConfirm.value;
    var name = f.name.value;
    
    // 정규식
    var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
    var pwPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,}$/;

    if (!id || !name || !pw || !pwConfirm) { alert("모든 정보를 입력하세요."); return; }
    if (!emailPattern.test(id)) { alert("아이디는 이메일 형식이어야 합니다."); f.userId.focus(); return; }
    
    // 비밀번호 복잡도 (필요시 주석 해제하여 pwPattern 사용 가능)
    if (pw.length < 4) { alert("비밀번호는 4자리 이상이어야 합니다."); f.password.focus(); return; }
    
    if (pw !== pwConfirm) { 
        alert("비밀번호가 일치하지 않습니다."); 
        f.passwordConfirm.value = ""; 
        f.passwordConfirm.focus(); 
        return; 
    }
    
    f.submit();
}

// [비밀번호 변경 폼 검사]
function checkPasswordChange() {
    var f = document.pwForm;
    if (!f) { alert("비밀번호 변경 폼을 찾을 수 없습니다."); return; }

    var current = f.currentPw.value;
    var newPw = f.newPw.value;
    var confirmPw = f.confirmPw.value;

    if (!current || !newPw || !confirmPw) { alert("모든 정보를 입력해주세요."); return; }
    if (newPw !== confirmPw) { 
        alert("새 비밀번호가 일치하지 않습니다.\n다시 확인해주세요."); 
        f.confirmPw.value = ""; 
        f.confirmPw.focus(); 
        return; 
    }
    if (newPw.length < 4) { alert("비밀번호는 4자리 이상이어야 합니다."); f.newPw.focus(); return; }

    f.submit();
}


/* =========================================
   2. 페이지 로드 후 실행되는 이벤트 (통합됨)
   ========================================= */
document.addEventListener('DOMContentLoaded', () => {
    
    // [1] 로고 스크롤 효과
    const logo = document.querySelector('.hero-logo');
    const hero = document.querySelector('.hero');
    if (logo && hero) {
        window.addEventListener('scroll', () => {
            const heroBottom = hero.offsetHeight;
            if (window.scrollY > heroBottom * 0.6) logo.classList.add('scrolled');
            else logo.classList.remove('scrolled');
        });
    }

    // [2] 요소 가져오기
    const loginMenu = document.getElementById("loginMenu");
    const loginPanel = document.getElementById("loginPanel");
    const loginCloseBtn = document.getElementById("loginCloseBtn");
    const joinCloseBtn = document.getElementById("joinCloseBtn");
    
    const loginView = document.getElementById("loginView");
    const joinView = document.getElementById("joinView");

    // [3] 메인 LOGIN 버튼 클릭 -> 패널 열기 (항상 로그인창 먼저 보여줌)
    if (loginMenu) {
        loginMenu.addEventListener("click", (e) => {
            e.preventDefault();
            if(loginView && joinView) {
                loginView.style.display = "block";
                joinView.style.display = "none";
            }
            if (loginPanel) loginPanel.classList.add("active");
        });
    }

    // [4] 닫기 버튼 이벤트
    if (loginCloseBtn) {
        loginCloseBtn.addEventListener("click", () => {
            if (loginPanel) loginPanel.classList.remove("active");
        });
    }
    if (joinCloseBtn) {
        joinCloseBtn.addEventListener("click", (e) => {
            e.preventDefault();
            if (loginPanel) loginPanel.classList.remove("active");
        });
    }

    // [5] 자동 로그인 패널 열기 (?login=open 감지)
    // account.jsp 등에서 쫓겨났을 때 로그인창을 자동으로 띄워줌
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('login') === 'open') {
        // 로그인 화면으로 초기화
        if (loginView && joinView) {
            loginView.style.display = 'block';
            joinView.style.display = 'none';
        }
        // 패널 열기 (약간의 딜레이를 주어 자연스럽게)
        if (loginPanel) {
            setTimeout(() => {
                loginPanel.classList.add("active");
            }, 100);
        }
    }
});