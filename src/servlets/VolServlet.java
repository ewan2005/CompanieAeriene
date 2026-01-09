package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Vol;
import oo.Avion;
import oo.Aeroport;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.List;
import utils.Web;

public class VolServlet extends HttpServlet {
    private static Timestamp parseDateFromDateInput(String value) {
        if (value == null) return null;
        String v = value.trim();
        if (v.isEmpty()) return null;
        // HTML input type="date" => "yyyy-MM-dd"
        if (v.length() == 10) v = v + " 00:00:00";
        return Timestamp.valueOf(v);
    }

    private static Time parseTimeFromTimeInput(String value) {
        if (value == null) return null;
        String v = value.trim();
        if (v.isEmpty()) return null;
        // HTML input type="time" => "HH:mm" (no seconds)
        if (v.length() == 5) v = v + ":00";
        return Time.valueOf(v);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Vol v = Vol.findById(id);
                request.setAttribute("vol", v);
                request.setAttribute("avions", Avion.findAll());
                request.setAttribute("aeroports", Aeroport.findAll());
                request.getRequestDispatcher("formVol.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("avions", Avion.findAll());
                request.setAttribute("aeroports", Aeroport.findAll());
                request.getRequestDispatcher("formVol.jsp").forward(request, response);
            } else {
                List<Vol> list = Vol.findAll();
                request.setAttribute("vols", list);
                request.getRequestDispatcher("listVol.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                Integer numero = (request.getParameter("numeroVol") == null || request.getParameter("numeroVol").isEmpty()) ? null : Integer.parseInt(request.getParameter("numeroVol"));
                Timestamp dateDepart = parseDateFromDateInput(request.getParameter("dateDepart"));
                Timestamp dateArrive = parseDateFromDateInput(request.getParameter("dateArrive"));
                Time heureDepart = parseTimeFromTimeInput(request.getParameter("heureDepart"));
                Time heureArrive = parseTimeFromTimeInput(request.getParameter("heureArrivee"));
                int idAvion = Integer.parseInt(request.getParameter("idAvion"));
                int idAeroportDepart = Integer.parseInt(request.getParameter("idAeroportDepart"));
                int idAeroportArrive = Integer.parseInt(request.getParameter("idAeroportArrive"));

                Vol v = new Vol(numero, dateDepart, dateArrive, heureDepart, heureArrive, idAvion, idAeroportDepart, idAeroportArrive);
                if (!v.hasDifferentAirports()) throw new ServletException("L'aéroport de départ et d'arrivée doivent être différents.");
                v.save();
                Web.redirectValidation(request, response, "Vol enregistré avec succès.", "/VolServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idVol"));
                Integer numero = (request.getParameter("numeroVol") == null || request.getParameter("numeroVol").isEmpty()) ? null : Integer.parseInt(request.getParameter("numeroVol"));
                Timestamp dateDepart = parseDateFromDateInput(request.getParameter("dateDepart"));
                Timestamp dateArrive = parseDateFromDateInput(request.getParameter("dateArrive"));
                Time heureDepart = parseTimeFromTimeInput(request.getParameter("heureDepart"));
                Time heureArrive = parseTimeFromTimeInput(request.getParameter("heureArrivee"));
                int idAvion = Integer.parseInt(request.getParameter("idAvion"));
                int idAeroportDepart = Integer.parseInt(request.getParameter("idAeroportDepart"));
                int idAeroportArrive = Integer.parseInt(request.getParameter("idAeroportArrive"));

                Vol v = new Vol(id, numero, dateDepart, dateArrive, heureDepart, heureArrive, idAvion, idAeroportDepart, idAeroportArrive);
                if (!v.hasDifferentAirports()) throw new ServletException("L'aéroport de départ et d'arrivée doivent être différents.");
                v.update();
                Web.redirectValidation(request, response, "Vol mis à jour.", "/VolServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idVol"));
                Vol v = new Vol(); v.setIdVol(id);
                v.delete();
                Web.redirectValidation(request, response, "Vol supprimé.", "/VolServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/VolServlet");
        } catch (SQLException | IllegalArgumentException | ServletException e) {
            Web.redirectError(request, response, e.getMessage(), "/VolServlet");
        }
    }
}
