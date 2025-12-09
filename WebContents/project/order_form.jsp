<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, my.dao.*, my.model.*, my.util.*" %>
<%
    String userId = (String) session.getAttribute("userId");
    if(userId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='index.jsp?login=open';</script>");
        return;
    }

    // 장바구니 확인
    List<Map<String, Object>> cartList = (List<Map<String, Object>>) session.getAttribute("cartList");
    if(cartList == null || cartList.isEmpty()) {
        out.println("<script>alert('장바구니가 비어있습니다.'); history.back();</script>");
        return;
    }

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
<style>
    .checkout-container { width: 800px; margin: 100px auto; }
    .checkout-title { font-size: 24px; font-weight: 700; margin-bottom: 30px; text-align: center; }
    .order-section { margin-bottom: 40px; border-top: 2px solid #000; padding-top: 20px; }
    .section-head { font-size: 16px; font-weight: 700; margin-bottom: 15px; }
    
    .order-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .order-table th, .order-table td { padding: 12px; border-bottom: 1px solid #eee; text-align: center; font-size: 13px; }
    .order-table th { background: #f9f9f9; }
    
    .form-group { margin-bottom: 15px; }
    .form-label { display: block; font-size: 13px; margin-bottom: 5px; font-weight: 600; }
    .form-input { width: 100%; padding: 10px; border: 1px solid #ddd; font-size: 13px; }
    .addr-select { width: 100%; padding: 10px; border: 1px solid #ddd; font-size: 13px; margin-bottom: 15px; background: #f9f9f9; }
    
    .payment-info { background: #f5f5f5; padding: 20px; text-align: right; }
    .final-price { font-size: 20px; font-weight: 700; color: #d00; }
    
    .pay-btn { width: 100%; padding: 15px; background: #000; color: #fff; font-size: 16px; font-weight: 700; cursor: pointer; border: none; margin-top: 20px; }
</style>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="style.js"></script>
<script>
    var savedAddresses = [
        <% 
        if(addrList != null) {
            for(int i=0; i<addrList.size(); i++) {
                DeliveryAddress addr = addrList.get(i);
        %>
            {
                id: <%=addr.getAddrId()%>,
                name: "<%=addr.getAddrName()%>",
                recipient: "<%=addr.getRecipientName()%>",
                phone: "<%=addr.getPhone()%>",
                road: "<%=addr.getAddrRoad()%>",
                detail: "<%=addr.getAddrDetail()%>"
            }<%= (i < addrList.size() - 1) ? "," : "" %>
        <% 
            }
        } 
        %>
    ];

    function changeAddress(select) {
        var selectedValue = select.value;
        var form = document.orderForm;
        
        if (selectedValue === "new") {
            form.receiverName.value = "";
            form.receiverPhone.value = "";
            document.getElementById("roadAddress").value = "";
            document.getElementById("detailAddress").value = "";
            return;
        }

        // Find selected address data
        for(var i=0; i<savedAddresses.length; i++) {
            if(savedAddresses[i].id == selectedValue) {
                var addr = savedAddresses[i];
                form.receiverName.value = addr.recipient;
                form.receiverPhone.value = addr.phone;
                document.getElementById("roadAddress").value = addr.road;
                document.getElementById("detailAddress").value = addr.detail;
                break;
            }
        }
    }
</script>
</head>
<body>
    <header class="header">
        <div class="header-inner">
            <div class="header-logo"><a href="index.jsp"><img src="images/mainlogo.png"></a></div>
            <nav class="header-nav"><a href="product.jsp">BACK TO SHOP</a></nav>
        </div>
    </header>

    <div class="checkout-container">
        <h2 class="checkout-title">ORDER SHEET</h2>
        
        <form action="order_proc.jsp" method="post" name="orderForm">
            <!-- 1. 주문 상품 정보 -->
            <div class="order-section">
                <p class="section-head">PRODUCT INFO</p>
                <table class="order-table">
                    <tr>
                        <th>IMAGE</th>
                        <th>PRODUCT</th>
                        <th>OPTION</th>
                        <th>QTY</th>
                        <th>PRICE</th>
                    </tr>
                    <% for(Map<String, Object> item : cartList) { %>
                    <tr>
                        <td><img src="uploadfile/<%=item.get("img")%>" width="40"></td>
                        <td style="text-align:left;"><%=item.get("title")%></td>
                        <td><%=item.get("color")%> / <%=item.get("size")%></td>
                        <td><%=item.get("quantity")%></td>
                        <td><%= String.format("%,d", (Integer)item.get("price") * (Integer)item.get("quantity")) %></td>
                    </tr>
                    <% } %>
                </table>
            </div>

            <!-- 2. 배송지 정보 -->
            <div class="order-section">
                <p class="section-head">SHIPPING INFO</p>
                
                <% if(addrList != null && !addrList.isEmpty()) { %>
                <select class="addr-select" onchange="changeAddress(this)">
                    <option value="new">-- New Address --</option>
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
                    <label class="form-label">Recipient</label>
                    <input type="text" name="receiverName" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getRecipientName() : "" %>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Phone</label>
                    <input type="text" name="receiverPhone" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getPhone() : "" %>" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Address</label>
                    <div style="display:flex; gap:10px; margin-bottom:5px;">
                        <input type="text" id="postcode" class="form-input" style="width:100px;" placeholder="Zip" readonly>
                        <button type="button" onclick="execDaumPostcode()" style="padding:0 10px; cursor:pointer;">Find</button>
                    </div>
                    <input type="text" id="roadAddress" name="addr1" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getAddrRoad() : "" %>" placeholder="Road Address" readonly style="margin-bottom:5px;">
                    <input type="text" id="detailAddress" name="addr2" class="form-input" value="<%= (defaultAddr != null) ? defaultAddr.getAddrDetail() : "" %>" placeholder="Detail Address">
                    <input type="hidden" id="extraAddress">
                </div>
            </div>

            <!-- 3. 결제 정보 -->
            <div class="order-section">
                <p class="section-head">PAYMENT INFO</p>
                <div class="form-group">
                    <label class="form-label">Depositor Name (입금자명)</label>
                    <input type="text" name="depositor" class="form-input" required placeholder="무통장 입금자명을 입력하세요">
                </div>
                <div class="payment-info">
                    <p>TOTAL AMOUNT</p>
                    <p class="final-price">₩ <%= String.format("%,d", totalAmount) %></p>
                    <input type="hidden" name="totalAmount" value="<%=totalAmount%>">
                </div>
            </div>

            <button type="submit" class="pay-btn">PLACE ORDER</button>
        </form>
    </div>
</body>
</html>
