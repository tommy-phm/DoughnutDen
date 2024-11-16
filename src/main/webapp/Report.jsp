<%@ page import="java.sql.*" %>
<%@ page import="store.Database" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Report</title>
    <link rel="stylesheet" href="styles.css">
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

    <h2>Report</h2>

    <!-- Form to collect the query stuff -->
    <form action="Report.jsp" method="post">
        <label for="timeFrame">Select Time Frame:</label>
        <select name="timeFrame" id="timeFrame" required>
            <option value="weekly">Weekly</option>
            <option value="monthly">Monthly</option>
            <option value="yearly">Yearly</option>
        </select>

        <label for="type">Select Report Type:</label>
        <select name="type" id="type" required>
            <option value="transaction">Transaction</option>
            <option value="doughnut">Doughnut</option>
        </select>

        <button type="submit">Generate Report</button>
    </form>

    <h2>Report Results</h2>
    <div>
        <%
            ///check if form submitted with the two criteria
            String timeFrame = request.getParameter("timeFrame");
            String type = request.getParameter("type");

            if (timeFrame != null && type != null) {
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    ///connecting to database
                    conn = Database.getConnection();

                    ///dynamic query based on the input (timeFrame and type)
                    String query = "";

                    if ("transaction".equals(type)) {
                        query = "SELECT td.TractionID, t.Data, t.Status " +
                                "FROM tractiondetails td " +
                                "JOIN tractions t ON td.TractionID = t.TractionID " +
                                "WHERE t.Data BETWEEN ? AND ?";
                    } else if ("doughnut".equals(type)) {
                        query = "SELECT td.TractionID, td.DoughnutID, td.DoughnutQty, t.Data, t.Status " +
                                "FROM tractiondetails td " +
                                "JOIN tractions t ON td.TractionID = t.TractionID " +
                                "WHERE t.Data BETWEEN ? AND ?";
                    }

                    stmt = conn.prepareStatement(query);

                    ///set the date range based on the time frame (weekly, monthly, yearly)
                    java.util.Date currentDate = new java.util.Date();
                    java.sql.Date startDate = null;
                    ///always today's date
                    java.sql.Date endDate = new java.sql.Date(currentDate.getTime());

                    if ("weekly".equals(timeFrame)) {
                    	///subtracts 7 days from current date
                        startDate = new java.sql.Date(currentDate.getTime() - 7L * 24 * 60 * 60 * 1000);
                    	///subtracts 30 days
                    } else if ("monthly".equals(timeFrame)) {
                        startDate = new java.sql.Date(currentDate.getTime() - 30L * 24 * 60 * 60 * 1000);
                    	///subtracts 365
                    } else if ("yearly".equals(timeFrame)) {
                        startDate = new java.sql.Date(currentDate.getTime() - 365L * 24 * 60 * 60 * 1000);
                    }

                    ///set the parameters for querying
                    stmt.setDate(1, startDate);
                    stmt.setDate(2, endDate);

                    ///execute query and store in ResultSet object
                    rs = stmt.executeQuery();
        %>

		<!-- Result Display -->
        <table border="1">
            <tr>
                <th>Traction ID</th>
                <% if ("doughnut".equals(type)) { %>
                <th>Doughnut ID</th>
                <th>Doughnut Quantity</th>
                <% } %>
                <th>Date</th>
                <th>Status</th>
            </tr>

        <%
            ///loop through the result set and display data in table
            while (rs.next()) {
                int tractionID = rs.getInt("TractionID");
                String data = rs.getString("Data");
                String status = rs.getString("Status");

                if ("doughnut".equals(type)) {
                    int doughnutID = rs.getInt("DoughnutID");
                    int doughnutQty = rs.getInt("DoughnutQty");
        %>
            <tr>
                <td><%= tractionID %></td>
                <td><%= doughnutID %></td>
                <td><%= doughnutQty %></td>
                <td><%= data %></td>
                <td><%= status %></td>
            </tr>
        <%
                } else {
        %>
            <tr>
                <td><%= tractionID %></td>
                <td><%= data %></td>
                <td><%= status %></td>
            </tr>
        <%
                }
            }
        %>
        </table>

        <%
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>
    </div>

</body>
</html>
