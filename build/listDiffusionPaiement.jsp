<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.DiffusionPaiement" %>
<%@ page import="oo.DiffusionPaiement.DiffusionPaiementDetail" %>
<%@ page import="oo.DiffusionPaiement.DiffusionVolDetail" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diffusions & Paiements Proportionnels - Skyfly Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
    <style>
        .diffusion-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .diffusion-header {
            background: linear-gradient(135deg, #9b59b6, #8e44ad);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .diffusion-header h3 {
            margin: 0;
            font-size: 18px;
        }
        .diffusion-header .periode {
            font-size: 14px;
            opacity: 0.9;
        }
        .diffusion-body {
            padding: 20px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .stat-box {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
        }
        .stat-box.du { border-left: 4px solid #f39c12; }
        .stat-box.paye { border-left: 4px solid #27ae60; }
        .stat-box.reste { border-left: 4px solid #e74c3c; }
        .stat-box.percent { border-left: 4px solid #3498db; }
        .stat-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }
        .stat-value {
            font-size: 18px;
            font-weight: bold;
        }
        .stat-value.du { color: #f39c12; }
        .stat-value.paye { color: #27ae60; }
        .stat-value.reste { color: #e74c3c; }
        .stat-value.percent { color: #3498db; }
        .progress-bar-container {
            background: #e0e0e0;
            border-radius: 10px;
            height: 20px;
            margin: 15px 0;
            overflow: hidden;
        }
        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #27ae60, #2ecc71);
            border-radius: 10px;
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: bold;
        }
        .vol-detail {
            background: #fafafa;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 12px 15px;
            margin-top: 10px;
        }
        .vol-detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .vol-info {
            font-weight: bold;
            color: #333;
        }
        .vol-date {
            color: #666;
            font-size: 13px;
        }
        .vol-amounts {
            display: flex;
            gap: 20px;
            font-size: 13px;
        }
        .vol-amounts span {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        .summary-card {
            border-radius: 10px;
            padding: 20px;
            color: white;
            text-align: center;
        }
        .summary-card.total-du { background: linear-gradient(135deg, #f39c12, #e67e22); }
        .summary-card.total-paye { background: linear-gradient(135deg, #27ae60, #2ecc71); }
        .summary-card.total-reste { background: linear-gradient(135deg, #e74c3c, #c0392b); }
        .summary-card h4 {
            margin: 0 0 10px 0;
            font-size: 14px;
            opacity: 0.9;
        }
        .summary-card .value {
            font-size: 24px;
            font-weight: bold;
        }
        .info-box {
            background: #e8f4fd;
            border-left: 4px solid #3498db;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .info-box h4 {
            margin: 0 0 10px 0;
            color: #2980b9;
        }
        .info-box p {
            margin: 5px 0;
            color: #555;
            font-size: 14px;
        }
        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-danger { background: #f8d7da; color: #721c24; }
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
        <%
            List<DiffusionPaiementDetail> diffusions = (List<DiffusionPaiementDetail>) request.getAttribute("diffusions");
            BigDecimal totalDu = (BigDecimal) request.getAttribute("totalDu");
            BigDecimal totalPaye = (BigDecimal) request.getAttribute("totalPaye");
            BigDecimal totalReste = (BigDecimal) request.getAttribute("totalReste");
            
            if (totalDu == null) totalDu = BigDecimal.ZERO;
            if (totalPaye == null) totalPaye = BigDecimal.ZERO;
            if (totalReste == null) totalReste = BigDecimal.ZERO;
            
            double totalPourcentage = 0;
            if (totalDu.compareTo(BigDecimal.ZERO) > 0) {
                totalPourcentage = totalPaye.multiply(new BigDecimal("100"))
                    .divide(totalDu, 2, java.math.RoundingMode.HALF_UP).doubleValue();
            }
        %>
        
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">💹</span> Diffusions & Paiements Proportionnels</h1>
                <p class="page-subtitle">Détail des paiements par société avec répartition proportionnelle sur les vols</p>
            </div>
            <a href="<%= request.getContextPath() %>/Accueil.jsp" class="btn btn-secondary">Retour Accueil</a>
        </div>

        <!-- Explication du fonctionnement -->
        <%-- <div class="info-box">
            <h4>📌 Comment fonctionne le paiement proportionnel ?</h4>
            <p><strong>1.</strong> Quand une société paie une partie de son achat, le pourcentage payé est calculé : <code>% payé = montant payé / montant total dû × 100</code></p>
            <p><strong>2.</strong> Ce pourcentage est appliqué à chaque vol où les diffusions sont affectées.</p>
            <p><strong>3.</strong> Exemple : Si socobis paie 100 000 Ar sur 800 000 Ar dû (12.5%), alors chaque vol reçoit 12.5% du montant de ses diffusions.</p>
        </div> --%>

        <!-- Cartes de synthèse globale -->
        <div class="summary-cards">
            <div class="summary-card total-du">
                <h4>💰 Total Dû (toutes sociétés)</h4>
                <div class="value"><%= String.format("%,.0f", totalDu.doubleValue()) %> Ar</div>
            </div>
            <div class="summary-card total-paye">
                <h4>✅ Total Payé</h4>
                <div class="value"><%= String.format("%,.0f", totalPaye.doubleValue()) %> Ar</div>
            </div>
            <div class="summary-card total-reste">
                <h4>⏳ Total Reste à Payer</h4>
                <div class="value"><%= String.format("%,.0f", totalReste.doubleValue()) %> Ar</div>
            </div>
        </div>

        <!-- Barre de progression globale -->
        <div class="card" style="margin-bottom: 25px;">
            <div class="card-body">
                <h4 style="margin: 0 0 10px 0;">📊 Progression globale des paiements</h4>
                <div class="progress-bar-container">
                    <div class="progress-bar" style="width: <%= totalPourcentage %>%;">
                        <%= String.format("%.1f", totalPourcentage) %>%
                    </div>
                </div>
            </div>
        </div>

        <!-- Liste des diffusions par société -->
        <h2 style="margin-bottom: 20px;">📺 Détail par Société</h2>
        
        <%
            if (diffusions != null && !diffusions.isEmpty()) {
                for (DiffusionPaiementDetail diff : diffusions) {
                    String badgeClass = "badge-danger";
                    String badgeText = "Non payé";
                    if (diff.getPourcentagePaye() >= 100) {
                        badgeClass = "badge-success";
                        badgeText = "Payé 100%";
                    } else if (diff.getPourcentagePaye() > 0) {
                        badgeClass = "badge-warning";
                        badgeText = "Paiement partiel";
                    }
        %>
        <div class="diffusion-card">
            <div class="diffusion-header">
                <div>
                    <h3>🏛️ <%= diff.getSocieteNom() %></h3>
                    <div class="periode"><%= diff.getMoisNom() %> <%= diff.getAnnee() %></div>
                </div>
                <span class="badge <%= badgeClass %>"><%= badgeText %></span>
            </div>
            <div class="diffusion-body">
                <!-- Statistiques -->
                <div class="stats-grid">
                    <div class="stat-box">
                        <div class="stat-label">Diffusions achetées</div>
                        <div class="stat-value"><%= diff.getNombreDiffusionsAchetees() %></div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">Diffusions affectées</div>
                        <div class="stat-value"><%= diff.getNombreDiffusionsAffectees() %></div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">Coût unitaire</div>
                        <div class="stat-value"><%= String.format("%,.0f", diff.getCoutUnitaire().doubleValue()) %> Ar</div>
                    </div>
                    <div class="stat-box du">
                        <div class="stat-label">Montant Total Dû</div>
                        <div class="stat-value du"><%= String.format("%,.0f", diff.getMontantTotalDu().doubleValue()) %> Ar</div>
                    </div>
                    <div class="stat-box paye">
                        <div class="stat-label">Montant Payé</div>
                        <div class="stat-value paye"><%= String.format("%,.0f", diff.getMontantTotalPaye().doubleValue()) %> Ar</div>
                    </div>
                    <div class="stat-box reste">
                        <div class="stat-label">Reste à Payer</div>
                        <div class="stat-value reste"><%= String.format("%,.0f", diff.getResteAPayer().doubleValue()) %> Ar</div>
                    </div>
                </div>

                <!-- Barre de progression -->
                <div class="progress-bar-container">
                    <div class="progress-bar" style="width: <%= diff.getPourcentagePaye() %>%;">
                        <%= String.format("%.1f", diff.getPourcentagePaye()) %>% payé
                    </div>
                </div>

                <!-- Détail par vol -->
                <% if (!diff.getDiffusionsParVol().isEmpty()) { %>
                <h4 style="margin: 20px 0 10px 0;">📋 Répartition proportionnelle par vol</h4>
                <% for (DiffusionVolDetail volDetail : diff.getDiffusionsParVol()) { 
                    // Calculer le montant par diffusion unitaire
                    double coutUnitaire = diff.getCoutUnitaire().doubleValue();
                    double pourcentPaye = diff.getPourcentagePaye();
                    double payeParDiffusion = coutUnitaire * pourcentPaye / 100;
                    double resteParDiffusion = coutUnitaire - payeParDiffusion;
                %>
                <div class="vol-detail">
                    <div class="vol-detail-header">
                        <div>
                            <span class="vol-info">✈️ Vol <%= volDetail.getNumeroVol() %></span>
                            <span class="vol-date"> - 📅 <%= volDetail.getDateVol() %> 🕐 <%= volDetail.getHeureVol() != null ? volDetail.getHeureVol().toString().substring(0,5) : "" %></span>
                        </div>
                        <span style="color: #9b59b6; font-weight: bold;"><%= volDetail.getNbDiffusions() %> diffusion(s)</span>
                    </div>
                    
                    <!-- Affichage de chaque diffusion séparément -->
                    <div style="margin-top: 10px;">
                        <% for (int i = 1; i <= volDetail.getNbDiffusions(); i++) { %>
                        <div style="background: #fff; border: 1px solid #ddd; border-radius: 6px; padding: 10px 15px; margin-bottom: 8px; border-left: 3px solid #9b59b6;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                <span style="font-weight: bold; color: #333;">📺 Diffusion #<%= i %></span>
                                <span style="color: #666; font-size: 12px;">Tarif: <strong><%= String.format("%,.0f", coutUnitaire) %> Ar</strong></span>
                            </div>
                            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; font-size: 13px;">
                                <div style="background: #fef5e7; padding: 8px; border-radius: 4px; text-align: center;">
                                    <div style="color: #666; font-size: 11px;">Montant Dû</div>
                                    <div style="color: #f39c12; font-weight: bold;"><%= String.format("%,.0f", coutUnitaire) %> Ar</div>
                                </div>
                                <div style="background: #e8f8f5; padding: 8px; border-radius: 4px; text-align: center;">
                                    <div style="color: #666; font-size: 11px;">Payé (<%= String.format("%.1f", pourcentPaye) %>%)</div>
                                    <div style="color: #27ae60; font-weight: bold;"><%= String.format("%,.0f", payeParDiffusion) %> Ar</div>
                                </div>
                                <div style="background: #fdedec; padding: 8px; border-radius: 4px; text-align: center;">
                                    <div style="color: #666; font-size: 11px;">Reste à Payer</div>
                                    <div style="color: #e74c3c; font-weight: bold;"><%= String.format("%,.0f", resteParDiffusion) %> Ar</div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <!-- Total pour ce vol -->
                    <div style="background: #f0f0f0; padding: 10px 15px; border-radius: 6px; margin-top: 5px;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-weight: bold; color: #555;">📊 Total ce vol (<%= volDetail.getNbDiffusions() %> diffusion(s))</span>
                            <div style="display: flex; gap: 15px; font-size: 13px;">
                                <span style="color: #f39c12;">Dû: <strong><%= String.format("%,.0f", volDetail.getMontantDu().doubleValue()) %> Ar</strong></span>
                                <span style="color: #27ae60;">Payé: <strong><%= String.format("%,.0f", volDetail.getMontantPaye().doubleValue()) %> Ar</strong></span>
                                <span style="color: #e74c3c;">Reste: <strong><%= String.format("%,.0f", volDetail.getResteAPayer().doubleValue()) %> Ar</strong></span>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
                <% } else { %>
                <p style="color: #999; font-style: italic; margin-top: 15px;">Aucune diffusion affectée à un vol pour le moment.</p>
                <% } %>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="card">
            <div class="card-body">
                <div class="empty-state">
                    <div class="icon">📺</div>
                    <h3>Aucune diffusion</h3>
                    <p>Il n'y a pas encore d'achats de diffusion enregistrés</p>
                </div>
            </div>
        </div>
        <% } %>
    </main>
</div>
</body>
</html>
