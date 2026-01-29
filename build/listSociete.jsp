<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Sociétés - Skyfly Airlines</title>
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
                <h1 class="page-title"><span class="icon">🏛️</span> Sociétés Publicitaires</h1>
                <p class="page-subtitle">Gérez les sociétés qui diffusent des publicités</p>
            </div>
            <a href="<%= request.getContextPath() %>/SocieteServlet?action=new" class="btn btn-primary">➕ Nouvelle Société</a>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Liste des sociétés</h3>
            </div>
            <div class="card-body">
                <div class="filter-bar">
                    <input type="search" id="filterInput" class="form-control" placeholder="🔎 Rechercher..." autocomplete="off">
                </div>
                <div class="table-container">
                    <table class="table" id="listTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nom</th>
                                <th>Adresse</th>
                                <th>Téléphone</th>
                                <th>Email</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            java.util.List societes = (java.util.List) request.getAttribute("societes");
                            if (societes != null && !societes.isEmpty()) {
                                for (Object o : societes) {
                                    oo.Societe s = (oo.Societe) o;
                        %>
                            <tr>
                                <td><span class="badge badge-info">#<%= s.getIdSociete() %></span></td>
                                <td><strong><%= s.getNom() %></strong></td>
                                <td><%= s.getAdresse() != null ? s.getAdresse() : "-" %></td>
                                <td><%= s.getTelephone() != null ? s.getTelephone() : "-" %></td>
                                <td><%= s.getEmail() != null ? s.getEmail() : "-" %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/SocieteServlet?action=edit&id=<%= s.getIdSociete() %>" class="btn btn-sm btn-primary">✏️</a>
                                    <form method="post" action="<%= request.getContextPath() %>/SocieteServlet" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= s.getIdSociete() %>">
                                        <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Supprimer cette société ?')">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="6" style="text-align:center;">Aucune société trouvée.</td></tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</div>
<script src="<%= request.getContextPath() %>/js/list-filter.js"></script>
</body>
</html>
