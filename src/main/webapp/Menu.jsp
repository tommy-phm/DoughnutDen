<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="store.Doughnut"%>
<html>
<head>
	<title>DoughnutDen - Cart</title>
	<link rel="stylesheet" href="styles.css">
	<link rel="icon" href="assets/Doughnut-Icon.png"/>
</head>
<body>
<header class="headerBanner">
    <h1 class="headerMain">
        <a href="Menu.jsp">
            <img src="images/Doughnut-Icon.png"/>
            Doughnut Den
        </a>
    </h1>
    <div class="headerIcons">
        <a href="Cart.jsp">
            <img src="images/cart.png"/>
        </a>
        <a href="StaffPortal.jsp">
            <img src="images/User_icon.png"/>
        </a>
    </div>
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
			<h3><a href="Doughnut/<%=doughnut.getId()%>"><%=doughnut.getName()%></a></h3>
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
