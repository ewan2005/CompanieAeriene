package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.CAParVol;
import oo.TarifDiffusion;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet pour afficher le Chiffre d'Affaires par vol.
 * Affiche un tableau avec:
 * - Aéroport départ / arrivée
 * - Avion
 * - Date et heure départ
 * - Montant généré par ticket vendu
 * - Montant généré par diffusion de publicité
 * - Montant CA total
 * - CA diffusion avec paiement (montant payé proportionnel)
 * - CA total avec paiement de diffusion
 * - Reste à payer par vol
 */
public class CAParVolServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Récupérer le CA de tous les vols
            List<CAParVol.CAVolDetail> caList = CAParVol.getCAParVol();
            
            // Calculer les totaux
            BigDecimal totalBillets = BigDecimal.ZERO;
            BigDecimal totalDiffusions = BigDecimal.ZERO;
            BigDecimal totalDiffusionsPaye = BigDecimal.ZERO;
            BigDecimal totalCA = BigDecimal.ZERO;
            BigDecimal totalCAAvecPaiement = BigDecimal.ZERO;
            BigDecimal totalResteAPayer = BigDecimal.ZERO;
            
            for (CAParVol.CAVolDetail ca : caList) {
                totalBillets = totalBillets.add(ca.getMontantBillets());
                totalDiffusions = totalDiffusions.add(ca.getMontantDiffusions());
                totalDiffusionsPaye = totalDiffusionsPaye.add(ca.getMontantDiffusionsPaye());
                totalCA = totalCA.add(ca.getMontantTotal());
                totalCAAvecPaiement = totalCAAvecPaiement.add(ca.getMontantTotalAvecPaiement());
                totalResteAPayer = totalResteAPayer.add(ca.getResteDiffusionsAPayer());
            }
            
            // Récupérer le tarif de diffusion actuel (pour info)
            BigDecimal tarifDiffusion = TarifDiffusion.getTarifActuel();
            
            request.setAttribute("caList", caList);
            request.setAttribute("totalBillets", totalBillets);
            request.setAttribute("totalDiffusions", totalDiffusions);
            request.setAttribute("totalDiffusionsPaye", totalDiffusionsPaye);
            request.setAttribute("totalCA", totalCA);
            request.setAttribute("totalCAAvecPaiement", totalCAAvecPaiement);
            request.setAttribute("totalResteAPayer", totalResteAPayer);
            request.setAttribute("tarifDiffusion", tarifDiffusion);
            
            request.getRequestDispatcher("caParVol.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Erreur lors du chargement du CA par vol: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Rediriger vers GET
        doGet(request, response);
    }
}
