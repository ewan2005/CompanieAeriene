package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.DiffusionPaiement;
import oo.DiffusionPaiement.DiffusionPaiementDetail;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet pour afficher toutes les diffusions avec leurs paiements proportionnels
 */
@WebServlet("/DiffusionPaiementServlet")
public class DiffusionPaiementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Récupérer toutes les diffusions avec paiements
            List<DiffusionPaiementDetail> diffusions = DiffusionPaiement.getAllDiffusionsPaiements();
            
            // Récupérer les totaux
            BigDecimal[] totaux = DiffusionPaiement.getTotaux();
            
            request.setAttribute("diffusions", diffusions);
            request.setAttribute("totalDu", totaux[0]);
            request.setAttribute("totalPaye", totaux[1]);
            request.setAttribute("totalReste", totaux[2]);
            
            request.getRequestDispatcher("/listDiffusionPaiement.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors de la récupération des diffusions: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
