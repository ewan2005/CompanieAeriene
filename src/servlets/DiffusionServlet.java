package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.AchatDiffusion;
import oo.DiffusionVol;
import oo.Societe;
import oo.Vol;
import oo.TarifDiffusion;
import utils.Web;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class DiffusionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("newAchat".equals(action)) {
                // Formulaire nouvel achat de diffusions
                request.setAttribute("societes", Societe.findAll());
                request.setAttribute("tarifActuel", TarifDiffusion.getTarifActuel());
                request.getRequestDispatcher("formAchatDiffusion.jsp").forward(request, response);
            } else if ("editAchat".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                AchatDiffusion a = AchatDiffusion.findById(id);
                request.setAttribute("achat", a);
                request.setAttribute("societes", Societe.findAll());
                request.setAttribute("tarifActuel", TarifDiffusion.getTarifActuel());
                request.setAttribute("diffusionsAffectees", a.getDiffusionsAffectees());
                request.getRequestDispatcher("formAchatDiffusion.jsp").forward(request, response);
            } else if ("affecter".equals(action)) {
                // Formulaire pour affecter des diffusions à un vol
                int idAchat = Integer.parseInt(request.getParameter("idAchat"));
                AchatDiffusion a = AchatDiffusion.findById(idAchat);
                request.setAttribute("achat", a);
                request.setAttribute("vols", Vol.findAll());
                request.setAttribute("diffusionsRestantes", a.getDiffusionsRestantes());
                request.getRequestDispatcher("formAffecterDiffusion.jsp").forward(request, response);
            } else if ("detailVol".equals(action)) {
                // Détail des diffusions pour un vol
                int idVol = Integer.parseInt(request.getParameter("idVol"));
                Vol v = Vol.findById(idVol);
                List<Object[]> diffParSociete = DiffusionVol.countBySocieteForVol(idVol);
                request.setAttribute("vol", v);
                request.setAttribute("diffParSociete", diffParSociete);
                request.getRequestDispatcher("detailDiffusionVol.jsp").forward(request, response);
            } else if ("ca".equals(action)) {
                // Afficher le CA publicitaire par mois
                int mois = 12; // Décembre par défaut
                int annee = 2025;
                
                String moisParam = request.getParameter("mois");
                String anneeParam = request.getParameter("annee");
                if (moisParam != null && !moisParam.isEmpty()) {
                    mois = Integer.parseInt(moisParam);
                }
                if (anneeParam != null && !anneeParam.isEmpty()) {
                    annee = Integer.parseInt(anneeParam);
                }
                
                BigDecimal caTotal = AchatDiffusion.getCAByMoisAnnee(mois, annee);
                List<AchatDiffusion> achats = AchatDiffusion.findByMoisAnnee(mois, annee);
                List<Object[]> resumeParVol = DiffusionVol.getResumeParVol(mois, annee);
                
                // Calculer le nombre total de diffusions pour la simulation
                int totalDiffusions = 0;
                for (AchatDiffusion a : achats) {
                    totalDiffusions += a.getNombreDiffusions();
                }
                
                // Récupérer le tarif actuel pour la simulation
                BigDecimal tarifActuel = TarifDiffusion.getTarifActuel();

                // Simulation: recalcul fictif du CA avec un tarif choisi (ne modifie pas la base)
                BigDecimal tarifSimulation = tarifActuel;
                String tarifSimuleParam = request.getParameter("tarifSimule");
                if (tarifSimuleParam != null && !tarifSimuleParam.isEmpty()) {
                    try {
                        tarifSimulation = new BigDecimal(tarifSimuleParam.trim());
                    } catch (NumberFormatException ignored) {
                        tarifSimulation = tarifActuel;
                    }
                }

                BigDecimal caSimule = tarifSimulation.multiply(BigDecimal.valueOf(totalDiffusions));
                BigDecimal differenceSimule = caSimule.subtract(caTotal);
                
                request.setAttribute("mois", mois);
                request.setAttribute("annee", annee);
                request.setAttribute("caTotal", caTotal);
                request.setAttribute("achats", achats);
                request.setAttribute("resumeParVol", resumeParVol);
                request.setAttribute("totalDiffusions", totalDiffusions);
                request.setAttribute("tarifActuel", tarifActuel);
                request.setAttribute("tarifSimulation", tarifSimulation);
                request.setAttribute("caSimule", caSimule);
                request.setAttribute("differenceSimule", differenceSimule);
                request.getRequestDispatcher("caDiffusion.jsp").forward(request, response);
            } else {
                // Liste des achats de diffusions
                List<AchatDiffusion> achats = AchatDiffusion.findAll();
                request.setAttribute("achats", achats);
                request.setAttribute("tarifActuel", TarifDiffusion.getTarifActuel());
                request.getRequestDispatcher("listAchatDiffusion.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("createAchat".equals(action)) {
                AchatDiffusion a = new AchatDiffusion();
                a.setIdSociete(Integer.parseInt(request.getParameter("idSociete")));
                a.setMois(Integer.parseInt(request.getParameter("mois")));
                a.setAnnee(Integer.parseInt(request.getParameter("annee")));
                a.setNombreDiffusions(Integer.parseInt(request.getParameter("nombreDiffusions")));
                
                String coutStr = request.getParameter("coutUnitaire");
                if (coutStr != null && !coutStr.isEmpty()) {
                    a.setCoutUnitaire(new BigDecimal(coutStr));
                } else {
                    a.setCoutUnitaire(TarifDiffusion.getTarifActuel());
                }
                
                a.save();
                Web.redirectValidation(request, response, "Achat de diffusions enregistré avec succès.", "/DiffusionServlet");
            } else if ("updateAchat".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idAchat"));
                AchatDiffusion a = AchatDiffusion.findById(id);
                if (a != null) {
                    a.setIdSociete(Integer.parseInt(request.getParameter("idSociete")));
                    a.setMois(Integer.parseInt(request.getParameter("mois")));
                    a.setAnnee(Integer.parseInt(request.getParameter("annee")));
                    a.setNombreDiffusions(Integer.parseInt(request.getParameter("nombreDiffusions")));
                    
                    String coutStr = request.getParameter("coutUnitaire");
                    if (coutStr != null && !coutStr.isEmpty()) {
                        a.setCoutUnitaire(new BigDecimal(coutStr));
                    }
                    
                    a.update();
                    Web.redirectValidation(request, response, "Achat modifié avec succès.", "/DiffusionServlet");
                } else {
                    Web.redirectError(request, response, "Achat introuvable.", "/DiffusionServlet");
                }
            } else if ("deleteAchat".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                AchatDiffusion a = AchatDiffusion.findById(id);
                if (a != null) {
                    a.delete();
                    Web.redirectValidation(request, response, "Achat supprimé avec succès.", "/DiffusionServlet");
                } else {
                    Web.redirectError(request, response, "Achat introuvable.", "/DiffusionServlet");
                }
            } else if ("affecter".equals(action)) {
                // Affecter des diffusions à un vol
                int idAchat = Integer.parseInt(request.getParameter("idAchat"));
                int idVol = Integer.parseInt(request.getParameter("idVol"));
                int nombre = Integer.parseInt(request.getParameter("nombre"));
                
                // Vérifier qu'il reste assez de diffusions
                AchatDiffusion a = AchatDiffusion.findById(idAchat);
                int restantes = a.getDiffusionsRestantes();
                
                if (nombre > restantes) {
                    Web.redirectError(request, response, 
                        "Impossible d'affecter " + nombre + " diffusions. Il n'en reste que " + restantes + ".", 
                        "/DiffusionServlet?action=affecter&idAchat=" + idAchat);
                    return;
                }
                
                DiffusionVol.affecterDiffusions(idAchat, idVol, nombre);
                Web.redirectValidation(request, response, 
                    nombre + " diffusion(s) affectée(s) au vol avec succès.", "/DiffusionServlet");
            } else if ("deleteDiffusion".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                DiffusionVol dv = DiffusionVol.findById(id);
                if (dv != null) {
                    dv.delete();
                    Web.redirectValidation(request, response, "Diffusion supprimée avec succès.", "/DiffusionServlet");
                } else {
                    Web.redirectError(request, response, "Diffusion introuvable.", "/DiffusionServlet");
                }
            } else {
                Web.redirectValidation(request, response, "Opération terminée.", "/DiffusionServlet");
            }
        } catch (SQLException e) {
            Web.redirectError(request, response, e.getMessage(), "/DiffusionServlet");
        }
    }
}
