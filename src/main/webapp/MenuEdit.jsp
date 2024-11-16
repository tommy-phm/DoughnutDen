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
				<a href="Tray.jsp">Tray</a>
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
	<h1>Menu Edit</h1>
	<%
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		response.sendRedirect("MenuEdit.jsp");
	}
	%>
	
	<div class="ME-Container">
	
	<%
	List<Doughnut> doughnuts = Doughnut.getDoughnuts();
	List<String> categories = Doughnut.getCategories();
	for (Doughnut doughnut : doughnuts) {
	%>
		
		<form class="ME-Card" action="MenuEdit" method="post" enctype="multipart/form-data">
	
		
			
			<a href="Doughnut/<%=doughnut.getId()%>"> <%=doughnut.getId()%> </a>
				
			<div class="ME-Image">
				<img style="width: 100px;" src="images/<%= doughnut.getId() %>.png?timestamp=<%= System.currentTimeMillis() %>"
					onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
					<span style="display: none;">No Image</span>
					<input type="file"
					name="file_<%=doughnut.getId()%>" accept=".png">
			</div>			
				
			<input type="text" 
				name="name_<%=doughnut.getId()%>"
				value="<%=doughnut.getName()%>" />
		
			<input type="text" 
				name="description_<%=doughnut.getId()%>"
				value="<%=doughnut.getDescription()%>" /> 
			<input type="number"
				step="0.01" name="price_<%=doughnut.getId()%>"
				value="<%=doughnut.getPrice()%>" />  
			<select
				name="category_<%=doughnut.getId()%>">
					
				<%
				for (String category : categories) {
				%>
				<option value="<%=category%>"
					<%=doughnut.getCategoryName().equals(category) ? "selected" : ""%>>
					<%=category%>
				</option>
				<%
				}
				%>
			</select> 
			<input type="checkbox" name="status_<%=doughnut.getId()%>"
				<%=doughnut.getStatus() ? "checked" : ""%> />
				
				
			<div class="ME-Actions">
				<button type="submit" name="action" value="saveData">Save Data</button>
				<button type="submit" name="action" value="saveImage">Save Image</button>
				<input type="hidden" name="doughnutId" value="<%=doughnut.getId()%>" />
			</div>
			
		
		</form>
	<%
		}
	%>			
	</div>
	
	<h3 style="text-align: left;">Add Doughnut</h3>
	<form action="MenuEdit" method="post" enctype="multipart/form-data">
		<span>No Image</span> <input type="text" name="name_new"
			placeholder="New Name" /> <input type="text" name="description_new"
			placeholder="New Description" /> <input type="number" step="0.01"
			name="price_new" placeholder="0.00" /> <select name="category_new">
			<%
			for (String category : categories) {
			%>
			<option value="<%=category%>"><%=category%></option>
			<%
			}
			%>
		</select> <input type="checkbox" name="status_new" />
		<button type="submit" name="action" value="insert">Add</button>
	</form>
</body>
</html>
