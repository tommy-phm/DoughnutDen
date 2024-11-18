<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*" %>
<%@ page import="store.Doughnut" %>

<%
    // Retrieve cart as Map<Integer, Integer> from the session
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        out.println("<h3>Your cart is empty.</h3>");
        return;
    }

    double grandTotal = 0.0;
    java.util.Date currentDate = new java.util.Date();
    
    Connection conn = null;
    PreparedStatement psInsertTraction = null;
    PreparedStatement psInsertTractionDetails = null;
    PreparedStatement psUpdateTray = null;
    PreparedStatement psGetDoughnutById = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/database", "root", "password");
        
        // Disable auto-commit for transaction management
        conn.setAutoCommit(false);

        // Insert transaction into Transactions table
        String transactionSQL = "INSERT INTO Tractions (Date, Status) VALUES (?, ?)";
        psInsertTraction = conn.prepareStatement(transactionSQL, Statement.RETURN_GENERATED_KEYS);
        psInsertTraction.setTimestamp(1, new java.sql.Timestamp(currentDate.getTime()));
        psInsertTraction.setBoolean(2, true);
        psInsertTraction.executeUpdate();

        ResultSet generatedKeys = psInsertTraction.getGeneratedKeys();
        int transactionId = 0;
        if (generatedKeys.next()) {
            transactionId = generatedKeys.getInt(1); // Retrieve the auto-generated transaction ID
        }

        // PreparedStatement for retrieving doughnut details by ID
        String getDoughnutSQL = "SELECT DoughnutID, Name, Price FROM Doughnuts WHERE DoughnutID = ?";
        psGetDoughnutById = conn.prepareStatement(getDoughnutSQL);

        // PreparedStatement for inserting into TransactionDetails
        String transactionDetailsSQL = "INSERT INTO TractionDetails (TractionID, DoughnutID, DoughnutQty) VALUES (?, ?, ?)";
        psInsertTractionDetails = conn.prepareStatement(transactionDetailsSQL);

        // PreparedStatement for updating Trays
        String updateTraySQL = "UPDATE Trays SET FreshQty = FreshQty - ? WHERE DoughnutID = ?";
        psUpdateTray = conn.prepareStatement(updateTraySQL);

        // Iterate through the cart to process each doughnut
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            int doughnutId = entry.getKey();
            int quantity = entry.getValue();

            // Retrieve doughnut details
            psGetDoughnutById.setInt(1, doughnutId);
            rs = psGetDoughnutById.executeQuery();
            if (!rs.next()) {
                out.println("Error: Doughnut ID " + doughnutId + " not found in Doughnuts table.");
                continue; // Skip this doughnut if not found
            }

            String doughnutName = rs.getString("Name");
            double doughnutPrice = rs.getDouble("Price");

            double totalPrice = doughnutPrice * quantity;
            grandTotal += totalPrice;

            // Insert into TransactionDetails
            psInsertTractionDetails.setInt(1, transactionId);
            psInsertTractionDetails.setInt(2, doughnutId);
            psInsertTractionDetails.setInt(3, quantity);
            psInsertTractionDetails.executeUpdate();

            // Update Trays
            psUpdateTray.setInt(1, quantity);
            psUpdateTray.setInt(2, doughnutId);
            psUpdateTray.executeUpdate();
        }

        conn.commit(); // Commit the transaction
%>
<html>
<head>
    <link rel="stylesheet" href="/Doughnut/styles.css">
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

    <h1>Receipt</h1>
    <p>Transaction ID: <%= transactionId %></p>
    <p>Date: <%= currentDate %></p>
    <div style="display: flex; flex-direction: column; gap: 10px; align-items: center; margin-top: 20px;">

    <!-- Header Row -->
    <div style="display: flex; width: 100%; justify-content: space-evenly; font-weight: bold; background-color: var(--layer1-color); padding: 10px; border-radius: 8px;">
        <span style="flex: 1; text-align: center;">Doughnut Name</span>
        <span style="flex: 1; text-align: center;">Quantity</span>
        <span style="flex: 1; text-align: center;">Price Each</span>
        <span style="flex: 1; text-align: center;">Total Price</span>
    </div>

    <!-- Doughnut Details -->
    <% for (Map.Entry<Integer, Integer> entry : cart.entrySet()) { 
        int doughnutId = entry.getKey();
        int quantity = entry.getValue();

        // Retrieve doughnut details for display
        psGetDoughnutById.setInt(1, doughnutId);
        rs = psGetDoughnutById.executeQuery();
        rs.next();
        String doughnutName = rs.getString("Name");
        double doughnutPrice = rs.getDouble("Price");
        double totalPrice = doughnutPrice * quantity;
    %>
    <div style="display: flex; width: 100%; justify-content: space-evenly; background-color: var(--bg-color); padding: 10px; border-radius: 8px;">
        <span style="flex: 1; text-align: center;"><%= doughnutName %></span>
        <span style="flex: 1; text-align: center;"><%= quantity %></span>
        <span style="flex: 1; text-align: center;">$<%= doughnutPrice %></span>
        <span style="flex: 1; text-align: center;">$<%= String.format("%.2f", totalPrice) %></span>
    </div>
    <% } %>

    <!-- Grand Total -->
    <div style="display: flex; width: 100%; justify-content: space-evenly; font-weight: bold; background-color: var(--highlight-color); padding: 10px; border-radius: 8px; margin-top: 20px;">
        <span style="flex: 3; text-align: right;">Grand Total:</span>
        <span style="flex: 1; text-align: center;">$<%= String.format("%.2f", grandTotal) %></span>
    </div>
</div>

<!-- Back to Menu Button -->
<form action="Menu.jsp" method="get" style="margin-top: 20px; text-align: center;">
    <button type="submit" style="background-color: var(--layer1-color); color: var(--body-text-color); padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-size: 1.2em;">
        Back to Menu
    </button>
</form>
</body>
</html>

<%
    } catch (Exception e) {
        if (conn != null) conn.rollback();
        e.printStackTrace();
        out.println("Error processing transaction: " + e.getMessage());
    } finally {
        if (psInsertTraction != null) psInsertTraction.close();
        if (psInsertTractionDetails != null) psInsertTractionDetails.close();
        if (psUpdateTray != null) psUpdateTray.close();
        if (psGetDoughnutById != null) psGetDoughnutById.close();
        if (conn != null) conn.close();
    }

    // Clear the cart after checkout
    session.removeAttribute("cart");
%>
