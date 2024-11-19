<%@ page language="java" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Portal - Doughnut Den</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
	<header class="headerBanner">
	    <h1 class="headerMain">
	        <a href="Menu.jsp">
	            <img src="images/Doughnut-Icon.png"/>
	            Doughnut Den
	        </a>
	    </h1>
	</header>

    <div class="portal-container">
        <h1>Staff Portal</h1>
        <nav>
            <a href="MenuEdit.jsp">Edit Menu</a>
            <a href="TrayEdit.jsp">Edit Tray</a>
            <a href="TransactionEdit.jsp">Edit Transactions</a>
            <a href="Report.jsp">Generate Reports</a>
        </nav>
        <form action="Logout.jsp" method="post">
            <button type="submit">Logout</button>
        </form>
    </div>
</body>
</html>
