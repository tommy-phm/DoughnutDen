<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Report</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
	<header class="headerBanner">
		<h1 class="headerMain" style="display: flex; align-items: center; text-decoration: none;">
			<a href="Menu.jsp"> 
				<img src="images/Doughnut-Icon.png" style=" width: 50px;" />
			 	Doughnut Den
			</a>
		</h1>
		<a style="margin-left: 10%;" href="Menu.jsp">
			<button class="nav-button">Menu</button>
		</a>
		<div class="nav-dropdown">
				
		    <button class="nav-button">Staff Portal</button>
			<div class="dropdown-content">
				<a href="MenuEdit.jsp">Edit Menu</a>
				<a href="TrayEdit.jsp">Edit Tray</a>
				<a href="TransactionEdit.jsp">Edit Transaction</a>
				<a href="Report.jsp">Report</a>
			</div>
		</div>
		
		<a href="Receipt.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="images/User_icon.png"/>
		</a>
		<a href="Cart.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="images/cart.png"/>
		</a>
	</header>
	
	<h2>Report</h2>
    
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
