<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.VenteProduitExtra" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ventes Produits Extra - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/ProduitExtraServlet" class="nav-link">
                    <span class="icon">🍫</span> Produits
                </a>
                <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet" class="nav-link active">
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
            List<VenteProduitExtra> ventes = (List<VenteProduitExtra>) request.getAttribute("ventes");
            Integer idVolFiltre = (Integer) request.getAttribute("idVolFiltre");
            
            // Calculer le total
            BigDecimal totalVentes = BigDecimal.ZERO;
            if (ventes != null) {
                for (VenteProduitExtra v : ventes) {
                    totalVentes = totalVentes.add(v.getMontantTotal());
                }
            }
        %>
        
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">🛒</span> Ventes Produits Extra</h1>
                <p class="page-subtitle">
                    <%= idVolFiltre != null ? "Ventes du vol #" + idVolFiltre : "Historique des ventes de produits à bord" %>
                </p>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet?action=new" class="btn btn-primary">
                    ➕ Nouvelle Vente
                </a>
                <% if (idVolFiltre != null) { %>
                <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet" class="btn btn-secondary">
                    📋 Toutes les ventes
                </a>
                <% } %>
            </div>
        </div>

        <!-- Carte total -->
        <div style="margin-bottom: 20px;">
            <div class="card" style="background: linear-gradient(135deg, #e67e22, #d35400); max-width: 300px;">
                <div class="card-body" style="text-align: center; padding: 20px; color: white;">
                    <h3 style="margin: 0; font-size: 14px; opacity: 0.9;">💰 Total Ventes</h3>
                    <p style="font-size: 28px; font-weight: bold; margin: 8px 0;">
                        <%= String.format("%,.0f", totalVentes.doubleValue()) %> Ar
                    </p>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header" style="background: linear-gradient(135deg, #e67e22, #d35400);">
                <h3 class="card-title" style="color: white;">🧾 Liste des Ventes</h3>
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
                                <th>Produit</th>
                                <th>Vol</th>
                                <th>Quantité</th>
                                <th>Prix Unitaire</th>
                                <th>Montant Total</th>
                                <th>Date Vente</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (ventes != null && !ventes.isEmpty()) {
                                for (VenteProduitExtra v : ventes) {
                        %>
                            <tr>
                                <td><%= v.getIdVente() %></td>
                                <td><strong>🍫 <%= v.getProduitNom() != null ? v.getProduitNom() : "Produit #" + v.getIdProduit() %></strong></td>
                                <td>
                                    <span style="background: #3498db; color: white; padding: 3px 8px; border-radius: 3px;">
                                        ✈️ <%= v.getVolNumero() != null ? v.getVolNumero() : "Vol #" + v.getIdVol() %>
                                    </span>
                                </td>
                                <td style="text-align: center;"><strong><%= v.getQuantite() %></strong></td>
                                <td style="text-align: right;"><%= String.format("%,.0f", v.getPrixUnitaire().doubleValue()) %> Ar</td>
                                <td style="text-align: right;">
                                    <strong style="color: #e67e22;"><%= String.format("%,.0f", v.getMontantTotal().doubleValue()) %> Ar</strong>
                                </td>
                                <td>
                                    <%= v.getDateVente() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(v.getDateVente()) : "-" %>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet?action=edit&id=<%= v.getIdVente() %>" 
                                       class="btn btn-secondary" style="padding: 5px 10px; font-size: 12px;">✏️</a>
                                    <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet?action=delete&id=<%= v.getIdVente() %>" 
                                       class="btn btn-danger" style="padding: 5px 10px; font-size: 12px;"
                                       onclick="return confirm('Supprimer cette vente ?');">🗑️</a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="8">
                                    <div class="empty-state">
                                        <div class="icon">🛒</div>
                                        <h3>Aucune vente</h3>
                                        <p>Enregistrez une vente de produit extra</p>
                                        <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet?action=new" class="btn btn-primary">Nouvelle vente</a>
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
