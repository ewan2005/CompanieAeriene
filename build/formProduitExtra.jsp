<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="oo.ProduitExtra" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Produit Extra - Skyfly Airlines</title>
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
            ProduitExtra produit = (ProduitExtra) request.getAttribute("produit");
            boolean isEdit = produit != null;
        %>
        
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">🍫</span> <%= isEdit ? "Modifier" : "Nouveau" %> Produit Extra</h1>
                <p class="page-subtitle"><%= isEdit ? "Modifier les informations du produit" : "Ajouter un nouveau produit au catalogue" %></p>
            </div>
            <a href="<%= request.getContextPath() %>/ProduitExtraServlet" class="btn btn-secondary">Retour à la liste</a>
        </div>

        <div class="card">
            <div class="card-header" style="background: linear-gradient(135deg, #e67e22, #d35400);">
                <h3 class="card-title" style="color: white;">📝 Informations du Produit</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/ProduitExtraServlet">
                    <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= produit.getIdProduit() %>">
                    <% } %>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="nom" style="display: block; margin-bottom: 8px; font-weight: bold;">Nom du produit *</label>
                        <input type="text" id="nom" name="nom" class="form-control" required
                               value="<%= isEdit ? produit.getNom() : "" %>"
                               placeholder="Ex: Tablette de chocolat"
                               style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;">
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="prix" style="display: block; margin-bottom: 8px; font-weight: bold;">Prix (Ar) *</label>
                        <input type="number" id="prix" name="prix" class="form-control" required min="0" step="100"
                               value="<%= isEdit ? produit.getPrix().intValue() : "5000" %>"
                               placeholder="Ex: 5000"
                               style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;">
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="description" style="display: block; margin-bottom: 8px; font-weight: bold;">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="3"
                                  placeholder="Description du produit..."
                                  style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;"><%= isEdit && produit.getDescription() != null ? produit.getDescription() : "" %></textarea>
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label style="display: flex; align-items: center; cursor: pointer;">
                            <input type="checkbox" name="actif" <%= isEdit ? (produit.isActif() ? "checked" : "") : "checked" %>
                                   style="margin-right: 10px; width: 18px; height: 18px;">
                            <span style="font-weight: bold;">Produit actif (disponible à la vente)</span>
                        </label>
                    </div>
                    
                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn btn-primary" style="padding: 12px 30px;">
                            💾 <%= isEdit ? "Enregistrer" : "Créer le produit" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/ProduitExtraServlet" class="btn btn-secondary" style="padding: 12px 30px;">
                            ❌ Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
