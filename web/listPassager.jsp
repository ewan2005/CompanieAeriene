<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Passagers - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link active"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
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
                <h1 class="page-title"><span class="icon">👥</span> Liste des Passagers</h1>
                <p class="page-subtitle">Gérez les passagers enregistrés</p>
            </div>
            <a href="<%= request.getContextPath() %>/PassagerServlet?action=new" class="btn btn-primary">➕ Nouveau Passager</a>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Tous les passagers</h3>
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
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Passeport</th>
                                <th>Nationalité</th>
                                <th>Réservation</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            java.util.List passagers = (java.util.List) request.getAttribute("passagers");
                            if (passagers != null && !passagers.isEmpty()) {
                                for (Object o : passagers) {
                                    oo.Passager p = (oo.Passager) o;
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= p.getIdPassager() %></span></td>
                                <td>📅 <%= nowDate %></td>
                                <td><strong><%= p.getNom() != null ? p.getNom() : "-" %></strong></td>
                                <td><%= p.getPrenom() != null ? p.getPrenom() : "-" %></td>
                                <td> <%= p.getNumeroPasseport() != null ? p.getNumeroPasseport() : "-" %></td>
                                <td> <%= p.getNationnalite() != null ? p.getNationnalite() : "-" %></td>
                                <td><span class="badge badge-success">#<%= p.getIdReservation() %></span></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/PassagerServlet?action=edit&id=<%= p.getIdPassager() %>" class="btn btn-sm btn-primary">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/PassagerServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="idPassager" value="<%= p.getIdPassager() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer ce passager ?')">🗑️</button>
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
                                        <div class="icon"></div>
                                        <h3>Aucun passager</h3>
                                        <p>Les passagers apparaîtront ici</p>
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
