<%@ page import="java.util.List" %>
<%@ page import="store.Tray" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Trays</title>
    <link rel="stylesheet" href="styles.css">
        <style>
        h1 {
            text-align: center;
        }
    	table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            background-color: white;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
            font-size: 14px;
        }

        th {
            background-color: #f99f9b;
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

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
		<h1 class="headerMain" style="display: flex; align-items: center; text-decoration: none;">
			<a href="Menu.jsp"> 
				<img src="images/Doughnut-Icon.png" style=" width: 50px;" />
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
				<a href="TrayEdit.jsp">Edit Tray</a>
				<a href="TransactionEdit.jsp">Edit Transaction </a>
				<a href="Report.jsp">Report</a>
			</div>
		</div>
		
		<a href="Receipt.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="images/User_icon.png"/>
		</a>
		<a href="Cart.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="images/cart.png"/>
		</a>
	</header>
	
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
