<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String action = request.getParameter("action");
    
    // Manual JSON construction to avoid dependency issues
    StringBuilder jsonBuilder = new StringBuilder();
    
    List<Map<String, Object>> cartList = (List<Map<String, Object>>) session.getAttribute("cartList");
    if(cartList == null) {
        cartList = new ArrayList<>();
        session.setAttribute("cartList", cartList);
    }

    if("remove".equals(action)) {
        try {
            int idx = Integer.parseInt(request.getParameter("idx"));
            if(idx >= 0 && idx < cartList.size()) {
                cartList.remove(idx);
                jsonBuilder.append("{\"status\": \"success\"}");
            } else {
                jsonBuilder.append("{\"status\": \"error\", \"message\": \"Invalid index\"}");
            }
        } catch(Exception e) {
            jsonBuilder.append("{\"status\": \"error\", \"message\": \"").append(e.getMessage()).append("\"}");
        }
    } else {
        jsonBuilder.append("{\"status\": \"error\", \"message\": \"Invalid action\"}");
    }
    
    out.print(jsonBuilder.toString());
%>