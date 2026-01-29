<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.CAParVol" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chiffre d'Affaires par Vol - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link"><span class="icon">🏠</span> Accueil</a>
                <a href="<%= request.getContextPath() %>/TrajetServlet" class="nav-link"><span class="icon">🧭</span> Trajets</a>
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link"><span class="icon">➕</span> Nouveau trajet</a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Publicité</div>
                <a href="<%= request.getContextPath() %>/SocieteServlet" class="nav-link"><span class="icon">🏛️</span> Sociétés</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet" class="nav-link"><span class="icon">📺</span> Diffusions</a>
                <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="nav-link"><span class="icon">⚙️</span> Config Tarif Pub</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=ca" class="nav-link"><span class="icon">📊</span> CA Publicité</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Statistiques</div>
                <a href="<%= request.getContextPath() %>/CAParVolServlet" class="nav-link active"><span class="icon">📈</span> CA par Vol</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Compte</div>
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link"><span class="icon">🚪</span> Déconnexion</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <%
            List<CAParVol.CAVolDetail> caList = (List<CAParVol.CAVolDetail>) request.getAttribute("caList");
            BigDecimal totalBillets = (BigDecimal) request.getAttribute("totalBillets");
            BigDecimal totalDiffusions = (BigDecimal) request.getAttribute("totalDiffusions");
            BigDecimal totalDiffusionsPaye = (BigDecimal) request.getAttribute("totalDiffusionsPaye");
            BigDecimal totalCA = (BigDecimal) request.getAttribute("totalCA");
            BigDecimal totalCAAvecPaiement = (BigDecimal) request.getAttribute("totalCAAvecPaiement");
            BigDecimal totalResteAPayer = (BigDecimal) request.getAttribute("totalResteAPayer");
            BigDecimal tarifDiffusion = (BigDecimal) request.getAttribute("tarifDiffusion");
            
            if (totalBillets == null) totalBillets = BigDecimal.ZERO;
            if (totalDiffusions == null) totalDiffusions = BigDecimal.ZERO;
            if (totalDiffusionsPaye == null) totalDiffusionsPaye = BigDecimal.ZERO;
            if (totalCA == null) totalCA = BigDecimal.ZERO;
            if (totalCAAvecPaiement == null) totalCAAvecPaiement = BigDecimal.ZERO;
            if (totalResteAPayer == null) totalResteAPayer = BigDecimal.ZERO;
            if (tarifDiffusion == null) tarifDiffusion = new BigDecimal("400000");
        %>
        
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">📈</span> Chiffre d'Affaires par Vol</h1>
                <p class="page-subtitle">Vue globale des recettes par vol (billets + publicités avec paiements)</p>
            </div>
            <a href="<%= request.getContextPath() %>/Accueil.jsp" class="btn btn-secondary">Retour Accueil</a>
        </div>

        <!-- Cartes de synthèse -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 25px;">
            <div class="card" style="background: linear-gradient(135deg, #3498db, #2980b9);">
                <div class="card-body" style="text-align: center; padding: 20px; color: white;">
                    <h3 style="margin: 0; font-size: 14px; opacity: 0.9;">🎫 Total Billets</h3>
                    <p style="font-size: 24px; font-weight: bold; margin: 8px 0;">
                        <%= String.format("%,.0f", totalBillets.doubleValue()) %> Ar
                    </p>
                </div>
            </div>
            <div class="card" style="background: linear-gradient(135deg, #9b59b6, #8e44ad);">
                <div class="card-body" style="text-align: center; padding: 20px; color: white;">
                    <h3 style="margin: 0; font-size: 14px; opacity: 0.9;">📺 Total Diffusions Dû</h3>
                    <p style="font-size: 24px; font-weight: bold; margin: 8px 0;">
                        <%= String.format("%,.0f", totalDiffusions.doubleValue()) %> Ar
                    </p>
                </div>
            </div>
            <div class="card" style="background: linear-gradient(135deg, #1abc9c, #16a085);">
                <div class="card-body" style="text-align: center; padding: 20px; color: white;">
                    <h3 style="margin: 0; font-size: 14px; opacity: 0.9;">✅ Diffusions Payées</h3>
                    <p style="font-size: 24px; font-weight: bold; margin: 8px 0;">
                        <%= String.format("%,.0f", totalDiffusionsPaye.doubleValue()) %> Ar
                    </p>
                </div>
            </div>
            <div class="card" style="background: linear-gradient(135deg, #e74c3c, #c0392b);">
                <div class="card-body" style="text-align: center; padding: 20px; color: white;">
                    <h3 style="margin: 0; font-size: 14px; opacity: 0.9;">⏳ Reste à Payer</h3>
                    <p style="font-size: 24px; font-weight: bold; margin: 8px 0;">
                        <%= String.format("%,.0f", totalResteAPayer.doubleValue()) %> Ar
                    </p>
                </div>
            </div>
            <div class="card" style="background: linear-gradient(135deg, #f39c12, #e67e22);">
                <div class="card-body" style="text-align: center; padding: 20px; color: white;">
                    <h3 style="margin: 0; font-size: 14px; opacity: 0.9;">💰 CA Total (Dû)</h3>
                    <p style="font-size: 24px; font-weight: bold; margin: 8px 0;">
                        <%= String.format("%,.0f", totalCA.doubleValue()) %> Ar
                    </p>
                </div>
            </div>
            <div class="card" style="background: linear-gradient(135deg, #27ae60, #2ecc71);">
                <div class="card-body" style="text-align: center; padding: 20px; color: white;">
                    <h3 style="margin: 0; font-size: 14px; opacity: 0.9;">💵 CA Réel (Payé)</h3>
                    <p style="font-size: 24px; font-weight: bold; margin: 8px 0;">
                        <%= String.format("%,.0f", totalCAAvecPaiement.doubleValue()) %> Ar
                    </p>
                </div>
            </div>
        </div>

        <!-- Info tarifs et règles -->
        <div class="card" style="margin-bottom: 20px; background: #f8f9fa;">
            <div class="card-body" style="padding: 15px;">
                <p style="margin: 0 0 10px 0; color: #666;">
                    <strong>📌 Rappel:</strong> 
                    Billet adulte économique = <strong>800 000 Ar</strong> | 
                    Tarif diffusion pub = <strong><%= String.format("%,.0f", tarifDiffusion.doubleValue()) %> Ar</strong> par diffusion
                </p>
                <p style="margin: 0; color: #666; font-size: 13px;">
                    <strong>📋 Règle de paiement:</strong> 
                    Les paiements des sociétés sont répartis proportionnellement sur tous les vols.<br>
                    Exemple: Si une société a payé 4% de son total dû, chaque vol reçoit 4% du montant de ses diffusions.
                </p>
            </div>
        </div>

        <!-- Tableau principal -->
        <div class="card">
            <div class="card-header" style="background: linear-gradient(135deg, #2c3e50, #34495e);">
                <h3 class="card-title" style="color: white;">📊 Détail du Chiffre d'Affaires par Vol</h3>
            </div>
            <div class="card-body">
                <div class="filter-bar">
                    <select id="filterColumn" class="form-control">
                        <option value="-1">Toutes les colonnes</option>
                    </select>
                    <input type="search" id="filterInput" class="form-control" placeholder="🔎 Rechercher..." autocomplete="off">
                </div>
                <div class="table-container" style="overflow-x: auto;">
                    <table class="table" id="listTable">
                        <thead>
                            <tr style="background: #34495e; color: white;">
                                <th>Aéroport Départ</th>
                                <th>Aéroport Arrivée</th>
                                <th>Avion</th>
                                <th>Date Départ</th>
                                <th>Heure Départ</th>
                                <th style="text-align: right;">Montant Tickets</th>
                                <th style="text-align: right;">Montant Pub (Dû)</th>
                                <th style="text-align: right; background: #f39c12;">CA Total (Dû)</th>
                                <th style="text-align: right; background: #1abc9c;">CA Pub Payé</th>
                                <th style="text-align: right; background: #27ae60;">CA Total Payé</th>
                                <th style="text-align: right; background: #e74c3c;">Reste à Payer</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (caList != null && !caList.isEmpty()) {
                                for (CAParVol.CAVolDetail ca : caList) {
                        %>
                            <tr>
                                <td>
                                    <div>
                                        🛫 <strong><%= ca.getAeroportDepart() %></strong>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        🛬 <strong><%= ca.getAeroportArrive() %></strong>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <strong><%= ca.getAvionCode() %></strong><br>
                                        <small style="color: #666;"><%= ca.getAvionModele() %></small>
                                    </div>
                                </td>
                                <td>📅 <%= ca.getDateDepart() != null ? ca.getDateDepart().toString() : "-" %></td>
                                <td>🕐 <%= ca.getHeureDepart() != null ? ca.getHeureDepart().toString().substring(0,5) : "-" %></td>
                                <td style="text-align: right;">
                                    <div>
                                        <strong style="color: #3498db;"><%= String.format("%,.0f", ca.getMontantBillets().doubleValue()) %> Ar</strong><br>
                                        <small style="color: #666;"><%= ca.getNbBillets() %> billet(s)</small>
                                    </div>
                                </td>
                                <td style="text-align: right;">
                                    <div>
                                        <strong style="color: #9b59b6;"><%= String.format("%,.0f", ca.getMontantDiffusions().doubleValue()) %> Ar</strong><br>
                                        <small style="color: #666;"><%= ca.getDetailDiffusions() %></small>
                                    </div>
                                </td>
                                <td style="text-align: right; background: #fef5e7;">
                                    <strong style="color: #f39c12; font-size: 14px;">
                                        <%= String.format("%,.0f", ca.getMontantTotal().doubleValue()) %> Ar
                                    </strong>
                                </td>
                                <td style="text-align: right; background: #e8f8f5;">
                                    <strong style="color: #1abc9c; font-size: 14px;">
                                        <%= String.format("%,.0f", ca.getMontantDiffusionsPaye().doubleValue()) %> Ar
                                    </strong>
                                </td>
                                <td style="text-align: right; background: #e8f8f0;">
                                    <strong style="color: #27ae60; font-size: 14px;">
                                        <%= String.format("%,.0f", ca.getMontantTotalAvecPaiement().doubleValue()) %> Ar
                                    </strong>
                                </td>
                                <td style="text-align: right; background: #fdedec;">
                                    <strong style="color: #e74c3c; font-size: 14px;">
                                        <%= String.format("%,.0f", ca.getResteDiffusionsAPayer().doubleValue()) %> Ar
                                    </strong>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="11">
                                    <div class="empty-state">
                                        <div class="icon">📊</div>
                                        <h3>Aucun vol disponible</h3>
                                        <p>Il n'y a pas encore de vols pour calculer le chiffre d'affaires</p>
                                        <a href="<%= request.getContextPath() %>/VolServlet?action=new" class="btn btn-primary">Créer un vol</a>
                                    </div>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                        <% if (caList != null && !caList.isEmpty()) { %>
                        <tfoot>
                            <tr style="background: #2c3e50; color: white; font-weight: bold;">
                                <td colspan="5" style="text-align: right;">TOTAUX :</td>
                                <td style="text-align: right;"><%= String.format("%,.0f", totalBillets.doubleValue()) %> Ar</td>
                                <td style="text-align: right;"><%= String.format("%,.0f", totalDiffusions.doubleValue()) %> Ar</td>
                                <td style="text-align: right; background: #f39c12;"><%= String.format("%,.0f", totalCA.doubleValue()) %> Ar</td>
                                <td style="text-align: right; background: #1abc9c;"><%= String.format("%,.0f", totalDiffusionsPaye.doubleValue()) %> Ar</td>
                                <td style="text-align: right; background: #27ae60;"><%= String.format("%,.0f", totalCAAvecPaiement.doubleValue()) %> Ar</td>
                                <td style="text-align: right; background: #e74c3c;"><%= String.format("%,.0f", totalResteAPayer.doubleValue()) %> Ar</td>
                            </tr>
                        </tfoot>
                        <% } %>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>
<script src="<%= request.getContextPath() %>/js/list-filter.js"></script>
</body>
</html>
