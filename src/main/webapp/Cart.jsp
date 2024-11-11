<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="store.Doughnut" %>

<%
    HttpSession session = request.getSession();
    List<Doughnut> cart = (List<Doughnut>) session.getAttribute("cart");
    
    Map<Doughnut, Integer> doughnutQuantities = new HashMap<>();

    if (cart != null) {
        for (Doughnut d : cart) {
            int id = d.getId();
            if (doughnutQuantities.containsKey(id)) {
                doughnutQuantities.put(d, doughnutQuantities.get(id) + 1);
            } else {
                doughnutQuantities.put(d, 1);
            }
        }
    }
%>

<html>
<head>
    <title>Shopping Cart</title>
</head>
<body>
    <h1>Your Cart</h1>
    <table border="1">
        <tr>
            <th>Doughnut Name</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Total Price</th>
            <th>Actions</th>
        </tr>

        <%
            double grandTotal = 0.0;
            for (Map.Entry<Doughnut, Integer> entry : doughnutQuantities.entrySet()) {
            	Doughnut d = entry.getKey();
                int quantity = entry.getValue();
                double totalPrice = d.getPrice() * quantity;
                grandTotal += totalPrice;
        %>
            <tr>
                <td><%= d.getName() %></td>
                <td><%= quantity %></td>
                <td>$<%= d.getPrice() %></td>
                <td>$<%= String.format("%.2f", totalPrice) %></td>
                <td>
                    <form action="Cart" method="post" style="display:inline;">
                        <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
                        <button type="submit">Add</button>
                    </form>
                    <form action="RemoveDoughnut" method="post" style="display:inline;">
                        <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
                        <button type="submit">Remove</button>
                    </form>
                </td>
            </tr>
        <%
            }
        %>
        <tr>
            <td colspan="3" style="text-align:right;"><b>Grand Total:</b></td>
            <td>$<%= String.format("%.2f", grandTotal) %></td>
            <td></td>
        </tr>
    </table>
</body>
</html>
