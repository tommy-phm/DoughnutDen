<%@ page import="store.Doughnut" %>
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
		<td><img src="../images/<%= doughnut.getId() %>.png"></td>
        <h1><%= doughnut.getName() %></h1>
        <p><strong>Description:</strong> <%= doughnut.getDescription() %></p>
        <p><strong>Price:</strong> $<%= doughnut.getPrice() %></p>
        <p><strong>Status:</strong> <%= doughnut.getStatus() ? "Available" : "Unavailable" %></p>
<%
    } else {
        out.println("<p>Doughnut not found.</p>");
    }
%>
