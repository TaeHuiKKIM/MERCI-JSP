<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String action = request.getParameter("action");
    List<Map<String, Object>> cartList = (List<Map<String, Object>>) session.getAttribute("cartList");
    
    // JSON 응답 생성을 위한 StringBuilder
    StringBuilder jsonBuilder = new StringBuilder();
    
    if(cartList == null) {
        cartList = new ArrayList<>();
        session.setAttribute("cartList", cartList);
    }

    try {
        if("remove".equals(action)) {
            // 삭제 로직 (인덱스 대신 cart_id 사용 권장하나 기존 호환성 위해 idx 유지 가능)
            // 여기서는 안전하게 cart_id로 찾는 방식과 병행 가능한 구조로 작성
            String targetId = request.getParameter("cart_id");
            boolean removed = false;
            
            if(targetId != null) {
                Iterator<Map<String, Object>> iter = cartList.iterator();
                while(iter.hasNext()){
                    if(targetId.equals(iter.next().get("cart_id"))){
                        iter.remove();
                        removed = true;
                        break;
                    }
                }
            }
            
            if(removed) {
                // 삭제 후 남은 총액 계산
                int newTotal = 0;
                for(Map<String, Object> item : cartList) {
                    newTotal += (Integer)item.get("price") * (Integer)item.get("quantity");
                }
                jsonBuilder.append("{\"status\": \"success\", \"total\": " + newTotal + ", \"count\": " + cartList.size() + "}");
            } else {
                jsonBuilder.append("{\"status\": \"error\", \"message\": \"Item not found\"}");
            }

        } else if("update".equals(action)) {
            // [추가됨] 수량 변경 로직
            String targetId = request.getParameter("cart_id");
            int newQty = Integer.parseInt(request.getParameter("quantity"));
            
            if(newQty < 1) newQty = 1; // 최소 수량 방어
            
            int itemTotal = 0;
            boolean updated = false;
            
            for(Map<String, Object> item : cartList) {
                if(targetId.equals(item.get("cart_id"))) {
                    item.put("quantity", newQty);
                    updated = true;
                    itemTotal = (Integer)item.get("price") * newQty;
                    break;
                }
            }
            
            if(updated) {
                // 전체 총액 재계산
                int cartTotal = 0;
                for(Map<String, Object> item : cartList) {
                    cartTotal += (Integer)item.get("price") * (Integer)item.get("quantity");
                }
                // 응답: 성공여부, 해당아이템총액, 전체총액
                jsonBuilder.append("{");
                jsonBuilder.append("\"status\": \"success\", ");
                jsonBuilder.append("\"itemTotal\": " + itemTotal + ", ");
                jsonBuilder.append("\"cartTotal\": " + cartTotal);
                jsonBuilder.append("}");
            } else {
                jsonBuilder.append("{\"status\": \"error\", \"message\": \"Update failed\"}");
            }
        }
    } catch(Exception e) {
        jsonBuilder.append("{\"status\": \"error\", \"message\": \"").append(e.getMessage()).append("\"}");
    }
    
    out.print(jsonBuilder.toString());
%>