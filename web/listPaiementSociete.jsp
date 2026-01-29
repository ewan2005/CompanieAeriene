<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paiements Publicité - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link active">
                    <span class="icon">🏠</span> Accueil
                </a>
                <a href="<%= request.getContextPath() %>/TrajetServlet" class="nav-link">
                    <span class="icon">🧭</span> Trajets
                </a>
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link">
                    <span class="icon">🛫</span> Vols
                </a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link">
                    <span class="icon">📋</span> Réservations
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link">
                    <span class="icon">➕</span> Nouveau trajet
                </a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link">
                    <span class="icon">✈️</span> Avions
                </a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link">
                    <span class="icon">🏢</span> Aéroports
                </a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link">
                    <span class="icon">👥</span> Passagers
                </a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link">
                    <span class="icon">🎫</span> Billets
                </a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link">
                    <span class="icon">💳</span> Paiements
                </a>
                <a href="<%= request.getContextPath() %>/validation.jsp" class="nav-link">
                    <span class="icon">✅</span> Validation
                </a>
                <a href="<%= request.getContextPath() %>/error.jsp" class="nav-link">
                    <span class="icon">⚠️</span> Erreurs
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Publicité</div>
                <a href="<%= request.getContextPath() %>/SocieteServlet" class="nav-link">
                    <span class="icon">🏛️</span> Sociétés
                </a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet" class="nav-link">
                    <span class="icon">📺</span> Diffusions
                </a>
                <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="nav-link">
                    <span class="icon">⚙️</span> Config Tarif Pub
                </a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=ca" class="nav-link">
                    <span class="icon">📊</span> CA Publicité
                </a>
                <a href="<%= request.getContextPath() %>/DiffusionPaiementServlet" class="nav-link">
                    <span class="icon">💹</span> Paiements Diffusions
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Statistiques</div>
                <a href="<%= request.getContextPath() %>/CAParVolServlet" class="nav-link">
                    <span class="icon">📈</span> CA par Vol
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Compte</div>
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link">
                    <span class="icon">🚪</span> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">💳</span> Paiements Publicité</h1>
                <%
                    oo.AchatDiffusion achatFiltre = (oo.AchatDiffusion) request.getAttribute("achat");
                    java.math.BigDecimal totalPaye = (java.math.BigDecimal) request.getAttribute("totalPaye");
                    java.math.BigDecimal resteAPayer = (java.math.BigDecimal) request.getAttribute("resteAPayer");
                %>
                <% if (achatFiltre != null) { %>
                    <p class="page-subtitle">
                        Paiements pour: <strong><%= achatFiltre.getSociete() != null ? achatFiltre.getSociete().getNom() : "-" %></strong>
                        - <%= achatFiltre.getNombreDiffusions() %> diffusions 
                        (<%= String.format("%02d", achatFiltre.getMois()) %>/<%= achatFiltre.getAnnee() %>)
                    </p>
                <% } else { %>
                    <p class="page-subtitle">Historique de tous les paiements de publicité</p>
                <% } %>
            </div>
            <div>
                <% if (achatFiltre != null) { %>
                    <a href="<%= request.getContextPath() %>/PaiementSocieteServlet?action=new&idAchat=<%= achatFiltre.getIdAchat() %>" class="btn btn-primary">
                        ➕ Nouveau Paiement
                    </a>
                    <a href="<%= request.getContextPath() %>/PaiementSocieteServlet" class="btn btn-secondary">
                        📋 Tous les paiements
                    </a>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/PaiementSocieteServlet?action=new" class="btn btn-primary">
                        ➕ Nouveau Paiement
                    </a>
                <% } %>
            </div>
        </div>

        <% if (achatFiltre != null && totalPaye != null && resteAPayer != null) { %>
        <div class="stats-grid" style="margin-bottom: 20px;">
            <div class="stat-card">
                <div class="stat-value"><%= String.format("%,.0f", achatFiltre.getMontantTotal().doubleValue()) %> Ar</div>
                <div class="stat-label">💵 Montant Total Dû</div>
            </div>
            <div class="stat-card" style="border-left: 4px solid #28a745;">
                <div class="stat-value" style="color: #28a745;"><%= String.format("%,.0f", totalPaye.doubleValue()) %> Ar</div>
                <div class="stat-label">✅ Total Payé</div>
            </div>
            <div class="stat-card" style="border-left: 4px solid <%= resteAPayer.compareTo(java.math.BigDecimal.ZERO) > 0 ? "#dc3545" : "#28a745" %>;">
                <div class="stat-value" style="color: <%= resteAPayer.compareTo(java.math.BigDecimal.ZERO) > 0 ? "#dc3545" : "#28a745" %>;">
                    <%= String.format("%,.0f", resteAPayer.doubleValue()) %> Ar
                </div>
                <div class="stat-label">
                    <% if (resteAPayer.compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                        ⏳ Reste à Payer
                    <% } else { %>
                        ✓ Soldé
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">📋 Liste des paiements</h3>
            </div>
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <% if (achatFiltre == null) { %>
                            <th>Société</th>
                            <th>Période</th>
                            <% } %>
                            <th>Montant</th>
                            <th>Référence</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List paiements = (java.util.List) request.getAttribute("paiements");
                            if (paiements != null && !paiements.isEmpty()) {
                                for (Object o : paiements) {
                                    oo.PaiementSociete p = (oo.PaiementSociete) o;
                                    oo.AchatDiffusion achat = null;
                                    try { achat = p.getAchat(); } catch (Exception e) {}
                        %>
                        <tr>
                            <td><%= p.getDatePaiement() != null ? p.getDatePaiement().toString() : "-" %></td>
                            <% if (achatFiltre == null) { %>
                            <td>
                                <strong><%= achat != null && achat.getSociete() != null ? achat.getSociete().getNom() : "-" %></strong>
                            </td>
                            <td>
                                <% if (achat != null) { %>
                                    <span class="badge badge-info"><%= String.format("%02d", achat.getMois()) %>/<%= achat.getAnnee() %></span>
                                <% } else { %>
                                    -
                                <% } %>
                            </td>
                            <% } %>
                            <td><strong style="color: #28a745;"><%= String.format("%,.0f", p.getMontant().doubleValue()) %> Ar</strong></td>
                            <td><%= p.getReference() != null && !p.getReference().isEmpty() ? p.getReference() : "-" %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/PaiementSocieteServlet?action=edit&id=<%= p.getIdPaiement() %>" 
                                   class="btn btn-secondary btn-sm">✏️</a>
                                <a href="<%= request.getContextPath() %>/PaiementSocieteServlet?action=delete&id=<%= p.getIdPaiement() %>" 
                                   class="btn btn-danger btn-sm" 
                                   onclick="return confirm('Supprimer ce paiement ?');">🗑️</a>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="<%= achatFiltre == null ? 6 : 4 %>" style="text-align: center;">
                                Aucun paiement enregistré.
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <% if (achatFiltre != null) { %>
        <div style="margin-top: 20px;">
            <a href="<%= request.getContextPath() %>/DiffusionServlet" class="btn btn-secondary">
                ⬅️ Retour aux achats
            </a>
        </div>
        <% } %>
    </main>
</div>
</body>
</html>
