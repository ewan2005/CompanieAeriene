<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservations - SkyWings Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
</head>
<body>
<div class="app-container">
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <span class="plane-icon">✈️</span>
                <h2>SkyWings</h2>
            </div>
        </div>
        <div class="sidebar-nav">
            <div class="nav-section">
                <div class="nav-section-title">Menu Principal</div>
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link">
                    <span class="icon">🏠</span> Accueil
                </a>
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link">
                    <span class="icon">🛫</span> Vols
                </a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link active">
                    <span class="icon">📋</span> Réservations
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link">
                    <span class="icon">✈️</span> Avions
                </a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link">
                    <span class="icon">🏢</span> Aéroports
                </a>
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
                <div class="nav-section-title">Compte</div>
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link">
                    <span class="icon">🚪</span> Déconnexion
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">📋</span> Réservations</h1>
                <p class="page-subtitle">Gérez les réservations des passagers</p>
            </div>
            <a href="<%= request.getContextPath() %>/ReservationServlet?action=new" class="btn btn-primary">➕ Nouvelle Réservation</a>
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
                <h3 class="card-title">📋 Toutes les réservations</h3>
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
                                <th>Date Réservation</th>
                                <th>Statut</th>
                                <th>Paiement</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            java.util.List reservations = (java.util.List) request.getAttribute("reservations");
                            if (reservations != null && !reservations.isEmpty()) {
                                for (Object o : reservations) {
                                    oo.Reservation r = (oo.Reservation) o;
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= r.getIdReservation() %></span></td>
                                <td>📅 <%= r.getDateReservation() != null ? r.getDateReservation() : "-" %></td>
                                <td>
                                    <% if (r.isStatus()) { %>
                                        <span class="badge badge-success">✅ Confirmée</span>
                                    <% } else { %>
                                        <span class="badge badge-warning">⏳ En attente</span>
                                    <% } %>
                                </td>
                                <td><%= r.getIdPaiement() > 0 ? "💳 #" + r.getIdPaiement() : "-" %></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/ReservationServlet?action=edit&id=<%= r.getIdReservation() %>" class="btn btn-sm btn-primary">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/ReservationServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="idReservation" value="<%= r.getIdReservation() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer cette réservation ?')">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <div class="icon">📋</div>
                                        <h3>Aucune réservation</h3>
                                        <p>Les réservations apparaîtront ici</p>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
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
