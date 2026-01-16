package oo;

import utils.DB;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Billet {
    private int idBillet;
    private BigDecimal prix;
    private String classe;
    private int idReservation;
    private int idPaiement;

    public Billet() {}

    public Billet(BigDecimal prix, String classe, int idReservation, int idPaiement) {
        this.prix = prix; 
        this.classe = classe; 
        this.idReservation = idReservation; 
        this.idPaiement = idPaiement;
    }

    public Billet(int idBillet, BigDecimal prix, String classe, int idReservation, int idPaiement) { 
        this(prix, classe, idReservation, idPaiement); 
        this.idBillet = idBillet; 
    }

    // getters/setters
    public int getIdBillet() { return idBillet; }
    public void setIdBillet(int idBillet) { this.idBillet = idBillet; }
    public BigDecimal getPrix() { return prix; }
    public void setPrix(BigDecimal prix) { this.prix = prix; }
    public String getClasse() { return classe; }
    public void setClasse(String classe) { this.classe = classe; }
    public int getIdReservation() { return idReservation; }
    public void setIdReservation(int idReservation) { this.idReservation = idReservation; }
    public int getIdPaiement() { return idPaiement; }
    public void setIdPaiement(int idPaiement) { this.idPaiement = idPaiement; }

    public void save() throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { save(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void save(Connection conn) throws SQLException {
        // Vérifier que la réservation existe
        Reservation res = Reservation.findById(conn, this.idReservation);
        if (res == null) throw new SQLException("Réservation introuvable pour idReservation=" + this.idReservation);

        // Vérifier qu'il n'y a pas déjà un billet pour cette réservation
        String checkQ = "SELECT idBillet FROM billet WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkQ)) {
            ps.setInt(1, this.idReservation);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) throw new SQLException("Un billet existe déjà pour cette réservation.");
            }
        }

        String q = "INSERT INTO billet (prix, classe, idReservation, idPaiement) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setBigDecimal(1, this.prix);
            ps.setString(2, this.classe);
            ps.setInt(3, this.idReservation);
            if (this.idPaiement > 0) ps.setInt(4, this.idPaiement); else ps.setNull(4, Types.INTEGER);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idBillet = rs.getInt(1); }
        }
    }

    public static Billet findById(int id) throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { return findById(conn, id); } finally { if (conn != null) conn.close(); } 
    }

    public static Billet findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM billet WHERE idBillet = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { 
            ps.setInt(1, id); 
            try (ResultSet rs = ps.executeQuery()) { 
                if (rs.next()) return new Billet(
                    rs.getInt("idBillet"), 
                    rs.getBigDecimal("prix"), 
                    rs.getString("classe"), 
                    rs.getInt("idReservation"), 
                    rs.getInt("idPaiement")
                ); 
            } 
        }
        return null;
    }

    public static List<Billet> findAll() throws SQLException {
        Connection conn = DB.getconnect();
        try { return findAll(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<Billet> findAll(Connection conn) throws SQLException {
        List<Billet> list = new ArrayList<>();
        String q = "SELECT * FROM billet ORDER BY idBillet DESC";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) list.add(new Billet(
                rs.getInt("idBillet"), 
                rs.getBigDecimal("prix"), 
                rs.getString("classe"), 
                rs.getInt("idReservation"), 
                rs.getInt("idPaiement")
            ));
        }
        return list;
    }

    public void update() throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { update(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void update(Connection conn) throws SQLException {
        String q = "UPDATE billet SET prix = ?, classe = ?, idReservation = ?, idPaiement = ? WHERE idBillet = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setBigDecimal(1, this.prix);
            ps.setString(2, this.classe);
            ps.setInt(3, this.idReservation);
            if (this.idPaiement > 0) ps.setInt(4, this.idPaiement); else ps.setNull(4, Types.INTEGER);
            ps.setInt(5, this.idBillet);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { delete(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void delete(Connection conn) throws SQLException { 
        String q = "DELETE FROM billet WHERE idBillet = ?"; 
        try (PreparedStatement ps = conn.prepareStatement(q)) { 
            ps.setInt(1, this.idBillet); 
            ps.executeUpdate(); 
        } 
    }

    // Classe utilitaire pour afficher les billets avec tous les détails
    public static class BilletDetail {
        private final int idBillet;
        private final BigDecimal prix;
        private final String classe;
        private final int idReservation;
        private final Timestamp dateReservation;
        private final String numeroVol;
        private final String trajetDepart;
        private final String trajetArrivee;
        private final String avionCode;
        private final int numeroPlace;
        private final String passagerNom;
        private final String passagerPrenom;
        private final int idPaiement;
        private final BigDecimal montantPaiement;
        private final Timestamp datePaiement;

        public BilletDetail(int idBillet, BigDecimal prix, String classe, int idReservation, Timestamp dateReservation,
                  String numeroVol, String trajetDepart, String trajetArrivee, String avionCode,
                          int numeroPlace, String passagerNom, String passagerPrenom,
                          int idPaiement, BigDecimal montantPaiement, Timestamp datePaiement) {
            this.idBillet = idBillet;
            this.prix = prix;
            this.classe = classe;
            this.idReservation = idReservation;
            this.dateReservation = dateReservation;
            this.numeroVol = numeroVol;
            this.trajetDepart = trajetDepart;
            this.trajetArrivee = trajetArrivee;
            this.avionCode = avionCode;
            this.numeroPlace = numeroPlace;
            this.passagerNom = passagerNom;
            this.passagerPrenom = passagerPrenom;
            this.idPaiement = idPaiement;
            this.montantPaiement = montantPaiement;
            this.datePaiement = datePaiement;
        }

        public int getIdBillet() { return idBillet; }
        public BigDecimal getPrix() { return prix; }
        public String getClasse() { return classe; }
        public int getIdReservation() { return idReservation; }
        public Timestamp getDateReservation() { return dateReservation; }
        public String getNumeroVol() { return numeroVol; }
        public String getTrajetDepart() { return trajetDepart; }
        public String getTrajetArrivee() { return trajetArrivee; }
        public String getAvionCode() { return avionCode; }
        public int getNumeroPlace() { return numeroPlace; }
        public String getPassagerNom() { return passagerNom; }
        public String getPassagerPrenom() { return passagerPrenom; }
        public int getIdPaiement() { return idPaiement; }
        public BigDecimal getMontantPaiement() { return montantPaiement; }
        public Timestamp getDatePaiement() { return datePaiement; }
    }

    public static List<BilletDetail> findAllDetailed() throws SQLException {
        Connection conn = DB.getconnect();
        try { return findAllDetailed(conn); } finally { if (conn != null) conn.close(); }
    }

    // Informations tarifaires calculées pour une réservation (tarif de base, remise et prix final)
    public static class PriceInfo {
        public final java.math.BigDecimal tarifBase;
        public final java.math.BigDecimal remise;
        public final java.math.BigDecimal prixFinal;
        public final String classe;

        public PriceInfo(java.math.BigDecimal tarifBase, java.math.BigDecimal remise, java.math.BigDecimal prixFinal, String classe) {
            this.tarifBase = tarifBase; this.remise = remise; this.prixFinal = prixFinal; this.classe = classe;
        }
    }

    public static PriceInfo computePriceForReservation(int idReservation) throws SQLException {
        Connection conn = DB.getconnect();
        try {
            String q = "SELECT tc.tarif AS tarif, COALESCE(rc.montant_remise, 0) AS remise, tc.type_place AS type_place, c.libelle AS categorie_libelle " +
                       "FROM reservation r " +
                       "JOIN place p ON r.idplace = p.idplace " +
                       "JOIN tarif_classe tc ON tc.type_place = p.type_place " +
                       "LEFT JOIN remise_categorie rc ON rc.type_place = tc.type_place AND rc.idcategorie = r.idcategorie " +
                       "LEFT JOIN categorie c ON c.idcategorie = r.idcategorie " +
                       "WHERE r.idreservation = ? LIMIT 1";
            try (PreparedStatement ps = conn.prepareStatement(q)) {
                ps.setInt(1, idReservation);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        java.math.BigDecimal tarif = rs.getBigDecimal("tarif");
                        java.math.BigDecimal remise = rs.getBigDecimal("remise");
                        String typePlace = rs.getString("type_place");
                        String categorieLibelle = rs.getString("categorie_libelle");
                            java.math.BigDecimal prix;
                            // Business rules:
                            // - If there is a remise and the reservation category is 'bebe' => montant_remise stores the final fixed price for bebe (10% of adult tarif).
                            // - If there is a remise and either the type_place is 'economique' (for 'enfant' or other economy discounts) => use montant_remise as fixed final price.
                            // - Otherwise, treat remise as an absolute discount to subtract from tarif.
                            if (categorieLibelle != null && "bebe".equalsIgnoreCase(categorieLibelle)) {
                                prix = tarif.multiply(new java.math.BigDecimal("0.10")).setScale(2, RoundingMode.HALF_UP);
                            } else if (remise != null && remise.compareTo(java.math.BigDecimal.ZERO) > 0 && "economique".equalsIgnoreCase(typePlace)) {
                                // For economy class with a fixed remise (e.g., enfant), use the remise as final fixed price
                                prix = remise;
                            } else {
                                prix = tarif.subtract(remise == null ? java.math.BigDecimal.ZERO : remise);
                            }
                            if (prix.compareTo(java.math.BigDecimal.ZERO) < 0) prix = java.math.BigDecimal.ZERO;
                        String classe;
                        if ("premiere_classe".equalsIgnoreCase(typePlace)) classe = "Premiere Classe";
                        else if ("premium".equalsIgnoreCase(typePlace)) classe = "Premium";
                        else classe = "Economique";
                        return new PriceInfo(tarif, remise, prix, classe);
                    }
                }
            }
            return new PriceInfo(java.math.BigDecimal.ZERO, java.math.BigDecimal.ZERO, java.math.BigDecimal.ZERO, "N/A");
        } finally { if (conn != null) conn.close(); }
    }

    public static List<BilletDetail> findAllDetailed(Connection conn) throws SQLException {
        List<BilletDetail> list = new ArrayList<>();
        String q = 
            "SELECT b.idBillet, b.prix, b.classe, b.idReservation, r.dateReservation, " +
            "v.numeroVol, ad.ville || ' (' || ad.code || ')' AS trajetDepart, " +
            "aa.ville || ' (' || aa.code || ')' AS trajetArrivee, " +
            "av.code AS avionCode, p.numeroPlace, " +
            "pa.nom AS passagerNom, pa.prenom AS passagerPrenom, " +
            "COALESCE(b.idPaiement, 0) AS idPaiement, pay.montant AS montantPaiement, pay.datePaiement " +
            "FROM billet b " +
            "JOIN reservation r ON b.idReservation = r.idReservation " +
            "JOIN vol v ON r.idVol = v.idVol " +
            "JOIN trajet t ON v.idTrajet = t.idTrajet " +
            "JOIN aeroport ad ON t.idAeroportDepart = ad.idAeroport " +
            "JOIN aeroport aa ON t.idAeroportArrive = aa.idAeroport " +
            "JOIN avion av ON v.idAvion = av.idAvion " +
            "JOIN place p ON r.idPlace = p.idPlace " +
            "LEFT JOIN passager pa ON pa.idReservation = r.idReservation " +
            "LEFT JOIN paiement pay ON b.idPaiement = pay.idPaiement " +
            "ORDER BY b.idBillet DESC";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) {
                list.add(new BilletDetail(
                    rs.getInt("idBillet"),
                    rs.getBigDecimal("prix"),
                    rs.getString("classe"),
                    rs.getInt("idReservation"),
                    rs.getTimestamp("dateReservation"),
                    rs.getString("numeroVol"),
                    rs.getString("trajetDepart"),
                    rs.getString("trajetArrivee"),
                    rs.getString("avionCode"),
                    rs.getInt("numeroPlace"),
                    rs.getString("passagerNom"),
                    rs.getString("passagerPrenom"),
                    rs.getInt("idPaiement"),
                    rs.getBigDecimal("montantPaiement"),
                    rs.getTimestamp("datePaiement")
                ));
            }
        }
        return list;
    }

    /**
     * Calcule le chiffre d'affaires total
     */
    public static BigDecimal getChiffreAffaireTotal() throws SQLException {
        Connection conn = DB.getconnect();
        try { return getChiffreAffaireTotal(conn); } finally { if (conn != null) conn.close(); }
    }

    public static BigDecimal getChiffreAffaireTotal(Connection conn) throws SQLException {
        String q = "SELECT COALESCE(SUM(prix), 0) FROM billet";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            if (rs.next()) return rs.getBigDecimal(1);
        }
        return BigDecimal.ZERO;
    }

    /**
     * Calcule le chiffre d'affaires par trajet
     */
    public static class ChiffreAffaireTrajet {
        private final int idTrajet;
        private final String trajetDepart;
        private final String trajetArrivee;
        private final BigDecimal chiffreAffaire;
        private final int nbBillets;

        public ChiffreAffaireTrajet(int idTrajet, String trajetDepart, String trajetArrivee, BigDecimal chiffreAffaire, int nbBillets) {
            this.idTrajet = idTrajet;
            this.trajetDepart = trajetDepart;
            this.trajetArrivee = trajetArrivee;
            this.chiffreAffaire = chiffreAffaire;
            this.nbBillets = nbBillets;
        }

        public int getIdTrajet() { return idTrajet; }
        public String getTrajetDepart() { return trajetDepart; }
        public String getTrajetArrivee() { return trajetArrivee; }
        public BigDecimal getChiffreAffaire() { return chiffreAffaire; }
        public int getNbBillets() { return nbBillets; }
    }

    public static List<ChiffreAffaireTrajet> getChiffreAffaireParTrajet() throws SQLException {
        Connection conn = DB.getconnect();
        try { return getChiffreAffaireParTrajet(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<ChiffreAffaireTrajet> getChiffreAffaireParTrajet(Connection conn) throws SQLException {
        List<ChiffreAffaireTrajet> list = new ArrayList<>();
        String q = 
            "SELECT t.idTrajet, ad.ville || ' (' || ad.code || ')' AS trajetDepart, " +
            "aa.ville || ' (' || aa.code || ')' AS trajetArrivee, " +
            "COALESCE(SUM(b.prix), 0) AS ca, COUNT(b.idBillet) AS nb " +
            "FROM trajet t " +
            "JOIN aeroport ad ON t.idAeroportDepart = ad.idAeroport " +
            "JOIN aeroport aa ON t.idAeroportArrive = aa.idAeroport " +
            "LEFT JOIN vol v ON v.idTrajet = t.idTrajet " +
            "LEFT JOIN reservation r ON r.idVol = v.idVol " +
            "LEFT JOIN billet b ON b.idReservation = r.idReservation " +
            "GROUP BY t.idTrajet, ad.ville, ad.code, aa.ville, aa.code " +
            "ORDER BY ca DESC";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) {
                list.add(new ChiffreAffaireTrajet(
                    rs.getInt("idTrajet"),
                    rs.getString("trajetDepart"),
                    rs.getString("trajetArrivee"),
                    rs.getBigDecimal("ca"),
                    rs.getInt("nb")
                ));
            }
        }
        return list;
    }

    /**
     * Calcule le chiffre d'affaires par avion
     */
    public static class ChiffreAffaireAvion {
        private final int idAvion;
        private final String model;
        private final String code;
        private final BigDecimal chiffreAffaire;
        private final int nbBillets;

        public ChiffreAffaireAvion(int idAvion, String model, String code, BigDecimal chiffreAffaire, int nbBillets) {
            this.idAvion = idAvion;
            this.model = model;
            this.code = code;
            this.chiffreAffaire = chiffreAffaire;
            this.nbBillets = nbBillets;
        }

        public int getIdAvion() { return idAvion; }
        public String getModel() { return model; }
        public String getCode() { return code; }
        public BigDecimal getChiffreAffaire() { return chiffreAffaire; }
        public int getNbBillets() { return nbBillets; }
    }

    public static List<ChiffreAffaireAvion> getChiffreAffaireParAvion() throws SQLException {
        Connection conn = DB.getconnect();
        try { return getChiffreAffaireParAvion(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<ChiffreAffaireAvion> getChiffreAffaireParAvion(Connection conn) throws SQLException {
        List<ChiffreAffaireAvion> list = new ArrayList<>();
        String q = 
            "SELECT a.idAvion, a.modele AS model, a.code, " +
            "COALESCE(SUM(b.prix), 0) AS ca, COUNT(b.idBillet) AS nb " +
            "FROM avion a " +
            "LEFT JOIN vol v ON v.idAvion = a.idAvion " +
            "LEFT JOIN reservation r ON r.idVol = v.idVol " +
            "LEFT JOIN billet b ON b.idReservation = r.idReservation " +
            "GROUP BY a.idAvion, a.modele, a.code " +
            "ORDER BY ca DESC";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) {
                list.add(new ChiffreAffaireAvion(
                    rs.getInt("idAvion"),
                    rs.getString("model"),
                    rs.getString("code"),
                    rs.getBigDecimal("ca"),
                    rs.getInt("nb")
                ));
            }
        }
        return list;
    }
}
