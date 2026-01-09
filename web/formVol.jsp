<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Avion" %>
<%@ page import="oo.Aeroport" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vol - SkyWings Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
</head>
<body>
<div class="app-container">
    <nav class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <span class="plane-icon">✈️</span>
                <h2>SkyWings</h2>
            </div>
        </div>
        <div class="sidebar-nav">
            <div class="nav-section">
                <div class="nav-section-title">Menu Principal</div>
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link"><span class="icon">🏠</span> Accueil</a>
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link active"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
                <a href="<%= request.getContextPath() %>/validation.jsp" class="nav-link"><span class="icon">✅</span> Validation</a>
                <a href="<%= request.getContextPath() %>/error.jsp" class="nav-link"><span class="icon">⚠️</span> Erreurs</a>
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
                <h1 class="page-title"><span class="icon">🛫</span>
                    <% oo.Vol _vol = (oo.Vol) request.getAttribute("vol");
                       if (_vol != null && _vol.getIdVol() > 0) { %>
                        Modifier Vol
                    <% } else { %>
                        Nouveau Vol
                    <% } %>
                </h1>
                <p class="page-subtitle">Remplissez les informations du vol</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Informations du vol</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/VolServlet">
                    <% if (_vol != null && _vol.getIdVol() > 0) { %>
                        <input type="hidden" name="action" value="update">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>
                    <input type="hidden" name="idVol" value="<%= _vol != null ? _vol.getIdVol() : 0 %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Numéro de Vol</label>
                            <input type="number" name="numeroVol" class="form-control" value="${vol.numeroVol}" placeholder="Ex: 1234">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Avion</label>
                            <select name="idAvion" class="form-control" required>
                                <option value="">-- Sélectionner un avion --</option>
                                <%
                                    List<Avion> avions = (List<Avion>) request.getAttribute("avions");
                                    if (avions != null) {
                                        for (Avion a : avions) {
                                            int selectedId = request.getAttribute("vol") != null ? ((oo.Vol)request.getAttribute("vol")).getIdAvion() : 0;
                                            String selected = (a.getIdAvion() == selectedId) ? "selected" : "";
                                %>
                                <option value="<%= a.getIdAvion() %>" <%= selected %>><%= a.getCode() %> - <%= a.getModel() %> (Capacité: <%= a.getCapacite() %>)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Aéroport de Départ</label>
                            <select name="idAeroportDepart" class="form-control" required>
                                <option value="">-- Sélectionner un aéroport --</option>
                                <%
                                    List<Aeroport> aeroports = (List<Aeroport>) request.getAttribute("aeroports");
                                    if (aeroports != null) {
                                        for (Aeroport ap : aeroports) {
                                            int selectedId = request.getAttribute("vol") != null ? ((oo.Vol)request.getAttribute("vol")).getIdAeroportDepart() : 0;
                                            String selected = (ap.getIdAeroport() == selectedId) ? "selected" : "";
                                %>
                                <option value="<%= ap.getIdAeroport() %>" <%= selected %>><%= ap.getCode() %> - <%= ap.getNom() %> (<%= ap.getVille() %>)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Aéroport d''Arrivée</label>
                            <select name="idAeroportArrive" class="form-control" required>
                                <option value="">-- Sélectionner un aéroport --</option>
                                <%
                                    if (aeroports != null) {
                                        for (Aeroport ap : aeroports) {
                                            int selectedId = request.getAttribute("vol") != null ? ((oo.Vol)request.getAttribute("vol")).getIdAeroportArrive() : 0;
                                            String selected = (ap.getIdAeroport() == selectedId) ? "selected" : "";
                                %>
                                <option value="<%= ap.getIdAeroport() %>" <%= selected %>><%= ap.getCode() %> - <%= ap.getNom() %> (<%= ap.getVille() %>)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de Départ</label>
                            <input type="date" name="dateDepart" class="form-control" value="${vol.dateDepart}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Date d''Arrivée</label>
                            <input type="date" name="dateArrive" class="form-control" value="${vol.dateArrive}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Heure de Départ</label>
                            <input type="time" name="heureDepart" class="form-control" value="${vol.heureDepart}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Heure d''Arrivée</label>
                            <input type="time" name="heureArrivee" class="form-control" value="${vol.heureArrivee}">
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"> Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/VolServlet" class="btn btn-secondary"> Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
