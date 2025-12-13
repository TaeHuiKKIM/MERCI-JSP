<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, my.dao.*, my.model.*, my.util.*" %>
<%
    String userId = (String) session.getAttribute("userId");
    if(userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='index.jsp?login=open';</script>");
        return;
    }
    
    // 장바구니 확인 (이전 단계에서 선택된 항목들만 넘어왔거나, 전체 목록이라고 가정)
    List<Map<String, Object>> cartList = (List<Map<String, Object>>) session.getAttribute("cartList");
    if(cartList == null || cartList.isEmpty()) {
        out.println("<script>alert('장바구니가 비어있습니다.'); history.back();</script>");
        return;
    }
    
    // 전체 주문 금액 계산 (선택 로직이 빠졌으므로 여기서 계산된 값이 최종 결제 금액입니다)
    int totalAmount = 0;
    for(Map<String, Object> item : cartList) {
        totalAmount += (Integer)item.get("price") * (Integer)item.get("quantity");
    }
    
    // 기본 배송지 및 전체 배송지 목록 조회
    DeliveryAddress defaultAddr = null;
    List<DeliveryAddress> addrList = null;
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        DeliveryAddressDao dao = new DeliveryAddressDao();
        defaultAddr = dao.selectDefault(conn, userId);
        addrList = dao.selectList(conn, userId);
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(conn);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ORDER - MERCI</title>
<link rel="icon" href="images/favicon.ico">
<link rel="stylesheet" href="style.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
<script src="style.js"></script>
<script>
    // 배송지 목록 데이터
    var savedAddresses = [
        <% 
        if(addrList != null) {
            for(int i=0; i<addrList.size(); i++) {
                DeliveryAddress addr = addrList.get(i);
                String zip = (addr.getZipcode() == null) ? "" : addr.getZipcode();
        %>
            {
                id: <%=addr.getAddrId()%>,
                name: "<%=addr.getAddrName()%>",
                recipient: "<%=addr.getRecipientName()%>",
                phone: "<%=addr.getPhone()%>",
                zipcode: "<%=zip%>",
                road: "<%=addr.getAddrRoad()%>",
                detail: "<%=addr.getAddrDetail()%>"
            }<%= (i < addrList.size() - 1) ? "," : "" %>
        <% 
            }
        } 
        %>
    ];

    // 배송지 변경 함수
    function changeAddress(select) {
        var selectedValue = select.value;
        var form = document.orderForm;
        
        if (selectedValue === "new") {
            form.receiverName.value = "";
            form.receiverPhone.value = "";
            document.getElementById("postcode").value = "";
            document.getElementById("roadAddress").value = "";
            document.getElementById("detailAddress").value = "";
            return;
        }
        
        for(var i=0; i<savedAddresses.length; i++) {
            if(savedAddresses[i].id == selectedValue) {
                var addr = savedAddresses[i];
                form.receiverName.value = addr.recipient;
                form.receiverPhone.value = addr.phone;
                document.getElementById("postcode").value = addr.zipcode;
                document.getElementById("roadAddress").value = addr.road;
                document.getElementById("detailAddress").value = addr.detail;
                break;
            }
        }
    }

    // --- PortOne V2 결제 요청 ---
    async function checkPayment(e) {
        e.preventDefault(); 
        var form = document.orderForm;
        
        // 필수 입력값 검증
        if(!form.receiverName.value || !form.receiverPhone.value || !document.getElementById("detailAddress").value) {
            alert("배송지 정보를 모두 입력해주세요.");
            return false;
        }
        
        var postcodeVal = document.getElementById("postcode").value;
        if(!postcodeVal) {
            alert("우편번호를 입력해주세요.");
            return false;
        }

        // 체크박스 로직이 사라졌으므로 hidden input에 있는 고정된 총액을 가져옵니다.
        var currentTotalAmount = parseInt(form.totalAmount.value);

        var method = document.querySelector('input[name="payMethod"]:checked').value;
        var channelKeyToUse = "";
        var payMethodToUse = "";
        var easyPayOption = undefined;

        if (method === 'kakaopay') {
            channelKeyToUse = "channel-key-5a5e4804-a215-4506-bb64-91a13fb31e06";
            payMethodToUse = "EASY_PAY";
            easyPayOption = { provider: "KAKAOPAY" };
        } else if (method === 'general') {
            channelKeyToUse = "channel-key-fd9c016a-7e83-4d01-96c3-8377214cee24"; 
            payMethodToUse = "CARD";
        }

        try {
            const response = await PortOne.requestPayment({
                storeId: "store-4ad37cda-c027-4827-92ce-356e9b8ca025",
                channelKey: channelKeyToUse,
                paymentId: "ORD" + new Date().getTime(),
                orderName: "MERCI Ordered Items",
                totalAmount: currentTotalAmount,
                currency: "CURRENCY_KRW",
                payMethod: payMethodToUse,
                easyPay: easyPayOption,
                customer: {
                    fullName: form.receiverName.value,
                    phoneNumber: form.receiverPhone.value,
                    email: "test@merci.com",
                    address: {
                        addressLine1: document.getElementById("roadAddress").value,
                        addressLine2: document.getElementById("detailAddress").value,
                    },
                    zipcode: postcodeVal
                }
            });

            if (response.code != null) {
                alert("결제 실패: " + response.message);
                return false;
            }

            document.querySelector('input[name="paymentId"]').value = response.paymentId;
            form.submit();
        } catch (err) {
            console.error(err);
            alert("결제 시스템 오류: " + (err.message || err));
        }
    }
