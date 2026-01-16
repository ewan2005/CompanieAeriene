package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Reservation {
    private int idReservation;
    private Timestamp dateReservation;
    private int idVol;
    private int idPlace;
    private int idCategorie = 1; // 1 = adulte par défaut

    public Reservation() {}

    public Reservation(Timestamp dateReservation, int idVol, int idPlace, int idCategorie) {
        this.dateReservation = dateReservation;
        this.idVol = idVol;
        this.idPlace = idPlace;
        this.idCategorie = idCategorie;
    }

    public Reservation(int idReservation, Timestamp dateReservation, int idVol, int idPlace, int idCategorie) {
        this.idReservation = idReservation;
        this.dateReservation = dateReservation;
        this.idVol = idVol;
        this.idPlace = idPlace;
        this.idCategorie = idCategorie;
    }

    public int getIdReservation() { return idReservation; }
    public void setIdReservation(int idReservation) { this.idReservation = idReservation; }
    public Timestamp getDateReservation() { return dateReservation; }
    public void setDateReservation(Timestamp dateReservation) { this.dateReservation = dateReservation; }
    public int getIdVol() { return idVol; }
    public void setIdVol(int idVol) { this.idVol = idVol; }
    public int getIdPlace() { return idPlace; }
    public void setIdPlace(int idPlace) { this.idPlace = idPlace; }
    public int getIdCategorie() { return idCategorie; }
    public void setIdCategorie(int idCategorie) { this.idCategorie = idCategorie; }

    public void save() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); save(conn); } finally { if (conn != null) conn.close(); }
    }

    public void save(Connection conn) throws SQLException {
        // Vérifier que la place n'est pas déjà réservée pour ce vol
        String checkQ = "SELECT idReservation FROM reservation WHERE idVol = ? AND idPlace = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkQ)) {
            ps.setInt(1, this.idVol);
            ps.setInt(2, this.idPlace);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) throw new SQLException("Cette place est déjà réservée pour ce vol.");
            }
        }

        String query = "INSERT INTO reservation (dateReservation, idVol, idPlace, idcategorie) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setTimestamp(1, this.dateReservation);
            ps.setInt(2, this.idVol);
            ps.setInt(3, this.idPlace);
            ps.setInt(4, this.idCategorie);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idReservation = rs.getInt(1); }
        }
    }

    public static Reservation findById(int id) throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findById(conn, id); } finally { if (conn != null) conn.close(); }
    }

    public static Reservation findById(Connection conn, int id) throws SQLException {
        String query = "SELECT * FROM reservation WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new Reservation(
                    rs.getInt("idReservation"), 
                    rs.getTimestamp("dateReservation"), 
                    rs.getInt("idVol"), 
                    rs.getInt("idPlace"),
                    rs.getInt("idcategorie")
                );
            }
        }
        return null;
    }

    public static List<Reservation> findAll() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findAll(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<Reservation> findAll(Connection conn) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String query = "SELECT * FROM reservation ORDER BY idReservation DESC";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) list.add(new Reservation(
                rs.getInt("idReservation"), 
                rs.getTimestamp("dateReservation"), 
                rs.getInt("idVol"), 
                rs.getInt("idPlace"),
                rs.getInt("idcategorie")
            ));
        }
        return list;
    }

    /**
     * Retourne les réservations qui n'ont pas encore de billet (pour création de billet)
     */
    public static List<Reservation> findWithoutBillet() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findWithoutBillet(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<Reservation> findWithoutBillet(Connection conn) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String query = 
            "SELECT r.* FROM reservation r " +
            "WHERE NOT EXISTS (SELECT 1 FROM billet b WHERE b.idReservation = r.idReservation) " +
            "ORDER BY r.idReservation DESC";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) list.add(new Reservation(
                rs.getInt("idReservation"), 
                rs.getTimestamp("dateReservation"), 
                rs.getInt("idVol"), 
                rs.getInt("idPlace"),
                rs.getInt("idcategorie")
            ));
        }
        return list;
    }

    /**
     * Retourne les places déjà réservées pour un vol donné
     */
    public static List<Integer> findReservedPlaceIds(int idVol) throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findReservedPlaceIds(conn, idVol); } finally { if (conn != null) conn.close(); }
    }

    public static List<Integer> findReservedPlaceIds(Connection conn, int idVol) throws SQLException {
        List<Integer> list = new ArrayList<>();
        String query = "SELECT idPlace FROM reservation WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(rs.getInt("idPlace"));
            }
        }
        return list;
    }

    /**
     * Retourne les places réservées pour un vol, excluant une réservation spécifique (pour édition)
     */
    public static List<Integer> findReservedPlaceIdsExcluding(Connection conn, int idVol, int excludeReservationId) throws SQLException {
        List<Integer> list = new ArrayList<>();
        String query = "SELECT idPlace FROM reservation WHERE idVol = ? AND idReservation <> ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, idVol);
            ps.setInt(2, excludeReservationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(rs.getInt("idPlace"));
            }
        }
        return list;
    }

    public void update() throws SQLException { 
        Connection conn = null; 
        try { conn = DB.getconnect(); update(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void update(Connection conn) throws SQLException {
        // Vérifier que la place n'est pas déjà réservée par une autre réservation
        String checkQ = "SELECT idReservation FROM reservation WHERE idVol = ? AND idPlace = ? AND idReservation <> ?";
        try (PreparedStatement ps = conn.prepareStatement(checkQ)) {
            ps.setInt(1, this.idVol);
            ps.setInt(2, this.idPlace);
            ps.setInt(3, this.idReservation);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) throw new SQLException("Cette place est déjà réservée pour ce vol.");
            }
        }

        String query = "UPDATE reservation SET dateReservation = ?, idVol = ?, idPlace = ? WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setTimestamp(1, this.dateReservation);
            ps.setInt(2, this.idVol);
            ps.setInt(3, this.idPlace);
            ps.setInt(4, this.idReservation);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { 
        Connection conn = null; 
        try { conn = DB.getconnect(); delete(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void delete(Connection conn) throws SQLException {
        // Vérifier si un billet existe
        String checkQ = "SELECT COUNT(*) FROM billet WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(checkQ)) {
            ps.setInt(1, this.idReservation);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) 
                    throw new SQLException("Impossible de supprimer: un billet est associé à cette réservation.");
            }
        }

        // Supprimer le passager associé d'abord
        String delPassager = "DELETE FROM passager WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(delPassager)) {
            ps.setInt(1, this.idReservation);
            ps.executeUpdate();
        }

        String query = "DELETE FROM reservation WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) { 
            ps.setInt(1, this.idReservation); 
            ps.executeUpdate(); 
        }
    }

    // Classe utilitaire pour afficher les réservations avec tous les détails
    public static class ReservationDetail {
        private final int idReservation;
        private final Timestamp dateReservation;
        private final int idVol;
        private final String numeroVol;
        private final String trajetDepart;
        private final String trajetArrivee;
        private final String avionCode;
        private final int idPlace;
        private final int numeroPlace;
        private final String passagerNom;
        private final String passagerPrenom;
        private final String categorieLibelle;
        private final boolean hasBillet;

        public ReservationDetail(int idReservation, Timestamp dateReservation, int idVol, String numeroVol,
                                String trajetDepart, String trajetArrivee, String avionCode,
                                int idPlace, int numeroPlace, String passagerNom, String passagerPrenom, String categorieLibelle, boolean hasBillet) {
            this.idReservation = idReservation;
            this.dateReservation = dateReservation;
            this.idVol = idVol;
            this.numeroVol = numeroVol;
            this.trajetDepart = trajetDepart;
            this.trajetArrivee = trajetArrivee;
            this.avionCode = avionCode;
            this.idPlace = idPlace;
            this.numeroPlace = numeroPlace;
            this.passagerNom = passagerNom;
            this.passagerPrenom = passagerPrenom;
            this.categorieLibelle = categorieLibelle;
            this.hasBillet = hasBillet;
        }

        public int getIdReservation() { return idReservation; }
        public Timestamp getDateReservation() { return dateReservation; }
        public int getIdVol() { return idVol; }
        public String getNumeroVol() { return numeroVol; }
        public String getTrajetDepart() { return trajetDepart; }
        public String getTrajetArrivee() { return trajetArrivee; }
        public String getAvionCode() { return avionCode; }
        public int getIdPlace() { return idPlace; }
        public int getNumeroPlace() { return numeroPlace; }
        public String getPassagerNom() { return passagerNom; }
        public String getPassagerPrenom() { return passagerPrenom; }
        public String getCategorieLibelle() { return categorieLibelle; }
        public boolean isHasBillet() { return hasBillet; }
    }

    public static List<ReservationDetail> findAllDetailed() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findAllDetailed(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<ReservationDetail> findAllDetailed(Connection conn) throws SQLException {
        List<ReservationDetail> list = new ArrayList<>();
        String query = 
            "SELECT r.idReservation, r.dateReservation, r.idVol, v.numeroVol, " +
            "ad.ville || ' (' || ad.code || ')' AS trajetDepart, " +
            "aa.ville || ' (' || aa.code || ')' AS trajetArrivee, " +
            "av.code AS avionCode, r.idPlace, p.numeroPlace, " +
            "pa.nom AS passagerNom, pa.prenom AS passagerPrenom, " +
            "c.libelle AS categorieLibelle, " +
            "(SELECT COUNT(*) FROM billet b WHERE b.idReservation = r.idReservation) > 0 AS hasBillet " +
            "FROM reservation r " +
            "JOIN vol v ON r.idVol = v.idVol " +
            "JOIN trajet t ON v.idTrajet = t.idTrajet " +
            "JOIN aeroport ad ON t.idAeroportDepart = ad.idAeroport " +
            "JOIN aeroport aa ON t.idAeroportArrive = aa.idAeroport " +
            "JOIN avion av ON v.idAvion = av.idAvion " +
            "JOIN place p ON r.idPlace = p.idPlace " +
            "LEFT JOIN passager pa ON pa.idReservation = r.idReservation " +
            "LEFT JOIN categorie c ON c.idcategorie = r.idcategorie " +
            "ORDER BY r.idReservation DESC";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                list.add(new ReservationDetail(
                    rs.getInt("idReservation"),
                    rs.getTimestamp("dateReservation"),
                    rs.getInt("idVol"),
                    rs.getString("numeroVol"),
                    rs.getString("trajetDepart"),
                    rs.getString("trajetArrivee"),
                    rs.getString("avionCode"),
                    rs.getInt("idPlace"),
                    rs.getInt("numeroPlace"),
                    rs.getString("passagerNom"),
                    rs.getString("passagerPrenom"),
                    rs.getString("categorieLibelle"),
                    rs.getBoolean("hasBillet")
                ));
            }
        }
        return list;
    }

    /**
     * Retourne les réservations sans billet avec détails (pour le formulaire de billet)
     */
    public static List<ReservationDetail> findWithoutBilletDetailed() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findWithoutBilletDetailed(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<ReservationDetail> findWithoutBilletDetailed(Connection conn) throws SQLException {
        List<ReservationDetail> list = new ArrayList<>();
        String query = 
            "SELECT r.idReservation, r.dateReservation, r.idVol, v.numeroVol, " +
            "ad.ville || ' (' || ad.code || ')' AS trajetDepart, " +
            "aa.ville || ' (' || aa.code || ')' AS trajetArrivee, " +
            "av.code AS avionCode, r.idPlace, p.numeroPlace, " +
            "pa.nom AS passagerNom, pa.prenom AS passagerPrenom, " +
            "c.libelle AS categorieLibelle " +
            "FROM reservation r " +
            "JOIN vol v ON r.idVol = v.idVol " +
            "JOIN trajet t ON v.idTrajet = t.idTrajet " +
            "JOIN aeroport ad ON t.idAeroportDepart = ad.idAeroport " +
            "JOIN aeroport aa ON t.idAeroportArrive = aa.idAeroport " +
            "JOIN avion av ON v.idAvion = av.idAvion " +
            "JOIN place p ON r.idPlace = p.idPlace " +
            "LEFT JOIN passager pa ON pa.idReservation = r.idReservation " +
            "LEFT JOIN categorie c ON c.idcategorie = r.idcategorie " +
            "WHERE NOT EXISTS (SELECT 1 FROM billet b WHERE b.idReservation = r.idReservation) " +
            "ORDER BY r.idReservation DESC";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                list.add(new ReservationDetail(
                    rs.getInt("idReservation"),
                    rs.getTimestamp("dateReservation"),
                    rs.getInt("idVol"),
                    rs.getString("numeroVol"),
                    rs.getString("trajetDepart"),
                    rs.getString("trajetArrivee"),
                    rs.getString("avionCode"),
                    rs.getInt("idPlace"),
                    rs.getInt("numeroPlace"),
                    rs.getString("passagerNom"),
                    rs.getString("passagerPrenom"),
                    rs.getString("categorieLibelle"),
                    false
                ));
            }
        }
        return list;
    }
}
