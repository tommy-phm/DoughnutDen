<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="store.*"%>

<%
    // Database connection variables
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    List<Integer> transactionIds = new ArrayList<>();
    List<Timestamp> transactionDates = new ArrayList<>();
    List<Boolean> transactionStatuses = new ArrayList<>();

    try {
        // Establish connection using Database utility
        conn = Database.getConnection();

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
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<html>
<head>
    <title>Edit Transactions</title>
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
	
    <h1>Edit Transaction  Page</h1>
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
                
                conn = Database.getConnection();
                
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
