/* style.js - 최종 수정본 */

/* =========================================
   1. 화면 전환 및 유효성 검사 (전역 함수)
   ========================================= */

// [화면 전환] 로그인 -> 회원가입
function showJoinMode() {
	const loginView = document.getElementById('loginView');
	const joinView = document.getElementById('joinView');
	if (loginView && joinView) {
		loginView.style.display = 'none';
		joinView.style.display = 'block';
	}
}

// [화면 전환] 회원가입 -> 로그인
function showLoginMode() {
	const loginView = document.getElementById('loginView');
	const joinView = document.getElementById('joinView');
	if (loginView && joinView) {
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
	var findQ = f.findQ.value;
	var findA = f.findA.value;

	var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
	// 비밀번호: 영문, 숫자, 특수문자 포함 8자 이상
	var pwPattern = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,}$/;

	if (!id || !name || !pw || !pwConfirm) { alert("모든 정보를 입력하세요."); return; }
	if (!findQ || !findA) { alert("비밀번호 찾기 질문과 답변을 입력하세요."); return; }
	
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
			if (loginView && joinView) {
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
});
/* ================= 배송지 모달 기능 ================= */
function openAddrModal() {
	const modal = document.getElementById('addrModal');
	if (modal) modal.classList.add('show');
}

function closeAddrModal() {
	const modal = document.getElementById('addrModal');
	if (modal) modal.classList.remove('show');
}
/* =========================================
   5. 배송지 관리 리스트 기능 (추가됨)
   ========================================= */

// 현재 선택된 주소 ID를 저장할 변수 (전역 변수)
let currentSelectedId = null;

// [주소 박스 클릭 시 실행] 테두리 표시 및 ID 저장
function selectAddr(element, id) {
	// 1. 기존에 선택된 모든 박스에서 'selected' 클래스 제거
	const allItems = document.querySelectorAll('.addr-item');
	allItems.forEach(item => item.classList.remove('selected'));

	// 2. 지금 클릭한 박스에만 'selected' 클래스 추가
	element.classList.add('selected');

	// 3. 선택된 ID 저장
	currentSelectedId = id;
}

// [하단 버튼 클릭 시 실행] 액션 처리 (기본설정, 수정, 삭제)
function doAction(mode) {
	// 선택된 배송지가 없으면 경고
	if (currentSelectedId === null) {
		alert("먼저 목록에서 배송지를 선택해주세요.");
		return;
	}

	if (mode === 'default') {
		if (confirm("이 주소를 기본 배송지로 설정하시겠습니까?")) {
			// 같은 user 폴더 안에 있으므로 파일명만 적습니다.
			location.href = "address_action.jsp?mode=default&id=" + currentSelectedId;
		}
	} else if (mode === 'edit') {
		location.href = "address_edit.jsp?id=" + currentSelectedId;
	} else if (mode === 'delete') {
		if (confirm("정말 삭제하시겠습니까?")) {
			location.href = "address_action.jsp?mode=delete&id=" + currentSelectedId;
		}
	}
}
/* =========================================
   6. 다음(Kakao) 주소 찾기 API 기능
   ========================================= */
function execDaumPostcode() {
	// daum 객체는 html에서 라이브러리를 로딩해야 존재합니다.
	new daum.Postcode({
		oncomplete: function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수

			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				addr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if (data.userSelectedType === 'R') {
				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
				if (extraAddr !== '') {
					extraAddr = ' (' + extraAddr + ')';
				}
				// 조합된 참고항목을 해당 필드에 넣는다.
				// (주의: HTML에 id="extraAddress"가 없다면 이 줄은 에러가 날 수 있으니, hidden input이 있는지 확인하세요)
				var extraInput = document.getElementById("extraAddress");
				if (extraInput) extraInput.value = extraAddr;

			} else {
				var extraInput = document.getElementById("extraAddress");
				if (extraInput) extraInput.value = '';
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById('postcode').value = data.zonecode;

			// [중요] 도로명 주소 + 참고항목을 같이 넣어줌
			document.getElementById("roadAddress").value = addr + extraAddr;

			// 커서를 상세주소 필드로 이동한다.
			document.getElementById("detailAddress").focus();
		}
	}).open();
}
/* =========================================
   7. 계정 삭제 (2중 확인)
   ========================================= */
function deleteAccount() {
    // 1차 확인
    var msg1 = "정말 계정을 삭제하시겠습니까?\n삭제하시면 모든 정보가 삭제되며 되돌릴 수 없습니다.";
    
    if (confirm(msg1)) {
        // 2차 확인 (확인 버튼을 누르면 한 번 더 물어봄)
        var msg2 = "정말 삭제하시겠습니까? (마지막 확인)";
        
        if (confirm(msg2)) {
            // 모두 확인을 누르면 삭제 처리 페이지로 이동
            // (user 폴더 안에 있다면 파일명만, 밖에 있다면 user/ 붙여야 함. 현재 account.jsp 기준)
            location.href = "delete_account.jsp"; 
        }
    }
    // 취소를 누르면 아무 일도 일어나지 않습니다.
}

/* =========================================
   8. 장바구니 팝업 토글
   ========================================= */
function toggleCartPopup() {
    var popup = document.getElementById('cartPopup');
    if(popup) {
        popup.classList.toggle('show');
    }
}

/* =========================================
   9. 관리자 페이지 유틸리티 (Q&A, Order)
   ========================================= */
function toggleAnswer(rowId) {
    var row = document.getElementById(rowId);
    if(row.style.display === 'none' || row.style.display === '') {
        row.style.display = 'table-row';
    } else {
        row.style.display = 'none';
    }
}

function toggleTrackingInput(select, orderId) {
    var val = select.value;
    var carrier = document.getElementById('carrier_' + orderId);
    var trackNum = document.getElementById('trackNum_' + orderId);
    
    if(val === '배송중' || val === '배송완료') {
        if(carrier) carrier.style.display = 'inline-block';
        if(trackNum) trackNum.style.display = 'inline-block';
    } else {
        if(carrier) carrier.style.display = 'none';
        if(trackNum) trackNum.style.display = 'none';
    }
}
