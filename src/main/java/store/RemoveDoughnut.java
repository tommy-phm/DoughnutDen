package store;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/RemoveDoughnut")
public class RemoveDoughnut extends HttpServlet {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/doughnutdb"; // Adjust database URL
    private static final String DB_USER = "username"; // Replace with actual DB username
    private static final String DB_PASSWORD = "password"; // Replace with actual DB password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int doughnutId = Integer.parseInt(request.getParameter("doughnutId"));

        HttpSession session = request.getSession();
        List<Doughnut> cart = (List<Doughnut>) session.getAttribute("cart");
        if (cart != null) {
            // Check if donut exists in cart and remove it
            boolean removed = false;
            for (int i = 0; i < cart.size(); i++) {
                Doughnut d = cart.get(i);
                if (d.getId() == doughnutId) {
                    cart.remove(i);
                    removed = true;
                    break;
                }
            }
            
            // Only update the database if the donut was found and removed from the cart
            if (removed) {
                updateDoughnutStock(doughnutId);
            }
        }

        response.sendRedirect("Cart.jsp");
    }

    // Method to update doughnut quantity in the database
    private void updateDoughnutStock(int doughnutId) {
        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "UPDATE doughnuts SET quantity = quantity + 1 WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, doughnutId);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log or handle the exception
        }
    }
}
