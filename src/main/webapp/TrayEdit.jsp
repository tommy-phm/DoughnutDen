<%@ page import="java.util.List" %>
<%@ page import="store.Tray" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Trays</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>Edit Tray List</h2>
    <table border="1">
        <thead>
            <tr>
                <th>TrayID</th>
                <th>DateTime</th>
                <th>DoughnutID</th>
                <th>FreshQty</th>
                <th>TotalQty</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Tray> trays = (List<Tray>) request.getAttribute("trays");
                for (Tray t : trays) {
            %>
            <tr>
                <form action="Tray" method="post">
                    <td><%= t.getTrayID() %></td>
                    <td><%= t.getDateTime() %></td>
                    <td><%= t.getDoughnutID() %></td>
                    <td><input type="number" name="freshQty" value="<%= t.getFreshQty() %>"></td>
                    <td><input type="number" name="totalQty" value="<%= t.getTotalQty() %>"></td>
                    <td>
                        <input type="hidden" name="trayID" value="<%= t.getTrayID() %>">
                        <input type="hidden" name="action" value="update">
                        <button type="submit">Update</button>
                    </td>
                </form>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <h3>Add New Tray</h3>
    <form action="Tray" method="post">
        <label for="doughnutID">Doughnut ID:</label>
        <input type="number" name="doughnutID">
        <br>
        <label for="freshQty">Fresh Quantity:</label>
        <input type="number" name="freshQty">
        <br>
        <label for="totalQty">Total Quantity:</label>
        <input type="number" name="totalQty">
        <br>
        <input type="hidden" name="action" value="add">
        <button type="submit">Add Tray</button>
    </form>
</body>
</html>
