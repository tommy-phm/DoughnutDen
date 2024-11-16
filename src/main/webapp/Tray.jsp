<%@ page import="java.util.List" %>
<%@ page import="store.Tray" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tray List</title>
    <link rel="stylesheet" href="styles.css">
</head>
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
