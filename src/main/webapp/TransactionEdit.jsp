<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    // Database connection variables
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    List<Integer> transactionIds = new ArrayList<>();
    List<Timestamp> transactionDates = new ArrayList<>();
    List<Boolean> transactionStatuses = new ArrayList<>();

    try {
        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish connection
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/doughnut", "username", "password");
        
        // Query to fetch all transactions
        String query = "SELECT TransactionID, Date, Status FROM Transactions";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        // Collect transaction data
        while (rs.next()) {
            transactionIds.add(rs.getInt("TransactionID"));
            transactionDates.add(rs.getTimestamp("Date"));
            transactionStatuses.add(rs.getBoolean("Status"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<html>
<head>
    <title>Edit Transactions</title>
</head>
<body>
    <h1>Transaction Edit Page</h1>
    <form action="TransactionEdit.jsp" method="post">
        <table border="1">
            <tr>
                <th>Transaction ID</th>
                <th>Date</th>
                <th>Status</th>
            </tr>
            <%
                for (int i = 0; i < transactionIds.size(); i++) {
                    int transactionId = transactionIds.get(i);
                    Timestamp transactionDate = transactionDates.get(i);
                    boolean status = transactionStatuses.get(i);
            %>
            <tr>
                <td><%= transactionId %></td>
                <td><%= transactionDate %></td>
                <td>
                    <select name="status_<%= transactionId %>">
                        <option value="true" <%= status ? "selected" : "" %>>Completed</option>
                        <option value="false" <%= !status ? "selected" : "" %>>Pending</option>
                    </select>
                </td>
            </tr>
            <% } %>
        </table>
        <button type="submit">Save Changes</button>
    </form>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            // Only process form submission if it's a POST request
            try {
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/doughnut", "username", "password");
                
                // Prepare statement to update transaction status
                String updateSQL = "UPDATE Transactions SET Status = ? WHERE TransactionID = ?";
                PreparedStatement psUpdate = conn.prepareStatement(updateSQL);
                
                for (Integer transactionId : transactionIds) {
                    // Retrieve the updated status for each transaction
                    String statusParam = request.getParameter("status_" + transactionId);
                    boolean updatedStatus = Boolean.parseBoolean(statusParam);

                    // Update each transaction with the new status
                    psUpdate.setBoolean(1, updatedStatus);
                    psUpdate.setInt(2, transactionId);
                    psUpdate.executeUpdate();
                }
                
                psUpdate.close();
                out.println("<p>Changes saved successfully.</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error saving changes. Please try again.</p>");
            } finally {
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>
