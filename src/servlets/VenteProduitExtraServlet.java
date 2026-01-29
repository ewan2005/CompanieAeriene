package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.ProduitExtra;
import oo.VenteProduitExtra;
import oo.Vol;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

/**
 * Servlet pour la gestion des ventes de produits extra
 */
public class VenteProduitExtraServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "new":
                    // Charger la liste des produits et des vols pour le formulaire
                    List<ProduitExtra> produits = ProduitExtra.findAllActifs();
                    List<Vol> vols = Vol.findAll();
                    request.setAttribute("produits", produits);
                    request.setAttribute("vols", vols);
                    request.getRequestDispatcher("formVenteProduitExtra.jsp").forward(request, response);
                    break;
                case "edit":
                    int id = Integer.parseInt(request.getParameter("id"));
                    VenteProduitExtra vente = VenteProduitExtra.findById(id);
                    if (vente == null) {
                        request.setAttribute("error", "Vente introuvable");
                        response.sendRedirect(request.getContextPath() + "/VenteProduitExtraServlet");
                        return;
                    }
                    request.setAttribute("vente", vente);
                    request.setAttribute("produits", ProduitExtra.findAllActifs());
                    request.setAttribute("vols", Vol.findAll());
                    request.getRequestDispatcher("formVenteProduitExtra.jsp").forward(request, response);
                    break;
                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    VenteProduitExtra.delete(deleteId);
                    response.sendRedirect(request.getContextPath() + "/VenteProduitExtraServlet");
                    break;
                case "byVol":
                    int idVol = Integer.parseInt(request.getParameter("idVol"));
                    List<VenteProduitExtra> ventesVol = VenteProduitExtra.findByVol(idVol);
                    request.setAttribute("ventes", ventesVol);
                    request.setAttribute("idVolFiltre", idVol);
                    request.getRequestDispatcher("listVenteProduitExtra.jsp").forward(request, response);
                    break;
                default: // list
                    List<VenteProduitExtra> ventes = VenteProduitExtra.findAll();
                    request.setAttribute("ventes", ventes);
                    request.getRequestDispatcher("listVenteProduitExtra.jsp").forward(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Erreur base de données: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            String idStr = request.getParameter("id");
            int idProduit = Integer.parseInt(request.getParameter("idProduit"));
            int idVol = Integer.parseInt(request.getParameter("idVol"));
            int quantite = Integer.parseInt(request.getParameter("quantite"));
            
            // Récupérer le prix unitaire du produit
            ProduitExtra produit = ProduitExtra.findById(idProduit);
            if (produit == null) {
                throw new ServletException("Produit introuvable");
            }
            BigDecimal prixUnitaire = produit.getPrix();
            
            // Permettre de surcharger le prix si spécifié
            String prixStr = request.getParameter("prixUnitaire");
            if (prixStr != null && !prixStr.trim().isEmpty()) {
                prixUnitaire = new BigDecimal(prixStr);
            }
            
            if (idStr != null && !idStr.isEmpty()) {
                // Mise à jour
                VenteProduitExtra vente = VenteProduitExtra.findById(Integer.parseInt(idStr));
                if (vente != null) {
                    vente.setIdProduit(idProduit);
                    vente.setIdVol(idVol);
                    vente.setQuantite(quantite);
                    vente.setPrixUnitaire(prixUnitaire);
                    vente.update();
                }
            } else {
                // Création
                VenteProduitExtra vente = new VenteProduitExtra(idProduit, idVol, quantite, prixUnitaire);
                vente.save();
            }
            
            response.sendRedirect(request.getContextPath() + "/VenteProduitExtraServlet");
            
        } catch (SQLException e) {
            throw new ServletException("Erreur lors de l'enregistrement: " + e.getMessage(), e);
        }
    }
}
