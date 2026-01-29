<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.ProduitExtra" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Produits Extra - Skyfly Airlines</title>
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
                <div class="nav-section-title">Produits Extra</div>
                <a href="<%= request.getContextPath() %>/ProduitExtraServlet" class="nav-link active">
                    <span class="icon">🍫</span> Produits
                </a>
                <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet" class="nav-link">
                    <span class="icon">🛒</span> Ventes
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Statistiques</div>
                <a href="<%= request.getContextPath() %>/CAParVolServlet" class="nav-link">
                    <span class="icon">📈</span> CA par Vol
                </a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <%
            List<ProduitExtra> produits = (List<ProduitExtra>) request.getAttribute("produits");
        %>
        
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">🍫</span> Produits Extra</h1>
                <p class="page-subtitle">Catalogue des produits vendus à bord</p>
            </div>
            <a href="<%= request.getContextPath() %>/ProduitExtraServlet?action=new" class="btn btn-primary">
                ➕ Nouveau Produit
            </a>
        </div>

        <div class="card">
            <div class="card-header" style="background: linear-gradient(135deg, #e67e22, #d35400);">
                <h3 class="card-title" style="color: white;">📦 Liste des Produits</h3>
            </div>
            <div class="card-body">
                <div class="filter-bar">
                    <input type="search" id="filterInput" class="form-control" placeholder="🔎 Rechercher..." autocomplete="off">
                </div>
                <div class="table-container">
                    <table class="table" id="listTable">
                        <thead>
                            <tr style="background: #34495e; color: white;">
                                <th>ID</th>
                                <th>Nom</th>
                                <th>Prix</th>
                                <th>Description</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (produits != null && !produits.isEmpty()) {
                                for (ProduitExtra p : produits) {
                        %>
                            <tr>
                                <td><%= p.getIdProduit() %></td>
                                <td><strong><%= p.getNom() %></strong></td>
                                <td style="text-align: right;">
                                    <strong style="color: #e67e22;"><%= String.format("%,.0f", p.getPrix().doubleValue()) %> Ar</strong>
                                </td>
                                <td><%= p.getDescription() != null ? p.getDescription() : "-" %></td>
                                <td>
                                    <% if (p.isActif()) { %>
                                        <span style="background: #27ae60; color: white; padding: 3px 8px; border-radius: 3px;">✅ Actif</span>
                                    <% } else { %>
                                        <span style="background: #95a5a6; color: white; padding: 3px 8px; border-radius: 3px;">❌ Inactif</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/ProduitExtraServlet?action=edit&id=<%= p.getIdProduit() %>" 
                                       class="btn btn-secondary" style="padding: 5px 10px; font-size: 12px;">✏️ Modifier</a>
                                    <a href="<%= request.getContextPath() %>/ProduitExtraServlet?action=delete&id=<%= p.getIdProduit() %>" 
                                       class="btn btn-danger" style="padding: 5px 10px; font-size: 12px;"
                                       onclick="return confirm('Supprimer ce produit ?');">🗑️ Supprimer</a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6">
                                    <div class="empty-state">
                                        <div class="icon">🍫</div>
                                        <h3>Aucun produit</h3>
                                        <p>Ajoutez des produits extra à vendre à bord</p>
                                        <a href="<%= request.getContextPath() %>/ProduitExtraServlet?action=new" class="btn btn-primary">Ajouter un produit</a>
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
