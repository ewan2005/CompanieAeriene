<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Reservation" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passager - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/PassagerServlet" class="nav-link active"><span class="icon">👥</span> Passagers</a>
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
                <h1 class="page-title"><span class="icon">👥</span>
                    <% oo.Passager _passager = (oo.Passager) request.getAttribute("passager");
                       if (_passager != null && _passager.getIdPassager() > 0) { %>
                        Modifier Passager
                    <% } else { %>
                        Nouveau Passager
                    <% } %>
                </h1>
                <p class="page-subtitle">Remplissez les informations du passager</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Informations personnelles</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/PassagerServlet">
                    <% if (_passager != null && _passager.getIdPassager() > 0) { %>
                        <input type="hidden" name="action" value="update">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>
                    <input type="hidden" name="idPassager" value="<%= _passager != null ? _passager.getIdPassager() : 0 %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nom" class="form-control" value="${passager.nom}" placeholder="Nom de famille" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Prénom</label>
                            <input type="text" name="prenom" class="form-control" value="${passager.prenom}" placeholder="Prénom" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Numéro de Passeport</label>
                            <input type="text" name="numeroPasseport" class="form-control" value="${passager.numeroPasseport}" placeholder="AB123456">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nationalité</label>
                            <select name="nationalite" class="form-control">
                                <option value="">-- Sélectionner --</option>
                                <% String _nat = _passager != null ? _passager.getNationnalite() : null; %>
                                <option value="Française" <%= "Française".equals(_nat) ? "selected" : "" %>> Française</option>
                                <option value="Malgache" <%= "Malgache".equals(_nat) ? "selected" : "" %>> Malgache</option>
                                <option value="Américaine" <%= "Américaine".equals(_nat) ? "selected" : "" %>> Américaine</option>
                                <option value="Britannique" <%= "Britannique".equals(_nat) ? "selected" : "" %>> Britannique</option>
                                <option value="Allemande" <%= "Allemande".equals(_nat) ? "selected" : "" %>> Allemande</option>
                                <option value="Italienne" <%= "Italienne".equals(_nat) ? "selected" : "" %>> Italienne</option>
                                <option value="Espagnole" <%= "Espagnole".equals(_nat) ? "selected" : "" %>> Espagnole</option>
                                <option value="Autre" <%= "Autre".equals(_nat) ? "selected" : "" %>> Autre</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de Naissance</label>
                            <input type="date" name="dateNaissance" class="form-control" value="<%= (_passager != null && _passager.getDateNaissance() != null) ? _passager.getDateNaissance().toLocalDateTime().toLocalDate().toString() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Réservation</label>
                            <select name="idReservation" class="form-control" required>
                                <option value="">-- Sélectionner une réservation --</option>
                                <%
                                    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
                                    if (reservations != null) {
                                        for (Reservation r : reservations) {
                                            int selectedId = request.getAttribute("passager") != null ? ((oo.Passager)request.getAttribute("passager")).getIdReservation() : 0;
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

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"> Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/PassagerServlet" class="btn btn-secondary"> Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
