<%@ page language="java" %>
<%
    if (session.getAttribute("username") != null) {
        response.sendRedirect("StaffPortal.jsp");
        return;
    }

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        if (username.equals("admin") && password.equals("password")) {
            session.setAttribute("username", username);

            response.sendRedirect("StaffPortal.jsp");
            return;
        } else {
            out.println("<p style='color:red;'>Invalid username or password.</p>");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Doughnut Den</title>
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
        <h1>Login</h1>
        <form method="post" action="Login.jsp">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>


