<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="store.Doughnut" %>


<%
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
    
 // Handle removing a doughnut from the cart
    String doughnutIdToRemove = request.getParameter("doughnutId");
    if (doughnutIdToRemove != null) {
        int idToRemove = Integer.parseInt(doughnutIdToRemove);
        
        // Iterate over the cart and remove the doughnut with the given ID
        for (int i = 0; i < cart.size(); i++) {
            Doughnut d = cart.get(i);
            if (d.getId() == idToRemove) {
                // Remove the doughnut from the cart
                cart.remove(i);
                break;
            }
        }

        // Rebuild the doughnutQuantities map after removal
        doughnutQuantities.clear();
        for (Doughnut d : cart) {
            if (doughnutQuantities.containsKey(d)) {
                doughnutQuantities.put(d, doughnutQuantities.get(d) + 1);
            } else {
                doughnutQuantities.put(d, 1);
            }
        }
        session.setAttribute("cart", cart); // Update the session with the new cart
    }
%>

<html>

<head>
<link rel="stylesheet" href="styles.css">
    <title>Shopping Cart</title>
    <h3 class="headerSub">
        <div class="nav-dropdown">
            <button>Dropdown</button>
            <div class="dropdown-content">
                <a href="Cart.jsp">View Cart</a>
                <a href="TODO">Storefront</a>
                <a href="TODO">Employee Portal</a>
                <a href="TODO">About Us</a>
            </div>
        </div> 
    </h3>
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
                    <form action="Cart" method="post" style="display:inline;">
                        <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
                        <button type="submit" name="remove" value="true">Remove One</button>
                    </form>
                    <form action="Cart" method="post" style="display:inline;">
                        <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
                        <button type="submit" name="removeAll" value="true">Remove All</button>
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
    
    <!-- Checkout Button -->
    <form action="Receipt.jsp" method="post">
        <button type="submit">Checkout</button>
    </form>
</body>
</html>
