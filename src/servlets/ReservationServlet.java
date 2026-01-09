package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Reservation;
import oo.Paiement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import utils.DB;
import utils.Web;

public class ReservationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Reservation r = Reservation.findById(id);
                request.setAttribute("reservation", r);
                request.setAttribute("paiements", Paiement.findAll());
                request.getRequestDispatcher("formReservation.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("paiements", Paiement.findAll());
                request.getRequestDispatcher("formReservation.jsp").forward(request, response);
            } else {
                List<Reservation> list = Reservation.findAll();
                request.setAttribute("reservations", list);
                request.getRequestDispatcher("listReservation.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("create".equals(action)) {
                Reservation r = new Reservation();
                r.setDateReservation(parseDateTimeLocal(request.getParameter("dateReservation")));
                if (r.getDateReservation() == null) r.setDateReservation(new Timestamp(System.currentTimeMillis()));
                r.setStatus(Boolean.parseBoolean(request.getParameter("status")));

                String idPaiementStr = request.getParameter("idPaiement");
                int idPaiement = (idPaiementStr == null || idPaiementStr.isEmpty()) ? 0 : Integer.parseInt(idPaiementStr);

                String montantStr = request.getParameter("montant");
                boolean hasMontant = montantStr != null && !montantStr.trim().isEmpty();

                if (idPaiement > 0) {
                    r.setIdPaiement(idPaiement);
                    r.save();
                } else if (hasMontant) {
                    double montant = Double.parseDouble(montantStr.trim());
                    if (montant > 0) {
                        Paiement p = new Paiement(montant, new Timestamp(System.currentTimeMillis()));
                        Connection conn = DB.getconnect();
                        try {
                            Reservation.createWithPayment(r, p, conn);
                        } finally {
                            if (conn != null) conn.close();
                        }
                    } else {
                        // paiement optionnel: montant vide/0 => pas de paiement
                        r.save();
                    }
                } else {
                    r.save();
                }
                Web.redirectValidation(request, response, "Réservation enregistrée avec succès.", "/ReservationServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idReservation"));
                Reservation r = Reservation.findById(id);
                if (r == null) {
                    Web.redirectError(request, response, "Réservation introuvable.", "/ReservationServlet");
                    return;
                }

                Timestamp dateReservation = parseDateTimeLocal(request.getParameter("dateReservation"));
                if (dateReservation != null) r.setDateReservation(dateReservation);
                r.setStatus(Boolean.parseBoolean(request.getParameter("status")));

                String idPaiementStr = request.getParameter("idPaiement");
                int idPaiement = (idPaiementStr == null || idPaiementStr.isEmpty()) ? 0 : Integer.parseInt(idPaiementStr);
                if (idPaiement > 0) {
                    r.setIdPaiement(idPaiement);
                } else {
                    String montantStr = request.getParameter("montant");
                    boolean hasMontant = montantStr != null && !montantStr.trim().isEmpty();
                    if (hasMontant) {
                        double montant = Double.parseDouble(montantStr.trim());
                        if (montant > 0) {
                            Connection conn = DB.getconnect();
                            boolean previousAuto = conn.getAutoCommit();
                            try {
                                conn.setAutoCommit(false);
                                Paiement p = new Paiement(montant, new Timestamp(System.currentTimeMillis()));
                                p.save(conn);
                                r.setIdPaiement(p.getIdPaiement());
                                r.update(conn);
                                conn.commit();
                            } catch (SQLException ex) {
                                conn.rollback();
                                throw ex;
                            } finally {
                                conn.setAutoCommit(previousAuto);
                                if (conn != null) conn.close();
                            }
                            Web.redirectValidation(request, response, "Réservation mise à jour.", "/ReservationServlet");
                            return;
                        }
                    }
                    // paiement optionnel: allow clearing payment
                    r.setIdPaiement(0);
                }
                r.update();
                Web.redirectValidation(request, response, "Réservation mise à jour.", "/ReservationServlet");
                return;
            } else if ("cancel".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idReservation"));
                Reservation r = new Reservation(); r.setIdReservation(id); r.setStatus(false); r.update();
                Web.redirectValidation(request, response, "Réservation annulée.", "/ReservationServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idReservation"));
                Reservation r = new Reservation();
                r.setIdReservation(id);
                r.delete();
                Web.redirectValidation(request, response, "Réservation supprimée.", "/ReservationServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/ReservationServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/ReservationServlet");
        }
    }

    private static Timestamp parseDateTimeLocal(String value) {
        if (value == null) return null;
        String v = value.trim();
        if (v.isEmpty()) return null;
        v = v.replace('T', ' ');
        if (v.length() == 16) v = v + ":00";
        return Timestamp.valueOf(v);
    }
}
