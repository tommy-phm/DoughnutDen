<%@ page import="store.Doughnut" %>
<html>
<head>
    <link rel="stylesheet" href="/Doughnut/styles.css">
    <title>DoughnutDen</title>
    <link rel="icon" href="assets/Doughnut-Icon.png" type="image/png" />
</head>
<body>
	<header class="headerBanner">
		<h1 class="headerMain" style="display: flex; justify-content: center; align-items: center; text-decoration: none;">
			<a href="../Menu.jsp"> 
				<img src="../images/Doughnut-Icon.png" style=" width: 50px;" />
			 	Doughnut Den
			</a>
		</h1>
		<a style="margin-left: 10%;" href="../Menu.jsp">
			<button class="nav-button">Menu</button>
		</a>
		<div class="nav-dropdown">
				
		    <button class="nav-button">Staff Portal</button>
			<div class="dropdown-content">
				<a href="../MenuEdit.jsp">Edit Menu</a>
				<a href="../TrayEdit.jsp">Edit Tray</a>
				<a href="../TransactionEdit.jsp">Edit Transaction </a>
				<a href="../Report.jsp">Report</a>
			</div>
		</div>
		
		<a href="../StaffPortal.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="../images/User_icon.png"/>
		</a>
		<a href="../Cart.jsp" style="float: right; margin-right: 5%;"> 
			<img style=" width: 50px;" src="../images/cart.png"/>
		</a>
	</header>
    <main style = "margin-top: 20px;">
        <%
            String pathInfo = request.getPathInfo();
            int doughnutId = 0;

            if (pathInfo != null && pathInfo.length() > 1) {
                try {
                    doughnutId = Integer.parseInt(pathInfo.substring(1));
                } catch (NumberFormatException e) {
                    out.println("<p>Invalid Doughnut ID format.</p>");
                }
            } else {
                out.println("<p>Doughnut ID missing or incorrect.</p>");
            }

            Doughnut doughnut = Doughnut.getDoughnutById(doughnutId);

            if (doughnut != null) {
        %>
        <div class="DD-Container" style="display: flex; gap: 20px; align-items: flex-start;">
            <!-- First Column -->
            <div class="DD-ColumnLeft" style="flex: 1; text-align: center;">
                <h1><%= doughnut.getName() %></h1>
                <img class="DD-Image" src="../images/<%= doughnut.getId() %>.png" 
                     alt="Doughnut Image" 
                     style="max-width: 100%; height: auto;"
                     onerror="this.onerror=null; this.style.display='none'; this.nextElementSibling.style.display='inline';">
                <span style="display: none;">No Image</span>
            </div>

            <!-- Second Column -->
            <div style="flex: 1;">
                <h3><strong>Category:</strong> <%= doughnut.getCategoryName() %></h3>
                <h3><strong>Price:</strong> $<%= doughnut.getPrice() %></h3>
                <p><strong>Description:</strong> <%= doughnut.getDescription() %></p>
                <form action="../Cart" method="post" style="margin-top: 20px;">
                    <input type="hidden" name="doughnutId" value="<%= doughnut.getId() %>">
                    <label for="quantity"><strong>Quantity:</strong></label>
                    <input type="number" id="quantity" name="quantity" min="1" value="1" required style="margin-left: 10px; margin-bottom: 10px;">
                    <br/>
                    <button type="submit" style="background: none; border: none; cursor: pointer;">
                        <img src="../images/Add_to_Cart.png" alt="Add to Cart" style="width: 200px;">
                    </button>
                </form>
            </div>
        </div>
        <%
            } else {
                out.println("<p>Doughnut not found.</p>");
            }
        %>
    </main>
</body>
</html>
