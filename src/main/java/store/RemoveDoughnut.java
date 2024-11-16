package store;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/RemoveDoughnut")
public class RemoveDoughnut extends HttpServlet {
	private static final long serialVersionUID = 1L;

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
    	String sql = "UPDATE doughnuts SET quantity = quantity + 1 WHERE id = ?";
        try (Connection connection = Database.getConnection()) {
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, doughnutId);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log or handle the exception
        }
    }
}
