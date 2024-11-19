<%@ page language="java" %>
<%
    if (session != null) {
        session.invalidate();
    }
    response.sendRedirect("Login.jsp");
%>
