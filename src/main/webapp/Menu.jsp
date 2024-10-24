<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="store.Doughnut" %>
<html>
<head>
    <link rel="stylesheet" href="styles.css">
    <title>DonutDen</title> <!-- Titles the tab-->
    <link rel="icon" href="assets/Donut-Icon.png" type="image/png" /> <!-- this gives the icon to a tab-->
    <style>
        img {
            max-width: 100px;
            max-height: 100px; 
            width: auto;
            height: auto;
        }
    </style>
</head>
<body>
    <!-- HEADER -------------------------------------------------------------->
    <header class="headerBanner">
        <h1 class="headerMain"> <!-- The title of the displayed Page-->
          <a href="Menu.jsp">
               <img src="images/Donut-Icon.png" alt="Icon for DonutDen" width="50" />
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
    <h1>Doughnut Menu</h1>
    <%
        List<Doughnut> doughnuts = Doughnut.getDoughnuts();
    %>
    <table>
        <thead>
            <tr>
                <th>Image</th>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
                <th>Category </th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Doughnut doughnut : doughnuts) {
            %>
            <tr>
                <td><img src="images/<%= doughnut.getId() %>.png"></td>
                <td><a href="Doughnut/<%= doughnut.getId() %>"><%= doughnut.getName() %></a></td>
                <td><%= doughnut.getDescription() %></td>
                <td>$<%= String.format("%.2f", doughnut.getPrice()) %></td>
                <td><%= doughnut.getCategory() %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
