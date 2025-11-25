document.addEventListener('DOMContentLoaded', () => {
    const logo = document.querySelector('.hero-logo');
    const hero = document.querySelector('.hero');

    window.addEventListener('scroll', () => {
        const heroBottom = hero.offsetHeight; // hero 높이
        const scrollY = window.scrollY;

        if (scrollY > heroBottom * 0.6) {
            logo.classList.add('scrolled');
        } else {
            logo.classList.remove('scrolled');
        }
    });
});
// ========== LOGIN PANEL OPEN/CLOSE ==========

// 로그인 버튼 요소
const loginBtn = document.getElementById("loginMenu");  // 네가 만든 LOGIN 메뉴 위치
const loginPanel = document.getElementById("loginPanel");
const loginCloseBtn = document.getElementById("loginCloseBtn");

// 열기
loginBtn.addEventListener("click", (e) => {
    e.preventDefault();
    loginPanel.classList.add("open");
});

// 닫기
loginCloseBtn.addEventListener("click", () => {
    loginPanel.classList.remove("open");
});
document.addEventListener('DOMContentLoaded', () => {
	const logo = document.querySelector('.hero-logo');
	const hero = document.querySelector('.hero');

	window.addEventListener('scroll', () => {
		const heroBottom = hero.offsetHeight; // hero 높이
		const scrollY = window.scrollY;

		if (scrollY > heroBottom * 0.6) {
			logo.classList.add('scrolled');
		} else {
			logo.classList.remove('scrolled');
		}
	});
});


// 1. 비밀번호 패턴 검사 (숫자+영문+특수문자, 8자리 이상)
function checkPasswordPattern(str) {
	var pattern1 = /[0-9]/;
	var pattern2 = /[a-zA-Z]/;
	var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/;
	if (!pattern1.test(str) || !pattern2.test(str) || !pattern3.test(str) || str.length < 8) {
		alert("비밀번호는 8자리 이상 문자, 숫자, 특수문자로 구성하여야 합니다.");
		return false;
	}
	return true;
}

// 2. 이메일 형식 검사 (@ 포함)
function checkEmailPattern(str) {
	var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
	if (!emailPattern.test(str)) {
		alert("아이디는 이메일 형식(예: abc@site.com)으로 입력해야 합니다.");
		return false;
	}
	return true;
}

// 3. 로그인 버튼 클릭 시
function loginCheck() {
	var f = document.loginForm;
	if (!f.userId.value || !f.password.value) {
		alert("아이디와 비밀번호를 입력하세요.");
		return;
	}
	// (선택) 로그인 할 때도 이메일 형식을 체크하려면 아래 주석 해제
	/*
	if (!checkEmailPattern(f.userId.value)) {
		f.userId.focus();
		return;
	}
	*/
	f.submit();
}

// 4. 회원가입 버튼 클릭 시
function joinCheck() {
	var f = document.joinForm;
	var id = f.userId.value;
	var pw = f.password.value;
	var pwConfirm = f.passwordConfirm.value;
	var name = f.name.value;

	if (!id || !name || !pw) {
		alert("모든 정보를 입력하세요.");
		return;
	}
	// 아이디 이메일 체크
	if (!checkEmailPattern(id)) {
		f.userId.focus();
		return;
	}
	// 비밀번호 복잡도 체크
	if (!checkPasswordPattern(pw)) {
		f.password.value = "";
		f.passwordConfirm.value = "";
		f.password.focus();
		return;
	}
	// 비밀번호 확인 일치 체크
	if (pw !== pwConfirm) {
		alert("비밀번호 확인이 일치하지 않습니다.");
		f.passwordConfirm.value = "";
		f.passwordConfirm.focus();
		return;
	}
	f.submit();
}

// 5. 화면 전환 (로그인 <-> 가입)
document.getElementById("btnToJoin").onclick = function() {
	document.getElementById("loginView").style.display = "none";
	document.getElementById("joinView").style.display = "block";
};

document.getElementById("btnToLogin").onclick = function() {
	document.getElementById("joinView").style.display = "none";
	document.getElementById("loginView").style.display = "block";
};