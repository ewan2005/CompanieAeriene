package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Paiement;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import utils.Web;

public class PaiementServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Paiement p = Paiement.findById(id);
                request.setAttribute("paiement", p);
                request.getRequestDispatcher("formPaiement.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.getRequestDispatcher("formPaiement.jsp").forward(request, response);
            } else {
                List<Paiement> list = Paiement.findAll();
                request.setAttribute("paiements", list);
                request.getRequestDispatcher("listPaiement.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if (action == null || action.isEmpty()) action = "create";

            if ("create".equals(action)) {
                java.math.BigDecimal montant = new java.math.BigDecimal(request.getParameter("montant"));
                Timestamp datePaiement = parseDateTimeLocal(request.getParameter("datePaiement"));
                Paiement p = new Paiement(montant.doubleValue(), datePaiement);
                p.save();
                Web.redirectValidation(request, response, "Paiement enregistré avec succès.", "/PaiementServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPaiement"));
                java.math.BigDecimal montant = new java.math.BigDecimal(request.getParameter("montant"));
                Timestamp datePaiement = parseDateTimeLocal(request.getParameter("datePaiement"));
                Paiement p = new Paiement(id, montant.doubleValue(), datePaiement);
                p.update();
                Web.redirectValidation(request, response, "Paiement mis à jour.", "/PaiementServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPaiement"));
                Paiement p = new Paiement();
                p.setIdPaiement(id);
                p.delete();
                Web.redirectValidation(request, response, "Paiement supprimé.", "/PaiementServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/PaiementServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/PaiementServlet");
        }
    }

    private static Timestamp parseDateTimeLocal(String value) {
        if (value == null) return null;
        String v = value.trim();
        if (v.isEmpty()) return null;
        // HTML input type="datetime-local" => "yyyy-MM-ddTHH:mm" (no seconds)
        v = v.replace('T', ' ');
        if (v.length() == 16) v = v + ":00";
        return Timestamp.valueOf(v);
    }
}
