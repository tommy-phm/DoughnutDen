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
    PreparedStatement psInsertTransaction = null;
    PreparedStatement psInsertTransactionDetails = null;
    PreparedStatement psUpdateTray = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourDatabase", "username", "password");

        // Insert transaction into Transactions table
        String transactionSQL = "INSERT INTO Transactions (Date, Status) VALUES (?, ?)";
        psInsertTransaction = conn.prepareStatement(transactionSQL, Statement.RETURN_GENERATED_KEYS);
        psInsertTransaction.setTimestamp(1, new java.sql.Timestamp(currentDate.getTime()));
        psInsertTransaction.setBoolean(2, true);
        psInsertTransaction.executeUpdate();

        ResultSet generatedKeys = psInsertTransaction.getGeneratedKeys();
        int transactionId = 0;
        if (generatedKeys.next()) {
            transactionId = generatedKeys.getInt(1);
        }

        // Insert details into TransactionDetails table and update Trays table
        String transactionDetailsSQL = "INSERT INTO TransactionDetails (TransactionID, DoughnutID, DoughnutQty) VALUES (?, ?, ?)";
        psInsertTransactionDetails = conn.prepareStatement(transactionDetailsSQL);

        String updateTraySQL = "UPDATE Trays SET FreshQty = FreshQty - ? WHERE DoughnutID = ?";
        psUpdateTray = conn.prepareStatement(updateTraySQL);

        for (Map.Entry<Doughnut, Integer> entry : doughnutQuantities.entrySet()) {
            Doughnut d = entry.getKey();
            int quantity = entry.getValue();
            double totalPrice = d.getPrice() * quantity;
            grandTotal += totalPrice;

            // Add entry to TransactionDetails
            psInsertTransactionDetails.setInt(1, transactionId);
            psInsertTransactionDetails.setInt(2, d.getId());
            psInsertTransactionDetails.setInt(3, quantity);
            psInsertTransactionDetails.executeUpdate();

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
        out.println("Error processing transaction.");
    } finally {
        if (psInsertTransaction != null) psInsertTransaction.close();
        if (psInsertTransactionDetails != null) psInsertTransactionDetails.close();
        if (psUpdateTray != null) psUpdateTray.close();
        if (conn != null) conn.close();
    }

    // Clear the cart after checkout
    session.removeAttribute("cart");
%>
