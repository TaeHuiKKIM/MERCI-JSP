/* style.js - 최종 수정본 */

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
    
    var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
    // 비밀번호: 영문, 숫자, 특수문자 포함 8자 이상
    var pwPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,}$/;

    if (!id || !name || !pw || !pwConfirm) { alert("모든 정보를 입력하세요."); return; }
    if (!emailPattern.test(id)) { alert("아이디는 이메일 형식이어야 합니다."); f.userId.focus(); return; }
    
    // 비밀번호 정규식 체크
    if (!pwPattern.test(pw)) { 
        alert("비밀번호는 8자리 이상이어야 하며,\n영문, 숫자, 특수문자를 모두 포함해야 합니다."); 
        f.password.focus(); 
        return; 
    }
    
    if (pw !== pwConfirm) { 
        alert("비밀번호가 일치하지 않습니다."); 
        f.passwordConfirm.value = ""; 
        f.passwordConfirm.focus(); 
        return; 
    }
    
    f.submit();
}

// [비밀번호 변경 폼 검사] - 정규식 적용됨
function checkPasswordChange() {
    var f = document.pwForm;
    
    // 폼 존재 여부 확인
    if (!f) { alert("비밀번호 변경 폼을 찾을 수 없습니다."); return; }

    var current = f.currentPw.value;
    var newPw = f.newPw.value;
    var confirmPw = f.confirmPw.value;

    // 1. 빈칸 검사
    if (!current || !newPw || !confirmPw) { 
        alert("모든 정보를 입력해주세요."); 
        return; 
    }

    // 2. 기존 비밀번호와 새 비밀번호가 같은지 검사
    if (current === newPw) {
        alert("새 비밀번호는 기존 비밀번호와 다르게 설정해야 합니다.");
        f.newPw.value = "";
        f.confirmPw.value = "";
        f.newPw.focus();
        return;
    }

    // 3. 정규식 패턴 정의
    var pwPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,}$/;

    // 4. 새 비밀번호 유효성 검사
    if (!pwPattern.test(newPw)) {
        alert("새 비밀번호는 8자리 이상이어야 하며,\n영문, 숫자, 특수문자를 모두 포함해야 합니다.");
        f.newPw.value = "";       
        f.confirmPw.value = "";   
        f.newPw.focus();          
        return; 
    }

    // 5. 새 비밀번호 일치 검사
    if (newPw !== confirmPw) { 
        alert("새 비밀번호 확인이 일치하지 않습니다.\n다시 확인해주세요."); 
        f.confirmPw.value = ""; 
        f.confirmPw.focus(); 
        return; 
    }

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

    // [3] 메인 LOGIN 버튼 클릭 -> 패널 열기
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

    // [5] 자동 로그인 패널 열기 (?login=open)
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('login') === 'open') {
        if (loginView && joinView) {
            loginView.style.display = 'block';
            joinView.style.display = 'none';
        }
        if (loginPanel) {
            setTimeout(() => {
                loginPanel.classList.add("active");
            }, 100);
        }
    }

    // [6] Product Carousel Logic (Added)
    const track = document.getElementById('track');
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');

    if (track && prevBtn && nextBtn) {
        let currentIndex = 0;
        const items = document.querySelectorAll('.slide-item');
        const totalItems = items.length;
        const itemsVisible = 5; // Show 5 items at a time
        
        function updateCarousel() {
             const translateX = -(currentIndex * 20); // 20% per item
             track.style.transform = `translateX(${translateX}%)`;
             
             // Disable buttons at limits
             if (currentIndex === 0) {
                 prevBtn.style.opacity = "0.5";
                 prevBtn.style.pointerEvents = "none";
             } else {
                 prevBtn.style.opacity = "1";
                 prevBtn.style.pointerEvents = "auto";
             }
             
             const maxIndex = totalItems - itemsVisible;
             if (currentIndex >= maxIndex) {
                 nextBtn.style.opacity = "0.5";
                 nextBtn.style.pointerEvents = "none";
             } else {
                 nextBtn.style.opacity = "1";
                 nextBtn.style.pointerEvents = "auto";
             }
        }

        prevBtn.addEventListener('click', () => {
            if (currentIndex > 0) {
                currentIndex--;
                updateCarousel();
            }
        });

        nextBtn.addEventListener('click', () => {
             const maxIndex = totalItems - itemsVisible;
             if (currentIndex < maxIndex) {
                 currentIndex++;
                 updateCarousel();
             }
        });
        
        // Initial call to set button states
        updateCarousel();
    }
});
/* ================= 배송지 모달 기능 ================= */
function openAddrModal() {
    const modal = document.getElementById('addrModal');
    if(modal) modal.classList.add('show');
}

function closeAddrModal() {
    const modal = document.getElementById('addrModal');
    if(modal) modal.classList.remove('show');
}
