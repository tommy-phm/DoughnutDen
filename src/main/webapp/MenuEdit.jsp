<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="store.Doughnut" %>
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
            Doughnut.handleRequest(request);
            response.sendRedirect("MenuEdit.jsp"); 
        }
    %>
    
    <form action="MenuEdit.jsp" method="post">
        <table>
            <thead>
                <tr>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Category</th>
                    <th>Available</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<Doughnut> doughnuts = Doughnut.getDoughnuts();
                    List<String> categories = Doughnut.getCategories(); 
                    for (Doughnut doughnut : doughnuts) { 
                %>
                <tr>
                    <td>
                        <img src="images/<%= doughnut.getId() %>.png" 
                             onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
                        <span style="display:none;">No Image</span>
                    </td>
                    <td><input type="text" name="name_<%= doughnut.getId() %>" value="<%= doughnut.getName() %>" /></td>
                    <td><input type="text" name="description_<%= doughnut.getId() %>" value="<%= doughnut.getDescription() %>" /></td>
                    <td><input type="number" step="0.01" name="price_<%= doughnut.getId() %>" value="<%= doughnut.getPrice() %>" /></td>
                    <td>
                        <select name="category_<%= doughnut.getId() %>">
                            <% for (String category : categories) { %>
                                <option value="<%= category %>" <%= doughnut.getCategoryName().equals(category) ? "selected" : "" %>> <%= category %> </option>
                            <% } %>
                        </select>
                    </td>
                    <td><input type="checkbox" name="status_<%= doughnut.getId() %>" <%= doughnut.getStatus() ? "checked" : "" %> /></td>
                    <td><button type="submit" name="save" value="<%= doughnut.getId() %>">Save</button></td>
                </tr>
                <% } %>

                <tr>
                    <td>
                        <span>No Image</span>
                    </td>
                    <td><input type="text" name="name_new" placeholder="New Name" /></td>
                    <td><input type="text" name="description_new" placeholder="New Description" /></td>
                    <td><input type="number" step="0.01" name="price_new" placeholder="0.00" /></td>
                    <td>
                        <select name="category_new">
                            <% for (String category : categories) { %>
                                <option value="<%= category %>"><%= category %></option>
                            <% } %>
                        </select>
                    </td>
                    <td><input type="checkbox" name="status_new" /></td>
                    <td><button type="submit" name="insert" value="new">Add</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
