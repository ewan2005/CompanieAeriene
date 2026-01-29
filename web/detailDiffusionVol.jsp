<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Diffusions Vol - Skyfly Airlines</title>
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
            oo.Vol vol = (oo.Vol) request.getAttribute("vol");
        %>
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">📺</span> Diffusions Publicitaires</h1>
                <p class="page-subtitle">
                    Vol <%= vol != null ? vol.getNumeroVol() : "" %> - <%= vol != null ? vol.getDateDepart() : "" %>
                </p>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/DiffusionServlet?action=ca" class="btn">← Retour au CA</a>
            </div>
        </div>

        <% if (vol != null) { %>
        <div class="card" style="margin-bottom: 20px;">
            <div class="card-body">
                <div style="display: flex; gap: 30px; flex-wrap: wrap;">
                    <div>
                        <strong>Vol:</strong> <%= vol.getNumeroVol() %>
                    </div>
                    <div>
                        <strong>Date:</strong> <%= vol.getDateDepart() %>
                    </div>
                    <div>
                        <strong>Horaires:</strong> <%= vol.getHeureDepart() %> → <%= vol.getHeureArrivee() %>
                    </div>
                    <div>
                        <strong>Avion:</strong> 
                        <% 
                            oo.Avion avion = null;
                            try { avion = oo.Avion.findById(vol.getIdAvion()); } catch (Exception e) {}
                        %>
                        <%= avion != null ? avion.getCode() + " (" + avion.getModel() + ")" : "-" %>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">🎬 Publicités diffusées pendant ce vol</h3>
            </div>
            <div class="card-body">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Société</th>
                            <th>Nb Diffusions</th>
                            <th>Contact</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List<Object[]> diffusions = (java.util.List<Object[]>) request.getAttribute("diffusions");
                            if (diffusions != null && !diffusions.isEmpty()) {
                                for (Object[] row : diffusions) {
                                    // row: nomSociete, nbDiffusions, contact
                        %>
                            <tr>
                                <td><strong><%= row[0] %></strong></td>
                                <td><span class="badge badge-success"><%= row[1] %></span></td>
                                <td><%= row[2] != null ? row[2] : "-" %></td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="3" style="text-align:center;">Aucune publicité diffusée sur ce vol.</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
</body>
</html>
