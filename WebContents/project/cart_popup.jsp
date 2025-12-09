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
                <li class="cart-item" id="cart-item-<%=i%>">
                    <img src="uploadfile/<%=item.get("img")%>" class="c-img">
                    <div class="c-info">
                        <p class="c-title"><%=item.get("title")%></p>
                        <p class="c-opt"><%=item.get("color")%> / <%=item.get("size")%></p>
                        <p class="c-price" data-price="<%= (Integer)item.get("price") * (Integer)item.get("quantity") %>">
                            ₩ <%= String.format("%,d", item.get("price")) %> x <%=item.get("quantity")%>
                        </p>
                    </div>
                    <button class="c-del" onclick="removeCartItem(<%=i%>)">X</button>
                </li>
                <% } %>
            </ul>
        <% } %>
    </div>
    <div class="cart-footer">
        <div class="c-total">
            <span>TOTAL</span>
            <span id="cartTotalDisplay">₩ <%= String.format("%,d", cartTotal) %></span>
        </div>
        <button class="checkout-btn" onclick="location.href='order_form.jsp'">구매하기</button>
    </div>
</div>

<script>
    function removeCartItem(idx) {
        if(!confirm('정말 삭제하시겠습니까?')) return;
        
        fetch('cart_proc_ajax.jsp?action=remove&idx=' + idx)
            .then(response => response.json())
            .then(data => {
                if(data.status === 'success') {
                    // Remove item from DOM
                    // Since idx is index, but after deletion indices shift server-side.
                    // For simple UI update, we can reload or remove. 
                    // However, removing specific index from DOM is tricky if list isn't re-rendered.
                    // Safest way without React/Vue is to reload the page or re-fetch cart.
                    // BUT user asked for visible deletion.
                    // Let's reload to ensure sync, but 'history.back()' was the issue. 
                    // location.reload() might be better. 
                    // OR, simply remove the element and update total.
                    // Warning: Sequential deletes might fail if we don't sync indices.
                    // Best approach for this legacy setup: Reload content of cart popup or reload page.
                    // Given the constraint, let's reload the page which is better than history.back().
                    // Wait, user wants to SEE it deleted.
                    
                    // Let's try DOM removal + Reload on next action if needed?
                    // No, let's use location.reload() as it is reliable for index sync.
                    location.reload(); 
                } else {
                    alert('삭제 실패');
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>
