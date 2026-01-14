package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Aeroport;
import oo.Trajet;
import utils.DB;
import utils.Web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class TrajetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("new".equals(action)) {
                request.setAttribute("aeroports", Aeroport.findAll());
                request.getRequestDispatcher("formTrajet.jsp").forward(request, response);
                return;
            }
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Trajet t = Trajet.findById(id);
                request.setAttribute("trajet", t);
                request.setAttribute("aeroports", Aeroport.findAll());
                request.getRequestDispatcher("formTrajet.jsp").forward(request, response);
                return;
            }
            if ("ca".equals(action)) {
                int idTrajet = Integer.parseInt(request.getParameter("idTrajet"));
                Connection conn = DB.getconnect();
                try {
                    List<Trajet.ChiffreAffaireAvion> ca = Trajet.getChiffreAffaireParAvion(conn, idTrajet);
                    request.setAttribute("ca", ca);
                } finally {
                    if (conn != null) conn.close();
                }
                request.setAttribute("trajetId", idTrajet);
                request.getRequestDispatcher("trajetCA.jsp").forward(request, response);
                return;
            }

            // default list
            List<Trajet.TrajetDetail> list = Trajet.findAllDetailed();
            request.setAttribute("trajets", list);
            request.getRequestDispatcher("listTrajet.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                int idDepart = Integer.parseInt(request.getParameter("idAeroportDepart"));
                int idArrive = Integer.parseInt(request.getParameter("idAeroportArrive"));
                if (idDepart == idArrive) throw new IllegalArgumentException("L'aéroport de départ et d'arrivée doivent être différents.");

                Trajet t = new Trajet(idDepart, idArrive);
                t.save();
                Web.redirectValidation(request, response, "Trajet créé.", "/TrajetServlet");
                return;
            }
            if ("update".equals(action)) {
                int idTrajet = Integer.parseInt(request.getParameter("idTrajet"));
                int idDepart = Integer.parseInt(request.getParameter("idAeroportDepart"));
                int idArrive = Integer.parseInt(request.getParameter("idAeroportArrive"));
                if (idDepart == idArrive) throw new IllegalArgumentException("L'aéroport de départ et d'arrivée doivent être différents.");

                Trajet t = new Trajet(idTrajet, idDepart, idArrive);
                t.update();
                Web.redirectValidation(request, response, "Trajet mis à jour.", "/TrajetServlet");
                return;
            }
            if ("delete".equals(action)) {
                int idTrajet = Integer.parseInt(request.getParameter("idTrajet"));
                Trajet t = new Trajet();
                t.setIdTrajet(idTrajet);
                t.delete();
                Web.redirectValidation(request, response, "Trajet supprimé.", "/TrajetServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/TrajetServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/TrajetServlet");
        }
    }
}
