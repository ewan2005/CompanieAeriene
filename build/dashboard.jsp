<%@ page import="oo.Dashboard" %>
<%@ page import="java.util.Vector" %>
<% 
    Vector<Dashboard> dashboards = (Vector<Dashboard>) request.getAttribute("dashboards");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=`">
    <title>Document</title>
</head>
<body>
    <h1>Dashboard</h1>
    <table border="1">
        <thead>
            <tr>
                <th>Type credit</th>
                <th>Montant depense</th>
                <th>Reste</th>
            </tr>
        </thead>
        <tbody>
            <% for(Dashboard d : dashboards) { %>
                <tr>
                    <td><%= d.getTypeCredit() %></td>
                    <td><%= d.getMontantDepense() %></td>
                    <td><%= d.getReste() %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
    <a href="${pageContext.request.contextPath}/Accueil.jsp">Revenir a la page d'accueil</a>
</body>
</html>