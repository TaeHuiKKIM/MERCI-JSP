<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, my.dao.*, my.util.*"%>
<%
    String userName = (String) session.getAttribute("userName");
    String userId = (String) session.getAttribute("userId");
    if (userId == null || !"admin".equals(userId)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // 데이터 조회
    Map<String, Integer> dailySales = new LinkedHashMap<>();
    Map<String, Integer> categoryCount = new HashMap<>();
    
    Connection conn = null;
    try {
        conn = ConnectionProvider.getConnection();
        OrderDao orderDao = new OrderDao();
        dailySales = orderDao.getDailySales(conn);
        
        ClothDao clothDao = new ClothDao();
        categoryCount = clothDao.getCategoryCount(conn);
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        JdbcUtil.close(conn);
    }
    
    // JSON 변환
    StringBuilder dateLabels = new StringBuilder("[");
    StringBuilder salesData = new StringBuilder("[");
    int i = 0;
    for(String key : dailySales.keySet()) {
        if(i > 0) { dateLabels.append(","); salesData.append(","); }
        dateLabels.append("'").append(key).append("'");
        salesData.append(dailySales.get(key));
        i++;
    }
    dateLabels.append("]");
    salesData.append("]");

    StringBuilder catLabels = new StringBuilder("[");
    StringBuilder catData = new StringBuilder("[");
    i = 0;
    for(String key : categoryCount.keySet()) {
        if(i > 0) { catLabels.append(","); catData.append(","); }
        catLabels.append("'").append(key).append("'");
        catData.append(categoryCount.get(key));
        i++;
    }
    catLabels.append("]");
    catData.append("]");
    
    String root = request.getContextPath() + "/project";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>ADMIN DASHBOARD - MERCI ADMIN</title>
<link rel="icon" href="../images/favicon.ico">
<link rel="stylesheet" href="<%=root%>/style.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    .dash-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
    @media(max-width: 900px) { .dash-grid { grid-template-columns: 1fr; } }
</style>
</head>
<body class="admin-body">

	<!-- ========== HEADER ========== -->
	<jsp:include page="header.jsp" />

	<div class="admin-container">
        <div class="admin-page-title">
            <span>DASHBOARD</span>
            <span style="font-size: 14px; color: #777; font-weight: 400;">Welcome, Administrator</span>
        </div>
        
        <div class="dash-grid">
            <!-- Sales Chart -->
            <div class="admin-card">
                <h3>Weekly Sales Trend</h3>
                <div style="position: relative; height: 300px; width: 100%;">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>
            
            <!-- Category Chart -->
            <div class="admin-card">
                <h3>Inventory by Category</h3>
                <div style="position: relative; height: 300px; width: 100%; display: flex; justify-content: center;">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>
        </div>
	</div>

    <script>
        // Sales Chart
        const ctxSales = document.getElementById('salesChart').getContext('2d');
        new Chart(ctxSales, {
            type: 'line',
            data: {
                labels: <%=dateLabels.toString()%>,
                datasets: [{
                    label: 'Sales (₩)',
                    data: <%=salesData.toString()%>,
                    borderColor: '#007bff',
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    borderWidth: 2,
                    pointBackgroundColor: '#fff',
                    pointBorderColor: '#007bff',
                    pointRadius: 4,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false } },
                    y: { beginAtZero: true, border: { dash: [4, 4] } }
                }
            }
        });

        // Category Chart
        const ctxCat = document.getElementById('categoryChart').getContext('2d');
        new Chart(ctxCat, {
            type: 'doughnut',
            data: {
                labels: <%=catLabels.toString()%>,
                datasets: [{
                    data: <%=catData.toString()%>,
                    backgroundColor: [
                        '#2c3e50', '#e74c3c', '#ecf0f1', '#3498db', '#f1c40f'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: { 
                    legend: { position: 'right' } 
                }
            }
        });
    </script>

	<!-- ========== FOOTER ========== -->
	<jsp:include page="../footer.jsp" />

</body>
</html>