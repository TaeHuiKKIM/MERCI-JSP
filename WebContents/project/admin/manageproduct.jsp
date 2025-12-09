<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.sql.*, java.util.*, my.dao.*, my.model.*, my.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    // Admin Check
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>상품 관리 - MERCI</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
<style>
    /* Additional styles for product management */
    .search-area {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 20px;
    }
    .search-form { display: flex; gap: 10px; align-items: center; }
</style>
</head>

<body class="admin-body">

	<!-- HEADER -->
	<jsp:include page="header.jsp" />

	<div class="admin-container">
        
        <div class="admin-page-title">
            <span>상품 관리</span>
            <a href="product_insert_form.jsp" class="btn-admin btn-admin-primary">+ 새 상품 등록</a>
        </div>
	
        <div class="search-area">
            <h3 style="margin:0; font-size: 16px;">상품 목록</h3>
            <form action="manageproduct.jsp" method="post" class="search-form">
                <select name="target" class="admin-select" style="width: auto;">
                    <option value="title">상품명</option>
                    <option value="maker">제조사</option>
                </select>
                <input name="keyword" type="text" class="admin-input" placeholder="검색어 입력..." style="width: 200px;"> 
                <button type="submit" class="btn-admin btn-admin-dark">검색</button>
            </form>
        </div>
	
        <%
        Connection conn = ConnectionProvider.getConnection();
        List<Cloth> list = null;
        String target = request.getParameter("target");
        String keyword = request.getParameter("keyword");
        
        try {
            ClothDao dao = new ClothDao();
            if (keyword != null && !keyword.trim().isEmpty()) {
                list = dao.selectLike(conn, target, keyword);
            } else {
                list = dao.selectList(conn); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(conn);
        }
        %> 
        
        <div class="admin-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="50">ID</th>
                        <th width="80">이미지</th>
                        <th>상품명</th>
                        <th width="120">카테고리</th>
                        <th width="120">가격</th>
                        <th width="120">제조사</th>
                        <th width="150">관리</th>
                    </tr>
                </thead>
                <tbody>
                <c:set var="list" value="<%=list%>" />
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="cloth" items="${list}">
                            <tr>
                                <td>${cloth.id}</td>
                                <td>
                                    <img src="../uploadfile/${cloth.imgBody}?t=<%=new java.util.Date().getTime()%>" 
                                         width="40" height="40" style="object-fit: cover; border-radius: 4px;">
                                </td>
                                <td style="font-weight: 600;">${cloth.title}</td>
                                <td><span class="badge badge-dark">${cloth.clothType}</span></td>
                                <td>₩ <fmt:formatNumber value="${cloth.price}" type="number"/></td>
                                <td>${cloth.maker}</td>
                                <td>
                                    <button class="btn-admin btn-admin-outline" 
                                            onclick="location.href='product_update_form.jsp?clothId=${cloth.id}'">수정</button>
                                    <button class="btn-admin btn-admin-outline" style="color: #dc3545; border-color: #dc3545;"
                                            onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='product_delete_proc.jsp?clothId=${cloth.id}'">삭제</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="7" style="text-align: center; padding: 50px; color: #999;">상품이 없습니다.</td></tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
	</div>

	<!-- FOOTER -->
	<jsp:include page="../footer.jsp" />

</body>
</html>