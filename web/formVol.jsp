<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Avion" %>
<%@ page import="oo.Trajet" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vol - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link active"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link"><span class="icon">🎫</span> Billets</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                    <a href="<%= request.getContextPath() %>/TrajetServlet?action=new" class="nav-link"><span class="icon">➕</span> Nouveau trajet</a>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/PaiementServlet" class="nav-link"><span class="icon">💳</span> Paiements</a>
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
                <p class="page-subtitle">Un vol associe un trajet (itinéraire) à un avion avec des dates/heures</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">📝 Informations du vol</h3>
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
                            <label class="form-label">🔢 Numéro de Vol</label>
                            <input type="number" name="numeroVol" class="form-control" 
                                   value="<%= _vol != null && _vol.getNumeroVol() != null ? _vol.getNumeroVol() : "" %>" 
                                   placeholder="Ex: 1234">
                        </div>
                        <div class="form-group">
                            <label class="form-label">🗺️ Trajet (Itinéraire)</label>
                            <select name="idTrajet" class="form-control" required>
                                <option value="">-- Sélectionner un trajet --</option>
                                <%
                                    List<Trajet.TrajetDetail> trajets = (List<Trajet.TrajetDetail>) request.getAttribute("trajets");
                                    int selectedTrajetId = _vol != null ? _vol.getIdTrajet() : 0;
                                    if (trajets != null) {
                                        for (Trajet.TrajetDetail t : trajets) {
                                            String selected = (t.getIdTrajet() == selectedTrajetId) ? "selected" : "";
                                %>
                                <option value="<%= t.getIdTrajet() %>" <%= selected %>>
                                    <%= t.getDepartVille() %> (<%= t.getDepartCode() %>) → <%= t.getArriveVille() %> (<%= t.getArriveCode() %>)
                                </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <small style="color:#666;">Définissez d'abord les trajets dans le menu Trajets</small>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">✈️ Avion</label>
                            <select name="idAvion" class="form-control" required>
                                <option value="">-- Sélectionner un avion --</option>
                                <%
                                    List<Avion> avions = (List<Avion>) request.getAttribute("avions");
                                    int selectedAvionId = _vol != null ? _vol.getIdAvion() : 0;
                                    if (avions != null) {
                                        for (Avion a : avions) {
                                            String selected = (a.getIdAvion() == selectedAvionId) ? "selected" : "";
                                %>
                                <option value="<%= a.getIdAvion() %>" <%= selected %>>
                                    <%= a.getCode() %> - <%= a.getModel() %> (Capacité: <%= a.getCapacite() %> places)
                                </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">📅 Date de Départ</label>
                            <input type="date" name="dateDepart" class="form-control" 
                                   value="<%= _vol != null && _vol.getDateDepart() != null ? _vol.getDateDepart().toLocalDateTime().toLocalDate() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">📅 Date d'Arrivée</label>
                            <input type="date" name="dateArrive" class="form-control" 
                                   value="<%= _vol != null && _vol.getDateArrive() != null ? _vol.getDateArrive().toLocalDateTime().toLocalDate() : "" %>">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">🕐 Heure de Départ</label>
                            <input type="time" name="heureDepart" class="form-control" 
                                   value="<%= _vol != null && _vol.getHeureDepart() != null ? _vol.getHeureDepart().toString().substring(0,5) : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">🕐 Heure d'Arrivée</label>
                            <input type="time" name="heureArrivee" class="form-control" 
                                   value="<%= _vol != null && _vol.getHeureArrivee() != null ? _vol.getHeureArrivee().toString().substring(0,5) : "" %>">
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/VolServlet" class="btn btn-secondary">↩️ Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
