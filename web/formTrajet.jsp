<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Aeroport" %>
<%@ page import="oo.Trajet" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trajet - Skyfly Airlines</title>
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
                <%
                    Trajet trajet = (Trajet) request.getAttribute("trajet");
                    boolean editing = trajet != null && trajet.getIdTrajet() > 0;
                %>
                <h1 class="page-title"><span class="icon">🧭</span> <%= editing ? "Modifier Trajet" : "Nouveau Trajet" %></h1>
                <p class="page-subtitle">Définir une route (départ → arrivée)</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Informations du trajet</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/TrajetServlet">
                    <input type="hidden" name="action" value="<%= editing ? "update" : "create" %>">
                    <input type="hidden" name="idTrajet" value="<%= editing ? trajet.getIdTrajet() : 0 %>">

                    <%
                        List<Aeroport> aeroports = (List<Aeroport>) request.getAttribute("aeroports");
                    %>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Aéroport départ</label>
                            <select name="idAeroportDepart" class="form-control" required>
                                <option value="">-- Choisir --</option>
                                <%
                                    if (aeroports != null) {
                                        for (Aeroport a : aeroports) {
                                            String sel = (editing && a.getIdAeroport() == trajet.getIdAeroportDepart()) ? "selected" : "";
                                %>
                                <option value="<%= a.getIdAeroport() %>" <%= sel %>><%= a.getCode() %> - <%= a.getVille() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Aéroport arrivée</label>
                            <select name="idAeroportArrive" class="form-control" required>
                                <option value="">-- Choisir --</option>
                                <%
                                    if (aeroports != null) {
                                        for (Aeroport a : aeroports) {
                                            String sel = (editing && a.getIdAeroport() == trajet.getIdAeroportArrive()) ? "selected" : "";
                                %>
                                <option value="<%= a.getIdAeroport() %>" <%= sel %>><%= a.getCode() %> - <%= a.getVille() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/TrajetServlet" class="btn btn-secondary">Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