</script>
</head>
<body>
    <header class="header">
        <div class="header-inner">
            <div class="header-logo"><a href="index.jsp"><img src="images/mainlogo.png"></a></div>
            <nav class="header-nav"><a href="product.jsp">쇼핑 계속하기</a></nav>
        </div>
    </header>
    
    <div class="checkout-container">
        <h2 class="checkout-title">주문서 작성</h2>
        
        <form action="order_proc.jsp" method="post" name="orderForm" onsubmit="checkPayment(event)">
            <input type="hidden" name="paymentId" value="">
            
            <div class="order-section">
                <p class="section-head">주문 상품 정보</p>
                
                <table class="order-table">
                    <colgroup>
                        <col width="10%">
                        <col width="*">
                        <col width="15%">
                        <col width="10%">
                        <col width="15%">
                    </colgroup>
                    <tr>
                        <th>이미지</th>
                        <th>상품명</th>
                        <th>옵션</th>
                        <th>수량</th>
                        <th>가격</th>
                    </tr>
                    <% for(Map<String, Object> item : cartList) { 
                       int itemPrice = (Integer)item.get("price");
                       int quantity = (Integer)item.get("quantity");
                       int rowTotal = itemPrice * quantity;
                    %>
                    <tr>
                        <td><img src="uploadfile/<%=item.get("img")%>" width="40"></td>
                        
                        <td>
                            <span style="color: black;">
                                <%=item.get("title")%>
                            </span>
                        </td>
                        
                        <td><%=item.get("color")%> / <%=item.get("size")%></td>
                        <td><%=quantity%></td>
                        <td><%= String.format("%,d", rowTotal) %>원</td>
                    </tr>
                    <% } %>
                </table>
            </div>

            <div class="order-section">
                <p class="section-head">배송지 정보</p>
                
                <% if(addrList != null && !addrList.isEmpty()) { %>
                <select class="addr-select" onchange="changeAddress(this)">
                    <option value="new">-- 새로운 배송지 --</option>
                    <% for(DeliveryAddress addr : addrList) { 
                        boolean isSelected = (defaultAddr != null && defaultAddr.getAddrId() == addr.getAddrId());
                    %>
                    <option value="<%=addr.getAddrId()%>" <%=isSelected ? "selected" : ""%>>
                        [<%=addr.getAddrName()%>] <%=addr.getAddrRoad()%> (<%=addr.getRecipientName()%>)
                    </option>
                    <% } %>
                </select>
                <% } %>
                
                <div class="form-group">
                    <label class="form-label">받는 분</label>
                    <input type="text" name="receiverName" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getRecipientName() : "" %>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">휴대전화</label>
                    <input type="text" name="receiverPhone" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getPhone() : "" %>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">주소</label>
                    <div style="display:flex; gap:10px; margin-bottom:5px;">
                        <input type="text" id="postcode" class="form-input" style="width:100px;" placeholder="우편번호" readonly>
                        <button type="button" onclick="execDaumPostcode()" style="padding:0 10px; cursor:pointer;">주소 찾기</button>
                    </div>
                    <input type="text" id="roadAddress" name="addr1" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getAddrRoad() : "" %>" placeholder="도로명 주소" readonly style="margin-bottom:5px;">
                    <input type="text" id="detailAddress" name="addr2" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getAddrDetail() : "" %>" placeholder="상세 주소">
                    <input type="hidden" id="extraAddress">
                </div>
            </div>

            <div class="order-section">
                <p class="section-head">결제 정보</p>
                <div class="form-group">
                    <label class="form-label">결제 수단</label>
                    <div style="margin-top: 10px; display: flex; gap: 20px; align-items: center;">
                        <label style="cursor: pointer; display: flex; align-items: center;">
                            <input type="radio" name="payMethod" value="general" checked style="margin-right: 5px;">
                            일반결제 (카드/간편결제)
                        </label>
                        <label style="cursor: pointer; display: flex; align-items: center;">
                            <input type="radio" name="payMethod" value="kakaopay" style="margin-right: 5px;">
                            카카오페이 (테스트)
                        </label>
                    </div>
                </div>
                <div class="payment-info">
                    <p>총 결제 금액</p>
                    <p class="final-price">₩ <%= String.format("%,d", totalAmount) %></p>
                    <input type="hidden" name="totalAmount" value="<%=totalAmount%>">
                </div>
            </div>
            
            <button type="submit" class="pay-btn" style="margin-bottom: 60px;">결제하기</button>
        </form>
    </div>
    
    </body>
</html>