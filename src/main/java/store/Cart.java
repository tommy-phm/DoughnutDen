package store;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;


@WebServlet("/Cart")
public class Cart extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve or create the cart session attribute
        HttpSession session = request.getSession();
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
            // Example entry for testing
            cart.put(1, 3); // Example: Donut with ID 1 and quantity 3
        }
        
     // Retrieve doughnut ID and quantity from the request
        try {
            // Retrieve doughnut ID and quantity from the request
            int doughnutId = Integer.parseInt(request.getParameter("doughnutId"));
            int requestedQuantity = Integer.parseInt(request.getParameter("quantity"));

            // Check available quantity in the Trays database
            int availableQuantity = getAvailableQuantity(doughnutId);

            if (requestedQuantity > availableQuantity) {
                // Redirect to menu and pass the available quantity as a parameter
                response.sendRedirect("Menu.jsp?error=Only " + availableQuantity + " donuts of this type are available.");
            } else {
                // Add doughnut to cart
                cart.put(doughnutId, cart.getOrDefault(doughnutId, 0) + requestedQuantity);
                response.sendRedirect("Menu.jsp");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("Menu.jsp?error=Invalid input. Please try again.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Menu.jsp?error=An error occurred. Please try again later.");
        }
    }
    
    private int getAvailableQuantity(int doughnutId) throws Exception {
    	Connection conn = Database.getConnection();

        String query = "SELECT SUM(FreshQty) AS totalAvailable FROM Trays WHERE DoughnutID = ?";
        int totalAvailable = 0;

        try (conn;
             PreparedStatement statement = conn.prepareStatement(query)) {

            statement.setInt(1, doughnutId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    totalAvailable = resultSet.getInt("totalAvailable");
                }
            }
        }

        return totalAvailable;
    }
}
