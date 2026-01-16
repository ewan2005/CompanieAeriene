<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Reservation" %>
<%@ page import="oo.ModePaiement" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billet - Skyfly Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
    <style>
        .reservation-card { background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; padding: 25px; border-radius: 15px; margin-bottom: 25px; }
        .reservation-card h4 { margin: 0 0 15px 0; font-size: 20px; display: flex; align-items: center; gap: 10px; }
        .reservation-info { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .info-item { background: rgba(255,255,255,0.15); padding: 12px; border-radius: 8px; }
        .info-item .label { font-size: 11px; opacity: 0.8; text-transform: uppercase; letter-spacing: 0.5px; }
        .info-item .value { font-size: 16px; font-weight: 600; margin-top: 4px; }
        .pricing-section { background: #fef3c7; border: 2px solid #fbbf24; border-radius: 12px; padding: 20px; }
        .pricing-section h4 { color: #92400e; margin: 0 0 15px 0; display: flex; align-items: center; gap: 10px; }
        .price-preview { background: white; padding: 20px; border-radius: 10px; margin-top: 15px; }
        .price-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dashed #e5e7eb; }
        .price-row:last-child { border-bottom: none; }
        .price-total { font-size: 24px; font-weight: bold; color: #16a34a; }
        .no-reservation { text-align: center; padding: 60px 20px; background: #f1f5f9; border-radius: 12px; }
        .no-reservation .icon { font-size: 60px; margin-bottom: 15px; }
        .no-reservation p { color: #64748b; font-size: 16px; }
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
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link active"><span class="icon">🎫</span> Billets</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link"><span class="icon">➕</span> Nouveau trajet</a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
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
                <h1 class="page-title"><span class="icon">🎫</span>
                    <% oo.Billet _billet = (oo.Billet) request.getAttribute("billet");
                       if (_billet != null && _billet.getIdBillet() > 0) { %>
                        Modifier Billet
                    <% } else { %>
                        Nouveau Billet
                    <% } %>
                </h1>
                <p class="page-subtitle">Sélectionnez une réservation, définissez le prix et la classe, puis validez pour générer le billet</p>
            </div>
        </div>

        <%
            List<Reservation.ReservationDetail> reservations = (List<Reservation.ReservationDetail>) request.getAttribute("reservations");
            List<ModePaiement> modesPaiement = (List<ModePaiement>) request.getAttribute("modesPaiement");
            Integer selectedReservationIdObj = (Integer) request.getAttribute("selectedReservationId");
            int selectedReservationId = selectedReservationIdObj != null ? selectedReservationIdObj : 0;
            
            // Info réservation sélectionnée
            Reservation.ReservationDetail selectedRes = null;
            if (selectedReservationId > 0 && reservations != null) {
                for (Reservation.ReservationDetail r : reservations) {
                    if (r.getIdReservation() == selectedReservationId) { selectedRes = r; break; }
                }
            }
            
            // En édition, récupérer la réservation existante
            if (_billet != null && _billet.getIdBillet() > 0 && selectedRes == null) {
                Reservation.ReservationDetail existing = (Reservation.ReservationDetail) request.getAttribute("existingReservation");
                if (existing != null) selectedRes = existing;
            }
        %>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">📋 Étape 1: Choisir une réservation</h3>
            </div>
            <div class="card-body">
                <% if (reservations != null && !reservations.isEmpty()) { %>
                <div class="form-group">
                    <label class="form-label">Réservations sans billet</label>
                    <select class="form-control" id="reservationSelector" onchange="onReservationChange(this.value)" style="font-size: 16px; padding: 12px;">
                        <option value="">-- Choisir une réservation --</option>
                        <%
                            for (Reservation.ReservationDetail r : reservations) {
                                String sel = (r.getIdReservation() == selectedReservationId) ? "selected" : "";
                                String passagerInfo = (r.getPassagerNom() != null) ? r.getPassagerNom() + " " + r.getPassagerPrenom() : "Passager inconnu";
                        %>
                        <option value="<%= r.getIdReservation() %>" <%= sel %>>
                            Rés. #<%= r.getIdReservation() %> | <%= passagerInfo %> | Vol N°<%= r.getNumeroVol() %> | Place <%= r.getNumeroPlace() %> | <%= r.getTrajetDepart() %> → <%= r.getTrajetArrivee() %>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <% if (selectedRes != null) { %>
                <div class="reservation-card">
                    <h4>📋 Réservation sélectionnée #<%= selectedRes.getIdReservation() %></h4>
                    <div class="reservation-info">
                        <div class="info-item">
                            <div class="label">Passager</div>
                            <div class="value"><%= selectedRes.getPassagerNom() != null ? selectedRes.getPassagerNom() + " " + selectedRes.getPassagerPrenom() : "Non renseigné" %></div>
                        </div>
                        <div class="info-item">
                            <div class="label">Vol</div>
                            <div class="value">N° <%= selectedRes.getNumeroVol() %> - <%= selectedRes.getAvionCode() %></div>
                        </div>
                        <div class="info-item">
                            <div class="label">Trajet</div>
                            <div class="value"><%= selectedRes.getTrajetDepart() %> → <%= selectedRes.getTrajetArrivee() %></div>
                        </div>
                        <div class="info-item">
                            <div class="label">Place</div>
                            <div class="value">N° <%= selectedRes.getNumeroPlace() %></div>
                        </div>
                        <div class="info-item">
                            <div class="label">Date réservation</div>
                            <div class="value"><%= selectedRes.getDateReservation() != null ? selectedRes.getDateReservation().toLocalDateTime().toLocalDate() : "N/A" %></div>
                        </div>
                    </div>
                </div>
                <% } %>

                <% } else { %>
                <div class="no-reservation">
                    <div class="icon">📋</div>
                    <p>Aucune réservation en attente de billet.</p>
                    <p>Créez d'abord une réservation dans le menu <a href="<%= request.getContextPath() %>/ReservationServlet">Réservations</a></p>
                </div>
                <% } %>
            </div>
        </div>

        <% if (selectedRes != null || (_billet != null && _billet.getIdBillet() > 0)) { %>
        <form method="post" action="<%= request.getContextPath() %>/BilletServlet">
            <% if (_billet != null && _billet.getIdBillet() > 0) { %>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="idBillet" value="<%= _billet.getIdBillet() %>">
            <% } else { %>
                <input type="hidden" name="action" value="create">
            <% } %>
            <input type="hidden" name="idReservation" value="<%= selectedRes != null ? selectedRes.getIdReservation() : _billet.getIdReservation() %>">

            <div class="card" style="margin-top: 20px;">
                <div class="card-header">
                    <h3 class="card-title">💰 Étape 2: Tarification</h3>
                </div>
                <div class="card-body">
                    <div class="pricing-section">
                        <h4>💳 Informations de paiement</h4>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Classe calculée</label>
                                <input type="text" class="form-control" readonly value="<%= request.getAttribute("computedClasse") != null ? request.getAttribute("computedClasse") : (_billet != null ? _billet.getClasse() : "N/A") %>">
                                <input type="hidden" name="classe" value="<%= request.getAttribute("computedClasse") != null ? request.getAttribute("computedClasse") : (_billet != null ? _billet.getClasse() : "") %>">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Prix calculé (AR)</label>
                                <input type="text" class="form-control" readonly id="prixInput" value="<%= request.getAttribute("computedPrix") != null ? String.format("%.2f", ((java.math.BigDecimal)request.getAttribute("computedPrix")).doubleValue()) : (_billet != null ? String.format("%.2f", _billet.getPrix().doubleValue()) : "0.00") %>">
                                <input type="hidden" name="prix" value="<%= request.getAttribute("computedPrix") != null ? ((java.math.BigDecimal)request.getAttribute("computedPrix")) : (_billet != null ? _billet.getPrix() : new java.math.BigDecimal(0)) %>">
                            </div>
                            <% if (selectedRes != null && "bebe".equalsIgnoreCase(selectedRes.getCategorieLibelle())) { %>
                            <div style="margin-top:8px; padding:10px; background:#eef2ff; border-left:4px solid #6366f1; border-radius:6px; color:#1f2937; font-size:14px;">
                                Note: catégorie <strong>bébé</strong> — le tarif appliqué est de 10% du tarif adulte pour la même classe. Le montant affiché ci-dessus reflète cette règle.
                            </div>
                            <% } else if (selectedRes != null && "enfant".equalsIgnoreCase(selectedRes.getCategorieLibelle())) { %>
                            <div style="margin-top:8px; padding:10px; background:#fff7ed; border-left:4px solid #f97316; border-radius:6px; color:#92400e; font-size:14px;">
                                Note: catégorie <strong>enfant</strong> — pour la classe économique un tarif enfant fixe peut s'appliquer (remise définie dans la base). Le montant affiché ci-dessus tient compte de cette remise.
                            </div>
                            <% } %>
                                            <div class="form-group">
                                                <label class="form-label">Montant payé (AR) *</label>
                                                <%
                                                    java.math.BigDecimal computedPrix = (java.math.BigDecimal) request.getAttribute("computedPrix");
                                                    java.math.BigDecimal defaultMontant = computedPrix != null ? computedPrix : (_billet != null ? _billet.getPrix() : new java.math.BigDecimal(0));
                                                %>
                                                <input type="number" step="0.01" min="<%= defaultMontant.doubleValue() %>" name="montantPaiement" id="montantPaiement" class="form-control" required oninput="updatePricePreview()" value="<%= String.format("%.2f", defaultMontant.doubleValue()) %>">
                                                <div style="margin-top:8px; font-size:14px; color:#065f46;">
                                                    Montant requis pour cette réservation: <strong style="font-size:16px;"><%= String.format("%.2f", defaultMontant.doubleValue()) %> AR</strong>
                                                </div>
                                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Mode de paiement *</label>
                                <select name="idModePaiement" class="form-control" required>
                                    <option value="">-- Choisir un mode --</option>
                                    <%
                                        Integer currentModeId = (Integer) request.getAttribute("selectedModePaiementId");
                                        if (modesPaiement != null) {
                                            for (ModePaiement mp : modesPaiement) {
                                                String sel = (currentModeId != null && mp.getIdModePaiement() == currentModeId) ? "selected" : "";
                                    %>
                                    <option value="<%= mp.getIdModePaiement() %>" <%= sel %>><%= mp.getNom() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                        </div>

                        <div class="price-preview">
                            <h5 style="margin: 0 0 15px 0; color: #374151;">📝 Récapitulatif</h5>
                            <div class="price-row">
                                <span>Passager</span>
                                <span><strong><%= selectedRes != null && selectedRes.getPassagerNom() != null ? selectedRes.getPassagerNom() + " " + selectedRes.getPassagerPrenom() : "N/A" %></strong></span>
                            </div>
                            <div class="price-row">
                                <span>Vol</span>
                                <span><strong><%= selectedRes != null ? "N°" + selectedRes.getNumeroVol() : "N/A" %></strong></span>
                            </div>
                            <div class="price-row">
                                <span>Trajet</span>
                                <span><strong><%= selectedRes != null ? selectedRes.getTrajetDepart() + " → " + selectedRes.getTrajetArrivee() : "N/A" %></strong></span>
                            </div>
                            <div class="price-row">
                                <span>Place</span>
                                <span><strong><%= selectedRes != null ? "N°" + selectedRes.getNumeroPlace() : "N/A" %></strong></span>
                            </div>
                            <div class="price-row" style="margin-top: 10px; padding-top: 15px; border-top: 2px solid #e5e7eb;">
                                <span style="font-size: 18px;">💰 Montant requis</span>
                                <span class="price-total" id="totalPrice"><%= defaultMontant != null ? String.format("%.2f", defaultMontant.doubleValue()) + " AR" : "0.00 AR" %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card" style="margin-top: 20px;">
                <div class="card-body">
                    <div class="form-actions" style="justify-content: space-between; display: flex;">
                        <a href="<%= request.getContextPath() %>/BilletServlet" class="btn btn-secondary">↩️ Annuler</a>
                        <button type="submit" class="btn btn-primary">
                            🎫 <%= _billet != null && _billet.getIdBillet() > 0 ? "Modifier" : "Générer" %> le billet
                        </button>
                    </div>
                </div>
            </div>
        </form>
        <% } %>
    </main>
</div>

<script>
    function onReservationChange(reservationId) {
        if (!reservationId) {
            window.location.href = "<%= request.getContextPath() %>/BilletServlet?action=new";
            return;
        }
        window.location.href = "<%= request.getContextPath() %>/BilletServlet?action=new&idReservation=" + encodeURIComponent(reservationId);
    }

    function updatePricePreview() {
        var prix = document.getElementById('montantPaiement') ? document.getElementById('montantPaiement').value : (document.getElementById('prixInput') ? document.getElementById('prixInput').value : '0');
        var totalEl = document.getElementById('totalPrice');
        if (totalEl && prix) {
            totalEl.textContent = parseFloat(prix).toFixed(2) + ' AR';
        }
    }
</script>
</body>
</html>
