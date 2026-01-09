<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Vol" %>
<%@ page import="oo.Reservation" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billet - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link"><span class="icon">👥</span> Passagers</a>
                <a href="<%= request.getContextPath() %>/BilletServlet" class="nav-link active"><span class="icon">🎫</span> Billets</a>
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
                <h1 class="page-title"><span class="icon">🎫</span>
                    <% oo.Billet _billet = (oo.Billet) request.getAttribute("billet");
                       if (_billet != null && _billet.getIdBillet() > 0) { %>
                        Modifier Billet
                    <% } else { %>
                        Nouveau Billet
                    <% } %>
                </h1>
                <p class="page-subtitle">Remplissez les informations du billet</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Informations du billet</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/BilletServlet">
                    <% if (_billet != null && _billet.getIdBillet() > 0) { %>
                        <input type="hidden" name="action" value="update">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>
                    <input type="hidden" name="idBillet" value="<%= _billet != null ? _billet.getIdBillet() : 0 %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Vol</label>
                            <select name="idVol" class="form-control" required>
                                <option value="">-- Sélectionner un vol --</option>
                                <%
                                    List<Vol> vols = (List<Vol>) request.getAttribute("vols");
                                    if (vols != null) {
                                        for (Vol v : vols) {
                                            int selectedId = request.getAttribute("billet") != null ? ((oo.Billet)request.getAttribute("billet")).getIdVol() : 0;
                                            String selected = (v.getIdVol() == selectedId) ? "selected" : "";
                                %>
                                <option value="<%= v.getIdVol() %>" <%= selected %>>Vol #<%= v.getNumeroVol() %> (ID: <%= v.getIdVol() %>)</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Réservation</label>
                            <select name="idReservation" class="form-control" required>
                                <option value="">-- Sélectionner une réservation --</option>
                                <%
                                    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
                                    if (reservations != null) {
                                        for (Reservation r : reservations) {
                                            int selectedId = request.getAttribute("billet") != null ? ((oo.Billet)request.getAttribute("billet")).getIdReservation() : 0;
                                            String selected = (r.getIdReservation() == selectedId) ? "selected" : "";
                                            String status = r.isStatus() ? "Confirmée" : "En attente";
                                %>
                                <option value="<%= r.getIdReservation() %>" <%= selected %>>Réservation #<%= r.getIdReservation() %> - <%= status %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Classe</label>
                            <% String _classe = _billet != null ? _billet.getClasse() : null; %>
                            <select name="classe" class="form-control" required>
                                <option value="Economique" <%= "Economique".equals(_classe) ? "selected" : "" %>> Économique</option>
                                <option value="Business" <%= "Business".equals(_classe) ? "selected" : "" %>> Business</option>
                                <option value="Premiere" <%= "Premiere".equals(_classe) ? "selected" : "" %>> Première Classe</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Prix (AR)</label>
                            <input type="number" step="0.01" name="prix" class="form-control" value="${billet.prix}" placeholder="0.00" required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"> Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/BilletServlet" class="btn btn-secondary"> Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
