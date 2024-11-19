package store;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Report")
public class Report extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Report class fields
    private int id;
    private String name;
    private String description;
    private double price;
    private boolean status;
    private int categoryID;
    private String categoryName;
    private int totalQuantitySold;  
    private double totalSales;  
    private int freshQty;
    private int staleQty;
    private int totalQty;

    // Constructor
    public Report() {
        super();
    }

    // Getters and setters for Report fields
    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public boolean getStatus() {
        return status;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public int getQuantitySold() {
        return totalQuantitySold;
    }

    public double getTotalSales() {
        return totalSales;
    }
    
    public int getFreshQty(){
    	return freshQty;
    }
    
    public int getStaleQty(){
    	return staleQty;
    }
    
    public int getTotalQty(){
    	return totalQty;
    }
    
    private List<Report> getDoughnutSalesReport(String startDate, String endDate) throws SQLException {
        List<Report> doughnutList = new ArrayList<>();
        
        String basicInfoQuery = "SELECT d.DoughnutID, d.Name, d.Price, c.Name AS CategoryName "
                              + "FROM Doughnuts d "
                              + "LEFT JOIN Category c ON d.CategoryID = c.CategoryID "
                              + "ORDER BY d.DoughnutID";
        String transactionQuery = "SELECT td.DoughnutID, "
                                + "IFNULL(SUM(td.DoughnutQty), 0) AS TotalQuantitySold, "
                                + "IFNULL(SUM(td.DoughnutQty * d.Price), 0) AS TotalSales "
                                + "FROM TransactionDetails td "
                                + "INNER JOIN Transactions t ON td.TransactionID = t.TransactionID "
                                + "INNER JOIN Doughnuts d ON td.DoughnutID = d.DoughnutID "
                                + "WHERE t.Date BETWEEN ? AND ? "
                                + "GROUP BY td.DoughnutID";

        String trayQuery = "SELECT tr.DoughnutID, "
                         + "IFNULL(SUM(tr.TotalQty), 0) AS TotalQty, "
                         + "IFNULL(SUM(tr.FreshQty), 0) AS FreshQty "
                         + "FROM Trays tr "
                         + "WHERE tr.DateTime BETWEEN ? AND ? "
                         + "GROUP BY tr.DoughnutID";

        try (Connection connection = Database.getConnection();
             PreparedStatement basicInfoStatement = connection.prepareStatement(basicInfoQuery);
             ResultSet basicInfoResultSet = basicInfoStatement.executeQuery()) {

            while (basicInfoResultSet.next()) {
                Report report = new Report();
                report.id = basicInfoResultSet.getInt("DoughnutID");
                report.name = basicInfoResultSet.getString("Name");
                report.price = basicInfoResultSet.getDouble("Price");
                report.categoryName = basicInfoResultSet.getString("CategoryName");
                report.totalQuantitySold = 0;
                report.totalSales = 0.0;
                report.totalQty = 0;
                report.freshQty = 0;
                report.staleQty = 0;

                doughnutList.add(report);
            }

            try (PreparedStatement transactionStatement = connection.prepareStatement(transactionQuery)) {
                transactionStatement.setString(1, startDate);
                transactionStatement.setString(2, endDate);

                try (ResultSet transactionResultSet = transactionStatement.executeQuery()) {
                    while (transactionResultSet.next()) {
                        int doughnutId = transactionResultSet.getInt("DoughnutID");
                        int totalQuantitySold = transactionResultSet.getInt("TotalQuantitySold");
                        double totalSales = transactionResultSet.getDouble("TotalSales");

                        for (Report report : doughnutList) {
                            if (report.id == doughnutId) {
                                report.totalQuantitySold = totalQuantitySold;
                                report.totalSales = totalSales;
                                break;
                            }
                        }
                    }
                }
            }

            try (PreparedStatement trayStatement = connection.prepareStatement(trayQuery)) {
                trayStatement.setString(1, startDate);
                trayStatement.setString(2, endDate);

                try (ResultSet trayResultSet = trayStatement.executeQuery()) {
                    while (trayResultSet.next()) {
                        int doughnutId = trayResultSet.getInt("DoughnutID");
                        int totalQty = trayResultSet.getInt("TotalQty");
                        int freshQty = trayResultSet.getInt("FreshQty");
                        int staleQty = totalQty - freshQty;

                        for (Report report : doughnutList) {
                            if (report.id == doughnutId) {
                                report.totalQty = totalQty;
                                report.freshQty = freshQty;
                                report.staleQty = staleQty;
                                break;
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return doughnutList;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            if (startDate != null && endDate != null) {
                List<Report> report = getDoughnutSalesReport(startDate, endDate);
                request.setAttribute("report", report);
                request.getRequestDispatcher("/Report.jsp").forward(request, response);
            } else {
                response.sendRedirect("ErrorPage.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ErrorPage.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
