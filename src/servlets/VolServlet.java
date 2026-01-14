package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Vol;
import oo.Avion;
import oo.Trajet;

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
                request.setAttribute("trajets", Trajet.findAllDetailed());
                request.setAttribute("avions", Avion.findAll());
                request.getRequestDispatcher("formVol.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("trajets", Trajet.findAllDetailed());
                request.setAttribute("avions", Avion.findAll());
                request.getRequestDispatcher("formVol.jsp").forward(request, response);
            } else {
                List<Vol.VolDetail> list = Vol.findAllDetailed();
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
                String numero = request.getParameter("numeroVol");
                if (numero != null) {
                    numero = numero.trim();
                    if (numero.isEmpty()) numero = null;
                }
                Timestamp dateDepart = parseDateFromDateInput(request.getParameter("dateDepart"));
                Timestamp dateArrive = parseDateFromDateInput(request.getParameter("dateArrive"));
                Time heureDepart = parseTimeFromTimeInput(request.getParameter("heureDepart"));
                Time heureArrive = parseTimeFromTimeInput(request.getParameter("heureArrivee"));
                int idTrajet = Integer.parseInt(request.getParameter("idTrajet"));
                int idAvion = Integer.parseInt(request.getParameter("idAvion"));

                Vol v = new Vol(numero, dateDepart, dateArrive, heureDepart, heureArrive, idTrajet, idAvion);
                v.save();

                Web.redirectValidation(request, response, "Vol enregistré avec succès.", "/VolServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idVol"));
                String numero = request.getParameter("numeroVol");
                if (numero != null) {
                    numero = numero.trim();
                    if (numero.isEmpty()) numero = null;
                }
                Timestamp dateDepart = parseDateFromDateInput(request.getParameter("dateDepart"));
                Timestamp dateArrive = parseDateFromDateInput(request.getParameter("dateArrive"));
                Time heureDepart = parseTimeFromTimeInput(request.getParameter("heureDepart"));
                Time heureArrive = parseTimeFromTimeInput(request.getParameter("heureArrivee"));
                int idTrajet = Integer.parseInt(request.getParameter("idTrajet"));
                int idAvion = Integer.parseInt(request.getParameter("idAvion"));

                Vol v = new Vol(id, numero, dateDepart, dateArrive, heureDepart, heureArrive, idTrajet, idAvion);
                v.update();

                Web.redirectValidation(request, response, "Vol mis à jour.", "/VolServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idVol"));
                Vol v = new Vol(); 
                v.setIdVol(id);
                v.delete();
                Web.redirectValidation(request, response, "Vol supprimé.", "/VolServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/VolServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/VolServlet");
        }
    }
}
