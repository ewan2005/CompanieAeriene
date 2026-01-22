package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.PaiementSociete;
import oo.AchatDiffusion;
import utils.Web;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public class PaiementSocieteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("new".equals(action)) {
                // Formulaire nouveau paiement
                String idAchatParam = request.getParameter("idAchat");
                if (idAchatParam != null && !idAchatParam.isEmpty()) {
                    int idAchat = Integer.parseInt(idAchatParam);
                    AchatDiffusion achat = AchatDiffusion.findById(idAchat);
                    request.setAttribute("achat", achat);
                    request.setAttribute("resteAPayer", achat.getResteAPayer());
                }
                request.setAttribute("achats", AchatDiffusion.findAll());
                request.getRequestDispatcher("formPaiementSociete.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PaiementSociete p = PaiementSociete.findById(id);
                request.setAttribute("paiement", p);
                request.setAttribute("achats", AchatDiffusion.findAll());
                if (p.getAchat() != null) {
                    request.setAttribute("resteAPayer", p.getAchat().getResteAPayer().add(p.getMontant()));
                }
                request.getRequestDispatcher("formPaiementSociete.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PaiementSociete p = PaiementSociete.findById(id);
                if (p != null) {
                    p.delete();
                }
                response.sendRedirect(request.getContextPath() + "/PaiementSocieteServlet");
            } else if ("byAchat".equals(action)) {
                // Liste des paiements pour un achat spécifique
                int idAchat = Integer.parseInt(request.getParameter("idAchat"));
                AchatDiffusion achat = AchatDiffusion.findById(idAchat);
                List<PaiementSociete> paiements = PaiementSociete.findByAchat(idAchat);
                request.setAttribute("achat", achat);
                request.setAttribute("paiements", paiements);
                request.setAttribute("totalPaye", achat.getMontantPaye());
                request.setAttribute("resteAPayer", achat.getResteAPayer());
                request.getRequestDispatcher("listPaiementSociete.jsp").forward(request, response);
            } else {
                // Liste de tous les paiements
                List<PaiementSociete> paiements = PaiementSociete.findAll();
                request.setAttribute("paiements", paiements);
                request.getRequestDispatcher("listPaiementSociete.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                PaiementSociete p = new PaiementSociete();
                p.setIdAchat(Integer.parseInt(request.getParameter("idAchat")));
                p.setMontant(new BigDecimal(request.getParameter("montant").replace(" ", "").replace(",", ".")));
                p.setDatePaiement(Date.valueOf(request.getParameter("datePaiement")));
                p.setReference(request.getParameter("reference"));
                p.save();
                
                // Rediriger vers la liste des paiements de cet achat
                response.sendRedirect(request.getContextPath() + "/PaiementSocieteServlet?action=byAchat&idAchat=" + p.getIdAchat());
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPaiement"));
                PaiementSociete p = PaiementSociete.findById(id);
                if (p != null) {
                    p.setIdAchat(Integer.parseInt(request.getParameter("idAchat")));
                    p.setMontant(new BigDecimal(request.getParameter("montant").replace(" ", "").replace(",", ".")));
                    p.setDatePaiement(Date.valueOf(request.getParameter("datePaiement")));
                    p.setReference(request.getParameter("reference"));
                    p.update();
                }
                response.sendRedirect(request.getContextPath() + "/PaiementSocieteServlet?action=byAchat&idAchat=" + p.getIdAchat());
            } else {
                response.sendRedirect(request.getContextPath() + "/PaiementSocieteServlet");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
