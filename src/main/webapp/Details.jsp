<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<html>
<head>
	<link rel="stylesheet" href="style.css">
    <title>DonutDen</title> <!-- Itles the tab-->
    <link rel="icon" href="assets/Donut-Icon.png" type="image/png" /> <!-- this gives the icon to a tab-->
</head>
<body>
    <h1><%= doughnut.getName() %></h1>
    <%
        List<Doughnut> doughnuts = Doughnut.getDoughnuts();
    %>
    <table>
        <thead>
            <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Doughnut doughnut : doughnuts) {
            %>
            <tr>
                <td><%= doughnut.getName() %></td>
                <td><%= doughnut.getDescription() %></td>
                <td>$<%= String.format("%.2f", doughnut.getPrice()) %></td>
                <td><%= doughnut.getStatus() ? "Available" : "Not Available" %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>