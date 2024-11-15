<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*" %>
<%@ page import="store.Doughnut" %>

<%
    List<Doughnut> cart = (List<Doughnut>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        out.println("<h3>Your cart is empty.</h3>");
        return;
    }

    Map<Doughnut, Integer> doughnutQuantities = new HashMap<>();

    for (Doughnut d : cart) {
        doughnutQuantities.put(d, doughnutQuantities.getOrDefault(d, 0) + 1);
    }

    double grandTotal = 0.0;
    java.util.Date currentDate = new java.util.Date();
    
    Connection conn = null;
    PreparedStatement psInsertTraction = null;
    PreparedStatement psInsertTractionDetails = null;
    PreparedStatement psUpdateTray = null;
    PreparedStatement psGetDoughnutID = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/doughnutDen", "root", "1234");

        
     // Disable auto-commit for transaction management
        conn.setAutoCommit(false);

        // Insert transaction into Transactions table
        String tractionSQL = "INSERT INTO Tractions (Date, Status) VALUES (?, ?)";
        psInsertTraction = conn.prepareStatement(tractionSQL, Statement.RETURN_GENERATED_KEYS);
        psInsertTraction.setTimestamp(1, new java.sql.Timestamp(currentDate.getTime()));
        psInsertTraction.setBoolean(2, true);
        psInsertTraction.executeUpdate();

        // Insert details into TransactionDetails table and update Trays table
        String tractionDetailsSQL = "INSERT INTO TractionDetails (TractionID, DoughnutID, DoughnutQty) VALUES (?, ?, ?)";
        psInsertTractionDetails = conn.prepareStatement(tractionDetailsSQL);

        String updateTraySQL = "UPDATE Trays SET FreshQty = FreshQty - ? WHERE DoughnutID = ?";
        psUpdateTray = conn.prepareStatement(updateTraySQL);
        
        ResultSet generatedKeys = psInsertTraction.getGeneratedKeys();
        int transactionId = 0;
        if (generatedKeys.next()) {
            transactionId = generatedKeys.getInt(1);  // Retrieve the auto-generated transaction ID
        }
        

        String getDoughnutIDSQL = "SELECT DoughnutID FROM Doughnuts WHERE Name = ?";  // Adjust query as needed
        psGetDoughnutID = conn.prepareStatement(getDoughnutIDSQL);


        for (Map.Entry<Doughnut, Integer> entry : doughnutQuantities.entrySet()) {
            Doughnut d = entry.getKey();
            int quantity = entry.getValue();
            String checkDoughnutSQL = "SELECT COUNT(*) FROM Doughnuts WHERE DoughnutID = ?";
            try (PreparedStatement psCheckDoughnut = conn.prepareStatement(checkDoughnutSQL)) {
                psCheckDoughnut.setInt(1, d.getId());
                ResultSet rsCheck = psCheckDoughnut.executeQuery();
                if (rsCheck.next() && rsCheck.getInt(1) == 0) {
                    out.println("Error: DoughnutID " + d.getId() + " not found in Doughnuts table.");
                    continue; // Skip this doughnut if not found
                }
            }
            double totalPrice = d.getPrice() * quantity;
            grandTotal += totalPrice;           

            // Add entry to TransactionDetails
            psInsertTractionDetails.setInt(1, transactionId);
            psInsertTractionDetails.setInt(2, d.getId());
            psInsertTractionDetails.setInt(3, quantity);
            psInsertTractionDetails.executeUpdate();

            // Update Trays with new FreshQty
            psUpdateTray.setInt(1, quantity);
            psUpdateTray.setInt(2, d.getId());
            psUpdateTray.executeUpdate();
        }

        conn.commit();
       
%>

<html>
<head>
    <link rel="stylesheet" href="styles.css">
    <title>Receipt</title>
</head>
<body>
    <h1>Receipt</h1>
    <p>Transaction ID: <%= transactionId %></p>
    <p>Date: <%= currentDate %></p>
    <table border="1">
        <tr>
            <th>Doughnut Name</th>
            <th>Quantity</th>
            <th>Price Each</th>
            <th>Total Price</th>
        </tr>
        <%
            for (Map.Entry<Doughnut, Integer> entry : doughnutQuantities.entrySet()) {
                Doughnut d = entry.getKey();
                int quantity = entry.getValue();
                double totalPrice = d.getPrice() * quantity;
        %>
        <tr>
            <td><%= d.getName() %></td>
            <td><%= quantity %></td>
            <td>$<%= d.getPrice() %></td>
            <td>$<%= String.format("%.2f", totalPrice) %></td>
        </tr>
        <%
            }
        %>
        <tr>
            <td colspan="3" style="text-align:right;"><b>Grand Total:</b></td>
            <td>$<%= String.format("%.2f", grandTotal) %></td>
        </tr>
    </table>
    
    <!-- Back to Menu Button -->
    <form action="Menu.jsp" method="get" style="margin-top:20px;">
        <button type="submit">Back to Menu</button>
    </form>
</body>
</html>

<%
    } catch (Exception e) {
        if (conn != null) conn.rollback();
        e.printStackTrace();
        out.println("Error processing transaction."+e.getMessage());
    } finally {
        if (psInsertTraction != null) psInsertTraction.close();
        if (psInsertTractionDetails != null) psInsertTractionDetails.close();
        if (psUpdateTray != null) psUpdateTray.close();
        if (conn != null) conn.close();
    }

    // Clear the cart after checkout
    session.removeAttribute("cart");
%>
