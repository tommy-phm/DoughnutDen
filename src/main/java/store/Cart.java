package store;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/Cart")
public class Cart extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve or create the cart session attribute
        HttpSession session = request.getSession();
        List<Doughnut> cart = (List<Doughnut>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
            
            
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
        for (int i = 0; i < quantity; i++) {
            Doughnut cartItem = new Doughnut(
                selectedDoughnut.getId(),
                selectedDoughnut.getName(),
                selectedDoughnut.getDescription(),
                selectedDoughnut.getPrice(),
                selectedDoughnut.getStatus(),
                selectedDoughnut.getCategoryID(),
                selectedDoughnut.getCategoryName()
            );
            cart.add(cartItem);
        }

        // Redirect back to the menu or cart page
        response.sendRedirect("Menu.jsp");
    }
}
