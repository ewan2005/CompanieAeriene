package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Reservation;
import oo.Vol;
import oo.Place;
import oo.Passager;
import oo.Categorie;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import utils.DB;
import utils.Web;

public class ReservationServlet extends HttpServlet {
    private static int parseOptionalInt(String value) {
        if (value == null) return 0;
        String v = value.trim();
        if (v.isEmpty()) return 0;
        try {
            return Integer.parseInt(v);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    private static int resolveVolIdFromParam(String value) throws SQLException {
        int id = parseOptionalInt(value);
        if (id > 0) return id;
        if (value == null) return 0;
        String v = value.trim();
        if (v.isEmpty()) return 0;
        Vol found = Vol.findByNumeroVol(v);
        return (found != null) ? found.getIdVol() : 0;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Reservation r = Reservation.findById(id);
                request.setAttribute("reservation", r);
                
                // Charger les vols avec détails
                request.setAttribute("vols", Vol.findAllDetailed());
                // Charger les catégories pour le formulaire
                request.setAttribute("categories", Categorie.findAll());

                // Charger uniquement les places de l'avion du vol sélectionné
                if (r != null && r.getIdVol() > 0) {
                    Vol vol = Vol.findById(r.getIdVol());
                    if (vol != null && vol.getIdAvion() > 0) {
                        request.setAttribute("places", Place.findByAvion(vol.getIdAvion()));
                    }
                }
                
                // Pré-sélectionner le vol, la place et la catégorie
                if (r != null) {
                    request.setAttribute("selectedVolId", r.getIdVol());
                    request.setAttribute("selectedPlaceId", r.getIdPlace());
                    request.setAttribute("selectedCategorieId", r.getIdCategorie());
                }
                
                // Charger le passager associé s'il existe
                List<Passager> passagers = Passager.findByReservation(id);
                if (!passagers.isEmpty()) {
                    request.setAttribute("passager", passagers.get(0));
                }
                
                // Places réservées pour ce vol (exclure la réservation actuelle)
                if (r != null && r.getIdVol() > 0) {
                    Connection conn = DB.getconnect();
                    try {
                        List<Integer> reservedPlaces = Reservation.findReservedPlaceIdsExcluding(conn, r.getIdVol(), id);
                        Set<Integer> reservedSet = new HashSet<>(reservedPlaces);
                        request.setAttribute("reservedPlaceIds", reservedSet);
                    } finally {
                        if (conn != null) conn.close();
                    }
                }
                
                request.getRequestDispatcher("formReservation.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.setAttribute("vols", Vol.findAllDetailed());
                request.setAttribute("categories", Categorie.findAll());
                
                int selectedVolId = resolveVolIdFromParam(request.getParameter("idVol"));
                if (selectedVolId > 0) {
                    Vol vol = Vol.findById(selectedVolId);
                    if (vol != null && vol.getIdAvion() > 0) {
                        request.setAttribute("places", Place.findByAvion(vol.getIdAvion()));
                    }
                    List<Integer> reservedPlaces = Reservation.findReservedPlaceIds(selectedVolId);
                    Set<Integer> reservedSet = new HashSet<>(reservedPlaces);
                    request.setAttribute("reservedPlaceIds", reservedSet);
                    request.setAttribute("selectedVolId", selectedVolId);
                }
                
                request.getRequestDispatcher("formReservation.jsp").forward(request, response);
            } else if ("getReservedPlaces".equals(action)) {
                // AJAX endpoint pour obtenir les places réservées d'un vol
                int idVol = resolveVolIdFromParam(request.getParameter("idVol"));
                List<Integer> reservedPlaces = Reservation.findReservedPlaceIds(idVol);
                response.setContentType("application/json");
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < reservedPlaces.size(); i++) {
                    if (i > 0) json.append(",");
                    json.append(reservedPlaces.get(i));
                }
                json.append("]");
                response.getWriter().write(json.toString());
                return;
            } else {
                List<Reservation.ReservationDetail> list = Reservation.findAllDetailed();
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
                int idVol = Integer.parseInt(request.getParameter("idVol"));
                int idPlace = Integer.parseInt(request.getParameter("idPlace"));
                
                // Infos passager
                String passagerNom = request.getParameter("passagerNom");
                String passagerPrenom = request.getParameter("passagerPrenom");
                String passagerTelephone = request.getParameter("passagerTelephone");
                String passagerEmail = request.getParameter("passagerEmail");
                String passagerPasseport = request.getParameter("passagerPasseport");
                
                Connection conn = DB.getconnect();
                boolean previousAuto = conn.getAutoCommit();
                try {
                    conn.setAutoCommit(false);
                    
                    // Créer la réservation
                    Reservation r = new Reservation();
                    r.setDateReservation(new Timestamp(System.currentTimeMillis()));
                    r.setIdVol(idVol);
                    r.setIdPlace(idPlace);
                    // Catégorie (par défaut adulte si absent)
                    String idCatStr = request.getParameter("idCategorie");
                    if (idCatStr != null && !idCatStr.trim().isEmpty()) try { r.setIdCategorie(Integer.parseInt(idCatStr)); } catch (NumberFormatException ignored) {}
                    r.save(conn);
                    
                    // Créer le passager
                    if (passagerNom != null && !passagerNom.trim().isEmpty()) {
                        Passager p = new Passager();
                        p.setNom(passagerNom.trim());
                        p.setPrenom(passagerPrenom != null ? passagerPrenom.trim() : "");
                        p.setTelephone(passagerTelephone);
                        p.setEmail(passagerEmail);
                        p.setNumeroPasseport(passagerPasseport);
                        p.setIdReservation(r.getIdReservation());
                        p.save(conn);
                    }
                    
                    conn.commit();
                } catch (SQLException ex) {
                    conn.rollback();
                    throw ex;
                } finally {
                    conn.setAutoCommit(previousAuto);
                    if (conn != null) conn.close();
                }

                Web.redirectValidation(request, response, "Réservation créée avec succès.", "/ReservationServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idReservation"));
                int idVol = Integer.parseInt(request.getParameter("idVol"));
                int idPlace = Integer.parseInt(request.getParameter("idPlace"));
                
                // Infos passager
                String passagerNom = request.getParameter("passagerNom");
                String passagerPrenom = request.getParameter("passagerPrenom");
                String passagerTelephone = request.getParameter("passagerTelephone");
                String passagerEmail = request.getParameter("passagerEmail");
                String passagerPasseport = request.getParameter("passagerPasseport");
                
                Connection conn = DB.getconnect();
                boolean previousAuto = conn.getAutoCommit();
                try {
                    conn.setAutoCommit(false);
                    
                    // Mettre à jour la réservation
                    Reservation r = Reservation.findById(conn, id);
                    if (r == null) throw new SQLException("Réservation introuvable.");
                    r.setIdVol(idVol);
                    r.setIdPlace(idPlace);
                    // Catégorie (si fournie)
                    String idCatStr = request.getParameter("idCategorie");
                    if (idCatStr != null && !idCatStr.trim().isEmpty()) try { r.setIdCategorie(Integer.parseInt(idCatStr)); } catch (NumberFormatException ignored) {}
                    r.update(conn);
                    
                    // Mettre à jour ou créer le passager
                    List<Passager> passagers = Passager.findByReservation(conn, id);
                    if (passagerNom != null && !passagerNom.trim().isEmpty()) {
                        Passager p;
                        if (!passagers.isEmpty()) {
                            p = passagers.get(0);
                        } else {
                            p = new Passager();
                            p.setIdReservation(id);
                        }
                        p.setNom(passagerNom.trim());
                        p.setPrenom(passagerPrenom != null ? passagerPrenom.trim() : "");
                        p.setTelephone(passagerTelephone);
                        p.setEmail(passagerEmail);
                        p.setNumeroPasseport(passagerPasseport);
                        
                        if (p.getIdPassager() > 0) {
                            p.update(conn);
                        } else {
                            p.save(conn);
                        }
                    }
                    
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
}
