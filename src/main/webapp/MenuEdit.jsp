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
	<header>
		<h1>Menu Edit</h1>
	</header>

	<%
	if ("POST".equalsIgnoreCase(request.getMethod())) {
		response.sendRedirect("MenuEdit.jsp");
	}
	%>
	<%
	List<Doughnut> doughnuts = Doughnut.getDoughnuts();
	List<String> categories = Doughnut.getCategories();
	for (Doughnut doughnut : doughnuts) {
	%>
	<form action="MenuEdit" method="post" enctype="multipart/form-data">
		<img src="images/<%= doughnut.getId() %>.png?timestamp=<%= System.currentTimeMillis() %>"
			onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
		<span style="display: none;">No Image</span> <input type="file"
			name="file_<%=doughnut.getId()%>" accept=".png"> <input
			type="text" name="name_<%=doughnut.getId()%>"
			value="<%=doughnut.getName()%>" />
		<%=doughnut.getId()%>
		<input type="text" name="description_<%=doughnut.getId()%>"
			value="<%=doughnut.getDescription()%>" /> <input type="number"
			step="0.01" name="price_<%=doughnut.getId()%>"
			value="<%=doughnut.getPrice()%>" /> <input type="number"
			step="0.01" name="price_<%=doughnut.getId()%>"
			value="<%=doughnut.getPrice()%>" /> <select
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
		</select> <input type="checkbox" name="status_<%=doughnut.getId()%>"
			<%=doughnut.getStatus() ? "checked" : ""%> />
		<button type="submit" name="action" value="saveData">Save Data</button>
		<button type="submit" name="action" value="saveImage">Save Image</button>
		<input type="hidden" name="doughnutId" value="<%=doughnut.getId()%>" />
	</form>
	<%
	}
	%>
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
