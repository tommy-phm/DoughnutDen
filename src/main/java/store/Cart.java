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
        int doughnutId = Integer.parseInt(request.getParameter("doughnutId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Fetch doughnut details based on ID
        Doughnut selectedDoughnut = Doughnut.getDoughnutById(doughnutId);
        if (selectedDoughnut == null) {
            response.sendRedirect("Menu.jsp");
            return;
        }

        // Add doughnut to cart
        cart.put(doughnutId, quantity);

        // Redirect back to the menu or cart page
        response.sendRedirect("Menu.jsp");
    }
}
