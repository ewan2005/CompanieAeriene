<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="oo.Vol" %>
<%@ page import="oo.Place" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservation - Skyfly Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
    <style>
        .seat-grid { display: grid; grid-template-columns: repeat(6, 50px); gap: 8px; padding: 15px; background: #f8fafc; border-radius: 10px; }
        .seat-btn { width: 50px; height: 50px; border-radius: 8px; border: 2px solid #cbd5e1; background: #fff; cursor: pointer; font-weight: 600; font-size: 14px; transition: all 0.2s; position: relative; display:flex; align-items:center; justify-content:center; flex-direction:column; }
        .seat-btn .seat-type { font-size: 10px; font-weight: 700; padding: 2px 4px; border-radius: 4px; margin-top: 4px; }
        .seat-premiere { border-color: #f59e0b; }
        .seat-premiere .seat-type { background: #fef3c7; color: #92400e; }
        .seat-premium { border-color: #7c3aed; }
        .seat-premium .seat-type { background: #ede9fe; color: #4c1d95; }
        .seat-economique { border-color: #10b981; }
        .seat-economique .seat-type { background: #dcfce7; color: #065f46; }
        .seat-btn:hover:not(.reserved) { background: #e0f2fe; border-color: #0ea5e9; transform: scale(1.05); }
        .seat-btn.reserved { background: #fee2e2; color: #dc2626; cursor: not-allowed; border-color: #fca5a5; }
        .seat-btn.selected { background: #dcfce7; border-color: #22c55e; box-shadow: 0 0 0 3px rgba(34,197,94,0.3); }
        .seat-legend { display: flex; gap: 20px; align-items: center; flex-wrap: wrap; margin-top: 12px; padding: 10px; background: #fff; border-radius: 8px; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 13px; color: #475569; }
        .legend-dot { width: 20px; height: 20px; border-radius: 4px; border: 2px solid; }
        .flight-info { background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); color: white; padding: 20px; border-radius: 12px; margin-bottom: 20px; }
        .flight-info h4 { margin: 0 0 10px 0; font-size: 18px; }
        .flight-route { font-size: 24px; font-weight: bold; display: flex; align-items: center; gap: 15px; }
        .flight-route .arrow { font-size: 30px; }
        .flight-details { display: flex; gap: 30px; margin-top: 15px; flex-wrap: wrap; }
        .flight-detail { display: flex; flex-direction: column; }
        .flight-detail .label { font-size: 11px; opacity: 0.8; text-transform: uppercase; }
        .flight-detail .value { font-size: 16px; font-weight: 600; }
        .passager-section { background: #fef3c7; border: 2px solid #fbbf24; border-radius: 10px; padding: 20px; margin-top: 20px; }
        .passager-section h4 { color: #92400e; margin: 0 0 15px 0; }
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
                <h1 class="page-title"><span class="icon">📋</span>
                    <% oo.Reservation _reservation = (oo.Reservation) request.getAttribute("reservation");
                       if (_reservation != null && _reservation.getIdReservation() > 0) { %>
                        Modifier Réservation
                    <% } else { %>
                        Nouvelle Réservation
                    <% } %>
                </h1>
                <p class="page-subtitle">Sélectionnez un vol, choisissez une place, et saisissez les informations du passager</p>
            </div>
        </div>

        <%
            List<Vol.VolDetail> vols = (List<Vol.VolDetail>) request.getAttribute("vols");
            List<Place> places = (List<Place>) request.getAttribute("places");
            Integer selectedVolIdObj = (Integer) request.getAttribute("selectedVolId");
            int selectedVolId = selectedVolIdObj != null ? selectedVolIdObj : 0;
            Integer selectedPlaceIdObj = (Integer) request.getAttribute("selectedPlaceId");
            int selectedPlaceId = selectedPlaceIdObj != null ? selectedPlaceIdObj : 0;
            Set<Integer> reservedPlaceIds = (Set<Integer>) request.getAttribute("reservedPlaceIds");
            if (reservedPlaceIds == null) reservedPlaceIds = new java.util.HashSet<>();
            
            // Données passager existant (en édition)
            oo.Passager passager = (oo.Passager) request.getAttribute("passager");
            
            // Info du vol sélectionné
            Vol.VolDetail selectedVol = null;
            if (selectedVolId > 0 && vols != null) {
                for (Vol.VolDetail v : vols) {
                    if (v.getIdVol() == selectedVolId) { selectedVol = v; break; }
                }
            }

            String baseAction;
            if (_reservation != null && _reservation.getIdReservation() > 0) {
                baseAction = request.getContextPath() + "/ReservationServlet?action=edit&id=" + _reservation.getIdReservation();
            } else {
                baseAction = request.getContextPath() + "/ReservationServlet?action=new";
            }
        %>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">✈️ Étape 1: Choisir un vol</h3>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <label class="form-label">Sélectionner le vol</label>
                    <select class="form-control" id="volSelector" onchange="onVolChange(this.value)" style="font-size: 16px; padding: 12px;">
                        <option value="">-- Choisir un vol --</option>
                        <%
                            if (vols != null) {
                                for (Vol.VolDetail v : vols) {
                                    String sel = (v.getIdVol() == selectedVolId) ? "selected" : "";
                        %>
                        <option value="<%= v.getIdVol() %>" <%= sel %>>
                            Vol N°<%= v.getNumeroVol() %> | <%= v.getTrajetDepart() %> → <%= v.getTrajetArrivee() %> | <%= v.getAvionCode() %> (<%= v.getAvionModel() %>)
                        </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <% if (selectedVol != null) { %>
                <div class="flight-info">
                    <h4>✈️ Vol sélectionné</h4>
                    <div class="flight-route">
                        <span><%= selectedVol.getTrajetDepart() %></span>
                        <span class="arrow">✈️→</span>
                        <span><%= selectedVol.getTrajetArrivee() %></span>
                    </div>
                    <div class="flight-details">
                        <div class="flight-detail">
                            <span class="label">Numéro</span>
                            <span class="value"><%= selectedVol.getNumeroVol() %></span>
                        </div>
                        <div class="flight-detail">
                            <span class="label">Avion</span>
                            <span class="value"><%= selectedVol.getAvionCode() %> - <%= selectedVol.getAvionModel() %></span>
                        </div>
                        <div class="flight-detail">
                            <span class="label">Départ</span>
                            <span class="value"><%= selectedVol.getDateDepart() != null ? selectedVol.getDateDepart().toLocalDateTime().toLocalDate() : "N/A" %> à <%= selectedVol.getHeureDepart() != null ? selectedVol.getHeureDepart().toString().substring(0,5) : "N/A" %></span>
                        </div>
                        <div class="flight-detail">
                            <span class="label">Arrivée</span>
                            <span class="value"><%= selectedVol.getDateArrive() != null ? selectedVol.getDateArrive().toLocalDateTime().toLocalDate() : "N/A" %> à <%= selectedVol.getHeureArrivee() != null ? selectedVol.getHeureArrivee().toString().substring(0,5) : "N/A" %></span>
                        </div>
                        <div class="flight-detail">
                            <span class="label">Capacité</span>
                            <span class="value"><%= selectedVol.getAvionCapacite() %> places</span>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <% if (selectedVolId > 0) { %>
        <form method="post" action="<%= request.getContextPath() %>/ReservationServlet">
            <% if (_reservation != null && _reservation.getIdReservation() > 0) { %>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="idReservation" value="<%= _reservation.getIdReservation() %>">
            <% } else { %>
                <input type="hidden" name="action" value="create">
            <% } %>
            <input type="hidden" name="idVol" value="<%= selectedVolId %>">
            <input type="hidden" name="idPlace" id="idPlace" value="<%= selectedPlaceId %>">

            <div class="card" style="margin-top: 20px;">
                <div class="card-header">
                    <h3 class="card-title">💺 Étape 2: Choisir une place</h3>
                </div>
                <div class="card-body">
                    <p style="color: #64748b; margin-bottom: 15px;">Cliquez sur une place disponible pour la sélectionner</p>
                    
                    <div class="seat-grid" role="grid" aria-label="Plan des places">
                        <%
                            if (places != null) {
                                for (Place pl : places) {
                                    boolean isReserved = reservedPlaceIds.contains(pl.getIdPlace());
                                    boolean isSelected = pl.getIdPlace() == selectedPlaceId;
                                    String cls = "seat-btn" + (isReserved ? " reserved" : "") + (isSelected ? " selected" : "");
                                    // determine visual type class and label
                                    String typeClass = "seat-economique";
                                    String typeLabel = "Éco";
                                    if (pl.getTypePlace() != null) {
                                        if ("premiere_classe".equals(pl.getTypePlace())) { typeClass = "seat-premiere"; typeLabel = "Prem"; }
                                        else if ("premium".equals(pl.getTypePlace())) { typeClass = "seat-premium"; typeLabel = "Premium"; }
                                        else { typeClass = "seat-economique"; typeLabel = "Éco"; }
                                    }
                                    String fullCls = cls + " " + typeClass;
                        %>
                        <button type="button" class="<%= fullCls %>" 
                                data-place-id="<%= pl.getIdPlace() %>" 
                                <%= isReserved ? "disabled title='Place réservée'" : "" %>
                                onclick="selectSeat(<%= pl.getIdPlace() %>, <%= pl.getNumeroPlace() %>)">
                            <div><%= pl.getNumeroPlace() %></div>
                            <div class="seat-type"><%= typeLabel %></div>
                        </button>
                        <%
                                }
                            }
                        %>
                    </div>
                    
                    <div class="seat-legend">
                        <div class="legend-item">
                            <div class="legend-dot" style="background: #fff; border-color: #cbd5e1;"></div>
                            <span>Disponible</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-dot" style="background: #fee2e2; border-color: #fca5a5;"></div>
                            <span>Réservée</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-dot" style="background: #dcfce7; border-color: #22c55e;"></div>
                            <span>Sélectionnée</span>
                        </div>
                    </div>

                    <div style="margin-top: 15px; padding: 10px; background: #f1f5f9; border-radius: 8px;">
                        <strong>Place sélectionnée:</strong> 
                        <span id="selectedPlaceLabel" style="color: #16a34a; font-weight: bold;">
                            <%= selectedPlaceId > 0 ? "Place " + selectedPlaceId : "Aucune" %>
                        </span>
                    </div>
                </div>
            </div>

            <div class="card" style="margin-top: 20px;">
                <div class="card-header">
                    <h3 class="card-title">👤 Étape 3: Informations du passager</h3>
                </div>
                <div class="card-body">
                    <div class="passager-section">
                        <h4>👤 Données du passager</h4>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Nom *</label>
                                <input type="text" name="passagerNom" class="form-control" required
                                       value="<%= passager != null ? passager.getNom() : "" %>"
                                       placeholder="Ex: RAKOTO">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Prénom *</label>
                                <input type="text" name="passagerPrenom" class="form-control" required
                                       value="<%= passager != null ? passager.getPrenom() : "" %>"
                                       placeholder="Ex: Jean">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Téléphone</label>
                                <input type="tel" name="passagerTelephone" class="form-control"
                                       value="<%= passager != null && passager.getTelephone() != null ? passager.getTelephone() : "" %>"
                                       placeholder="Ex: 034 00 000 00">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" name="passagerEmail" class="form-control"
                                       value="<%= passager != null && passager.getEmail() != null ? passager.getEmail() : "" %>"
                                       placeholder="Ex: jean.rakoto@email.com">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Numéro Passeport</label>
                                <input type="text" name="passagerPasseport" class="form-control"
                                       value="<%= passager != null && passager.getNumeroPasseport() != null ? passager.getNumeroPasseport() : "" %>"
                                       placeholder="Ex: AB123456">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Catégorie</label>
                                <select name="idCategorie" class="form-control">
                                    <option value="">-- Sélectionner --</option>
                                    <%
                                        java.util.List<oo.Categorie> cats = (java.util.List<oo.Categorie>) request.getAttribute("categories");
                                        Integer selCat = (Integer) request.getAttribute("selectedCategorieId");
                                        if (cats != null) {
                                            for (oo.Categorie c : cats) {
                                                String sel = (selCat != null && c.getIdCategorie() == selCat) ? "selected" : "";
                                    %>
                                    <option value="<%= c.getIdCategorie() %>" <%= sel %>><%= c.getLibelle() %></option>
                                    <%    }
                                        }
                                    %>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card" style="margin-top: 20px;">
                <div class="card-body">
                    <div class="form-actions" style="justify-content: space-between; display: flex;">
                        <a href="<%= request.getContextPath() %>/ReservationServlet" class="btn btn-secondary">↩️ Annuler</a>
                        <button type="submit" class="btn btn-primary" id="submitBtn" <%= selectedPlaceId <= 0 ? "disabled" : "" %>>
                            💾 <%= _reservation != null && _reservation.getIdReservation() > 0 ? "Modifier" : "Créer" %> la réservation
                        </button>
                    </div>
                </div>
            </div>
        </form>
        <% } else { %>
        <div class="card" style="margin-top: 20px;">
            <div class="card-body" style="text-align: center; padding: 40px;">
                <p style="font-size: 18px; color: #64748b;">👆 Veuillez d'abord sélectionner un vol ci-dessus</p>
            </div>
        </div>
        <% } %>
    </main>
</div>

<script>
    function onVolChange(volId) {
        if (!volId) {
            window.location.href = "<%= baseAction %>";
            return;
        }
        window.location.href = "<%= baseAction %>&idVol=" + encodeURIComponent(volId);
    }

    function selectSeat(idPlace, numeroPlace) {
        document.getElementById('idPlace').value = idPlace;
        document.getElementById('selectedPlaceLabel').textContent = 'Place ' + numeroPlace;
        document.getElementById('submitBtn').disabled = false;

        // Visual selection
        var buttons = document.querySelectorAll('.seat-btn');
        buttons.forEach(function(btn) {
            btn.classList.remove('selected');
        });
        
        var selectedBtn = document.querySelector('.seat-btn[data-place-id="' + idPlace + '"]');
        if (selectedBtn) {
            selectedBtn.classList.add('selected');
        }
    }
</script>
</body>
</html>
