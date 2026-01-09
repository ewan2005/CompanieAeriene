<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Billets - SkyWings Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
</head>
<body>
<div class="app-container">
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
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link"><span class="icon">🏠</span> Accueil</a>
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link active"><span class="icon">🎫</span> Billets</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
                <a href="<%= request.getContextPath() %>/validation.jsp" class="nav-link"><span class="icon">✅</span> Validation</a>
                <a href="<%= request.getContextPath() %>/error.jsp" class="nav-link"><span class="icon">⚠️</span> Erreurs</a>
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
                <h1 class="page-title"><span class="icon">🎫</span> Liste des Billets</h1>
                <p class="page-subtitle">Gérez les billets émis</p>
            </div>
            <a href="<%= request.getContextPath() %>/BilletServlet?action=new" class="btn btn-primary">➕ Nouveau Billet</a>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Tous les billets</h3>
            </div>
            <div class="card-body">
                <%
                    String nowDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                %>
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
                                <th>Date</th>
                                <th>Vol</th>
                                <th>Réservation</th>
                                <th>Classe</th>
                                <th>Prix</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            java.util.List billets = (java.util.List) request.getAttribute("billets");
                            if (billets != null && !billets.isEmpty()) {
                                for (Object o : billets) {
                                    oo.Billet b = (oo.Billet) o;
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= b.getIdBillet() %></span></td>
                                <td>📅 <%= nowDate %></td>
                                <td> Vol #<%= b.getIdVol() %></td>
                                <td> #<%= b.getIdReservation() %></td>
                                <td><span class="badge badge-success"><%= b.getClasse() != null ? b.getClasse() : "-" %></span></td>
                                <td><strong><%= b.getPrix() != null ? b.getPrix() + " " : "-" %></strong></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/BilletServlet?action=edit&id=<%= b.getIdBillet() %>" class="btn btn-sm btn-primary">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/BilletServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="idBillet" value="<%= b.getIdBillet() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer ce billet ?')">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7">
                                    <div class="empty-state">
                                        <div class="icon"></div>
                                        <h3>Aucun billet</h3>
                                        <p>Les billets apparaîtront ici</p>
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
