<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Affecter Diffusions - Skyfly Airlines</title>
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
            </div>
            <div class="nav-section">
                <div class="nav-section-title">Publicité</div>
                <a href="<%= request.getContextPath() %>/SocieteServlet" class="nav-link"><span class="icon">🏛️</span> Sociétés</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet" class="nav-link active"><span class="icon">📺</span> Achats Diffusions</a>
                <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="nav-link"><span class="icon">⚙️</span> Config Tarif Pub</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <%
            oo.AchatDiffusion achat = (oo.AchatDiffusion) request.getAttribute("achat");
            Integer diffRestantes = (Integer) request.getAttribute("diffusionsRestantes");
            if (diffRestantes == null) diffRestantes = 0;
        %>
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">🎯</span> Affecter les Diffusions aux Vols</h1>
                <p class="page-subtitle">
                    <%= achat.getSociete().getNom() %> - <%= achat.getPeriode() %>
                </p>
            </div>
        </div>

        <div class="card" style="margin-bottom: 20px;">
            <div class="card-body">
                <div style="display: flex; gap: 30px; flex-wrap: wrap;">
                    <div>
                        <strong>Société:</strong> <%= achat.getSociete().getNom() %>
                    </div>
                    <div>
                        <strong>Période:</strong> <%= achat.getPeriode() %>
                    </div>
                    <div>
                        <strong>Diffusions achetées:</strong> 
                        <span class="badge badge-primary"><%= achat.getNombreDiffusions() %></span>
                    </div>
                    <div>
                        <strong>Diffusions restantes:</strong> 
                        <span class="badge badge-warning"><%= diffRestantes %></span>
                    </div>
                </div>
            </div>
        </div>

        <% if (diffRestantes == 0) { %>
            <div class="card">
                <div class="card-body" style="text-align: center; padding: 40px;">
                    <h3>✅ Toutes les diffusions ont été affectées</h3>
                    <p>Les <%= achat.getNombreDiffusions() %> diffusions de <%= achat.getSociete().getNom() %> 
                       pour <%= achat.getPeriode() %> ont été affectées aux vols.</p>
                    <a href="<%= request.getContextPath() %>/DiffusionServlet" class="btn btn-primary">Retour à la liste</a>
                </div>
            </div>
        <% } else { %>
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Affecter des diffusions à un vol</h3>
                </div>
                <div class="card-body">
                    <form method="post" action="<%= request.getContextPath() %>/DiffusionServlet">
                        <input type="hidden" name="action" value="affecter">
                        <input type="hidden" name="idAchat" value="<%= achat.getIdAchat() %>">

                        <div class="form-group">
                            <label class="form-label">Vol *</label>
                            <select name="idVol" class="form-control" required>
                                <option value="">-- Sélectionner un vol --</option>
                                <%
                                    java.util.List vols = (java.util.List) request.getAttribute("vols");
                                    if (vols != null) {
                                        for (Object o : vols) {
                                            oo.Vol v = (oo.Vol) o;
                                %>
                                    <option value="<%= v.getIdVol() %>">
                                        <%= v.getNumeroVol() %> - <%= v.getDateDepart() %> 
                                        (<%= v.getHeureDepart() %> → <%= v.getHeureArrivee() %>)
                                    </option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <small style="color: #888;">Sélectionnez le vol sur lequel diffuser la publicité</small>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Nombre de diffusions à affecter *</label>
                            <input type="number" name="nombre" class="form-control" min="1" max="<%= diffRestantes %>"
                                   value="1" required>
                            <small style="color: #888;">Maximum: <%= diffRestantes %> diffusions restantes</small>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">🎯 Affecter au vol</button>
                            <a href="<%= request.getContextPath() %>/DiffusionServlet" class="btn">Retour</a>
                        </div>
                    </form>
                </div>
            </div>
        <% } %>
    </main>
</div>
</body>
</html>
