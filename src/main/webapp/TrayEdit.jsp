<%@ page import="java.util.List" %>
<%@ page import="store.Tray" %>
<!DOCTYPE html>
<html>
<head>
    <title>DoughnutDen - Edit Tray</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="icon" href="images/Doughnut-Icon.png" type="image/png" />
    <style>
        form {
		    margin-top: 20px;
		    padding: 20px;
		    border-radius: 8px;
		    background-color: #f9f9f9;
		    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		    width: 300px;
		}

		form input[type="number"] {
		    width: 100%;
		    margin-bottom: 10px;
		}
		
		form button {
		    width: 100%;
		    background-color: #f99f9b;
		    color: white;
		    padding: 10px;
		    border: none;
		    border-radius: 4px;
		    font-size: 16px;
		}
    </style>
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
        <a href="StaffPortal.jsp">
            <img src="images/User_icon.png"/>
        </a>
    </div>
</header>
	
    <h1>Edit Tray</h1>
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
                List<Tray> trays = Tray.getAllTrays();
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
    <h1>Add New Tray</h1>
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
