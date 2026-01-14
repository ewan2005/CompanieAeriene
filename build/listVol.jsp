<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Vol" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Vols - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link active"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                    <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link"><span class="icon">➕</span> Nouveau trajet</a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
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
                <h1 class="page-title"><span class="icon">🛫</span> Liste des Vols</h1>
                <p class="page-subtitle">Un vol associe un trajet (itinéraire) à un avion</p>
            </div>
            <a href="<%= request.getContextPath() %>/VolServlet?action=new" class="btn btn-primary">➕ Nouveau Vol</a>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
        <div class="alert alert-danger">⚠️ <%= error %></div>
        <% } if (success != null) { %>
        <div class="alert alert-success">✅ <%= success %></div>
        <% } %>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">✈️ Tous les vols</h3>
            </div>
            <div class="card-body">
                <div class="filter-bar">
                    <select id="filterColumn" class="form-control">
                        <option value="-1">Toutes les colonnes</option>
                    </select>
                    <input type="search" id="filterInput" class="form-control" placeholder="🔎 Rechercher..." autocomplete="off">
                </div>
                <div class="table-container">
                    <table class="table" id="listTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>N° Vol</th>
                                <th>Trajet</th>
                                <th>Avion</th>
                                <th>Date Départ</th>
                                <th>Date Arrivée</th>
                                <th>Heure Départ</th>
                                <th>Heure Arrivée</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Vol.VolDetail> vols = (List<Vol.VolDetail>) request.getAttribute("vols");
                            if (vols != null && !vols.isEmpty()) {
                                for (Vol.VolDetail v : vols) {
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= v.getIdVol() %></span></td>
                                <td><strong><%= v.getNumeroVol() != null ? v.getNumeroVol() : "-" %></strong></td>
                                <td>
                                    <div style="font-size: 14px;">
                                        🛫 <%= v.getTrajetDepart() %><br>
                                        🛬 <%= v.getTrajetArrivee() %>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <strong><%= v.getAvionCode() %></strong><br>
                                        <small style="color: #666;"><%= v.getAvionModel() %></small>
                                    </div>
                                </td>
                                <td>📅 <%= v.getDateDepart() != null ? v.getDateDepart().toLocalDateTime().toLocalDate() : "-" %></td>
                                <td>📅 <%= v.getDateArrive() != null ? v.getDateArrive().toLocalDateTime().toLocalDate() : "-" %></td>
                                <td>🕐 <%= v.getHeureDepart() != null ? v.getHeureDepart().toString().substring(0,5) : "-" %></td>
                                <td>🕐 <%= v.getHeureArrivee() != null ? v.getHeureArrivee().toString().substring(0,5) : "-" %></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/VolServlet?action=edit&id=<%= v.getIdVol() %>" class="btn btn-sm btn-primary" title="Modifier">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/VolServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="idVol" value="<%= v.getIdVol() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer ce vol ?')" title="Supprimer">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="9">
                                    <div class="empty-state">
                                        <div class="icon">🛫</div>
                                        <h3>Aucun vol disponible</h3>
                                        <p>Créez d'abord des trajets, puis ajoutez des vols</p>
                                        <a href="<%= request.getContextPath() %>/TrajetServlet" class="btn btn-secondary">Voir les Trajets</a>
                                    </div>
                                </td>
                            </tr>
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
