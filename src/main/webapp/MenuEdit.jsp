<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="store.Doughnut"%>
<html>
<head>
	<title>DoughnutDen - Edit Menu</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="icon" href="images/Doughnut-Icon.png" type="image/png" />
    <style>
        img {
            width: 50px;
            height: auto;
        }
    </style>
</head>
<body>
	<header class="headerBanner" style="text-align: center;">
		<h1 class="headerMain" style="display: flex; justify-content: center; align-items: center; text-decoration: none;">
			<a href="Menu.jsp"> 
				<img src="images/Doughnut-Icon.png" style=" width: 50px;" />
			 	Doughnut Den
			</a>
		</h1>
		<div class="nav-dropdown">
		    <button class="nav-button">Staff Portal</button>
			<div class="dropdown-content">
				<a href="MenuEdit.jsp">Edit Menu</a>
				<a href="TrayEdit.jsp">Edit Tray</a>
				<a href="TransactionEdit.jsp">Edit Transaction </a>
				<a href="Report.jsp">Report</a>
			</div>
		</div>
	</header>

<h1>Menu Edit</h1>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    response.sendRedirect("MenuEdit.jsp");
}
%>

<div class="form-container">
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
                <th>Category</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
        List<Doughnut> doughnuts = Doughnut.getDoughnuts();
        List<String> categories = Doughnut.getCategories();
        for (Doughnut doughnut : doughnuts) {
        %>
            <tr>
                <td><a href="Doughnut/<%= doughnut.getId() %>"><%= doughnut.getId() %></a></td>
                <td>
                    <div>
                        <div>
                            <img src="images/<%= doughnut.getId() %>.png?timestamp=<%= System.currentTimeMillis() %>"
                                 onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
                            <span style="display: none;">No Image</span>
                        </div>
                        <div>
                            <form action="MenuEdit" method="post" enctype="multipart/form-data">
                                <input type="file" name="file_<%= doughnut.getId() %>" accept=".png">
                                <input type="hidden" name="doughnutId" value="<%= doughnut.getId() %>">
                                <button type="submit" name="action" value="saveImage">Save Image</button>
                            </form>
                        </div>
                    </div>
                </td>
                <form action="MenuEdit" method="post">
                    <td><input type="text" name="name_<%= doughnut.getId() %>" value="<%= doughnut.getName() %>" /></td>
                    <td><input type="text" name="description_<%= doughnut.getId() %>" value="<%= doughnut.getDescription() %>" /></td>
                    <td><input type="number" step="0.01" name="price_<%= doughnut.getId() %>" value="<%= doughnut.getPrice() %>" /></td>
                    <td>
                        <select name="category_<%= doughnut.getId() %>">
                            <% for (String category : categories) { %>
                                <option value="<%= category %>" <%= doughnut.getCategoryName().equals(category) ? "selected" : "" %>>
                                    <%= category %>
                                </option>
                            <% } %>
                        </select>
                    </td>
                    <td><input type="checkbox" name="status_<%= doughnut.getId() %>" <%= doughnut.getStatus() ? "checked" : "" %> /></td>
                    <td>
                        <button type="submit" name="action" value="saveData">Save</button>
                        <input type="hidden" name="doughnutId" value="<%= doughnut.getId() %>">
                    </td>
                </form>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

<div class="form-container">
    <h3>Add New Doughnut</h3>
    <form action="MenuEdit" method="post" enctype="multipart/form-data">
        <table>
            <tr>
                <td>
                    <input type="file" name="file_new" accept=".png">
                </td>
                <td><input type="text" name="name_new" placeholder="New Name"></td>
                <td><input type="text" name="description_new" placeholder="New Description"></td>
                <td><input type="number" step="0.01" name="price_new" placeholder="0.00"></td>
                <td>
                    <select name="category_new">
                        <% for (String category : categories) { %>
                            <option value="<%= category %>"><%= category %></option>
                        <% } %>
                    </select>
                </td>
                <td><input type="checkbox" name="status_new"></td>
                <td><button type="submit" name="action" value="insert">Add</button></td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>
