<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="oo.Billet" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billets & Chiffre d'Affaires - Skyfly Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 25px; }
        .stat-card { background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); color: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 15px rgba(59,130,246,0.3); }
        .stat-card.green { background: linear-gradient(135deg, #10b981 0%, #059669 100%); box-shadow: 0 4px 15px rgba(16,185,129,0.3); }
        .stat-card.purple { background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%); box-shadow: 0 4px 15px rgba(139,92,246,0.3); }
        .stat-card h4 { margin: 0 0 10px 0; font-size: 14px; opacity: 0.9; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-value { font-size: 32px; font-weight: 700; }
        .stat-sub { font-size: 13px; opacity: 0.8; margin-top: 5px; }
        .ca-section { background: #f8fafc; border-radius: 12px; padding: 20px; margin-bottom: 25px; }
        .ca-section h3 { margin: 0 0 15px 0; color: #1e293b; display: flex; align-items: center; gap: 10px; }
        .ca-table { width: 100%; border-collapse: collapse; }
        .ca-table th, .ca-table td { padding: 12px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        .ca-table th { background: #f1f5f9; font-weight: 600; color: #475569; }
        .ca-table tr:hover { background: #f8fafc; }
        .ca-amount { font-weight: 700; color: #16a34a; }
        .classe-badge { padding: 4px 10px; border-radius: 8px; font-size: 12px; font-weight: 600; }
        .classe-eco { background: #dbeafe; color: #1e40af; }
        .classe-bus { background: #fef3c7; color: #92400e; }
        .classe-pre { background: #fce7f3; color: #9d174d; }
        .tab-nav { display: flex; gap: 5px; margin-bottom: 20px; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px; }
        .tab-btn { padding: 10px 20px; border: none; background: transparent; cursor: pointer; font-size: 14px; font-weight: 500; color: #64748b; border-radius: 8px 8px 0 0; transition: all 0.2s; }
        .tab-btn:hover { background: #f1f5f9; }
        .tab-btn.active { background: #3b82f6; color: white; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
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
                <h1 class="page-title"><span class="icon">🎫</span> Billets & Chiffre d'Affaires</h1>
                <p class="page-subtitle">Gestion des billets et statistiques de revenus</p>
            </div>
            <a href="<%= request.getContextPath() %>/BilletServlet?action=new" class="btn btn-primary">➕ Nouveau Billet</a>
        </div>

        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
        <div class="alert alert-danger">⚠️ <%= error %></div>
        <% } if (success != null) { %>
        <div class="alert alert-success">✅ <%= success %></div>
        <% } %>

        <%
            BigDecimal caTotal = (BigDecimal) request.getAttribute("caTotal");
            List<Billet.ChiffreAffaireTrajet> caParTrajet = (List<Billet.ChiffreAffaireTrajet>) request.getAttribute("caParTrajet");
            List<Billet.ChiffreAffaireAvion> caParAvion = (List<Billet.ChiffreAffaireAvion>) request.getAttribute("caParAvion");
            List<Billet.BilletDetail> billets = (List<Billet.BilletDetail>) request.getAttribute("billets");
            
            int totalBillets = billets != null ? billets.size() : 0;
            int totalTrajets = caParTrajet != null ? caParTrajet.size() : 0;
            int totalAvions = caParAvion != null ? caParAvion.size() : 0;
        %>

        <!-- Statistiques globales -->
        <div class="stats-grid">
            <div class="stat-card green">
                <h4>💰 Chiffre d'Affaires Total</h4>
                <div class="stat-value"><%= caTotal != null ? String.format("%,.2f", caTotal) : "0.00" %> AR</div>
                <div class="stat-sub">Revenus cumulés de tous les billets</div>
            </div>
            <div class="stat-card">
                <h4>🎫 Total Billets Émis</h4>
                <div class="stat-value"><%= totalBillets %></div>
                <div class="stat-sub">Billets vendus</div>
            </div>
            <div class="stat-card purple">
                <h4>🗺️ Trajets Actifs</h4>
                <div class="stat-value"><%= totalTrajets %></div>
                <div class="stat-sub">Itinéraires disponibles</div>
            </div>
        </div>

        <!-- Onglets -->
        <div class="tab-nav">
            <button class="tab-btn active" onclick="showTab('billets')">🎫 Liste des Billets</button>
            <button class="tab-btn" onclick="showTab('ca-trajet')">🗺️ CA par Trajet</button>
            <button class="tab-btn" onclick="showTab('ca-avion')">✈️ CA par Avion</button>
        </div>

        <!-- Tab: Liste des billets -->
        <div id="tab-billets" class="tab-content active">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">🎫 Tous les billets</h3>
                </div>
                <div class="card-body">
                    <div class="filter-bar">
                        <input type="search" id="filterBillets" class="form-control" placeholder="🔎 Rechercher un billet..." onkeyup="filterTable('billetsTable', this.value)">
                    </div>
                    <div class="table-container">
                        <table class="table" id="billetsTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Passager</th>
                                    <th>Vol</th>
                                    <th>Trajet</th>
                                    <th>Place</th>
                                    <th>Classe</th>
                                    <th>Prix</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                if (billets != null && !billets.isEmpty()) {
                                    for (Billet.BilletDetail b : billets) {
                                        String passagerName = (b.getPassagerNom() != null) ? b.getPassagerNom() + " " + b.getPassagerPrenom() : "Non renseigné";
                                        String classeClass = "classe-eco";
                                        if ("Business".equals(b.getClasse())) classeClass = "classe-bus";
                                        else if ("Premiere".equals(b.getClasse())) classeClass = "classe-pre";
                            %>
                                <tr>
                                    <td><span class="badge badge-info">#<%= b.getIdBillet() %></span></td>
                                    <td><strong>👤 <%= passagerName %></strong></td>
                                    <td>
                                        <div>
                                            <strong>Vol N°<%= b.getNumeroVol() %></strong><br>
                                            <small style="color: #666;"><%= b.getAvionCode() %></small>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-size: 12px;">
                                            🛫 <%= b.getTrajetDepart() %><br>
                                            🛬 <%= b.getTrajetArrivee() %>
                                        </div>
                                    </td>
                                    <td><strong>💺 <%= b.getNumeroPlace() %></strong></td>
                                    <td><span class="classe-badge <%= classeClass %>"><%= b.getClasse() %></span></td>
                                    <td class="ca-amount"><%= String.format("%,.2f", b.getPrix()) %> AR</td>
                                    <td class="actions">
                                        <a href="<%= request.getContextPath() %>/BilletServlet?action=edit&id=<%= b.getIdBillet() %>" class="btn btn-sm btn-primary" title="Modifier">✏️</a>
                                        <form method="post" action="<%= request.getContextPath() %>/BilletServlet" style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="idBillet" value="<%= b.getIdBillet() %>">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer ce billet ?')" title="Supprimer">🗑️</button>
                                        </form>
                                    </td>
                                </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="8">
                                        <div class="empty-state">
                                            <div class="icon">🎫</div>
                                            <h3>Aucun billet émis</h3>
                                            <p>Créez d'abord des réservations, puis émettez des billets</p>
                                            <a href="<%= request.getContextPath() %>/ReservationServlet" class="btn btn-secondary">Voir les Réservations</a>
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
        </div>

        <!-- Tab: CA par Trajet -->
        <div id="tab-ca-trajet" class="tab-content">
            <div class="ca-section">
                <h3>🗺️ Chiffre d'Affaires par Trajet</h3>
                <table class="ca-table">
                    <thead>
                        <tr>
                            <th>Trajet</th>
                            <th>Nb Billets</th>
                            <th>Chiffre d'Affaires</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (caParTrajet != null && !caParTrajet.isEmpty()) {
                            for (Billet.ChiffreAffaireTrajet cat : caParTrajet) {
                    %>
                        <tr>
                            <td>
                                <strong>🛫 <%= cat.getTrajetDepart() %></strong><br>
                                <span style="color: #64748b;">🛬 <%= cat.getTrajetArrivee() %></span>
                            </td>
                            <td><span class="badge badge-info"><%= cat.getNbBillets() %></span></td>
                            <td class="ca-amount"><%= String.format("%,.2f", cat.getChiffreAffaire()) %> AR</td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="3" style="text-align: center; padding: 30px; color: #64748b;">
                                Aucune donnée disponible
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Tab: CA par Avion -->
        <div id="tab-ca-avion" class="tab-content">
            <div class="ca-section">
                <h3>✈️ Chiffre d'Affaires par Avion</h3>
                <table class="ca-table">
                    <thead>
                        <tr>
                            <th>Avion</th>
                            <th>Nb Billets</th>
                            <th>Chiffre d'Affaires</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (caParAvion != null && !caParAvion.isEmpty()) {
                            for (Billet.ChiffreAffaireAvion caa : caParAvion) {
                    %>
                        <tr>
                            <td>
                                <strong><%= caa.getCode() %></strong><br>
                                <span style="color: #64748b;"><%= caa.getModel() %></span>
                            </td>
                            <td><span class="badge badge-info"><%= caa.getNbBillets() %></span></td>
                            <td class="ca-amount"><%= String.format("%,.2f", caa.getChiffreAffaire()) %> AR</td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="3" style="text-align: center; padding: 30px; color: #64748b;">
                                Aucune donnée disponible
                            </td>
                        </tr>
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
    function showTab(tabId) {
        // Hide all tabs
        document.querySelectorAll('.tab-content').forEach(function(tab) {
            tab.classList.remove('active');
        });
        document.querySelectorAll('.tab-btn').forEach(function(btn) {
            btn.classList.remove('active');
        });
        
        // Show selected tab
        document.getElementById('tab-' + tabId).classList.add('active');
        event.target.classList.add('active');
    }

    function filterTable(tableId, query) {
        var table = document.getElementById(tableId);
        var rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
        query = query.toLowerCase();
        
        for (var i = 0; i < rows.length; i++) {
            var text = rows[i].textContent.toLowerCase();
            rows[i].style.display = text.indexOf(query) > -1 ? '' : 'none';
        }
    }
</script>
</body>
</html>
