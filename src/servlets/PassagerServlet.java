package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Passager;
import oo.Reservation;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import utils.Web;

public class PassagerServlet extends HttpServlet {
    private static Timestamp parseTimestampFromHtmlInput(String value) {
        if (value == null) return null;
        String v = value.trim();
        if (v.isEmpty()) return null;

        // Handles:
        // - <input type="date"> => "yyyy-MM-dd"
        // - <input type="datetime-local"> => "yyyy-MM-ddTHH:mm" or "yyyy-MM-ddTHH:mm:ss[.fffffffff]"
        if (v.length() == 10) {
            return Timestamp.valueOf(v + " 00:00:00");
        }

        v = v.replace('T', ' ');
        if (v.length() == 16) v = v + ":00";
        return Timestamp.valueOf(v);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Passager p = Passager.findById(id);
                request.setAttribute("passager", p);
                // Dans la nouvelle architecture, le passager est lié à une réservation existante
                request.setAttribute("reservations", Reservation.findAll());
                request.getRequestDispatcher("formPassager.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                // Charger les réservations pour associer un passager
                request.setAttribute("reservations", Reservation.findAll());
                request.getRequestDispatcher("formPassager.jsp").forward(request, response);
            } else if ("search".equals(action)) {
                String q = request.getParameter("q");
                List<Passager> list = Passager.findByNameOrPassport(q);
                request.setAttribute("passagers", list);
                request.getRequestDispatcher("listPassager.jsp").forward(request, response);
            } else {
                List<Passager> list = Passager.findAll();
                request.setAttribute("passagers", list);
                request.getRequestDispatcher("listPassager.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                Timestamp dateNaiss = parseTimestampFromHtmlInput(request.getParameter("dateNaissance"));
                String passport = request.getParameter("numeroPasseport");
                if (passport != null) {
                    passport = passport.trim();
                    if (passport.isEmpty()) passport = null;
                }
                int idReservation = Integer.parseInt(request.getParameter("idReservation"));
                Passager p = new Passager(request.getParameter("nom"), request.getParameter("prenom"), dateNaiss, passport, request.getParameter("nationalite"), idReservation);
                p.save();
                Web.redirectValidation(request, response, "Passager enregistré avec succès.", "/PassagerServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPassager"));
                Timestamp dateNaiss = parseTimestampFromHtmlInput(request.getParameter("dateNaissance"));
                String passport = request.getParameter("numeroPasseport");
                if (passport != null) {
                    passport = passport.trim();
                    if (passport.isEmpty()) passport = null;
                }
                int idReservation = Integer.parseInt(request.getParameter("idReservation"));
                Passager p = new Passager(id, request.getParameter("nom"), request.getParameter("prenom"), dateNaiss, passport, request.getParameter("nationalite"), idReservation);
                p.update();
                Web.redirectValidation(request, response, "Passager mis à jour.", "/PassagerServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idPassager"));
                Passager p = new Passager(); p.setIdPassager(id); p.delete();
                Web.redirectValidation(request, response, "Passager supprimé.", "/PassagerServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/PassagerServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/PassagerServlet");
        }
    }
}
