<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="oo.Paiement" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réservation - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link active"><span class="icon">📋</span> Réservations</a>
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
                <h1 class="page-title"><span class="icon">📋</span>
                    <% oo.Reservation _reservation = (oo.Reservation) request.getAttribute("reservation");
                       if (_reservation != null && _reservation.getIdReservation() > 0) { %>
                        Modifier Réservation
                    <% } else { %>
                        Nouvelle Réservation
                    <% } %>
                </h1>
                <p class="page-subtitle">Remplissez les informations de la réservation</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Informations de réservation</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/ReservationServlet">
                    <% if (_reservation != null && _reservation.getIdReservation() > 0) { %>
                        <input type="hidden" name="action" value="update">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>
                    <input type="hidden" name="idReservation" value="<%= _reservation != null ? _reservation.getIdReservation() : 0 %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Date de Réservation</label>
                            <input type="datetime-local" name="dateReservation" class="form-control" value="<%= (_reservation != null && _reservation.getDateReservation() != null) ? _reservation.getDateReservation().toLocalDateTime().toString() : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Paiement</label>
                            <select name="idPaiement" class="form-control">
                                <option value="">-- Aucun paiement --</option>
                                <%
                                    List<Paiement> paiements = (List<Paiement>) request.getAttribute("paiements");
                                    if (paiements != null) {
                                        for (Paiement p : paiements) {
                                            int selectedId = request.getAttribute("reservation") != null ? ((oo.Reservation)request.getAttribute("reservation")).getIdPaiement() : 0;
                                            String selected = (p.getIdPaiement() == selectedId) ? "selected" : "";
                                %>
                                <option value="<%= p.getIdPaiement() %>" <%= selected %>>Paiement #<%= p.getIdPaiement() %> - <%= p.getMontant() %> AR</option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Statut</label>
                            <select name="status" class="form-control">
                                <option value="true" <%= (_reservation != null && _reservation.isStatus()) ? "selected" : "" %>> Confirmée</option>
                                <option value="false" <%= (_reservation == null || !_reservation.isStatus()) ? "selected" : "" %>> En attente</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Nouveau paiement (optionnel) - Montant (AR)</label>
                            <input type="number" step="0.01" min="0.01" name="montant" class="form-control" placeholder="Ex: 150.00">
                            <small style="color: #666; font-size: 12px;">
                                Si un paiement est choisi dans la liste, ce montant est ignoré. Sinon, saisir un montant crée un nouveau paiement. Laisser vide = réservation sans paiement.
                            </small>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"> Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/ReservationServlet" class="btn btn-secondary"> Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
