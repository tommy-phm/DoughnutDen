<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="store.Doughnut"%>
<html>
<head>
<link rel="stylesheet" href="styles.css">
<title>DoughnutDen</title>
<link rel="icon" href="assets/Doughnut-Icon.png" type="image/png" />

</head>
<body>
	<header class="headerBanner">
		<h1 class="headerMain" style="display: flex; justify-content: center; align-items: center; text-decoration: none;">
			<a href="Menu.jsp"> 
				<img src="images/Doughnut-Icon.png" style=" width: 50px;" />
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
				<a href="TransactionEdit.jsp">Edit Transaction </a>
				<a href="Report.jsp">Report</a>
			</div>
		</div>
		
		<a href="StaffPortal.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="images/User_icon.png"/>
		</a>
		<a href="Cart.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="images/cart.png"/>
		</a>
	</header>
	
	
	<h1>Menu</h1>
	<%
	List<Doughnut> doughnuts = Doughnut.getDoughnuts();
	%>
	
	
	<div class="M-Container">
	<%
		for (Doughnut doughnut : doughnuts) {
			if (doughnut.getStatus()) {
	%>
	
		<div class="M-Card">
			<a href="Doughnut/<%=doughnut.getId()%>">
				<img class="M-Image" src="images/<%= doughnut.getId() %>.png?timestamp=<%= System.currentTimeMillis() %>"
					onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
					<span style="display: none;">No Image</span>
			</a>
			<h4><a href="Doughnut/<%=doughnut.getId()%>"><%=doughnut.getName()%></a></h4>
			<h4>$<%=String.format("%.2f", doughnut.getPrice())%></h4>
			<h4><%=doughnut.getCategoryName()%></h4>
			
			<!-- Add to Cart Form -->
            <form action="Cart" method="post">
                <input type="hidden" name="doughnutId" value="<%= doughnut.getId() %>">
                <label for="quantity-<%= doughnut.getId() %>">Quantity:</label>
                <input type="number" id="quantity-<%= doughnut.getId() %>" name="quantity" class="quantity-input" value="1" min="1">
                <button type="submit" class="nav-button" style="font-size: 1vh;">Add to Cart</button>
            </form>
		</div>
	<%
		}
		}
	%>			
	</div>
</body>
</html>
