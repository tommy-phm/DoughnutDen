<%@ page import="store.Doughnut" %>
<html>
<head>
    <link rel="stylesheet" href="styles.css">
    <title>DoughnutDen</title>
    <link rel="icon" href="assets/Doughnut-Icon.png" type="image/png" />
</head>
<body>
<%
    String pathInfo = request.getPathInfo(); 
    int doughnutId = 0;

    if (pathInfo != null && pathInfo.length() > 1) {
        try {
            doughnutId = Integer.parseInt(pathInfo.substring(1));
        } catch (NumberFormatException e) {
            out.println("<p>Invalid Doughnut ID format.</p>");
        }
    } else {
        out.println("<p>Doughnut ID missing or incorrect.</p>");
    }

    Doughnut doughnut = Doughnut.getDoughnutById(doughnutId);

    if (doughnut != null) {
%>
	<img src="../images/<%=doughnut.getId()%>.png"
		onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
	<span style="display: none;">No Image</span>
	<h1><%=doughnut.getName()%></h1>
        <p><strong>Description:</strong> <%= doughnut.getDescription() %></p>
        <p><strong>Price:</strong> $<%= doughnut.getPrice() %></p>
        <p><strong>Category:</strong> <%= doughnut.getCategoryName() %></p>

	<form action="../Cart" method="post">
        <input type="hidden" name="doughnutId" value="<%= doughnut.getId() %>">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" min="1" value="1" required>
        <button type="submit">Add to Cart</button>
    	</form>
<%
    } else {
        out.println("<p>Doughnut not found.</p>");
    }
%>
</body>
</html>
