package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.TarifDiffusion;
import utils.Web;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public class TarifDiffusionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                TarifDiffusion t = TarifDiffusion.findById(id);
                request.setAttribute("tarifDiffusion", t);
                request.getRequestDispatcher("formTarifDiffusion.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("tarifActuel", TarifDiffusion.getTarifActuel());
                request.getRequestDispatcher("formTarifDiffusion.jsp").forward(request, response);
            } else {
                // Liste des tarifs de diffusion
                List<TarifDiffusion> tarifs = TarifDiffusion.findAll();
                request.setAttribute("tarifs", tarifs);
                request.setAttribute("tarifActuel", TarifDiffusion.getTarifActuel());
                request.getRequestDispatcher("listTarifDiffusion.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                TarifDiffusion t = new TarifDiffusion();
                t.setCoutParDiffusion(new BigDecimal(request.getParameter("coutParDiffusion")));
                t.setDateDebut(Date.valueOf(request.getParameter("dateDebut")));
                
                String dateFinStr = request.getParameter("dateFin");
                if (dateFinStr != null && !dateFinStr.isEmpty()) {
                    t.setDateFin(Date.valueOf(dateFinStr));
                }
                
                t.save();
                Web.redirectValidation(request, response, "Tarif de diffusion créé avec succès.", "/TarifDiffusionServlet");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idTarif"));
                TarifDiffusion t = TarifDiffusion.findById(id);
                if (t != null) {
                    t.setCoutParDiffusion(new BigDecimal(request.getParameter("coutParDiffusion")));
                    t.setDateDebut(Date.valueOf(request.getParameter("dateDebut")));
                    
                    String dateFinStr = request.getParameter("dateFin");
                    if (dateFinStr != null && !dateFinStr.isEmpty()) {
                        t.setDateFin(Date.valueOf(dateFinStr));
                    } else {
                        t.setDateFin(null);
                    }
                    
                    t.update();
                    Web.redirectValidation(request, response, "Tarif de diffusion modifié avec succès.", "/TarifDiffusionServlet");
                } else {
                    Web.redirectError(request, response, "Tarif introuvable.", "/TarifDiffusionServlet");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                TarifDiffusion t = TarifDiffusion.findById(id);
                if (t != null) {
                    t.delete();
                    Web.redirectValidation(request, response, "Tarif de diffusion supprimé avec succès.", "/TarifDiffusionServlet");
                } else {
                    Web.redirectError(request, response, "Tarif introuvable.", "/TarifDiffusionServlet");
                }
            } else {
                Web.redirectValidation(request, response, "Opération terminée.", "/TarifDiffusionServlet");
            }
        } catch (SQLException e) {
            Web.redirectError(request, response, e.getMessage(), "/TarifDiffusionServlet");
        }
    }
}
