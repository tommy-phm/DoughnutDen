<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="store.Doughnut"%>
<html>
<head>
<link rel="stylesheet" href="styles.css">
<title>DoughnutDen</title>
<link rel="icon" href="assets/Doughnut-Icon.png" type="image/png" />
<style>
img {
	max-width: 100px;
	max-height: 100px;
	width: auto;
	height: auto;
}
</style>
</head>
<body>
	<header class="headerBanner">
		<h1 class="headerMain">
			<a href="Menu.jsp"> <img src="images/Doughnut-Icon.png" width="50" />
			</a> Doughnut Den
		</h1>

		<h3 class="headerSub">
			<div class="nav-dropdown">
				<button>Dropdown</button>
				<div class="dropdown-content">
					<a href="Cart.jsp">Cart</a>
					<a href="MenuEdit.jsp">Menu Edit</a>
					<a href="TrayEdit.jsp">Tray Edit</a>
					<a href="TransactionEdit.jsp">Transaction Edit</a>
					<a href="AboutUs.html">About US</a>
				</div>
			</div>
		</h3>
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
		</div>
	<%
		}
		}
	%>			
	</div>
</body>
</html>
