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
        // 파라미터 수신
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String img = request.getParameter("img");
        int price = Integer.parseInt(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String size = request.getParameter("size");
        String color = request.getParameter("color");

        // 맵 생성 및 추가
        Map<String, Object> item = new HashMap<>();
        item.put("id", id);
        item.put("title", title);
        item.put("img", img);
        item.put("price", price);
        item.put("quantity", quantity);
        item.put("size", size);
        item.put("color", color);
        
        cartList.add(item);
        
        // Redirect with success flag
        response.sendRedirect("catalogdetail.jsp?clothId=" + id + "&cart=added");
        
    } else if("remove".equals(action)) {
        int idx = Integer.parseInt(request.getParameter("idx"));
        if(idx >= 0 && idx < cartList.size()) {
            cartList.remove(idx);
        }
        // 이전 페이지로
        out.println("<script>history.back();</script>");
        
    } else if("clear".equals(action)) {
        cartList.clear();
        response.sendRedirect("index.jsp");
    }
%>
