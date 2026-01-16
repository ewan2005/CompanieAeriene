package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import oo.Avion;
import oo.Place;
import oo.Categorie;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import utils.DB;
import utils.Web;
import java.sql.Connection;
import java.math.BigDecimal;

public class AvionServlet extends HttpServlet {

    // GET: list or show form
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Avion a = Avion.findById(id);
                request.setAttribute("avion", a);
                request.setAttribute("nbPlacesPremiereClasse", a.getNbPlacesPremiereClasse());
                request.setAttribute("nbPlacesEconomique", a.getNbPlacesEconomique());
                request.setAttribute("nbPlacesPremium", a.getNbPlacesPremium());
                request.getRequestDispatcher("formAvion.jsp").forward(request, response);
            } else if ("new".equals(action)) {
                request.getRequestDispatcher("formAvion.jsp").forward(request, response);
            } else if ("details".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Avion a = Avion.findById(id);
                request.setAttribute("avion", a);
                
                // Récupérer les tarifs globaux depuis la table tarif_classe ; fallback sur constantes
                BigDecimal tarifPremiereClasse = Place.TARIF_PREMIERE_CLASSE;
                BigDecimal tarifEconomique = Place.TARIF_ECONOMIQUE;
                BigDecimal tarifPremium = Place.TARIF_PREMIUM;
                try (java.sql.Connection c2 = DB.getconnect()) {
                    String tq = "SELECT type_place, tarif FROM tarif_classe WHERE type_place = ?";
                    try (java.sql.PreparedStatement ps = c2.prepareStatement(tq)) {
                        ps.setString(1, Place.TYPE_PREMIERE_CLASSE);
                        try (java.sql.ResultSet rs = ps.executeQuery()) { if (rs.next()) tarifPremiereClasse = rs.getBigDecimal("tarif"); }
                        ps.setString(1, Place.TYPE_ECONOMIQUE);
                        try (java.sql.ResultSet rs = ps.executeQuery()) { if (rs.next()) tarifEconomique = rs.getBigDecimal("tarif"); }
                        ps.setString(1, Place.TYPE_PREMIUM);
                        try (java.sql.ResultSet rs = ps.executeQuery()) { if (rs.next()) tarifPremium = rs.getBigDecimal("tarif"); }
                    }
                } catch (SQLException ex) {
                    // ignore and use defaults (constants)
                }
                
                // On utilise uniquement les tarifs définis dans la table `tarif_classe` (pas d'overrides par place).                
                request.setAttribute("tarifPremiereClasse", tarifPremiereClasse);
                request.setAttribute("tarifEconomique", tarifEconomique);
                request.setAttribute("tarifPremium", tarifPremium);
                request.setAttribute("valeurMaximale", a.getValeurMaximaleVol());
                request.setAttribute("nbPlacesPremiereClasse", a.getNbPlacesPremiereClasse());
                request.setAttribute("nbPlacesEconomique", a.getNbPlacesEconomique());
                request.setAttribute("nbPlacesPremium", a.getNbPlacesPremium());
                // Nombre de places déjà payées par classe (réservations avec billet)
                try {
                    request.setAttribute("nbPaidPremiere", oo.Place.countPaidByTypeAndAvion(a.getIdAvion(), Place.TYPE_PREMIERE_CLASSE));
                    request.setAttribute("nbPaidPremium", oo.Place.countPaidByTypeAndAvion(a.getIdAvion(), Place.TYPE_PREMIUM));
                    request.setAttribute("nbPaidEconomique", oo.Place.countPaidByTypeAndAvion(a.getIdAvion(), Place.TYPE_ECONOMIQUE));
                } catch (SQLException ex) {
                    request.setAttribute("nbPaidPremiere", 0);
                    request.setAttribute("nbPaidPremium", 0);
                    request.setAttribute("nbPaidEconomique", 0);
                }
                // Compteurs filtrés par catégorie (ex: 'enfant' et 'bebe') pour la classe économique
                int nbPaidEcoEnfant = 0;
                int nbPaidEcoBebe = 0;
                java.math.BigDecimal valeurEcoEnfant = java.math.BigDecimal.ZERO;
                java.math.BigDecimal valeurEcoBebe = java.math.BigDecimal.ZERO;
                try {
                    Categorie catEnfant = Categorie.findByLibelle("enfant");
                    if (catEnfant != null) {
                        int idCatEnfant = catEnfant.getIdCategorie();
                        nbPaidEcoEnfant = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_ECONOMIQUE, idCatEnfant);
                        valeurEcoEnfant = oo.Place.getValeurMaximaleByAvionAndCategorie(a.getIdAvion(), idCatEnfant);
                    }
                } catch (SQLException ex) {
                    nbPaidEcoEnfant = 0; valeurEcoEnfant = java.math.BigDecimal.ZERO;
                }
                try {
                    Categorie catBebe = Categorie.findByLibelle("bebe");
                    if (catBebe != null) {
                        int idCatBebe = catBebe.getIdCategorie();
                        nbPaidEcoBebe = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_ECONOMIQUE, idCatBebe);
                        valeurEcoBebe = oo.Place.getValeurMaximaleByAvionAndCategorieAndType(a.getIdAvion(), Place.TYPE_ECONOMIQUE, idCatBebe);
                        // Premiere and Premium: count bebe in those classes too
                        int nbPaidPremiereBebe = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_PREMIERE_CLASSE, idCatBebe);
                        java.math.BigDecimal valeurPremiereBebe = oo.Place.getValeurMaximaleByAvionAndCategorieAndType(a.getIdAvion(), Place.TYPE_PREMIERE_CLASSE, idCatBebe);
                        int nbPaidPremiumBebe = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_PREMIUM, idCatBebe);
                        java.math.BigDecimal valeurPremiumBebe = oo.Place.getValeurMaximaleByAvionAndCategorieAndType(a.getIdAvion(), Place.TYPE_PREMIUM, idCatBebe);
                        request.setAttribute("nbPaidPremiereBebe", nbPaidPremiereBebe);
                        request.setAttribute("valeurMaxPremiereBebe", valeurPremiereBebe);
                        request.setAttribute("nbPaidPremiumBebe", nbPaidPremiumBebe);
                        request.setAttribute("valeurMaxPremiumBebe", valeurPremiumBebe);
                    }
                } catch (SQLException ex) {
                    nbPaidEcoBebe = 0; valeurEcoBebe = java.math.BigDecimal.ZERO;
                }
                // Compute bebe/adult counts for Premiere and Premium classes (adults = total - bebe - enfant)
                try {
                    int totalPaidPremiere = oo.Place.countPaidByTypeAndAvion(a.getIdAvion(), Place.TYPE_PREMIERE_CLASSE);
                    int totalPaidPremium = oo.Place.countPaidByTypeAndAvion(a.getIdAvion(), Place.TYPE_PREMIUM);
                    int nbPremiereBebe = 0; int nbPremiereEnfant = 0; int nbPremiumBebe = 0; int nbPremiumEnfant = 0;
                    Categorie catEnfant2 = Categorie.findByLibelle("enfant");
                    Categorie catBebe2 = Categorie.findByLibelle("bebe");
                    if (catBebe2 != null) {
                        nbPremiereBebe = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_PREMIERE_CLASSE, catBebe2.getIdCategorie());
                        nbPremiumBebe = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_PREMIUM, catBebe2.getIdCategorie());
                    }
                    if (catEnfant2 != null) {
                        nbPremiereEnfant = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_PREMIERE_CLASSE, catEnfant2.getIdCategorie());
                        nbPremiumEnfant = oo.Place.countPaidByTypeAndAvionAndCategorie(a.getIdAvion(), Place.TYPE_PREMIUM, catEnfant2.getIdCategorie());
                    }
                    int nbPaidPremiereAdultes = totalPaidPremiere - nbPremiereBebe - nbPremiereEnfant; if (nbPaidPremiereAdultes < 0) nbPaidPremiereAdultes = 0;
                    int nbPaidPremiumAdultes = totalPaidPremium - nbPremiumBebe - nbPremiumEnfant; if (nbPaidPremiumAdultes < 0) nbPaidPremiumAdultes = 0;
                    request.setAttribute("nbPaidPremiereBebe", nbPremiereBebe);
                    request.setAttribute("nbPaidPremiereAdultes", nbPaidPremiereAdultes);
                    request.setAttribute("nbPaidPremiumBebe", nbPremiumBebe);
                    request.setAttribute("nbPaidPremiumAdultes", nbPaidPremiumAdultes);
                } catch (SQLException ex) {
                    request.setAttribute("nbPaidPremiereBebe", 0);
                    request.setAttribute("nbPaidPremiereAdultes", 0);
                    request.setAttribute("nbPaidPremiumBebe", 0);
                    request.setAttribute("nbPaidPremiumAdultes", 0);
                }
                // expose attributes
                request.setAttribute("nbPaidEconomiqueEnfant", nbPaidEcoEnfant);
                request.setAttribute("valeurMaxEconomiqueEnfant", valeurEcoEnfant);
                request.setAttribute("nbPaidEconomiqueBebe", nbPaidEcoBebe);
                request.setAttribute("valeurMaxEconomiqueBebe", valeurEcoBebe);
                // adultes = total paid economy - enfants - bebe
                try {
                    int totalPaidEco = oo.Place.countPaidByTypeAndAvion(a.getIdAvion(), Place.TYPE_ECONOMIQUE);
                    int nbPaidEcoAdultes = totalPaidEco - nbPaidEcoEnfant - nbPaidEcoBebe;
                    if (nbPaidEcoAdultes < 0) nbPaidEcoAdultes = 0;
                    request.setAttribute("nbPaidEconomiqueAdultes", nbPaidEcoAdultes);
                } catch (SQLException ex) {
                    request.setAttribute("nbPaidEconomiqueAdultes", 0);
                }
                try {
                    request.setAttribute("places", a.getPlaces());
                } catch (SQLException ex) {
                    request.setAttribute("places", new java.util.ArrayList<>());
                }
                
                request.getRequestDispatcher("detailAvion.jsp").forward(request, response);
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
        Connection conn = null;
        try {
            conn = DB.getconnect();
            conn.setAutoCommit(false);
            
            if ("create".equals(action)) {
                int nbPremiereClasse = 0;
                int nbEconomique = 0;
                int nbPremium = 0;
                try {
                    nbPremiereClasse = Integer.parseInt(request.getParameter("nbPlacesPremiereClasse"));
                } catch (NumberFormatException e) {}
                try {
                    nbEconomique = Integer.parseInt(request.getParameter("nbPlacesEconomique"));
                } catch (NumberFormatException e) {}
                try {
                    nbPremium = Integer.parseInt(request.getParameter("nbPlacesPremium"));
                } catch (NumberFormatException e) {}
                
                // Créer l'avion (capacité = somme des places)
                Avion a = new Avion(
                    request.getParameter("model"), 
                    String.valueOf(nbPremiereClasse + nbEconomique + nbPremium), 
                    request.getParameter("code")
                );
                a.save(conn);
                
                // Créer les places première classe
                for (int i = 1; i <= nbPremiereClasse; i++) {
                    Place p = new Place();
                    p.setNumeroPlace(i);
                    p.setTypePlace(Place.TYPE_PREMIERE_CLASSE);
                    p.setIdAvion(a.getIdAvion());
                    p.save(conn);
                }
                
                // Créer les places économique
                for (int i = nbPremiereClasse + 1; i <= nbPremiereClasse + nbEconomique; i++) {
                    Place p = new Place();
                    p.setNumeroPlace(i);
                    p.setTypePlace(Place.TYPE_ECONOMIQUE);
                    p.setIdAvion(a.getIdAvion());
                    p.save(conn);
                }

                // Créer les places premium
                for (int i = nbPremiereClasse + nbEconomique + 1; i <= nbPremiereClasse + nbEconomique + nbPremium; i++) {
                    Place p = new Place();
                    p.setNumeroPlace(i);
                    p.setTypePlace(Place.TYPE_PREMIUM);
                    p.setIdAvion(a.getIdAvion());
                    p.save(conn);
                }
                
                conn.commit();
                Web.redirectValidation(request, response, "Avion enregistré avec " + nbPremiereClasse + " places première classe, " + nbPremium + " places premium et " + nbEconomique + " places économique.", "/AvionServlet");
                return;
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idAvion"));
                int nbPremiereClasse = 0;
                int nbEconomique = 0;
                int nbPremium = 0;
                try {
                    nbPremiereClasse = Integer.parseInt(request.getParameter("nbPlacesPremiereClasse"));
                } catch (NumberFormatException e) {}
                try {
                    nbEconomique = Integer.parseInt(request.getParameter("nbPlacesEconomique"));
                } catch (NumberFormatException e) {}
                try {
                    nbPremium = Integer.parseInt(request.getParameter("nbPlacesPremium"));
                } catch (NumberFormatException e) {}
                
                // Mettre à jour l'avion
                Avion a = new Avion(
                    id, 
                    request.getParameter("model"), 
                    String.valueOf(nbPremiereClasse + nbEconomique + nbPremium), 
                    request.getParameter("code")
                );
                a.update(conn);
                
                // Supprimer les anciennes places
                String deleteQ = "DELETE FROM place WHERE idavion = ?";
                try (java.sql.PreparedStatement ps = conn.prepareStatement(deleteQ)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
                
                // Recréer les places première classe
                for (int i = 1; i <= nbPremiereClasse; i++) {
                    Place p = new Place();
                    p.setNumeroPlace(i);
                    p.setTypePlace(Place.TYPE_PREMIERE_CLASSE);
                    p.setIdAvion(id);
                    p.save(conn);
                }
                
                // Recréer les places économique
                for (int i = nbPremiereClasse + 1; i <= nbPremiereClasse + nbEconomique; i++) {
                    Place p = new Place();
                    p.setNumeroPlace(i);
                    p.setTypePlace(Place.TYPE_ECONOMIQUE);
                    p.setIdAvion(id);
                    p.save(conn);
                }

                // Recréer les places premium
                for (int i = nbPremiereClasse + nbEconomique + 1; i <= nbPremiereClasse + nbEconomique + nbPremium; i++) {
                    Place p = new Place();
                    p.setNumeroPlace(i);
                    p.setTypePlace(Place.TYPE_PREMIUM);
                    p.setIdAvion(id);
                    p.save(conn);
                }
                
                conn.commit();
                Web.redirectValidation(request, response, "Avion mis à jour.", "/AvionServlet");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("idAvion"));
                Avion a = new Avion();
                a.setIdAvion(id);
                a.delete(conn);
                conn.commit();
                Web.redirectValidation(request, response, "Avion supprimé.", "/AvionServlet");
                return;
            }

            conn.commit();
            Web.redirectValidation(request, response, "Opération terminée.", "/AvionServlet");
        } catch (SQLException | IllegalArgumentException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) {}
            }
            Web.redirectError(request, response, e.getMessage(), "/AvionServlet");
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) {}
            }
        }
    }
}
