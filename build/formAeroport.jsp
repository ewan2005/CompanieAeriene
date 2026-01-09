<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvel Aéroport - SkyWings Airlines</title>
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
                <a href="<%= request.getContextPath() %>/Accueil.jsp" class="nav-link">
                    <span class="icon">🏠</span> Accueil
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
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link">
                    <span class="icon">✈️</span> Avions
                </a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link active">
                    <span class="icon">🏢</span> Aéroports
                </a>
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
                <h1 class="page-title"><span class="icon">🏢</span>
                    <% oo.Aeroport _aeroport = (oo.Aeroport) request.getAttribute("aeroport");
                       if (_aeroport != null && _aeroport.getIdAeroport() > 0) { %>
                        Modifier Aéroport
                    <% } else { %>
                        Nouvel Aéroport
                    <% } %>
                </h1>
                <p class="page-subtitle">Remplissez les informations</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title"> Informations</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/AeroportServlet">
                    <% if (_aeroport != null && _aeroport.getIdAeroport() > 0) { %>
                        <input type="hidden" name="action" value="update">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>
                    <input type="hidden" name="idAeroport" value="<%= _aeroport != null ? _aeroport.getIdAeroport() : 0 %>">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nom" class="form-control" value="${aeroport.nom}" placeholder="Ex: Charles de Gaulle" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Code IATA</label>
                            <input type="text" name="code" class="form-control" value="${aeroport.code}" placeholder="Ex: CDG">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ville</label>
                        <input type="text" name="ville" class="form-control" value="${aeroport.ville}" placeholder="Ex: Paris">
                    </div>

                    <div style="display: flex; gap: 15px; margin-top: 20px;">
                        <button type="submit" class="btn btn-primary"> Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/AeroportServlet" class="btn btn-secondary"> Retour</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
