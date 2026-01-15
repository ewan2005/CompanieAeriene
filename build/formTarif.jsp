<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Tarif - Skyfly Airlines</title>
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
                <div class="nav-section-title">Gestion</div>
                <a href="<%= request.getContextPath() %>/AvionServlet" class="nav-link"><span class="icon">✈️</span> Avions</a>
                <a href="<%= request.getContextPath() %>/AeroportServlet" class="nav-link"><span class="icon">🏢</span> Aéroports</a>
                <a href="<%= request.getContextPath() %>/TarifServlet" class="nav-link active"><span class="icon">💰</span> Tarifs</a>
                <a href="<%= request.getContextPath() %>/TarifServlet?action=edit&type=premiere_classe" class="nav-link"><span class="icon">✏️</span> Modifier tarif</a>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title">✏️ Modifier Tarif</h1>
                <p class="page-subtitle">Modifier le tarif pour une classe</p>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <form method="post" action="<%= request.getContextPath() %>/TarifServlet">
                    <input type="hidden" name="action" value="save" />
                    <div class="form-group">
                        <label class="form-label">Classe</label>
                        <input type="text" name="type_place" class="form-control" value="<%= request.getAttribute("type_place") != null ? request.getAttribute("type_place") : "" %>" readonly />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tarif (Ar)</label>
                        <input type="number" name="tarif" class="form-control" value="<%= request.getAttribute("tarif") != null ? ((java.math.BigDecimal)request.getAttribute("tarif")).longValue() : "" %>" required />
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                        <a href="<%= request.getContextPath() %>/TarifServlet" class="btn">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>