<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Achat Diffusion - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link active">
                    <span class="icon">🏠</span> Accueil
                </a>
                <a href="<%= request.getContextPath() %>/TrajetServlet" class="nav-link">
                    <span class="icon">🧭</span> Trajets
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
                <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link">
                    <span class="icon">➕</span> Nouveau trajet
                </a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link">
                    <span class="icon">✈️</span> Avions
                </a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link">
                    <span class="icon">🏢</span> Aéroports
                </a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link">
                    <span class="icon">👥</span> Passagers
                </a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link">
                    <span class="icon">🎫</span> Billets
                </a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link">
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
                <div class="nav-section-title">Publicité</div>
                <a href="<%= request.getContextPath() %>/SocieteServlet" class="nav-link">
                    <span class="icon">🏛️</span> Sociétés
                </a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet" class="nav-link">
                    <span class="icon">📺</span> Diffusions
                </a>
                <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="nav-link">
                    <span class="icon">⚙️</span> Config Tarif Pub
                </a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=ca" class="nav-link">
                    <span class="icon">📊</span> CA Publicité
                </a>
                <a href="<%= request.getContextPath() %>/DiffusionPaiementServlet" class="nav-link">
                    <span class="icon">💹</span> Paiements Diffusions
                </a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Statistiques</div>
                <a href="<%= request.getContextPath() %>/CAParVolServlet" class="nav-link">
                    <span class="icon">📈</span> CA par Vol
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
                <h1 class="page-title"><span class="icon">📺</span>
                    <% oo.AchatDiffusion _achat = (oo.AchatDiffusion) request.getAttribute("achat");
                       if (_achat != null && _achat.getIdAchat() > 0) { %>
                        Modifier Achat de Diffusions
                    <% } else { %>
                        Nouvel Achat de Diffusions
                    <% } %>
                </h1>
                <p class="page-subtitle">Une société achète un nombre de diffusions pour un mois</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Informations de l'achat</h3>
            </div>
            <div class="card-body">
                <%
                    java.math.BigDecimal tarifActuel = (java.math.BigDecimal) request.getAttribute("tarifActuel");
                    if (tarifActuel == null) tarifActuel = new java.math.BigDecimal("400000");
                    Integer diffAffectees = (Integer) request.getAttribute("diffusionsAffectees");
                    if (diffAffectees == null) diffAffectees = 0;
                %>
                <div class="alert alert-info" style="background: #e3f2fd; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <strong>💰 Tarif actuel:</strong> <%= String.format("%,.0f", tarifActuel.doubleValue()) %> Ar / diffusion
                </div>

                <% if (_achat != null && diffAffectees > 0) { %>
                <div class="alert" style="background: #fff3cd; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <strong>⚠️ Attention:</strong> <%= diffAffectees %> diffusion(s) déjà affectée(s) à des vols.
                </div>
                <% } %>

                <form method="post" action="<%= request.getContextPath() %>/DiffusionServlet">
                    <% if (_achat != null && _achat.getIdAchat() > 0) { %>
                        <input type="hidden" name="action" value="updateAchat">
                        <input type="hidden" name="idAchat" value="<%= _achat.getIdAchat() %>">
                    <% } else { %>
                        <input type="hidden" name="action" value="createAchat">
                    <% } %>

                    <div class="form-group">
                        <label class="form-label">Société *</label>
                        <select name="idSociete" class="form-control" required>
                            <option value="">-- Sélectionner --</option>
                            <%
                                java.util.List societes = (java.util.List) request.getAttribute("societes");
                                if (societes != null) {
                                    for (Object o : societes) {
                                        oo.Societe s = (oo.Societe) o;
                                        boolean selected = _achat != null && _achat.getIdSociete() == s.getIdSociete();
                            %>
                                <option value="<%= s.getIdSociete() %>" <%= selected ? "selected" : "" %>><%= s.getNom() %></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mois *</label>
                            <select name="mois" class="form-control" required>
                                <%
                                    String[] moisNoms = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                                                        "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
                                    int moisActuel = _achat != null ? _achat.getMois() : 12;
                                    for (int m = 1; m <= 12; m++) {
                                %>
                                    <option value="<%= m %>" <%= m == moisActuel ? "selected" : "" %>><%= moisNoms[m] %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Année *</label>
                            <select name="annee" class="form-control" required>
                                <%
                                    int anneeActuelle = _achat != null ? _achat.getAnnee() : 2025;
                                    for (int a = 2024; a <= 2030; a++) {
                                %>
                                    <option value="<%= a %>" <%= a == anneeActuelle ? "selected" : "" %>><%= a %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nombre de diffusions achetées *</label>
                            <input type="number" name="nombreDiffusions" class="form-control" min="1"
                                   value="<%= _achat != null ? _achat.getNombreDiffusions() : 1 %>" 
                                   placeholder="Ex: 20" required id="nbDiffusions">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Coût unitaire (Ar)</label>
                            <input type="number" name="coutUnitaire" class="form-control" 
                                   value="<%= _achat != null ? _achat.getCoutUnitaire().longValue() : tarifActuel.longValue() %>" 
                                   placeholder="400000" id="coutUnitaire">
                            <small style="color: #888;">Laissez vide pour utiliser le tarif actuel</small>
                        </div>
                    </div>

                    <div class="card" style="background: #f8f9fa; margin-bottom: 20px;">
                        <div class="card-body">
                            <h4>📊 Montant total de l'achat</h4>
                            <p style="font-size: 24px; font-weight: bold; color: #28a745;" id="montantTotal">
                                <%= _achat != null ? 
                                    String.format("%,.0f", _achat.getMontantTotal().doubleValue()) : 
                                    String.format("%,.0f", tarifActuel.doubleValue()) %> Ar
                            </p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/DiffusionServlet" class="btn">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    function calculerMontant() {
        var nb = parseInt(document.getElementById('nbDiffusions').value) || 0;
        var cout = parseInt(document.getElementById('coutUnitaire').value) || 0;
        var total = nb * cout;
        document.getElementById('montantTotal').textContent = total.toLocaleString('fr-FR') + ' Ar';
    }
    document.getElementById('nbDiffusions').addEventListener('input', calculerMontant);
    document.getElementById('coutUnitaire').addEventListener('input', calculerMontant);
</script>
</body>
</html>
