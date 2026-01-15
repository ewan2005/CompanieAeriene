<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Avion - Skyfly Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
    <style>
        .detail-card {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border: 1px solid rgba(255,255,255,0.1);
        }
        .detail-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .plane-icon-large {
            font-size: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            border-radius: 15px;
        }
        .detail-title h2 {
            margin: 0;
            font-size: 28px;
            color: #fff;
        }
        .detail-title p {
            margin: 5px 0 0;
            color: #888;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card.premiere {
            border-left: 4px solid #ffd700;
        }
        .stat-card.economique {
            border-left: 4px solid #3498db;
        }
        .stat-card.total {
            border-left: 4px solid #2ecc71;
        }
        .stat-card.valeur {
            border-left: 4px solid #e74c3c;
            background: linear-gradient(135deg, rgba(231,76,60,0.2) 0%, rgba(231,76,60,0.1) 100%);
        }
        .stat-icon {
            font-size: 36px;
            margin-bottom: 10px;
        }
        .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #fff;
            margin: 10px 0;
        }
        .stat-label {
            color: #888;
            font-size: 14px;
        }
        .calculation-card {
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            padding: 25px;
            margin-top: 20px;
        }
        .calculation-title {
            font-size: 18px;
            color: #fff;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .price-inputs {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .price-input-group {
            background: rgba(255,255,255,0.03);
            padding: 15px;
            border-radius: 10px;
        }
        .price-input-group label {
            display: block;
            color: #888;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .price-input-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 8px;
            background: rgba(255,255,255,0.05);
            color: #fff;
            font-size: 16px;
        }
        .formula-box {
            background: rgba(102, 126, 234, 0.1);
            border: 1px solid rgba(102, 126, 234, 0.3);
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        .formula-text {
            font-family: monospace;
            font-size: 14px;
            color: #a0aec0;
            line-height: 1.8;
        }
        .formula-highlight {
            color: #667eea;
            font-weight: bold;
        }
        .result-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            margin-top: 20px;
        }
        .result-label {
            color: rgba(255,255,255,0.8);
            font-size: 16px;
            margin-bottom: 10px;
        }
        .result-value {
            font-size: 42px;
            font-weight: bold;
            color: #fff;
        }
        .result-currency {
            font-size: 24px;
            color: rgba(255,255,255,0.8);
        }
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
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link"><span class="icon">➕</span> Nouveau trajet</a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link active"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Compte</div>
                <a href="<%= request.getContextPath() %>/index.jsp" class="nav-link"><span class="icon">🚪</span> Déconnexion</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <%
            oo.Avion avion = (oo.Avion) request.getAttribute("avion");
            java.math.BigDecimal valeurMaximale = (java.math.BigDecimal) request.getAttribute("valeurMaximale");
            Integer nbPlacesPremiereClasse = (Integer) request.getAttribute("nbPlacesPremiereClasse");
            Integer nbPlacesEconomique = (Integer) request.getAttribute("nbPlacesEconomique");
            java.util.List places = (java.util.List) request.getAttribute("places");
            
            // Tarifs depuis la base de données
            java.math.BigDecimal tarifPremiereClasse = (java.math.BigDecimal) request.getAttribute("tarifPremiereClasse");
            java.math.BigDecimal tarifEconomique = (java.math.BigDecimal) request.getAttribute("tarifEconomique");
            java.math.BigDecimal tarifPremium = (java.math.BigDecimal) request.getAttribute("tarifPremium");
            Integer nbPlacesPremium = (Integer) request.getAttribute("nbPlacesPremium");
            
            if (nbPlacesPremiereClasse == null) nbPlacesPremiereClasse = 0;
            if (nbPlacesEconomique == null) nbPlacesEconomique = 0;
            if (nbPlacesPremium == null) nbPlacesPremium = 0;
            if (valeurMaximale == null) valeurMaximale = java.math.BigDecimal.ZERO;
            if (tarifPremiereClasse == null) tarifPremiereClasse = new java.math.BigDecimal("1200000");
            if (tarifEconomique == null) tarifEconomique = new java.math.BigDecimal("800000");
            if (tarifPremium == null) tarifPremium = new java.math.BigDecimal("1000000");
            
            int totalPlaces = nbPlacesPremiereClasse + nbPlacesEconomique + nbPlacesPremium;
            
            // Calcul des revenus par type
            java.math.BigDecimal revenuPremiereClasse = tarifPremiereClasse.multiply(new java.math.BigDecimal(nbPlacesPremiereClasse));
            java.math.BigDecimal revenuEconomique = tarifEconomique.multiply(new java.math.BigDecimal(nbPlacesEconomique));
            java.math.BigDecimal revenuPremium = tarifPremium.multiply(new java.math.BigDecimal(nbPlacesPremium));
            
            NumberFormat nf = NumberFormat.getInstance(Locale.FRANCE);
        %>
        
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">✈️</span> Détails de l'Avion</h1>
                <p class="page-subtitle">Informations complètes et valeur maximale par vol</p>
            </div>
            <a href="<%= request.getContextPath() %>/AvionServlet" class="btn btn-secondary">← Retour à la liste</a>
        </div>

        <% if (avion != null) { %>
        <div class="detail-card">
            <div class="detail-header">
                <div class="plane-icon-large">✈️</div>
                <div class="detail-title">
                    <h2><%= avion.getModel() != null ? avion.getModel() : "Avion" %></h2>
                    <p>Code: <strong><%= avion.getCode() != null ? avion.getCode() : "-" %></strong> | ID: #<%= avion.getIdAvion() %></p>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card premiere">
                    <div class="stat-icon">🥇</div>
                    <div class="stat-value"><%= nbPlacesPremiereClasse %></div>
                    <div class="stat-label">Places Première Classe</div>
                </div>                <div class="stat-card valeur">
                    <div class="stat-icon">🌟</div>
                    <div class="stat-value"><%= nbPlacesPremium %></div>
                    <div class="stat-label">Places Premium</div>
                </div>                <div class="stat-card economique">
                    <div class="stat-icon">💺</div>
                    <div class="stat-value"><%= nbPlacesEconomique %></div>
                    <div class="stat-label">Places Économique</div>
                </div>
                <div class="stat-card total">
                    <div class="stat-icon">📊</div>
                    <div class="stat-value"><%= totalPlaces %></div>
                    <div class="stat-label">Capacité Totale</div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">💰 Valeur Maximale par Vol (Tarifs Base de Données)</h3>
            </div>
            <div class="card-body">
                <div class="calculation-title">
                    📝 Tarifs enregistrés dans la base de données
                </div>
                
                <div class="price-inputs">
                    <div class="price-input-group">
                        <label>🥇 Tarif Première Classe (Ar)</label>
                        <input type="text" value="<%= nf.format(tarifPremiereClasse.longValue()) %> Ar" readonly style="background: rgba(255,215,0,0.1); border-color: #ffd700;">
                    </div>
                    <div class="price-input-group">
                        <label>💺 Tarif Économique (Ar)</label>
                        <input type="text" value="<%= nf.format(tarifEconomique.longValue()) %> Ar" readonly style="background: rgba(52,152,219,0.1); border-color: #3498db;">
                    </div>
                </div>

                <div class="formula-box">
                    <div class="calculation-title">📐 Formule de calcul</div>
                    <div class="formula-text">
                        <strong>Valeur Maximale</strong> = (Nb Places Première Classe × Tarif Première Classe) + (Nb Places Premium × Tarif Premium) + (Nb Places Économique × Tarif Économique)<br><br>
                        <span class="formula-highlight">Valeur Maximale</span> = (<%= nbPlacesPremiereClasse %> × <%= nf.format(tarifPremiereClasse.longValue()) %> Ar) + (<%= nbPlacesPremium %> × <%= nf.format(tarifPremium.longValue()) %> Ar) + (<%= nbPlacesEconomique %> × <%= nf.format(tarifEconomique.longValue()) %> Ar)<br>
                        <span class="formula-highlight">Valeur Maximale</span> = <%= nf.format(revenuPremiereClasse.longValue()) %> Ar + <%= nf.format(revenuPremium.longValue()) %> Ar + <%= nf.format(revenuEconomique.longValue()) %> Ar
                    </div>
                </div>

                <div class="result-box">
                    <div class="result-label">💎 Valeur Maximale que cet avion peut générer pour un vol</div>
                    <div class="result-value">
                        <%= nf.format(valeurMaximale.longValue()) %> <span class="result-currency">Ar</span>
                    </div>
                </div>

                <div class="stats-grid" style="margin-top: 25px;">
                    <div class="stat-card valeur">
                        <div class="stat-icon">🥇</div>
                        <div class="stat-value"><%= nf.format(revenuPremiereClasse.longValue()) %></div>
                        <div class="stat-label">Revenu Première Classe (Ar)</div>
                    </div>
                    <div class="stat-card valeur">
                        <div class="stat-icon">🌟</div>
                        <div class="stat-value"><%= nf.format(revenuPremium.longValue()) %></div>
                        <div class="stat-label">Revenu Premium (Ar)</div>
                    </div>
                    <div class="stat-card valeur">
                        <div class="stat-icon">💺</div>
                        <div class="stat-value"><%= nf.format(revenuEconomique.longValue()) %></div>
                        <div class="stat-label">Revenu Économique (Ar)</div>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="card">
            <div class="card-body">
                <div class="empty-state">
                    <div class="icon">⚠️</div>
                    <h3>Avion non trouvé</h3>
                    <p>L'avion demandé n'existe pas.</p>
                    <a href="<%= request.getContextPath() %>/AvionServlet" class="btn btn-primary">Retour à la liste</a>
                </div>
            </div>
        </div>
        <% } %>
    </main>
</div>
</body>
</html>
