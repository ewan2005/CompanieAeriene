<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur - Skyfly Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
</head>
<body>
<div class="app-container">
    <nav class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <span class="plane-icon">✈️</span>
                <h2>Skyfly</h2>
            </div>
        </div>
        <div class="sidebar-nav">
            <div class="nav-section">
                <div class="nav-section-title">Menu Principal</div>
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link"><span class="icon">🏠</span> Accueil</a>
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
                <a href="<%= request.getContextPath() %>/validation.jsp" class="nav-link"><span class="icon">✅</span> Validation</a>
                <a href="<%= request.getContextPath() %>/error.jsp" class="nav-link active"><span class="icon">⚠️</span> Erreurs</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Compte</div>
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link"><span class="icon">🚪</span> Déconnexion</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <%
            String msg = request.getParameter("msg");
            String back = request.getParameter("back");
            if (msg != null) msg = URLDecoder.decode(msg, StandardCharsets.UTF_8);
            if (back != null) back = URLDecoder.decode(back, StandardCharsets.UTF_8);
            if (msg == null || msg.trim().isEmpty()) msg = "Une erreur est survenue.";
            if (back == null || back.trim().isEmpty()) back = request.getContextPath() + "/Accueil.jsp";
        %>

        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">⚠️</span> Erreur</h1>
                <p class="page-subtitle"><%= msg %></p>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div style="display:flex; gap: 15px; flex-wrap: wrap;">
                    <a href="<%= back %>" class="btn btn-secondary">↩️ Retour</a>
                    <a href="<%= request.getContextPath() %>/Accueil.jsp" class="btn btn-primary">🏠 Accueil</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
