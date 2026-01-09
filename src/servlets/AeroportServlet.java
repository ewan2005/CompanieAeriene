package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Aeroport;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import utils.Web;

public class AeroportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Aeroport a = Aeroport.findById(id);
                request.setAttribute("aeroport", a);
                request.getRequestDispatcher("formAeroport.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.getRequestDispatcher("formAeroport.jsp").forward(request, response);
            } else {
                List<Aeroport> list = Aeroport.findAll();
                request.setAttribute("aeroports", list);
                request.getRequestDispatcher("listAeroport.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                Aeroport a = new Aeroport(request.getParameter("nom"), request.getParameter("ville"), request.getParameter("code"));
                a.save();
                Web.redirectValidation(request, response, "Aéroport enregistré avec succès.", "/AeroportServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idAeroport"));
                Aeroport a = new Aeroport(id, request.getParameter("nom"), request.getParameter("ville"), request.getParameter("code"));
                a.update();
                Web.redirectValidation(request, response, "Aéroport mis à jour.", "/AeroportServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idAeroport"));
                Aeroport a = new Aeroport();
                a.setIdAeroport(id);
                a.delete();
                Web.redirectValidation(request, response, "Aéroport supprimé.", "/AeroportServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/AeroportServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/AeroportServlet");
        }
    }
}
