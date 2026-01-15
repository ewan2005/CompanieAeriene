<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Validation - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/TrajetServlet" class="nav-link"><span class="icon">🧭</span> Trajets</a>
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link"><span class="icon">➕</span> Nouveau trajet</a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
                <a href="<%= request.getContextPath() %>/validation.jsp" class="nav-link active"><span class="icon">✅</span> Validation</a>
                <a href="<%= request.getContextPath() %>/error.jsp" class="nav-link"><span class="icon">⚠️</span> Erreurs</a>
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
            if (msg == null || msg.trim().isEmpty()) msg = "Opération effectuée avec succès.";
            if (back == null || back.trim().isEmpty()) back = request.getContextPath() + "/Accueil.jsp";
        %>

        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">✅</span> Validation</h1>
                <p class="page-subtitle"><%= msg %></p>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div style="display:flex; gap: 15px; flex-wrap: wrap;">
                    <a href="<%= back %>" class="btn btn-primary">↩️ Retour</a>
                    <a href="<%= request.getContextPath() %>/Accueil.jsp" class="btn btn-secondary">🏠 Accueil</a>
                </div>
            </div>
        </div>

        <div class="card" style="margin-top: 20px;">
            <div class="card-header">
                <h3 class="card-title">📌 Validations disponibles</h3>
            </div>
            <div class="card-body">
                <p style="margin-top: 0;">Accéder rapidement aux listes après une validation :</p>
                <div style="display:flex; gap: 12px; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/ReservationServlet" class="btn btn-secondary">📋 Réservations</a>
                    <a href="<%= request.getContextPath() %>/VolServlet" class="btn btn-secondary">🛫 Vols</a>
                    <a href="<%= request.getContextPath() %>/PassagerServlet" class="btn btn-secondary">👥 Passagers</a>
                    <a href="<%= request.getContextPath() %>/BilletServlet" class="btn btn-secondary">🎫 Billets</a>
                    <a href="<%= request.getContextPath() %>/PaiementServlet" class="btn btn-secondary">💳 Paiements</a>
                    <a href="<%= request.getContextPath() %>/AvionServlet" class="btn btn-secondary">✈️ Avions</a>
                    <a href="<%= request.getContextPath() %>/AeroportServlet" class="btn btn-secondary">🏢 Aéroports</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
