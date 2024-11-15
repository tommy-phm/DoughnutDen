<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="store.Doughnut" %>


<%
    List<Doughnut> cart = (List<Doughnut>) session.getAttribute("cart");
	if (cart == null) {
	    cart = new ArrayList<>();
	    session.setAttribute("cart", cart);  
        Doughnut testDoughnut = new Doughnut(1, "Taco", "Taco", 10, true, 1,"test");
        cart.add(testDoughnut);
        
        String insertSql = "INSERT INTO Doughnuts (name, description, price, status, categoryID, categoryName) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/database", "root", "Cg11262003!");
        try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
            stmt.setString(1, "Test Donut");
            stmt.setString(2, "A sample donut for testing");
            stmt.setDouble(3, 1.99);
            stmt.setBoolean(4, true);
            stmt.setInt(5, 1);
            stmt.setString(6, "test");
            stmt.executeUpdate();
        }
	 catch (SQLException e) {
        e.printStackTrace();
	 }
	}

	
	    
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
        <!-- Flexbox container for the cart -->
    <div style="display: flex; flex-direction: column; gap: 10px; background-color: var(--bg-contrast-color); padding: 20px; border-radius: 8px;">

        <!-- Header Row -->
        <div style="display: flex; justify-content: space-between; font-weight: bold; text-align: center; padding: 10px; background-color: var(--header-color);">
            <div style="flex: 2;">Doughnut Name</div>
            <div style="flex: 1;">Quantity</div>
            <div style="flex: 1;">Price</div>
            <div style="flex: 1;">Total Price</div>
            <div style="flex: 1;">Actions</div>
        </div>

        <!-- Cart Items -->
        <%
            double grandTotal = 0.0;
            for (Map.Entry<Doughnut, Integer> entry : doughnutQuantities.entrySet()) {
                Doughnut d = entry.getKey();
                int quantity = entry.getValue();
                double totalPrice = d.getPrice() * quantity;
                grandTotal += totalPrice;
        %>
        <div style="display: flex; justify-content: space-between; padding: 10px; background-color: var(--bg-color); border-radius: 4px;">
            <div style="flex: 2;"><%= d.getName() %></div>
            <div style="flex: 1; text-align: center;"><%= quantity %></div>
            <div style="flex: 1; text-align: center;">$<%= d.getPrice() %></div>
            <div style="flex: 1; text-align: center;">$<%= String.format("%.2f", totalPrice) %></div>
            <div style="flex: 1; text-align: center;">
                <form action="RemoveDoughnut" method="post" style="display:inline;">
                    <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
                    <button type="submit" style="all: unset; cursor: pointer; background-color: var(--layer1-color); border-radius: 4px; padding: 5px;">Remove</button>
                </form>
            </div>
        </div>
        <%
            }
        %>

        <!-- Grand Total -->
        <div style="display: flex; justify-content: flex-end; padding: 10px; background-color: var(--header-color); border-radius: 4px;">
            <div style="flex: 2; text-align: right; font-weight: bold;">Grand Total:</div>
            <div style="flex: 1; text-align: center;">$<%= String.format("%.2f", grandTotal) %></div>
            <div style="flex: 1;"></div>
        </div>
    </div>

    <!-- Checkout Button -->
    <form action="Receipt.jsp" method="post" style="margin-top: 20px; text-align: center;">
        <button type="submit" style="all: unset; cursor: pointer; background-color: var(--highlight-color); color: white; padding: 10px 20px; border-radius: 8px;">Checkout</button>
    </form>
</body>
</html>
