package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Billet;
import oo.Vol;
import oo.Reservation;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import utils.Web;

public class BilletServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Billet b = Billet.findById(id);
                request.setAttribute("billet", b);
                request.setAttribute("vols", Vol.findAll());
                int currentReservationId = (b != null) ? b.getIdReservation() : 0;
                request.setAttribute("reservations", Reservation.findConfirmedWithoutBilletForSelect(currentReservationId));
                request.getRequestDispatcher("formBillet.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("vols", Vol.findAll());
                request.setAttribute("reservations", Reservation.findConfirmedWithoutBilletForSelect(0));
                request.getRequestDispatcher("formBillet.jsp").forward(request, response);
            } else if (request.getParameter("idVol") != null) {
                int idVol = Integer.parseInt(request.getParameter("idVol"));
                List<Billet> list = Billet.findAllByVol(idVol);
                request.setAttribute("billets", list);
                request.getRequestDispatcher("listBillet.jsp").forward(request, response);
            } else {
                request.setAttribute("billets", java.util.Collections.emptyList());
                request.getRequestDispatcher("listBillet.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                BigDecimal prix = new BigDecimal(request.getParameter("prix"));
                String classe = request.getParameter("classe");
                int idReservation = Integer.parseInt(request.getParameter("idReservation"));
                int idVol = Integer.parseInt(request.getParameter("idVol"));
                Billet b = new Billet(prix, classe, idReservation, idVol);
                b.save();
                Web.redirectValidation(request, response, "Billet enregistré avec succès.", "/BilletServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idBillet"));
                BigDecimal prix = new BigDecimal(request.getParameter("prix"));
                String classe = request.getParameter("classe");
                int idReservation = Integer.parseInt(request.getParameter("idReservation"));
                int idVol = Integer.parseInt(request.getParameter("idVol"));
                Billet b = new Billet(id, prix, classe, idReservation, idVol);
                b.update();
                Web.redirectValidation(request, response, "Billet mis à jour.", "/BilletServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idBillet"));
                Billet b = new Billet(); b.setIdBillet(id); b.delete();
                Web.redirectValidation(request, response, "Billet supprimé.", "/BilletServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/BilletServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/BilletServlet");
        }
    }
}
