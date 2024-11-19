<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="store.Report"%>
<html>
<head>
    <title>DoughnutDen - Sales Report</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="icon" href="images/Doughnut-Icon.png" type="image/png" />
</head>
<body>
<header class="headerBanner">
    <h1 class="headerMain">
        <a href="Menu.jsp">
            <img src="images/Doughnut-Icon.png" />
            Doughnut Den
        </a>
    </h1>
    <div class="headerIcons">
        <a href="StaffPortal.jsp">
            <img src="images/User_icon.png" />
        </a>
    </div>
</header>

<h1>Doughnut Sales Report</h1>

<div class="portal-container">
    <form method="get" action="Report">
        <label for="startDate">Start Date:</label>
        <input type="date" id="startDate" name="startDate" required>
        
        <label for="endDate">End Date:</label>
        <input type="date" id="endDate" name="endDate" required>
        
        <button type="submit" class="button">Generate Report</button>
    </form>
</div>

<div class="table-container">
    <table class="styled-table">
        <thead>
            <tr>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Sale</th>
                <th>Sold Qty</th>
                <th>Fresh Qty</th>
                <th>Stale Qty</th>
                <th>Total Qty</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Report> report = (List<Report>) request.getAttribute("report");
                if (report != null) {
                    for (Report row : report) {
            %>
            <tr>
                <td><%= row.getName() %></td>
                <td><%= row.getCategoryName() %></td>
                <td>$<%= row.getPrice() %></td>
                <td>$<%= row.getTotalSales() %></td>
                <td><%= row.getQuantitySold() %></td>
                <td><%= row.getFreshQty() %></td>
                <td><%= row.getStaleQty() %></td>
                <td><%= row.getTotalQty() %></td>
            </tr>
            <% 
                    }
                } else { 
            %>
            <tr>
                <td colspan="8" class="no-data">No data available</td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
