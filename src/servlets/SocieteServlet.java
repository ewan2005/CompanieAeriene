package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Societe;
import utils.Web;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class SocieteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Societe s = Societe.findById(id);
                request.setAttribute("societe", s);
                request.getRequestDispatcher("formSociete.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.getRequestDispatcher("formSociete.jsp").forward(request, response);
            } else {
                // Liste des sociétés
                List<Societe> societes = Societe.findAll();
                request.setAttribute("societes", societes);
                request.getRequestDispatcher("listSociete.jsp").forward(request, response);
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
                Societe s = new Societe();
                s.setNom(request.getParameter("nom"));
                s.setAdresse(request.getParameter("adresse"));
                s.setTelephone(request.getParameter("telephone"));
                s.setEmail(request.getParameter("email"));
                s.save();
                Web.redirectValidation(request, response, "Société créée avec succès.", "/SocieteServlet");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idSociete"));
                Societe s = Societe.findById(id);
                if (s != null) {
                    s.setNom(request.getParameter("nom"));
                    s.setAdresse(request.getParameter("adresse"));
                    s.setTelephone(request.getParameter("telephone"));
                    s.setEmail(request.getParameter("email"));
                    s.update();
                    Web.redirectValidation(request, response, "Société modifiée avec succès.", "/SocieteServlet");
                } else {
                    Web.redirectError(request, response, "Société introuvable.", "/SocieteServlet");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Societe s = Societe.findById(id);
                if (s != null) {
                    s.delete();
                    Web.redirectValidation(request, response, "Société supprimée avec succès.", "/SocieteServlet");
                } else {
                    Web.redirectError(request, response, "Société introuvable.", "/SocieteServlet");
                }
            } else {
                Web.redirectValidation(request, response, "Opération terminée.", "/SocieteServlet");
            }
        } catch (SQLException e) {
            Web.redirectError(request, response, e.getMessage(), "/SocieteServlet");
        }
    }
}
