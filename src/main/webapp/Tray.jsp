<%@ page import="java.util.List" %>
<%@ page import="store.Tray" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tray List</title>
    <link rel="stylesheet" href="styles.css">
    <h3 class="headerSub">
        <div class="nav-dropdown">
            <button>Dropdown</button>
            <div class="dropdown-content">
                <a href="Cart.jsp">View Cart</a>
                <a href="TODO">Storefront</a>
                <a href="TODO">Employee Portal</a>
                <a href="TODO">About Us</a>
            </div>
        </div> 
    </h3>
</head>
</head>
<body>
    <h2>Tray List</h2>
    <table border="1">
        <thead>
            <tr>
                <th>TrayID</th>
                <th>DateTime</th>
                <th>DoughnutID</th>
                <th>FreshQty</th>
                <th>TotalQty</th>
            </tr>
        </thead>
        <tbody>
            <%
                ///get the tray list from the request attribute
                List<Tray> trays = (List<Tray>) request.getAttribute("trays");

                if (trays != null) {
                    for (Tray tray : trays) {
            %>
            <tr>
                <td><%= tray.getTrayID() %></td>
                <td><%= tray.getDateTime() %></td>
                <td><%= tray.getDoughnutID() %></td>
                <td><%= tray.getFreshQty() %></td>
                <td><%= tray.getTotalQty() %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5">No trays available.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
