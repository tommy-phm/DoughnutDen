  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="store.Doughnut" %>


<%
List<Doughnut> cart = (List<Doughnut>) session.getAttribute("cart");
	if (cart == null) {
	    session.setAttribute("cart", cart);  
        
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
<body>
    <h1>Your Cart</h1>
    
    <div class="C-Container">
    	<div class="C-Content">
		    <%
		    	double grandTotal = 1.0;
		        for (Map.Entry<Doughnut, Integer> entry : doughnutQuantities.entrySet()) {
		        	Doughnut d = entry.getKey();
		            int quantity = entry.getValue();
		            double totalPrice = d.getPrice() * quantity;
		            grandTotal += totalPrice;
		    %>
		    <div class="C-Item">
		    	<p><%= d.getName() %></p>
		        <p><%= quantity %></p>
		        <p>$<%= d.getPrice() %></p>
		        <p>$<%= String.format("%.2f", totalPrice) %></p>
		         
		         <div class="C-DonutActions">
		         	<form action="Cart" method="post">
			            <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
			            <button class="C-Button" onclick="submit()">
  							<img src="/images/upArrow.png"/>
						</button>
		            </form>
		            <form action="Cart" method="post">
		                <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
		                <button type="submit" name="remove" value="true"><img src="/images/DownArrow.png"></button>
		            </form>
		         </div>
		         <form action="Cart" method="post">
		            <input type="hidden" name="doughnutId" value="<%= d.getId() %>" />
		            <button type="submit" name="removeAll" value="true">Remove All</button>
		         </form>
		    </div>
		    <%
		    	}
		    %>
    
    	</div>  <!-- End of Content -->
    
        <div class="C-Right">
            <h3 style="flex-direction: row;"><b>Grand Total:</b></h3>
            <h3 style="flex-direction: row;">$<%= String.format("%.2f", grandTotal) %></h3>
            
            <!-- Checkout Button -->
		    <form action="Receipt.jsp" method="post">
		        <button type="submit"><img src="../images/Checkout_button"></button>
		    </form>
            
        </div>
    </div>
</body>
</html>
