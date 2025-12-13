<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    
    List<Map<String, Object>> cartList = (List<Map<String, Object>>) session.getAttribute("cartList");
    if(cartList == null) {
        cartList = new ArrayList<>();
        session.setAttribute("cartList", cartList);
    }
    
    if("add".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String img = request.getParameter("img");
        int price = Integer.parseInt(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String size = request.getParameter("size");
        String color = request.getParameter("color");
        
        Map<String, Object> item = new HashMap<>();
        // [중요] AJAX 처리를 위해 고유 ID(UUID) 생성
        item.put("cart_id", UUID.randomUUID().toString()); 
        item.put("id", id); // 상품 ID (clothId)
        item.put("title", title);
        item.put("img", img);
        item.put("price", price);
        item.put("quantity", quantity);
        item.put("size", size);
        item.put("color", color);
        
        cartList.add(item);
        
        response.sendRedirect("catalogdetail.jsp?clothId=" + id + "&cart=added");
        
    } else if("remove".equals(action)) {
        // (기존 로직 유지하지만, 가급적 ajax 방식을 권장)
        int idx = Integer.parseInt(request.getParameter("idx"));
        if(idx >= 0 && idx < cartList.size()) {
            cartList.remove(idx);
        }
        out.println("<script>history.back();</script>");
        
    } else if("clear".equals(action)) {
        cartList.clear();
        response.sendRedirect("index.jsp");
    }
%>