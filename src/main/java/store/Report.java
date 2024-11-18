package store;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Report")
public class Report extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String doughnutId = request.getParameter("doughnutId");
        String timePeriod = request.getParameter("timePeriod");
        String dateInput = request.getParameter("date");

        if (doughnutId != null && timePeriod != null && dateInput != null) {
            try {
                // Parse the selected date from the user input (it's a date, so we convert it to java.sql.Date)
                java.sql.Date date = java.sql.Date.valueOf(dateInput);
                
                // Database connection
                Connection conn = Database.getConnection();
                
                // Adjust the query to filter based on time period (day, month, year)
                String dateCondition = "";
                if (timePeriod.equals("day")) {
                    dateCondition = "DATE(t.DateTime) = ?";
                } else if (timePeriod.equals("month")) {
                    dateCondition = "YEAR(t.DateTime) = YEAR(?) AND MONTH(t.DateTime) = MONTH(?)";
                } else if (timePeriod.equals("year")) {
                    dateCondition = "YEAR(t.DateTime) = YEAR(?)";
                }
                
                // SQL Query to get doughnut name, category name, total quantities, and sales data, including price
                String query = "SELECT d.Name AS DoughnutName, c.Name AS CategoryName, " +
                               "d.Price AS DoughnutPrice, " +
                               "SUM(t.TotalQty) AS TotalQty, SUM(t.FreshQty) AS FreshQty, " +
                               "(SUM(t.TotalQty) - SUM(t.FreshQty)) AS StaleQty, " +
                               "SUM(td.DoughnutQty) AS TotalAmountSold, " +
                               "SUM(td.DoughnutQty * d.Price) AS TotalSales " +
                               "FROM Doughnuts d " +
                               "JOIN Category c ON d.CategoryID = c.CategoryID " +
                               "JOIN Trays t ON d.DoughnutID = t.DoughnutID " +
                               "JOIN TransactionDetails td ON d.DoughnutID = td.DoughnutID " +
                               "WHERE d.DoughnutID = ? AND " + dateCondition +
                               " GROUP BY d.DoughnutID, d.Name, c.Name, d.Price";

                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, Integer.parseInt(doughnutId));

                // Set the date parameter to the query. We need to set it based on the time period.
                stmt.setDate(2, date);  // Always set the date
                if (timePeriod.equals("month") || timePeriod.equals("year")) {
                    stmt.setDate(3, date);  // For month or year, we set the same date twice
                }

                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    // Set attributes to be displayed on the JSP page
                    request.setAttribute("doughnutName", rs.getString("DoughnutName"));
                    request.setAttribute("categoryName", rs.getString("CategoryName"));
                    request.setAttribute("doughnutPrice", rs.getDouble("DoughnutPrice"));
                    request.setAttribute("totalQty", rs.getInt("TotalQty"));
                    request.setAttribute("freshQty", rs.getInt("FreshQty"));
                    request.setAttribute("staleQty", rs.getInt("StaleQty"));
                    request.setAttribute("totalAmountSold", rs.getInt("TotalAmountSold"));
                    request.setAttribute("totalSales", rs.getDouble("TotalSales"));
                } else {
                    // If no results are found, set an error message
                    request.setAttribute("error", "No data found for the selected period.");
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while fetching the report.");
            }
        }

        // Forward to JSP
        request.getRequestDispatcher("Report.jsp").forward(request, response);
    }
}
