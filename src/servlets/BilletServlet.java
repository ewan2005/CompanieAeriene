package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Billet;
import oo.ModePaiement;
import oo.Reservation;
import oo.Paiement;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import utils.DB;
import utils.Web;

public class BilletServlet extends HttpServlet {
    private static Integer parseOptionalInt(String value) {
        if (value == null) return null;
        String v = value.trim();
        if (v.isEmpty()) return null;
        try { return Integer.parseInt(v); } catch (NumberFormatException ex) { return null; }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Billet b = Billet.findById(id);
                request.setAttribute("billet", b);

                // State for JSP
                request.setAttribute("modesPaiement", ModePaiement.findAll());
                request.setAttribute("selectedReservationId", b != null ? b.getIdReservation() : 0);
                if (b != null) {
                    Paiement p = (b.getIdPaiement() > 0) ? Paiement.findById(b.getIdPaiement()) : null;
                    request.setAttribute("selectedModePaiementId", p != null ? p.getIdModePaiement() : null);
                }

                // Pour l'édition, on peut changer la réservation seulement si pas de paiement
                request.setAttribute("reservations", Reservation.findWithoutBilletDetailed());
                // La réservation existante ne sera pas dans la liste "sans billet"
                try {
                    List<Reservation.ReservationDetail> all = Reservation.findAllDetailed();
                    if (b != null) {
                        for (Reservation.ReservationDetail r : all) {
                            if (r.getIdReservation() == b.getIdReservation()) {
                                request.setAttribute("existingReservation", r);
                                break;
                            }
                        }
                    }
                } catch (SQLException ignore) {
                    // fallback: JSP affichera N/A
                }
                request.getRequestDispatcher("formBillet.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                // Charger les réservations sans billet avec tous les détails
                request.setAttribute("reservations", Reservation.findWithoutBilletDetailed());

                // Modes de paiement + réservation sélectionnée (via param idReservation)
                request.setAttribute("modesPaiement", ModePaiement.findAll());
                Integer selectedReservationId = parseOptionalInt(request.getParameter("idReservation"));
                if (selectedReservationId != null) request.setAttribute("selectedReservationId", selectedReservationId);

                request.getRequestDispatcher("formBillet.jsp").forward(request, response);
            } else {
                // Afficher tous les billets avec détails
                List<Billet.BilletDetail> list = Billet.findAllDetailed();
                request.setAttribute("billets", list);
                
                // Ajouter les statistiques de chiffre d'affaires
                request.setAttribute("caTotal", Billet.getChiffreAffaireTotal());
                request.setAttribute("caParTrajet", Billet.getChiffreAffaireParTrajet());
                request.setAttribute("caParAvion", Billet.getChiffreAffaireParAvion());
                
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
                Integer idModePaiement = parseOptionalInt(request.getParameter("idModePaiement"));
                
                // Créer le paiement automatiquement
                Connection conn = DB.getconnect();
                boolean previousAuto = conn.getAutoCommit();
                try {
                    conn.setAutoCommit(false);
                    
                    // Créer le paiement
                    Paiement p = new Paiement(prix.doubleValue(), new Timestamp(System.currentTimeMillis()), idModePaiement);
                    p.save(conn);
                    
                    // Créer le billet avec le paiement
                    Billet b = new Billet(prix, classe, idReservation, p.getIdPaiement());
                    b.save(conn);
                    
                    conn.commit();
                } catch (SQLException ex) {
                    conn.rollback();
                    throw ex;
                } finally {
                    conn.setAutoCommit(previousAuto);
                    if (conn != null) conn.close();
                }
                
                Web.redirectValidation(request, response, "Billet créé et paiement enregistré avec succès.", "/BilletServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idBillet"));
                BigDecimal prix = new BigDecimal(request.getParameter("prix"));
                String classe = request.getParameter("classe");
                int idReservation = Integer.parseInt(request.getParameter("idReservation"));
                
                Billet existing = Billet.findById(id);
                if (existing == null) throw new SQLException("Billet introuvable.");
                
                // Mettre à jour le billet
                existing.setPrix(prix);
                existing.setClasse(classe);
                existing.setIdReservation(idReservation);
                existing.update();
                
                // Mettre à jour le paiement si existe
                if (existing.getIdPaiement() > 0) {
                    Paiement p = Paiement.findById(existing.getIdPaiement());
                    if (p != null) {
                        p.setMontant(prix.doubleValue());
                        p.update();
                    }
                }
                
                Web.redirectValidation(request, response, "Billet mis à jour.", "/BilletServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idBillet"));
                Billet b = Billet.findById(id);
                if (b != null) {
                    b.delete();
                }
                Web.redirectValidation(request, response, "Billet supprimé.", "/BilletServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/BilletServlet");
        } catch (SQLException | IllegalArgumentException e) {
            Web.redirectError(request, response, e.getMessage(), "/BilletServlet");
        }
    }
}
