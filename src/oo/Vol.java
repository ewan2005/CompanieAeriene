package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Vol {
    private int idVol;
    private String numeroVol;
    private Timestamp dateDepart;
    private Timestamp dateArrive;
    private Time heureDepart;
    private Time heureArrivee;
    private int idTrajet;
    private int idAvion;

    public Vol() {}

    public Vol(String numeroVol, Timestamp dateDepart, Timestamp dateArrive, Time heureDepart, Time heureArrivee, int idTrajet, int idAvion) {
        this.numeroVol = numeroVol;
        this.dateDepart = dateDepart;
        this.dateArrive = dateArrive;
        this.heureDepart = heureDepart;
        this.heureArrivee = heureArrivee;
        this.idTrajet = idTrajet;
        this.idAvion = idAvion;
    }

    public Vol(int idVol, String numeroVol, Timestamp dateDepart, Timestamp dateArrive, Time heureDepart, Time heureArrivee, int idTrajet, int idAvion) {
        this(numeroVol, dateDepart, dateArrive, heureDepart, heureArrivee, idTrajet, idAvion);
        this.idVol = idVol;
    }

    // getters / setters
    public int getIdVol() { return idVol; }
    public void setIdVol(int idVol) { this.idVol = idVol; }
    public String getNumeroVol() { return numeroVol; }
    public void setNumeroVol(String numeroVol) { this.numeroVol = numeroVol; }
    public Timestamp getDateDepart() { return dateDepart; }
    public void setDateDepart(Timestamp dateDepart) { this.dateDepart = dateDepart; }
    public Timestamp getDateArrive() { return dateArrive; }
    public void setDateArrive(Timestamp dateArrive) { this.dateArrive = dateArrive; }
    public Time getHeureDepart() { return heureDepart; }
    public void setHeureDepart(Time heureDepart) { this.heureDepart = heureDepart; }
    public Time getHeureArrivee() { return heureArrivee; }
    public void setHeureArrivee(Time heureArrivee) { this.heureArrivee = heureArrivee; }
    public int getIdTrajet() { return idTrajet; }
    public void setIdTrajet(int idTrajet) { this.idTrajet = idTrajet; }
    public int getIdAvion() { return idAvion; }
    public void setIdAvion(int idAvion) { this.idAvion = idAvion; }

    public void save() throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { save(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO Vol (numeroVol, dateDepart, dateArrive, heureDepart, heureArrivee, idTrajet, idAvion) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            if (this.numeroVol != null && !this.numeroVol.trim().isEmpty()) ps.setString(1, this.numeroVol.trim()); else ps.setNull(1, Types.VARCHAR);
            ps.setTimestamp(2, this.dateDepart);
            ps.setTimestamp(3, this.dateArrive);
            ps.setTime(4, this.heureDepart);
            ps.setTime(5, this.heureArrivee);
            ps.setInt(6, this.idTrajet);
            ps.setInt(7, this.idAvion);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idVol = rs.getInt(1); }
        }
    }

    public static Vol findById(int id) throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { return findById(conn, id); } finally { if (conn != null) conn.close(); } 
    }

    public static Vol findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM Vol WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { 
                if (rs.next()) return new Vol(
                    rs.getInt("idVol"), 
                    rs.getString("numeroVol"), 
                    rs.getTimestamp("dateDepart"), 
                    rs.getTimestamp("dateArrive"), 
                    rs.getTime("heureDepart"), 
                    rs.getTime("heureArrivee"), 
                    rs.getInt("idTrajet"), 
                    rs.getInt("idAvion")
                ); 
            }
        }
        return null;
    }

    public static List<Vol> findAll() throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { return findAll(conn); } finally { if (conn != null) conn.close(); } 
    }

    public static List<Vol> findAll(Connection conn) throws SQLException {
        List<Vol> list = new ArrayList<>();
        String q = "SELECT * FROM Vol ORDER BY idVol DESC";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) list.add(new Vol(
                rs.getInt("idVol"), 
                rs.getString("numeroVol"), 
                rs.getTimestamp("dateDepart"), 
                rs.getTimestamp("dateArrive"), 
                rs.getTime("heureDepart"), 
                rs.getTime("heureArrivee"), 
                rs.getInt("idTrajet"), 
                rs.getInt("idAvion")
            ));
        }
        return list;
    }

    public static List<Vol> findByTrajet(int idTrajet) throws SQLException {
        Connection conn = DB.getconnect();
        try { return findByTrajet(conn, idTrajet); } finally { if (conn != null) conn.close(); }
    }

    public static List<Vol> findByTrajet(Connection conn, int idTrajet) throws SQLException {
        List<Vol> list = new ArrayList<>();
        String q = "SELECT * FROM Vol WHERE idTrajet = ? ORDER BY dateDepart";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idTrajet);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(new Vol(
                    rs.getInt("idVol"),
                    rs.getString("numeroVol"),
                    rs.getTimestamp("dateDepart"),
                    rs.getTimestamp("dateArrive"),
                    rs.getTime("heureDepart"),
                    rs.getTime("heureArrivee"),
                    rs.getInt("idTrajet"),
                    rs.getInt("idAvion")
                ));
            }
        }
        return list;
    }

    public void update() throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { update(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void update(Connection conn) throws SQLException {
        String q = "UPDATE Vol SET numeroVol = ?, dateDepart = ?, dateArrive = ?, heureDepart = ?, heureArrivee = ?, idTrajet = ?, idAvion = ? WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            if (this.numeroVol != null && !this.numeroVol.trim().isEmpty()) ps.setString(1, this.numeroVol.trim()); else ps.setNull(1, Types.VARCHAR);
            ps.setTimestamp(2, this.dateDepart);
            ps.setTimestamp(3, this.dateArrive);
            ps.setTime(4, this.heureDepart);
            ps.setTime(5, this.heureArrivee);
            ps.setInt(6, this.idTrajet);
            ps.setInt(7, this.idAvion);
            ps.setInt(8, this.idVol);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { delete(conn); } finally { if (conn != null) conn.close(); } 
    }

    public void delete(Connection conn) throws SQLException {
        // Vérifier si des réservations existent
        String countQ = "SELECT COUNT(*) FROM reservation WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(countQ)) {
            ps.setInt(1, this.idVol);
            try (ResultSet rs = ps.executeQuery()) { 
                if (rs.next() && rs.getInt(1) > 0) 
                    throw new SQLException("Impossible de supprimer le vol: des réservations sont associées."); 
            }
        }

        String q = "DELETE FROM Vol WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { 
            ps.setInt(1, this.idVol); 
            ps.executeUpdate(); 
        }
    }

    public int countReservations(Connection conn) throws SQLException {
        String q = "SELECT COUNT(*) FROM reservation WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { 
            ps.setInt(1, this.idVol); 
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); } 
        }
        return 0;
    }

    // Classe utilitaire pour afficher les vols avec détails
    public static class VolDetail {
        private final int idVol;
        private final String numeroVol;
        private final Timestamp dateDepart;
        private final Timestamp dateArrive;
        private final Time heureDepart;
        private final Time heureArrivee;
        private final int idTrajet;
        private final String trajetDepart;
        private final String trajetArrivee;
        private final int idAvion;
        private final String avionModel;
        private final String avionCode;
        private final String avionCapacite;

        public VolDetail(int idVol, String numeroVol, Timestamp dateDepart, Timestamp dateArrive, 
                        Time heureDepart, Time heureArrivee, int idTrajet, String trajetDepart, 
                        String trajetArrivee, int idAvion, String avionModel, String avionCode, String avionCapacite) {
            this.idVol = idVol;
            this.numeroVol = numeroVol;
            this.dateDepart = dateDepart;
            this.dateArrive = dateArrive;
            this.heureDepart = heureDepart;
            this.heureArrivee = heureArrivee;
            this.idTrajet = idTrajet;
            this.trajetDepart = trajetDepart;
            this.trajetArrivee = trajetArrivee;
            this.idAvion = idAvion;
            this.avionModel = avionModel;
            this.avionCode = avionCode;
            this.avionCapacite = avionCapacite;
        }

        public int getIdVol() { return idVol; }
        public String getNumeroVol() { return numeroVol; }
        public Timestamp getDateDepart() { return dateDepart; }
        public Timestamp getDateArrive() { return dateArrive; }
        public Time getHeureDepart() { return heureDepart; }
        public Time getHeureArrivee() { return heureArrivee; }
        public int getIdTrajet() { return idTrajet; }
        public String getTrajetDepart() { return trajetDepart; }
        public String getTrajetArrivee() { return trajetArrivee; }
        public int getIdAvion() { return idAvion; }
        public String getAvionModel() { return avionModel; }
        public String getAvionCode() { return avionCode; }
        public String getAvionCapacite() { return avionCapacite; }
    }

    public static List<VolDetail> findAllDetailed() throws SQLException {
        Connection conn = DB.getconnect();
        try { return findAllDetailed(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<VolDetail> findAllDetailed(Connection conn) throws SQLException {
        List<VolDetail> list = new ArrayList<>();
        String q = 
            "SELECT v.idVol, v.numeroVol, v.dateDepart, v.dateArrive, v.heureDepart, v.heureArrivee, " +
            "v.idTrajet, ad.ville || ' (' || ad.code || ')' AS trajetDepart, aa.ville || ' (' || aa.code || ')' AS trajetArrivee, " +
            "v.idAvion, av.modele AS avionModel, av.code AS avionCode, av.capacite AS avionCapacite " +
            "FROM Vol v " +
            "JOIN trajet t ON v.idTrajet = t.idTrajet " +
            "JOIN aeroport ad ON t.idAeroportDepart = ad.idAeroport " +
            "JOIN aeroport aa ON t.idAeroportArrive = aa.idAeroport " +
            "JOIN avion av ON v.idAvion = av.idAvion " +
            "ORDER BY v.idVol DESC";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) {
                list.add(new VolDetail(
                    rs.getInt("idVol"),
                    rs.getString("numeroVol"),
                    rs.getTimestamp("dateDepart"),
                    rs.getTimestamp("dateArrive"),
                    rs.getTime("heureDepart"),
                    rs.getTime("heureArrivee"),
                    rs.getInt("idTrajet"),
                    rs.getString("trajetDepart"),
                    rs.getString("trajetArrivee"),
                    rs.getInt("idAvion"),
                    rs.getString("avionModel"),
                    rs.getString("avionCode"),
                    rs.getString("avionCapacite")
                ));
            }
        }
        return list;
    }

    public static Vol findByNumeroVol(String numeroVol) throws SQLException {
        if (numeroVol == null) return null;
        String nv = numeroVol.trim();
        if (nv.isEmpty()) return null;
        Connection conn = DB.getconnect();
        try { return findByNumeroVol(conn, nv); } finally { if (conn != null) conn.close(); }
    }

    public static Vol findByNumeroVol(Connection conn, String numeroVol) throws SQLException {
        String q = "SELECT * FROM Vol WHERE numeroVol = ? ORDER BY idVol DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setString(1, numeroVol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Vol(
                        rs.getInt("idVol"),
                        rs.getString("numeroVol"),
                        rs.getTimestamp("dateDepart"),
                        rs.getTimestamp("dateArrive"),
                        rs.getTime("heureDepart"),
                        rs.getTime("heureArrivee"),
                        rs.getInt("idTrajet"),
                        rs.getInt("idAvion")
                    );
                }
            }
        }
        return null;
    }
}
