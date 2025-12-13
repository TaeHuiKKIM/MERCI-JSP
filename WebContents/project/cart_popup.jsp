<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
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
<style>
    .c-qty-ctrl { display: flex; align-items: center; gap: 5px; margin-top: 5px; }
    .c-qty-btn { width: 20px; height: 20px; background: #eee; border: none; cursor: pointer; display:flex; align-items:center; justify-content:center;}
    .c-qty-val { width: 25px; text-align: center; font-size: 12px; border:none; background:transparent;}
    .c-title a { text-decoration: none; color: inherit; }
    .c-title a:hover { text-decoration: underline; }
    .c-img { cursor: pointer; transition: transform 0.2s; }
    .c-img:hover { transform: scale(1.05); }
</style>

<div id="stickyCartBtn" onclick="toggleCartPopup()">
    <span class="cart-icon">🛒</span>
    <span class="cart-count" id="cartCountBadge"><%= (cartList != null) ? cartList.size() : 0 %></span>
</div>

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
                    // cart_id가 없으면 임시로 생성하거나 에러 방지 (기존 데이터 호환성)
                    String cartId = (String)item.get("cart_id");
                    if(cartId == null) cartId = ""; 
                %>
                <li class="cart-item" id="cart-item-<%=cartId%>">
                    
                    <a href="catalogdetail.jsp?clothId=<%=item.get("id")%>">
                        <img src="uploadfile/<%=item.get("img")%>" class="c-img">
                    </a>
                    
                    <div class="c-info">
                        <p class="c-title">
                            <a href="catalogdetail.jsp?clothId=<%=item.get("id")%>">
                                <%=item.get("title")%>
                            </a>
                        </p>
                        <p class="c-opt"><%=item.get("color")%> / <%=item.get("size")%></p>
                        
                        <div class="c-qty-ctrl">
                            <button class="c-qty-btn" onclick="updateCartQty('<%=cartId%>', -1)">-</button>
                            <input type="text" class="c-qty-val" id="qty-<%=cartId%>" value="<%=item.get("quantity")%>" readonly>
                            <button class="c-qty-btn" onclick="updateCartQty('<%=cartId%>', 1)">+</button>
                        </div>

                        <p class="c-price" id="price-<%=cartId%>">
                            ₩ <%= String.format("%,d", (Integer)item.get("price") * (Integer)item.get("quantity")) %>
                        </p>
                    </div>
                    
                    <button class="c-del" onclick="removeCartItem('<%=cartId%>')">X</button>
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
    // 수량 변경 함수 (AJAX)
    function updateCartQty(cartId, change) {
        if(!cartId) return; // ID 없으면 중단
        
        const qtyInput = document.getElementById('qty-' + cartId);
        let currentQty = parseInt(qtyInput.value);
        let newQty = currentQty + change;
        
        if(newQty < 1) return; // 1개 미만 금지

        fetch('cart_proc_ajax.jsp?action=update&cart_id=' + cartId + '&quantity=' + newQty)
            .then(res => res.json())
            .then(data => {
                if(data.status === 'success') {
                    // 화면 업데이트 (새로고침 없이 값만 변경)
                    qtyInput.value = newQty;
                    // 개별 상품 총액 업데이트 (1,000 단위 콤마)
                    document.getElementById('price-' + cartId).innerText = '₩ ' + data.itemTotal.toLocaleString();
                    // 전체 장바구니 총액 업데이트
                    document.getElementById('cartTotalDisplay').innerText = '₩ ' + data.cartTotal.toLocaleString();
                } else {
                    alert('수량 변경 실패');
                }
            })
            .catch(err => console.error('Error:', err));
    }

    // 삭제 함수 (AJAX)
    function removeCartItem(cartId) {
        if(!confirm('정말 삭제하시겠습니까?')) return;
        
        fetch('cart_proc_ajax.jsp?action=remove&cart_id=' + cartId)
            .then(response => response.json())
            .then(data => {
                if(data.status === 'success') {
                    // DOM에서 해당 리스트 아이템 삭제
                    const itemRow = document.getElementById('cart-item-' + cartId);
                    if(itemRow) {
                        itemRow.remove();
                    }
                    // 총액 및 뱃지 카운트 업데이트
                    document.getElementById('cartTotalDisplay').innerText = '₩ ' + data.total.toLocaleString();
                    document.getElementById('cartCountBadge').innerText = data.count;
                    
                    // 다 지웠으면 '비어있음' 표시 (선택사항)
                    if(data.count === 0) {
                       document.querySelector('.cart-body').innerHTML = '<p class="empty-msg">장바구니가 비어있습니다.</p>';
                    }
                } else {
                    alert('삭제 실패');
                }
            })
            .catch(error => console.error('Error:', error));
    }
</script>