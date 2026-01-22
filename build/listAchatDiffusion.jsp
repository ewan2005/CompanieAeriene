<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Achats de Diffusions - Skyfly Airlines</title>
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
                <div class="nav-section-title">Publicité</div>
                <a href="<%= request.getContextPath() %>/SocieteServlet" class="nav-link"><span class="icon">🏛️</span> Sociétés</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet" class="nav-link active"><span class="icon">📺</span> Achats Diffusions</a>
                <a href="<%= request.getContextPath() %>/PaiementSocieteServlet" class="nav-link"><span class="icon">💳</span> Paiements Pub</a>
                <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="nav-link"><span class="icon">⚙️</span> Config Tarif Pub</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=ca" class="nav-link"><span class="icon">📊</span> CA Publicité</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Compte</div>
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link"><span class="icon">🚪</span> Déconnexion</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">📺</span> Achats de Diffusions Publicitaires</h1>
                <p class="page-subtitle">Gérez les achats de diffusions par les sociétés</p>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=ca" class="btn btn-success">📊 Voir CA</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=newAchat" class="btn btn-primary">➕ Nouvel Achat</a>
            </div>
        </div>

        <div class="card" style="margin-bottom: 20px;">
            <div class="card-body">
                <p><strong>💰 Tarif actuel par diffusion:</strong> 
                    <span class="badge badge-success">
                        <%= request.getAttribute("tarifActuel") != null ? 
                            String.format("%,.0f", ((java.math.BigDecimal)request.getAttribute("tarifActuel")).doubleValue()) : "400 000" %> Ar
                    </span>
                </p>
                <p style="color: #666; margin-top: 10px;">
                    <strong>Fonctionnement:</strong> Une société achète X diffusions pour un mois. 
                    Ces diffusions sont ensuite affectées aux vols où la publicité sera diffusée sur les écrans de l'avion.
                </p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Liste des achats de diffusions</h3>
            </div>
            <div class="card-body">
                <div class="filter-bar">
                    <input type="search" id="filterInput" class="form-control" placeholder="🔎 Rechercher..." autocomplete="off">
                </div>
                <div class="table-container">
                    <table class="table" id="listTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Société</th>
                                <th>Période</th>
                                <th>Diffusions</th>
                                <th>Montant Total</th>
                                <th>Payé</th>
                                <th>Reste à Payer</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            java.util.List achats = (java.util.List) request.getAttribute("achats");
                            if (achats != null && !achats.isEmpty()) {
                                for (Object o : achats) {
                                    oo.AchatDiffusion a = (oo.AchatDiffusion) o;
                                    int affectees = 0;
                                    int restantes = 0;
                                    java.math.BigDecimal montantPaye = java.math.BigDecimal.ZERO;
                                    java.math.BigDecimal resteAPayer = a.getMontantTotal();
                                    try {
                                        affectees = a.getDiffusionsAffectees();
                                        restantes = a.getDiffusionsRestantes();
                                        montantPaye = a.getMontantPaye();
                                        resteAPayer = a.getResteAPayer();
                                    } catch (Exception e) {}
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= a.getIdAchat() %></span></td>
                                <td><strong><%= a.getSociete() != null ? a.getSociete().getNom() : "-" %></strong></td>
                                <td><%= a.getPeriode() %></td>
                                <td>
                                    <span class="badge badge-primary"><%= a.getNombreDiffusions() %></span>
                                    <small style="color: #666;">(<%= affectees %>/<%= restantes %> aff./rest.)</small>
                                </td>
                                <td><strong><%= String.format("%,.0f", a.getMontantTotal().doubleValue()) %> Ar</strong></td>
                                <td><span style="color: #28a745;"><%= String.format("%,.0f", montantPaye.doubleValue()) %> Ar</span></td>
                                <td>
                                    <% if (resteAPayer.compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                        <strong style="color: #dc3545;"><%= String.format("%,.0f", resteAPayer.doubleValue()) %> Ar</strong>
                                    <% } else { %>
                                        <span class="badge badge-success">✓ Soldé</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (resteAPayer.compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                        <a href="<%= request.getContextPath() %>/PaiementSocieteServlet?action=new&idAchat=<%= a.getIdAchat() %>" 
                                           class="btn btn-sm btn-success" title="Payer">💳</a>
                                    <% } %>
                                    <a href="<%= request.getContextPath() %>/PaiementSocieteServlet?action=byAchat&idAchat=<%= a.getIdAchat() %>" 
                                       class="btn btn-sm btn-info" title="Historique paiements">📋</a>
                                    <% if (restantes > 0) { %>
                                        <a href="<%= request.getContextPath() %>/DiffusionServlet?action=affecter&idAchat=<%= a.getIdAchat() %>" 
                                           class="btn btn-sm btn-warning" title="Affecter aux vols">🎯</a>
                                    <% } %>
                                    <a href="<%= request.getContextPath() %>/DiffusionServlet?action=editAchat&id=<%= a.getIdAchat() %>" class="btn btn-sm btn-primary">✏️</a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="8" style="text-align:center;">Aucun achat de diffusion trouvé.</td></tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>
<script src="<%= request.getContextPath() %>/js/list-filter.js"></script>
</body>
</html>
