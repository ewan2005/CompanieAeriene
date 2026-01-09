<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Paiements - SkyWings Airlines</title>
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
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link">
                    <span class="icon">🏠</span> Accueil
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
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link active">
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

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">💳</span> Liste des Paiements</h1>
                <p class="page-subtitle">Suivez les transactions</p>
            </div>
            <a href="<%= request.getContextPath() %>/PaiementServlet?action=new" class="btn btn-primary"> Nouveau Paiement</a>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Tous les paiements</h3>
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
                                <th>Montant</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            java.util.List paiements = (java.util.List) request.getAttribute("paiements");
                            if (paiements != null && !paiements.isEmpty()) {
                                for (Object o : paiements) {
                                    oo.Paiement p = (oo.Paiement) o;
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= p.getIdPaiement() %></span></td>
                                <td><strong><%= p.getMontant() %> </strong></td>
                                <td> <%= p.getDatePaiement() != null ? p.getDatePaiement() : "-" %></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/PaiementServlet?action=edit&id=<%= p.getIdPaiement() %>" class="btn btn-sm btn-primary">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/PaiementServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="idPaiement" value="<%= p.getIdPaiement() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer ce paiement ?')">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="4">
                                    <div class="empty-state">
                                        <div class="icon"></div>
                                        <h3>Aucun paiement</h3>
                                        <p>Les paiements apparaîtront ici</p>
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
