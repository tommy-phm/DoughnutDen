package store;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;

public class Doughnut {
    private int id;
    private String name;
    private String description;
    private double price;
    private boolean status;
    private String category;

    public Doughnut(int id, String name, String description, double price, boolean status, String category) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.status = status;
        this.category = category;
    }

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

    public String getCategory() {
        return category; 
    }

    public static void insertDoughnut(String name, String description, double price, boolean status) {
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "INSERT INTO Doughnuts (Name, Description, Price, Status) VALUES (?, ?, ?, ?)")) {
             
            statement.setString(1, name);
            statement.setString(2, description);
            statement.setDouble(3, price);
            statement.setBoolean(4, status);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Doughnut getDoughnutById(int doughnutId) {
        Doughnut doughnut = null;
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "SELECT d.DoughnutID, d.Name, d.Description, d.Price, d.Status, c.Name AS CategoryName " +
                 "FROM Doughnuts d " +
                 "JOIN Category c ON d.CategoryID = c.CategoryID " +
                 "WHERE d.DoughnutID = ?")) {
            statement.setInt(1, doughnutId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    int id = resultSet.getInt("DoughnutID");
                    String name = resultSet.getString("Name");
                    String description = resultSet.getString("Description");
                    double price = resultSet.getDouble("Price");
                    boolean status = resultSet.getBoolean("Status");
                    String category = resultSet.getString("CategoryName");

                    doughnut = new Doughnut(id, name, description, price, status, category);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doughnut;
    }

    public static List<Doughnut> getDoughnuts() {
        List<Doughnut> doughnuts = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "SELECT d.DoughnutID, d.Name, d.Description, d.Price, d.Status, c.Name AS CategoryName " +
                 "FROM Doughnuts d " +
                 "JOIN Category c ON d.CategoryID = c.CategoryID"); 
             ResultSet resultSet = statement.executeQuery()) {
             
            while (resultSet.next()) {
                int id = resultSet.getInt("DoughnutID");
                String name = resultSet.getString("Name");
                String description = resultSet.getString("Description");
                double price = resultSet.getDouble("Price");
                boolean status = resultSet.getBoolean("Status");
                String category = resultSet.getString("CategoryName");

                doughnuts.add(new Doughnut(id, name, description, price, status, category));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return doughnuts;
    }

    public static void updateDoughnuts(HttpServletRequest request) {
        try (Connection connection = Database.getConnection()) {
            for (String parameter : request.getParameterMap().keySet()) {
                if (parameter.startsWith("name_")) {
                    int id = Integer.parseInt(parameter.split("_")[1]);
                    String name = request.getParameter(parameter);
                    String description = request.getParameter("description_" + id);
                    double price = Double.parseDouble(request.getParameter("price_" + id));
                    boolean status = request.getParameter("status_" + id) != null;
                    String category = request.getParameter("category_" + id); 

                    try (PreparedStatement statement = connection.prepareStatement(
                            "UPDATE Doughnuts SET Name = ?, Description = ?, Price = ?, Status = ?, CategoryID = (SELECT CategoryID FROM Category WHERE Name = ?) WHERE DoughnutID = ?")) { // Update to set CategoryID
                        statement.setString(1, name);
                        statement.setString(2, description);
                        statement.setDouble(3, price);
                        statement.setBoolean(4, status);
                        statement.setString(5, category);
                        statement.setInt(6, id);
                        statement.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
