<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulaire Tarif Diffusion - Skyfly Airlines</title>
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
                <h1 class="page-title"><span class="icon">⚙️</span>
                    <% oo.TarifDiffusion _tarif = (oo.TarifDiffusion) request.getAttribute("tarifDiffusion");
                       if (_tarif != null && _tarif.getIdTarif() > 0) { %>
                        Modifier Tarif Diffusion
                    <% } else { %>
                        Nouveau Tarif Diffusion
                    <% } %>
                </h1>
                <p class="page-subtitle">Configurez le coût par diffusion publicitaire</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Configuration du tarif</h3>
            </div>
            <div class="card-body">
                <%
                    java.math.BigDecimal tarifActuel = (java.math.BigDecimal) request.getAttribute("tarifActuel");
                    if (tarifActuel == null) tarifActuel = new java.math.BigDecimal("400000");
                %>
                <% if (_tarif == null || _tarif.getIdTarif() == 0) { %>
                <div class="alert alert-info" style="background: #e3f2fd; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <strong>ℹ️ Info:</strong> Le tarif actuel est de <strong><%= String.format("%,.0f", tarifActuel.doubleValue()) %> Ar</strong> par diffusion.
                </div>
                <% } %>

                <form method="post" action="<%= request.getContextPath() %>/TarifDiffusionServlet">
                    <% if (_tarif != null && _tarif.getIdTarif() > 0) { %>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="idTarif" value="<%= _tarif.getIdTarif() %>">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>

                    <div class="form-group">
                        <label class="form-label">Coût par diffusion (Ar) *</label>
                        <input type="number" name="coutParDiffusion" class="form-control" 
                               value="<%= _tarif != null ? _tarif.getCoutParDiffusion().longValue() : 400000 %>" 
                               placeholder="Ex: 400000" required min="0">
                        <small style="color: #888;">Montant en Ariary facturé pour chaque diffusion de vidéo publicitaire</small>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de début *</label>
                            <input type="date" name="dateDebut" class="form-control" 
                                   value="<%= _tarif != null && _tarif.getDateDebut() != null ? _tarif.getDateDebut() : "" %>" required>
                            <small style="color: #888;">Date à partir de laquelle ce tarif s'applique</small>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Date de fin (optionnel)</label>
                            <input type="date" name="dateFin" class="form-control" 
                                   value="<%= _tarif != null && _tarif.getDateFin() != null ? _tarif.getDateFin() : "" %>">
                            <small style="color: #888;">Laissez vide si le tarif est toujours actif</small>
                        </div>
                    </div>

                    <div class="card" style="background: #fff3cd; margin-bottom: 20px;">
                        <div class="card-body">
                            <h4>⚠️ Important</h4>
                            <ul style="margin: 0; padding-left: 20px;">
                                <li>Le tarif avec la date de début la plus récente sera utilisé pour les nouvelles diffusions</li>
                                <li>Les diffusions existantes conservent leur tarif d'origine</li>
                                <li>Si aucun tarif n'est configuré, le tarif par défaut de 400 000 Ar sera utilisé</li>
                            </ul>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="btn">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
