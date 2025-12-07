<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, my.model.*" %>
<%
    // 세션에서 장바구니 가져오기 (List<Map<String, Object>> 구조로 가정)
    // Map 키: id, title, price, img, quantity, size, color
    List<Map<String, Object>> cartList = (List<Map<String, Object>>) session.getAttribute("cartList");
    int cartTotal = 0;
    if(cartList != null) {
        for(Map<String, Object> item : cartList) {
            int p = (Integer)item.get("price");
            int q = (Integer)item.get("quantity");
            cartTotal += (p * q);
        }
    }
%>
<!-- 스티키 장바구니 버튼 -->
<div id="stickyCartBtn" onclick="toggleCartPopup()">
    <span class="cart-icon">🛒</span>
    <span class="cart-count"><%= (cartList != null) ? cartList.size() : 0 %></span>
</div>

<!-- 장바구니 팝업 -->
<div id="cartPopup">
    <div class="cart-header">
        <h3>YOUR CART</h3>
        <button onclick="toggleCartPopup()" class="close-cart">X</button>
    </div>
    <div class="cart-body">
        <% if(cartList == null || cartList.isEmpty()) { %>
            <p class="empty-msg">장바구니가 비어있습니다.</p>
        <% } else { %>
            <ul class="cart-items">
                <% for(int i=0; i<cartList.size(); i++) { 
                    Map<String, Object> item = cartList.get(i);
                %>
                <li class="cart-item">
                    <img src="uploadfile/<%=item.get("img")%>" class="c-img">
                    <div class="c-info">
                        <p class="c-title"><%=item.get("title")%></p>
                        <p class="c-opt"><%=item.get("color")%> / <%=item.get("size")%></p>
                        <p class="c-price">₩ <%= String.format("%,d", item.get("price")) %> x <%=item.get("quantity")%></p>
                    </div>
                    <button class="c-del" onclick="location.href='cart_proc.jsp?action=remove&idx=<%=i%>'">X</button>
                </li>
                <% } %>
            </ul>
        <% } %>
    </div>
    <div class="cart-footer">
        <div class="c-total">
            <span>TOTAL</span>
            <span>₩ <%= String.format("%,d", cartTotal) %></span>
        </div>
        <button class="checkout-btn" onclick="location.href='order_form.jsp'">CHECKOUT</button>
    </div>
</div>
