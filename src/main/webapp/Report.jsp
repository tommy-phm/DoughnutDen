<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>DoughnutDen - Report</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<header class="headerBanner">
    <h1 class="headerMain">
        <a href="Menu.jsp">
            <img src="images/Doughnut-Icon.png"/>
            Doughnut Den
        </a>
    </h1>
    <div class="headerIcons">
        <a href="StaffPortal.jsp">
            <img src="images/User_icon.png"/>
        </a>
    </div>
</header>
	
	<h1>Report</h1>
    
    <!-- Form to input DoughnutID and Timer Period -->
    <form method="get" action="Report">
        <label for="doughnutId">Enter Doughnut ID:</label>
        <input type="number" name="doughnutId" id="doughnutId" required>
        
        <label for="timePeriod">Select Time Period:</label>
        <select name="timePeriod" id="timePeriod" required>
            <option value="day">Day</option>
            <option value="month">Month</option>
            <option value="year">Year</option>
        </select>
        
        <label for="date">Enter Date:</label>
        <input type="date" name="date" id="date" required>
        
        <button type="submit">Generate Report</button>
    </form>

    <hr>
    
    <!-- Display Report Results -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p style="color: red;"><%= error %></p>
    <%
        } else {
            String doughnutName = (String) request.getAttribute("doughnutName");
            String categoryName = (String) request.getAttribute("categoryName");
            Double doughnutPrice = (Double) request.getAttribute("doughnutPrice");
            Integer totalQty = (Integer) request.getAttribute("totalQty");
            Integer freshQty = (Integer) request.getAttribute("freshQty");
            Integer staleQty = (Integer) request.getAttribute("staleQty");
            Integer totalAmountSold = (Integer) request.getAttribute("totalAmountSold");
            Double totalSales = (Double) request.getAttribute("totalSales");

            if (doughnutName != null) {
    %>
    	<div class="R-Content">
    		<div class="R-Item">
                <h2><%= doughnutName %></h2>
                <br>
                <p><strong>Category:</strong> <%= categoryName %></p>
                <p><strong>Price:</strong> $<%= String.format("%.2f", doughnutPrice) %></p>
                <br>
            </div>
            
            <div class="R-Item">
                <p><strong>Total Quantity:</strong> <%= totalQty %></p>
                <p><strong>Fresh Quantity:</strong> <%= freshQty %></p>
                <p><strong>Stale Quantity:</strong> <%= staleQty %></p>
                <br>
            </div>
            
            <div class="R-Item">
                <p><strong>Total Amount Sold:</strong> <%= totalAmountSold %></p>
                <p><strong>Total Sales:</strong> $<%= String.format("%.2f", totalSales) %></p>
            </div>
            
        </div>
    <%
            }
        }
    %>
</body>
</html>
