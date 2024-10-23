<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="store.Doughnut" %>
<html>
<head>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- HEADER -------------------------------------------------------------->
    <header class="headerBanner">
        <h1 class="headerMain"> <!-- The title of tha displayed Page-->
          <a href="Menu.jsp">
               <img src="images/Donut-Icon.png" alt="Icon for DonutDen" width=50px/>
          </a>
          Donut Den
        </h1>
    
        <h3 class="headerSub">
            <!-- Drop-down menu ----------------------->
            <div class="nav-dropdown">
              <button>Dropdown</button>
              <div class="dropdown-content">
                <a href="TODO">Storefront</a>
                <a href="TODO">Employee Portal</a>
                <a href="TODO">About US</a>
              </div>
            </div> 
        </h3>
    </header>


    <!-- BODY ---------------------------------------------------------------->
    <h1>Doughnut Menu Edit</h1>
    <% List<Doughnut> doughnuts = Doughnut.getDoughnuts(); %>
    <form action="MenuEdit.jsp" method="post">
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Doughnut doughnut : doughnuts) {
                %>
                <tr>
                    <td><input type="text" name="name_<%= doughnut.getId() %>" value="<%= doughnut.getName() %>" /></td>
                    <td><input type="text" name="description_<%= doughnut.getId() %>" value="<%= doughnut.getDescription() %>" /></td>
                    <td><input type="text" name="price_<%= doughnut.getId() %>" value="<%= String.format("%.2f", doughnut.getPrice()) %>" /></td>
                    <td><input type="checkbox" name="status_<%= doughnut.getId() %>" <%= doughnut.getStatus() ? "checked" : "" %> /></td>
                </tr>
                <%
                    }
                %>
                <tr>
                    <td><input type="text" name="name_new" placeholder="New Doughnut Name" /></td>
                    <td><input type="text" name="description_new" placeholder="New Doughnut Description" /></td>
                    <td><input type="text" name="price_new" placeholder="New Doughnut Price" /></td>
                    <td><input type="checkbox" name="status_new" /></td>
                </tr>
            </tbody>
        </table>
        <input type="submit" value="Update Doughnuts" />
    </form>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            Doughnut.updateDoughnuts(request);

            String newName = request.getParameter("name_new");
            String newDescription = request.getParameter("description_new");
            String newPriceString = request.getParameter("price_new");
            String newStatus = request.getParameter("status_new");

            if (newName != null && !newName.trim().isEmpty() &&
                newDescription != null && !newDescription.trim().isEmpty() &&
                newPriceString != null && !newPriceString.trim().isEmpty()) {

                double newPrice = Double.parseDouble(newPriceString);
                boolean newDoughnutStatus = newStatus != null;

                Doughnut.insertDoughnut(newName, newDescription, newPrice, newDoughnutStatus);
            }
            response.sendRedirect("MenuEdit.jsp");
        }
    %>
</body>
</html>
