package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Avion;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import utils.Web;

public class AvionServlet extends HttpServlet {

    // GET: list or show form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Avion a = Avion.findById(id);
                request.setAttribute("avion", a);
                request.getRequestDispatcher("formAvion.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.getRequestDispatcher("formAvion.jsp").forward(request, response);
            } else {
                List<Avion> list = Avion.findAll();
                request.setAttribute("avions", list);
                request.getRequestDispatcher("listAvion.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    // POST: create / update / delete depending on action param
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                Avion a = new Avion(request.getParameter("model"), request.getParameter("capacite"), request.getParameter("code"));
                a.save();
                Web.redirectValidation(request, response, "Avion enregistré avec succès.", "/AvionServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idAvion"));
                Avion a = new Avion(id, request.getParameter("model"), request.getParameter("capacite"), request.getParameter("code"));
                a.update();
                Web.redirectValidation(request, response, "Avion mis à jour.", "/AvionServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idAvion"));
                Avion a = new Avion();
                a.setIdAvion(id);
                a.delete();
                Web.redirectValidation(request, response, "Avion supprimé.", "/AvionServlet");
                return;
            }

            Web.redirectValidation(request, response, "Opération terminée.", "/AvionServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/AvionServlet");
        }
    }
}
