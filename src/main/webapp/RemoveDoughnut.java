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
import java.util.Map;
import java.util.HashMap;

@WebServlet("/RemoveDoughnut")
public class RemoveDoughnut extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	// Parse the doughnut ID from the request parameter
        int doughnutId = Integer.parseInt(request.getParameter("doughnutId"));

        // Get the cart from the session
        HttpSession session = request.getSession();
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart != null) {
            // Remove the doughnut from the cart or decrease its quantity
            if (cart.containsKey(doughnutId)) {
                int currentQuantity = cart.get(doughnutId);
                if (currentQuantity > 1) {
                    // Decrease the quantity by 1
                    cart.put(doughnutId, currentQuantity - 1);
                } else {
                    // Remove the doughnut completely if the quantity is 1
                    cart.remove(doughnutId);
                }
            }
        }

        // Redirect back to the cart page
        response.sendRedirect("Cart.jsp");
    }
}
