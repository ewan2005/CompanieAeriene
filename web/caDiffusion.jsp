<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CA Publicité - Skyfly Airlines</title>
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
        <%
            Integer mois = (Integer) request.getAttribute("mois");
            Integer annee = (Integer) request.getAttribute("annee");
            if (mois == null) mois = 12;
            if (annee == null) annee = 2025;
            
            String[] moisNoms = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                                 "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
            
            java.math.BigDecimal totalCA = (java.math.BigDecimal) request.getAttribute("caTotal");
            if (totalCA == null) totalCA = java.math.BigDecimal.ZERO;
            
            Integer totalDiffusions = (Integer) request.getAttribute("totalDiffusions");
            if (totalDiffusions == null) totalDiffusions = 0;
            
            java.math.BigDecimal tarifActuel = (java.math.BigDecimal) request.getAttribute("tarifActuel");
            if (tarifActuel == null) tarifActuel = new java.math.BigDecimal("400000");

            // CA calculé directement si non fourni par le servlet
            java.math.BigDecimal caTotal = totalCA;
            if (caTotal.compareTo(java.math.BigDecimal.ZERO) == 0 && totalDiffusions > 0) {
                caTotal = tarifActuel.multiply(java.math.BigDecimal.valueOf(totalDiffusions));
            }
        %>
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">📊</span> Chiffre d'Affaires Publicité</h1>
                <p class="page-subtitle"><%= moisNoms[mois] %> <%= annee %></p>
            </div>
        </div>

        <div class="card" style="margin-bottom: 20px;">
            <div class="card-header">
                <h3 class="card-title">🔎 Filtrer par période</h3>
            </div>
            <div class="card-body">
                <form method="get" action="<%= request.getContextPath() %>/DiffusionServlet">
                    <input type="hidden" name="action" value="ca">
                    <div style="display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Mois</label>
                            <select name="mois" class="form-control">
                                <% for (int m = 1; m <= 12; m++) { %>
                                    <option value="<%= m %>" <%= m == mois ? "selected" : "" %>><%= moisNoms[m] %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label">Année</label>
                            <select name="annee" class="form-control">
                                <% for (int a = 2024; a <= 2030; a++) { %>
                                    <option value="<%= a %>" <%= a == annee ? "selected" : "" %>><%= a %></option>
                                <% } %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Rechercher</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card" style="margin-bottom: 20px; background: linear-gradient(135deg, #28a745, #20c997);">
            <div class="card-body" style="text-align: center; padding: 30px; color: white;">
                <h2 style="margin: 0; font-size: 18px;">💰 CA Total Réel - <%= moisNoms[mois] %> <%= annee %></h2>
                <p style="font-size: 48px; font-weight: bold; margin: 15px 0;">
                    <%= String.format("%,.0f", totalCA.doubleValue()) %> Ar
                </p>
                <p style="margin: 0; opacity: 0.9;"><%= totalDiffusions %> diffusions vendues</p>
            </div>
        </div>

        <!-- Section Simulation Fictive -->
        <div class="card" style="margin-bottom: 20px; border: 2px dashed #6c757d;">
            <div class="card-header" style="background: linear-gradient(135deg, #6c757d, #495057);">
                <h3 class="card-title" style="color: white;">🧮 Simulation Fictive (sans modifier la base de données)</h3>
            </div>
            <div class="card-body">
                <p style="color: #666; margin-bottom: 15px;">
                    <em>Simulez le CA si le tarif par diffusion était différent. Les <%= totalDiffusions %> diffusions de cette période seront recalculées avec le nouveau tarif.</em>
                </p>
                <div style="display: flex; gap: 20px; align-items: flex-end; flex-wrap: wrap;">
                    <div class="form-group" style="margin-bottom: 0; flex: 1; min-width: 200px;">
                        <label class="form-label">Tarif fictif par diffusion (Ar)</label>
                        <input type="number" id="tarifSimulation" class="form-control"
                               value="<%= tarifActuel.longValue() %>" min="0" step="10000"
                               placeholder="Ex: 500000">
                        <small style="color: #888;">Tarif actuel: <%= String.format("%,.0f", tarifActuel.doubleValue()) %> Ar</small>
                    </div>
                    <button type="button" class="btn btn-success" onclick="calculerSimulation()">🧮 Calculer</button>
                </div>

                <div id="resultSimulation" style="margin-top: 20px; display: none;">
                    <div style="background: linear-gradient(135deg, #6c757d, #495057); padding: 20px; border-radius: 10px; color: white; text-align: center;">
                        <h4 style="margin: 0;">💡 CA Simulé avec le nouveau tarif</h4>
                        <p style="font-size: 36px; font-weight: bold; margin: 10px 0;" id="caSimuleValue">0 Ar</p>
                        <p style="margin: 0; opacity: 0.9;">
                            <span id="nbDiffSimule"><%= totalDiffusions %></span> diffusions × 
                            <span id="tarifSimuleAffiche">0</span> Ar
                        </p>
                        <p style="margin-top: 10px; font-size: 14px;">
                            Différence avec le CA réel:
                            <strong id="differenceCA" style="color: #90EE90;">0 Ar</strong>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card" style="margin-bottom: 20px;">
            <div class="card-header">
                <h3 class="card-title">📋 Détail par société</h3>
            </div>
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Société</th>
                            <th>Diffusions</th>
                            <th>Montant Total</th>
                            <th>Montant Payé</th>
                            <th>Reste à Payer</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List achats = (java.util.List) request.getAttribute("achats");
                            if (achats != null && !achats.isEmpty()) {
                                for (Object o : achats) {
                                    oo.AchatDiffusion a = (oo.AchatDiffusion) o;
                                    java.math.BigDecimal montantPaye = java.math.BigDecimal.ZERO;
                                    java.math.BigDecimal resteAPayer = a.getMontantTotal();
                                    try { 
                                        montantPaye = a.getMontantPaye(); 
                                        resteAPayer = a.getResteAPayer();
                                    } catch (Exception e) {}
                        %>
                            <tr>
                                <td><strong><%= a.getSociete() != null ? a.getSociete().getNom() : "-" %></strong></td>
                                <td><span class="badge badge-primary"><%= a.getNombreDiffusions() %></span> × <%= String.format("%,.0f", a.getCoutUnitaire().doubleValue()) %> Ar</td>
                                <td><strong><%= String.format("%,.0f", a.getMontantTotal().doubleValue()) %> Ar</strong></td>
                                <td><span style="color: #28a745;"><%= String.format("%,.0f", montantPaye.doubleValue()) %> Ar</span></td>
                                <td>
                                    <% if (resteAPayer.compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                        <strong style="color: #dc3545;"><%= String.format("%,.0f", resteAPayer.doubleValue()) %> Ar</strong>
                                    <% } else { %>
                                        <span class="badge badge-success">✓ Soldé</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="5" style="text-align:center;">Aucun achat pour cette période.</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">✈️ Répartition par vol</h3>
            </div>
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Vol</th>
                            <th>Date</th>
                            <th>Nb Diffusions</th>
                            <th>Sociétés</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List<Object[]> resumeParVol = (java.util.List<Object[]>) request.getAttribute("resumeParVol");
                            if (resumeParVol != null && !resumeParVol.isEmpty()) {
                                for (Object[] row : resumeParVol) {
                                    // row: idVol, numeroVol, dateDepart, nbDiffusions, societes
                        %>
                            <tr>
                                <td><strong><%= row[1] %></strong></td>
                                <td><%= row[2] %></td>
                                <td><span class="badge badge-info"><%= row[3] %></span></td>
                                <td><%= row[4] %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/DiffusionServlet?action=detailVol&idVol=<%= row[0] %>" 
                                       class="btn btn-sm btn-primary">Détail</a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="5" style="text-align:center;">Aucune diffusion affectée pour cette période.</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script>
    // Variables globales pour la simulation
    var totalDiffusions = <%= totalDiffusions %>;
    var caReel = <%= caTotal.doubleValue() %>;
    var tarifActuel = <%= tarifActuel.longValue() %>;

    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    function calculerSimulation() {
        var tarifInput = document.getElementById('tarifSimulation');
        var tarifSimule = parseFloat(tarifInput.value) || 0;
        
        // Calcul du CA simulé
        var caSimule = totalDiffusions * tarifSimule;
        var difference = caSimule - caReel;
        
        // Affichage des résultats
        document.getElementById('caSimuleValue').textContent = formatNumber(Math.round(caSimule)) + " Ar";
        document.getElementById('tarifSimuleAffiche').textContent = formatNumber(Math.round(tarifSimule));
        document.getElementById('nbDiffSimule').textContent = totalDiffusions;
        
        // Formater la différence avec signe et couleur
        var diffElement = document.getElementById('differenceCA');
        var diffText = (difference >= 0 ? "+" : "") + formatNumber(Math.round(difference)) + " Ar";
        diffElement.textContent = diffText;
        diffElement.style.color = difference >= 0 ? "#90EE90" : "#FF6B6B";
        
        // Afficher la section résultat
        document.getElementById('resultSimulation').style.display = 'block';
    }
</script>
</body>
</html>
