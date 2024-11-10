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
					<a href="TODO">Storefront</a> <a href="TODO">Employee Portal</a> <a
						href="TODO">About US</a>
				</div>
			</div>
		</h3>
	</header>

	<h1>Menu</h1>
	<%
	List<Doughnut> doughnuts = Doughnut.getDoughnuts();
	%>
	<table>
		<thead>
			<tr>
				<th>Image</th>
				<th>Name</th>
				<th>Description</th>
				<th>Price</th>
				<th>Category</th>
			</tr>
		</thead>
		<tbody>
			<%
			for (Doughnut doughnut : doughnuts) {
				if (doughnut.getStatus()) {
			%>
			<tr>
				<td><img src="images/<%= doughnut.getId() %>.png?timestamp=<%= System.currentTimeMillis() %>"
					onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
					<span style="display: none;">No Image</span></td>
				<td><a href="Doughnut/<%=doughnut.getId()%>"><%=doughnut.getName()%></a></td>
				<td><%=doughnut.getDescription()%></td>
				<td>$<%=String.format("%.2f", doughnut.getPrice())%></td>
				<td><%=doughnut.getCategoryName()%></td>
			</tr>
			<%
			}
			}
			%>
		</tbody>
	</table>
</body>
</html>
