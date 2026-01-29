package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.ProduitExtra;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet pour la gestion des produits extra (CRUD)
 */
public class ProduitExtraServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "new":
                    request.getRequestDispatcher("formProduitExtra.jsp").forward(request, response);
                    break;
                case "edit":
                    int id = Integer.parseInt(request.getParameter("id"));
                    ProduitExtra produit = ProduitExtra.findById(id);
                    if (produit == null) {
                        request.setAttribute("error", "Produit introuvable");
                        response.sendRedirect(request.getContextPath() + "/ProduitExtraServlet");
                        return;
                    }
                    request.setAttribute("produit", produit);
                    request.getRequestDispatcher("formProduitExtra.jsp").forward(request, response);
                    break;
                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    ProduitExtra.delete(deleteId);
                    response.sendRedirect(request.getContextPath() + "/ProduitExtraServlet");
                    break;
                default: // list
                    List<ProduitExtra> produits = ProduitExtra.findAll();
                    request.setAttribute("produits", produits);
                    request.getRequestDispatcher("listProduitExtra.jsp").forward(request, response);
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
        
        String action = request.getParameter("action");
        if (action == null) action = "save";
        
        try {
            String idStr = request.getParameter("id");
            String nom = request.getParameter("nom");
            String prixStr = request.getParameter("prix");
            String description = request.getParameter("description");
            String actifStr = request.getParameter("actif");
            
            BigDecimal prix = new BigDecimal(prixStr);
            boolean actif = actifStr != null && (actifStr.equals("on") || actifStr.equals("true") || actifStr.equals("1"));
            
            if (idStr != null && !idStr.isEmpty()) {
                // Mise à jour
                ProduitExtra produit = ProduitExtra.findById(Integer.parseInt(idStr));
                if (produit != null) {
                    produit.setNom(nom);
                    produit.setPrix(prix);
                    produit.setDescription(description);
                    produit.setActif(actif);
                    produit.update();
                }
            } else {
                // Création
                ProduitExtra produit = new ProduitExtra(nom, prix, description);
                produit.setActif(actif);
                produit.save();
            }
            
            response.sendRedirect(request.getContextPath() + "/ProduitExtraServlet");
            
        } catch (SQLException e) {
            throw new ServletException("Erreur lors de l'enregistrement: " + e.getMessage(), e);
        }
    }
}
