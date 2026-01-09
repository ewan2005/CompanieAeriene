<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - SkyWings Airlines</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            position: relative;
        }
        
        .login-container {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 420px;
            padding: 20px;
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
            backdrop-filter: blur(10px);
            animation: slideUp 0.6s ease-out;
            border: 1px solid rgba(255,255,255,0.2);
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .logo-icon {
            font-size: 60px;
            margin-bottom: 15px;
            display: inline-block;
            animation: bounce 2s ease-in-out infinite;
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        .logo-text {
            font-size: 28px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            letter-spacing: -0.5px;
        }
        
        .logo-subtitle {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
            font-weight: 500;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 16px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #fafbfc;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .btn-login {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .error-message {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #dc2626;
        }
        
        .footer-text {
            text-align: center;
            margin-top: 25px;
            color: #888;
            font-size: 13px;
        }
        
        .features {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .feature {
            text-align: center;
            font-size: 12px;
            color: #888;
        }
        
        .feature-icon {
            font-size: 24px;
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <div class="logo-section">
            <div class="logo-icon">✈️</div>
            <div class="logo-text">SkyWings Airlines</div>
            <div class="logo-subtitle">Système de gestion des vols</div>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            ⚠️ <%= request.getAttribute("error") %>
        </div>
        <% } %>
        
        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="form-group">
                <label class="form-label">📧 Identifiant</label>
                <input type="text" name="login" class="form-control" placeholder="Votre identifiant" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">🔒 Mot de passe</label>
                <input type="password" name="password" class="form-control" placeholder="Votre mot de passe" required>
            </div>
            
            <button type="submit" class="btn-login">🚀 Se connecter</button>
        </form>
        
        <div class="features">
            <div class="feature">
                <div class="feature-icon">🛡️</div>
                <div>Sécurisé</div>
            </div>
            <div class="feature">
                <div class="feature-icon">⚡</div>
                <div>Rapide</div>
            </div>
            <div class="feature">
                <div class="feature-icon">🌍</div>
                <div>Global</div>
            </div>
        </div>
        
        <div class="footer-text">
            © 2024 SkyWings Airlines - Tous droits réservés
        </div>
    </div>
</div>
</body>
</html>
