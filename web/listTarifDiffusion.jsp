<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuration Tarif Publicité - Skyfly Airlines</title>
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
                <h1 class="page-title"><span class="icon">⚙️</span> Configuration Tarif Publicité</h1>
                <p class="page-subtitle">Gérez les tarifs de diffusion vidéo</p>
            </div>
            <a href="<%= request.getContextPath() %>/TarifDiffusionServlet?action=new" class="btn btn-primary">➕ Nouveau Tarif</a>
        </div>

        <!-- Tarif actuel -->
        <div class="card" style="margin-bottom: 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <div class="card-body" style="color: white; text-align: center;">
                <h2>💰 Tarif Actuel en Vigueur</h2>
                <p style="font-size: 48px; font-weight: bold; margin: 20px 0;">
                    <%= request.getAttribute("tarifActuel") != null ? 
                        String.format("%,.0f", ((java.math.BigDecimal)request.getAttribute("tarifActuel")).doubleValue()) : "400 000" %> Ar
                </p>
                <p>par diffusion</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Historique des tarifs</h3>
            </div>
            <div class="card-body">
                <p style="color: #666; margin-bottom: 15px;">
                    Le tarif le plus récent (date de début la plus proche) est utilisé pour les nouvelles diffusions.
                </p>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Coût par Diffusion</th>
                                <th>Date Début</th>
                                <th>Date Fin</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            java.util.List tarifs = (java.util.List) request.getAttribute("tarifs");
                            java.math.BigDecimal tarifActuel = (java.math.BigDecimal) request.getAttribute("tarifActuel");
                            if (tarifs != null && !tarifs.isEmpty()) {
                                for (Object o : tarifs) {
                                    oo.TarifDiffusion t = (oo.TarifDiffusion) o;
                                    boolean isActuel = tarifActuel != null && 
                                                       t.getCoutParDiffusion().compareTo(tarifActuel) == 0;
                        %>
                            <tr style="<%= isActuel ? "background: #e8f5e9;" : "" %>">
                                <td><span class="badge badge-info">#<%= t.getIdTarif() %></span></td>
                                <td><strong><%= String.format("%,.0f", t.getCoutParDiffusion().doubleValue()) %> Ar</strong></td>
                                <td><%= t.getDateDebut() %></td>
                                <td><%= t.getDateFin() != null ? t.getDateFin() : "<span style='color:#28a745;'>Actif</span>" %></td>
                                <td>
                                    <% if (isActuel) { %>
                                        <span class="badge badge-success">✓ En vigueur</span>
                                    <% } else { %>
                                        <span class="badge">Historique</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/TarifDiffusionServlet?action=edit&id=<%= t.getIdTarif() %>" class="btn btn-sm btn-primary">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/TarifDiffusionServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= t.getIdTarif() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer ce tarif ?')">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="6" style="text-align:center;">Aucun tarif configuré. Le tarif par défaut (400 000 Ar) sera utilisé.</td></tr>
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
</body>
</html>
