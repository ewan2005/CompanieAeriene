<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.VenteProduitExtra" %>
<%@ page import="oo.ProduitExtra" %>
<%@ page import="oo.Vol" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vente Produit Extra - Skyfly Airlines</title>
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
            VenteProduitExtra vente = (VenteProduitExtra) request.getAttribute("vente");
            List<ProduitExtra> produits = (List<ProduitExtra>) request.getAttribute("produits");
            List<Vol> vols = (List<Vol>) request.getAttribute("vols");
            boolean isEdit = vente != null;
        %>
        
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">🛒</span> <%= isEdit ? "Modifier" : "Nouvelle" %> Vente</h1>
                <p class="page-subtitle"><%= isEdit ? "Modifier les informations de la vente" : "Enregistrer une vente de produit extra" %></p>
            </div>
            <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet" class="btn btn-secondary">Retour à la liste</a>
        </div>

        <div class="card">
            <div class="card-header" style="background: linear-gradient(135deg, #e67e22, #d35400);">
                <h3 class="card-title" style="color: white;">📝 Informations de la Vente</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/VenteProduitExtraServlet">
                    <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= vente.getIdVente() %>">
                    <% } %>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="idProduit" style="display: block; margin-bottom: 8px; font-weight: bold;">Produit *</label>
                        <select id="idProduit" name="idProduit" class="form-control" required
                                style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;"
                                onchange="updatePrix()">
                            <option value="">-- Sélectionner un produit --</option>
                            <%
                                if (produits != null) {
                                    for (ProduitExtra p : produits) {
                            %>
                            <option value="<%= p.getIdProduit() %>" 
                                    data-prix="<%= p.getPrix().intValue() %>"
                                    <%= isEdit && vente.getIdProduit() == p.getIdProduit() ? "selected" : "" %>>
                                <%= p.getNom() %> - <%= String.format("%,.0f", p.getPrix().doubleValue()) %> Ar
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="idVol" style="display: block; margin-bottom: 8px; font-weight: bold;">Vol *</label>
                        <select id="idVol" name="idVol" class="form-control" required
                                style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;">
                            <option value="">-- Sélectionner un vol --</option>
                            <%
                                if (vols != null) {
                                    for (Vol v : vols) {
                            %>
                            <option value="<%= v.getIdVol() %>" 
                                    <%= isEdit && vente.getIdVol() == v.getIdVol() ? "selected" : "" %>>
                                ✈️ <%= v.getNumeroVol() %> - <%= v.getDateDepart() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="quantite" style="display: block; margin-bottom: 8px; font-weight: bold;">Quantité *</label>
                        <input type="number" id="quantite" name="quantite" class="form-control" required min="1"
                               value="<%= isEdit ? vente.getQuantite() : 1 %>"
                               onchange="calculateTotal()"
                               style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;">
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="prixUnitaire" style="display: block; margin-bottom: 8px; font-weight: bold;">Prix Unitaire (Ar) - optionnel</label>
                        <input type="number" id="prixUnitaire" name="prixUnitaire" class="form-control" min="0" step="100"
                               value="<%= isEdit ? vente.getPrixUnitaire().intValue() : "" %>"
                               placeholder="Laisser vide pour utiliser le prix du produit"
                               onchange="calculateTotal()"
                               style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #ddd;">
                        <small style="color: #666;">Si laissé vide, le prix du produit sélectionné sera utilisé.</small>
                    </div>
                    
                    <!-- Aperçu du total -->
                    <div style="margin-bottom: 20px; padding: 15px; background: #fdf2e9; border-radius: 8px; border-left: 4px solid #e67e22;">
                        <strong>💰 Montant total estimé:</strong>
                        <span id="totalEstime" style="font-size: 18px; color: #e67e22; font-weight: bold; margin-left: 10px;">0 Ar</span>
                    </div>
                    
                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn btn-primary" style="padding: 12px 30px;">
                            💾 <%= isEdit ? "Enregistrer" : "Créer la vente" %>
                        </button>
                        <a href="<%= request.getContextPath() %>/VenteProduitExtraServlet" class="btn btn-secondary" style="padding: 12px 30px;">
                            ❌ Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
function updatePrix() {
    var select = document.getElementById('idProduit');
    var prixInput = document.getElementById('prixUnitaire');
    var selectedOption = select.options[select.selectedIndex];
    
    if (selectedOption && selectedOption.dataset.prix) {
        prixInput.placeholder = selectedOption.dataset.prix + ' Ar (prix du produit)';
    }
    calculateTotal();
}

function calculateTotal() {
    var select = document.getElementById('idProduit');
    var prixInput = document.getElementById('prixUnitaire');
    var quantiteInput = document.getElementById('quantite');
    var totalSpan = document.getElementById('totalEstime');
    
    var selectedOption = select.options[select.selectedIndex];
    var prix = prixInput.value ? parseFloat(prixInput.value) : (selectedOption && selectedOption.dataset.prix ? parseFloat(selectedOption.dataset.prix) : 0);
    var quantite = parseInt(quantiteInput.value) || 0;
    
    var total = prix * quantite;
    totalSpan.textContent = total.toLocaleString('fr-FR') + ' Ar';
}

// Initialiser au chargement
document.addEventListener('DOMContentLoaded', function() {
    updatePrix();
    calculateTotal();
});
</script>
</body>
</html>
