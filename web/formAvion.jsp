<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvel Avion - SkyWings Airlines</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/airline.css">
</head>
<body>
<div class="flying-plane"></div>

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
                <a href="<%= request.getContextPath() %>/VolServlet" class="nav-link"><span class="icon">🛫</span> Vols</a>
                <a href="<%= request.getContextPath() %>/ReservationServlet" class="nav-link"><span class="icon">📋</span> Réservations</a>
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link active"><span class="icon">✈️</span> Avions</a>
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
                <h1 class="page-title"><span class="icon">✈️</span>
                    <% oo.Avion _avion = (oo.Avion) request.getAttribute("avion");
                       if (_avion != null && _avion.getIdAvion() > 0) { %>
                        Modifier Avion
                    <% } else { %>
                        Nouvel Avion
                    <% } %>
                </h1>
                <p class="page-subtitle">Remplissez les informations de l avion</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Informations de l avion</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/AvionServlet">
                    <% if (_avion != null && _avion.getIdAvion() > 0) { %>
                        <input type="hidden" name="action" value="update">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>
                    <input type="hidden" name="idAvion" value="<%= _avion != null ? _avion.getIdAvion() : 0 %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Modèle</label>
                            <input type="text" name="model" class="form-control" value="${avion.model}" placeholder="Ex: Boeing 737" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Code</label>
                            <input type="text" name="code" class="form-control" value="${avion.code}" placeholder="Ex: B737">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Capacité</label>
                        <input type="text" name="capacite" class="form-control" value="${avion.capacite}" placeholder="Ex: 180">
                    </div>

                    <div style="display: flex; gap: 15px; margin-top: 20px;">
                        <button type="submit" class="btn btn-primary"> Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/AvionServlet" class="btn btn-secondary"> Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
