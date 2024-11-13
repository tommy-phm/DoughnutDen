package store;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/Cart")
public class Cart extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve doughnut ID and quantity from the request
        int doughnutId = Integer.parseInt(request.getParameter("doughnutId"));

        // Fetch doughnut details based on ID
        Doughnut selectedDoughnut = Doughnut.getDoughnutById(doughnutId);
        if (selectedDoughnut == null) {
            response.sendRedirect("Menu.jsp");
            return;
        }
        
        Doughnut cartItem = new Doughnut(
                selectedDoughnut.getId(),
                selectedDoughnut.getName(),
                selectedDoughnut.getDescription(),
                selectedDoughnut.getPrice(),
                selectedDoughnut.getStatus(),
                selectedDoughnut.getCategory()
            );

        // Retrieve or create the cart session attribute
        HttpSession session = request.getSession();
        List<Doughnut> cart = (List<Doughnut>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        // Add doughnut to cart
        cart.add(cartItem);

        // Redirect back to the menu or cart page
        response.sendRedirect("Menu.jsp");
    }
}
