<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulaire Société - Skyfly Airlines</title>
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
                <a href="<%= request.getContextPath() %>/SocieteServlet" class="nav-link active"><span class="icon">🏛️</span> Sociétés</a>
                <a href="<%= request.getContextPath() %>/DiffusionServlet" class="nav-link"><span class="icon">📺</span> Diffusions</a>
                <a href="<%= request.getContextPath() %>/TarifDiffusionServlet" class="nav-link"><span class="icon">⚙️</span> Config Tarif Pub</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title"><span class="icon">🏛️</span>
                    <% oo.Societe _societe = (oo.Societe) request.getAttribute("societe");
                       if (_societe != null && _societe.getIdSociete() > 0) { %>
                        Modifier Société
                    <% } else { %>
                        Nouvelle Société
                    <% } %>
                </h1>
                <p class="page-subtitle">Remplissez les informations de la société</p>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Informations de la société</h3>
            </div>
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/SocieteServlet">
                    <% if (_societe != null && _societe.getIdSociete() > 0) { %>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="idSociete" value="<%= _societe.getIdSociete() %>">
                    <% } else { %>
                        <input type="hidden" name="action" value="create">
                    <% } %>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nom *</label>
                            <input type="text" name="nom" class="form-control" 
                                   value="<%= _societe != null ? _societe.getNom() : "" %>" 
                                   placeholder="Ex: Vaniala" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Téléphone</label>
                            <input type="text" name="telephone" class="form-control" 
                                   value="<%= _societe != null && _societe.getTelephone() != null ? _societe.getTelephone() : "" %>" 
                                   placeholder="Ex: 0341234567">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Adresse</label>
                        <input type="text" name="adresse" class="form-control" 
                               value="<%= _societe != null && _societe.getAdresse() != null ? _societe.getAdresse() : "" %>" 
                               placeholder="Ex: Antananarivo, Madagascar">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" 
                               value="<%= _societe != null && _societe.getEmail() != null ? _societe.getEmail() : "" %>" 
                               placeholder="Ex: contact@societe.mg">
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/SocieteServlet" class="btn">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>
