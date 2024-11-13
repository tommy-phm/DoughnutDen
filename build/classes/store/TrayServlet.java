package store;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/Tray")
public class TrayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ///fetch tray data from the model
        List<Tray> trays = Tray.getAllTrays();

        ///pass the tray list as an attribute
        request.setAttribute("trays", trays);

        ///forward the request to tray.jsp
        request.getRequestDispatcher("Tray.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ///handling add or update tray based on the 'action' parameter
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            ///update tray details
            int trayID = Integer.parseInt(request.getParameter("trayID"));
            int freshQty = Integer.parseInt(request.getParameter("freshQty"));
            int totalQty = Integer.parseInt(request.getParameter("totalQty"));
            Tray.updateTray(trayID, freshQty, totalQty);

        } else if ("add".equals(action)) {
            ///add a new tray
            int doughnutID = Integer.parseInt(request.getParameter("doughnutID"));
            int freshQty = Integer.parseInt(request.getParameter("freshQty"));
            int totalQty = Integer.parseInt(request.getParameter("totalQty"));
            Tray.addTray(doughnutID, freshQty, totalQty);
        }

        ///redirect back to the TrayEdit.jsp after updating or adding a tray
        response.sendRedirect("TrayEdit.jsp");
    }
}
