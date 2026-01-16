<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Reservation" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservations - Skyfly Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
    <style>
        .status-badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .status-billet { background: #dcfce7; color: #16a34a; }
        .status-no-billet { background: #fef3c7; color: #d97706; }
    </style>
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
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link active"><span class="icon">📋</span> Réservations</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link"><span class="icon">➕</span> Nouveau trajet</a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
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
                <h1 class="page-title"><span class="icon">📋</span> Réservations</h1>
                <p class="page-subtitle">Une réservation associe un vol, une place et un passager</p>
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
                                <th>Date Rés.</th>
                                <th>Passager</th>
                                <th>Catégorie</th>
                                <th>Vol</th>
                                <th>Trajet</th>
                                <th>Place</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Reservation.ReservationDetail> reservations = (List<Reservation.ReservationDetail>) request.getAttribute("reservations");
                            if (reservations != null && !reservations.isEmpty()) {
                                for (Reservation.ReservationDetail r : reservations) {
                                    String passagerName = (r.getPassagerNom() != null) ? r.getPassagerNom() + " " + r.getPassagerPrenom() : "Non renseigné";
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= r.getIdReservation() %></span></td>
                                <td>📅 <%= r.getDateReservation() != null ? r.getDateReservation().toLocalDateTime().toLocalDate() : "-" %></td>
                                <td>
                                    <strong>👤 <%= passagerName %></strong>
                                </td>
                                <td>
                                    <strong><%= r.getCategorieLibelle() != null ? r.getCategorieLibelle() : "adulte" %></strong>
                                </td>
                                <td>
                                    <div>
                                        <strong>Vol N°<%= r.getNumeroVol() %></strong><br>
                                        <small style="color: #666;"><%= r.getAvionCode() %></small>
                                    </div>
                                </td>
                                <td>
                                    <div style="font-size: 13px;">
                                        🛫 <%= r.getTrajetDepart() %><br>
                                        🛬 <%= r.getTrajetArrivee() %>
                                    </div>
                                </td>
                                <td><strong>💺 <%= r.getNumeroPlace() %></strong></td>
                                <td>
                                    <% if (r.isHasBillet()) { %>
                                        <span class="status-badge status-billet">🎫 Billet émis</span>
                                    <% } else { %>
                                        <span class="status-badge status-no-billet">⏳ En attente</span>
                                    <% } %>
                                </td>
                                <td class="actions">
                                    <% if (!r.isHasBillet()) { %>
                                    <a href="<%= request.getContextPath() %>/BilletServlet?action=new&idReservation=<%= r.getIdReservation() %>" class="btn btn-sm btn-success" title="Créer billet">🎫</a>
                                    <% } %>
                                    <a href="<%= request.getContextPath() %>/ReservationServlet?action=edit&id=<%= r.getIdReservation() %>" class="btn btn-sm btn-primary" title="Modifier">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/ReservationServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="idReservation" value="<%= r.getIdReservation() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer cette réservation ?')" title="Supprimer">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="8">
                                    <div class="empty-state">
                                        <div class="icon">📋</div>
                                        <h3>Aucune réservation</h3>
                                        <p>Créez d'abord des vols, puis ajoutez des réservations</p>
                                        <a href="<%= request.getContextPath() %>/VolServlet" class="btn btn-secondary">Voir les Vols</a>
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
