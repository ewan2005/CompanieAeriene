<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paiement Publicité - Skyfly Airlines</title>
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
        <div class="sidebar-nav" style="max-height: calc(100vh - 80px); overflow-y: auto;">
            <div class="nav-section">
                <div class="nav-section-title">Menu Principal</div>
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link"><span class="icon">🏠</span> Accueil</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Publicité</div>
                <a href="<%= request.getContextPath() %>/SocieteServlet" class="nav-link"><span class="icon">🏛️</span> Sociétés</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet" class="nav-link"><span class="icon">📺</span> Achats Diffusions</a>
                <a href="<%= request.getContextPath() %>/PaiementSocieteServlet" class="nav-link active"><span class="icon">💳</span> Paiements Pub</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=ca" class="nav-link"><span class="icon">📊</span> CA Publicité</a>
                <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="nav-link"><span class="icon">⚙️</span> Config Tarif Pub</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">💳</span>
                    <% oo.PaiementSociete _paiement = (oo.PaiementSociete) request.getAttribute("paiement");
                       if (_paiement != null && _paiement.getIdPaiement() > 0) { %>
                        Modifier Paiement
                    <% } else { %>
                        Nouveau Paiement Publicité
                    <% } %>
                </h1>
                <p class="page-subtitle">Enregistrer un paiement d'une société pour ses diffusions publicitaires</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">💰 Informations du paiement</h3>
            </div>
            <div class="card-body">
                <%
                    java.math.BigDecimal resteAPayer = (java.math.BigDecimal) request.getAttribute("resteAPayer");
                    oo.AchatDiffusion achatPreselect = (oo.AchatDiffusion) request.getAttribute("achat");
                %>
                
                <% if (achatPreselect != null && resteAPayer != null) { %>
                <div class="alert" style="background: #fff3cd; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <strong>📋 Achat sélectionné:</strong> 
                    <%= achatPreselect.getSociete() != null ? achatPreselect.getSociete().getNom() : "-" %> 
                    - <%= achatPreselect.getNombreDiffusions() %> diffusions 
                    (<%= String.format("%02d", achatPreselect.getMois()) %>/<%= achatPreselect.getAnnee() %>)
                    <br>
                    <strong>💵 Montant total:</strong> <%= String.format("%,.0f", achatPreselect.getMontantTotal().doubleValue()) %> Ar
                    <br>
                    <strong>⏳ Reste à payer:</strong> 
                    <span style="color: <%= resteAPayer.compareTo(java.math.BigDecimal.ZERO) > 0 ? "#dc3545" : "#28a745" %>; font-weight: bold;">
                        <%= String.format("%,.0f", resteAPayer.doubleValue()) %> Ar
                    </span>
                </div>
                <% } %>

                <form method="post" action="<%= request.getContextPath() %>/PaiementSocieteServlet">
                    <% if (_paiement != null && _paiement.getIdPaiement() > 0) { %>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="idPaiement" value="<%= _paiement.getIdPaiement() %>">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>

                    <div class="form-group">
                        <label class="form-label">Achat de diffusions *</label>
                        <select name="idAchat" id="idAchat" class="form-control" required onchange="updateResteAPayer()">
                            <option value="">-- Sélectionner un achat --</option>
                            <%
                                java.util.List achats = (java.util.List) request.getAttribute("achats");
                                if (achats != null) {
                                    for (Object o : achats) {
                                        oo.AchatDiffusion a = (oo.AchatDiffusion) o;
                                        String societeNom = a.getSociete() != null ? a.getSociete().getNom() : "-";
                                        java.math.BigDecimal reste = a.getResteAPayer();
                                        boolean selected = false;
                                        if (_paiement != null && _paiement.getIdAchat() == a.getIdAchat()) {
                                            selected = true;
                                        } else if (achatPreselect != null && achatPreselect.getIdAchat() == a.getIdAchat()) {
                                            selected = true;
                                        }
                            %>
                            <option value="<%= a.getIdAchat() %>" 
                                    data-reste="<%= reste.doubleValue() %>"
                                    data-total="<%= a.getMontantTotal().doubleValue() %>"
                                    <%= selected ? "selected" : "" %>>
                                <%= societeNom %> - <%= a.getNombreDiffusions() %> diff. (<%= String.format("%02d", a.getMois()) %>/<%= a.getAnnee() %>) 
                                - Reste: <%= String.format("%,.0f", reste.doubleValue()) %> Ar
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div id="resteInfo" class="alert" style="background: #e3f2fd; padding: 15px; border-radius: 8px; margin-bottom: 20px; display: none;">
                        <strong>💵 Reste à payer:</strong> <span id="resteAPayerDisplay">0</span> Ar
                        <button type="button" class="btn btn-sm btn-success" style="margin-left: 15px;" onclick="payerTout()">
                            💰 Payer la totalité
                        </button>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Montant du paiement (Ar) *</label>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <input type="text" name="montant" id="montantInput" class="form-control" required
                                   value="<%= _paiement != null ? String.format("%.0f", _paiement.getMontant().doubleValue()) : "" %>"
                                   placeholder="Entrez le montant à payer"
                                   oninput="validerMontant()">
                        </div>
                        <small id="montantHelp" style="color: #666; margin-top: 5px; display: block;">
                            Vous pouvez payer un montant partiel ou la totalité du reste à payer.
                        </small>
                        <small id="montantError" style="color: #dc3545; margin-top: 5px; display: none;"></small>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Date du paiement *</label>
                        <input type="date" name="datePaiement" class="form-control" required
                               value="<%= _paiement != null && _paiement.getDatePaiement() != null ? _paiement.getDatePaiement().toString() : new java.sql.Date(System.currentTimeMillis()).toString() %>">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Référence (optionnel)</label>
                        <input type="text" name="reference" class="form-control"
                               value="<%= _paiement != null && _paiement.getReference() != null ? _paiement.getReference() : "" %>"
                               placeholder="Ex: REF-2025-001, Chèque N°123, Virement...">
                    </div>

                    <div class="form-actions" style="margin-top: 20px;">
                        <button type="submit" class="btn btn-primary">
                            <% if (_paiement != null && _paiement.getIdPaiement() > 0) { %>
                                Modifier
                            <% } else { %>
                                💾 Enregistrer le paiement
                            <% } %>
                        </button>
                        <a href="<%= request.getContextPath() %>/PaiementSocieteServlet" class="btn btn-secondary">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
var resteActuel = 0;

function updateResteAPayer() {
    var select = document.getElementById('idAchat');
    var option = select.options[select.selectedIndex];
    var resteInfo = document.getElementById('resteInfo');
    var resteDisplay = document.getElementById('resteAPayerDisplay');
    
    if (option && option.value) {
        resteActuel = parseFloat(option.getAttribute('data-reste')) || 0;
        resteDisplay.textContent = resteActuel.toLocaleString('fr-FR');
        resteInfo.style.display = 'block';
    } else {
        resteActuel = 0;
        resteInfo.style.display = 'none';
    }
    validerMontant();
}

function payerTout() {
    var montantInput = document.getElementById('montantInput');
    montantInput.value = Math.round(resteActuel);
    validerMontant();
}

function validerMontant() {
    var montantInput = document.getElementById('montantInput');
    var montantError = document.getElementById('montantError');
    var montantHelp = document.getElementById('montantHelp');
    var submitBtn = document.querySelector('button[type="submit"]');
    
    var montant = parseFloat(montantInput.value.replace(/\s/g, '').replace(',', '.')) || 0;
    
    if (resteActuel > 0 && montant > resteActuel) {
        montantError.textContent = '⚠️ Le montant ne peut pas dépasser le reste à payer (' + resteActuel.toLocaleString('fr-FR') + ' Ar)';
        montantError.style.display = 'block';
        montantHelp.style.display = 'none';
        montantInput.style.borderColor = '#dc3545';
        submitBtn.disabled = true;
    } else if (montant <= 0 && montantInput.value !== '') {
        montantError.textContent = '⚠️ Le montant doit être supérieur à 0';
        montantError.style.display = 'block';
        montantHelp.style.display = 'none';
        montantInput.style.borderColor = '#dc3545';
        submitBtn.disabled = true;
    } else {
        montantError.style.display = 'none';
        montantHelp.style.display = 'block';
        montantInput.style.borderColor = '';
        submitBtn.disabled = false;
    }
}

// Appeler au chargement si un achat est déjà sélectionné
document.addEventListener('DOMContentLoaded', function() {
    var select = document.getElementById('idAchat');
    if (select.value) {
        updateResteAPayer();
    }
});
</script>
</body>
</html>
