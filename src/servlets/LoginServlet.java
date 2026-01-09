package servlets;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import oo.User;

public class LoginServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // The login form uses the field name "login" (see index.jsp). Read that here.
        String username = request.getParameter("login");
        String password = request.getParameter("password");
        
        try {
            User user = User.authenticate(username, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());

                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());
                
                request.getRequestDispatcher("Accueil.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Identifiants incorrects");
                // On authentication failure, forward back to the login page (index.jsp)
                request.setAttribute("error", "Identifiants incorrects");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            String userMessage = "Une erreur est survenue lors de la connexion à la base de données. Veuillez vérifier la configuration du serveur.";
            String cause = e.getMessage() != null ? e.getMessage() : "";
            // If the error indicates missing SCRAM password, provide a more precise hint
            if (cause.contains("SCRAM") || cause.toLowerCase().contains("password")) {
                userMessage = "Erreur de connexion à la base : le mot de passe DB est introuvable ou incorrect. Configurez la variable d'environnement DB_PASSWORD ou démarrez Tomcat avec -DDB_PASSWORD=<motdepasse>.";
            }
            request.setAttribute("error", userMessage);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}