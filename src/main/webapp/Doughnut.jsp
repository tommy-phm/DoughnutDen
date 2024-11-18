<%@ page import="store.Doughnut" %>
<html>
<head>
    <link rel="stylesheet" href="/Doughnut/styles.css">
    <title>DoughnutDen</title>
    <link rel="icon" href="assets/Doughnut-Icon.png" type="image/png" />
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
				<a href="../MenuEdit.jsp">Edit Menu</a>
				<a href="../TrayEdit.jsp">Edit Tray</a>
				<a href="../TransactionEdit.jsp">Transaction Edit</a>
				<a href="../Report.jsp">Report</a>
			</div>
		</div>
		
		<a href="Receipt.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="../images/User_icon.png"/>
		</a>
		<a href="Cart.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="../images/cart.png"/>
		</a>
	</header>
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

	<h1><%=doughnut.getName()%></h1>
	
	<div class="DD-Container">
	
		<div class="DD-ImageLeft">
	        
	        <img class="DD-Image" src="../images/<%=doughnut.getId()%>.png"
				onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
			<span style="display: none;">No Image</span>
	    </div>
	    
	    <div class="DD-MiddleContent">
	    	<h3><strong>Category:</strong> <%= doughnut.getCategoryName() %></h3>
	    	<h3><strong>Unit-Price:</strong> $<%= doughnut.getPrice() %></h3> 
	    </div>
	    
	    <div class="DD-RightContent">
	        <h2>Checkout</h2>
	        <form action="../Cart" method="post">
	        <input type="hidden" name="doughnutId" value="<%= doughnut.getId() %>">
	        <label for="quantity">Quantity:</label>
	        <input type="number" id="quantity" name="quantity" min="1" value="1" required>
	        <br/>
	        <button type="submit"><img src="../images/Add_to_Cart.png" style="width: 200px;"></button>
	    	</form>
	        
	    </div>
    
    </div>
    <p style="float: left;"><strong>Description:</strong> <%= doughnut.getDescription() %></p>
    
<%
	} else {
		out.println("<p>Doughnut not found.</p>");
	}
%>
</body>
</html>
