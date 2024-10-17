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

    public Doughnut(int id, String name, String description, double price, boolean status) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.status = status;
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

    public static List<Doughnut> getDoughnuts() {
        List<Doughnut> doughnuts = new ArrayList<>();
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                 "SELECT DoughnutID, Name, Description, Price, Status FROM Doughnuts");
             ResultSet resultSet = statement.executeQuery()) {
             
            while (resultSet.next()) {
                int id = resultSet.getInt("DoughnutID");
                String name = resultSet.getString("Name");
                String description = resultSet.getString("Description");
                double price = resultSet.getDouble("Price");
                boolean status = resultSet.getBoolean("Status");

                doughnuts.add(new Doughnut(id, name, description, price, status));
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

                    try (PreparedStatement statement = connection.prepareStatement(
                            "UPDATE Doughnuts SET Name = ?, Description = ?, Price = ?, Status = ? WHERE DoughnutID = ?")) {
                        statement.setString(1, name);
                        statement.setString(2, description);
                        statement.setDouble(3, price);
                        statement.setBoolean(4, status);
                        statement.setInt(5, id);
                        statement.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
