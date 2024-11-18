<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*" %>
<%@ page import="store.*" %>


<%	    
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
        // Example entry for testing
        cart.put(1, 3); // Example: Donut with ID 1 and quantity 3
    }
 // Handle removing a doughnut from the cart
    String doughnutIdToRemove = request.getParameter("doughnutId");
    if (doughnutIdToRemove != null) {
    	int doughnutRemove = Integer.parseInt(doughnutIdToRemove);
        int currentQuantity = cart.get(doughnutRemove);
        if (currentQuantity > 1) {
            // Decrement quantity
            int newQuantity = currentQuantity - 1;
            cart.put(doughnutRemove, newQuantity);
        } else {
            // Remove the donut from the cart if quantity is 1
            cart.remove(doughnutRemove);
        }
    }
%>

<html>

<head>
<link rel="stylesheet" href="styles.css">
    <title>Shopping Cart</title>
</head>
<body>
	<header class="headerBanner">
		<h1 class="headerMain" style="display: flex; align-items: center; text-decoration: none;">
			<a href="Menu.jsp"> 
				<img src="../images/Doughnut-Icon.png" style=" width: 50px;" />
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
				<a href="TransactionEdit.jsp">Transaction Edit</a>
				<a href="Report.jsp">Report</a>
			</div>
		</div>
		
		<a href="Receipt.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="../images/User_icon.png"/>
		</a>
		<a href="Cart.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="../images/cart.png"/>
		</a>
	</header>
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
        	double grandTotal = 0;
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int doughnutId = entry.getKey();
                int quantity = entry.getValue();
                Doughnut d = Doughnut.getDoughnutById(doughnutId);

                if (d != null) {
                    double totalPrice = d.getPrice() * quantity;
                    grandTotal += totalPrice;
        %>
        System.out.println("Doughnut ID: " + doughnutId + ", Quantity: " + quantity);
        <div style="display: flex; justify-content: space-between; padding: 10px; background-color: var(--bg-color); border-radius: 4px;">
            <div style="flex: 2;"><%= d.getName() %></div>
            <div style="flex: 1; text-align: center;"><%= quantity %></div>
            <div style="flex: 1; text-align: center;">$<%= d.getPrice() %></div>
            <div style="flex: 1; text-align: center;">$<%= String.format("%.2f", totalPrice) %></div>
            <div style="flex: 1; text-align: center;">
                <form action="RemoveDoughnut" method="post" style="display:inline;">
                    <input type="hidden" name="doughnutId" value="<%= doughnutId %>" />
                    <button type="submit" style="all: unset; cursor: pointer; background-color: var(--layer1-color); border-radius: 4px; padding: 5px;">Remove</button>
                </form>
            </div>
        </div>
        <%
            }
                
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
