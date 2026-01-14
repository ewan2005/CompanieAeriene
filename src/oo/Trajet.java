package oo;

import utils.DB;
import utils.Schema;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Trajet {
    private int idTrajet;
    private int idAeroportDepart;
    private int idAeroportArrive;

    public Trajet() {}

    public Trajet(int idAeroportDepart, int idAeroportArrive) {
        this.idAeroportDepart = idAeroportDepart;
        this.idAeroportArrive = idAeroportArrive;
    }

    public Trajet(int idTrajet, int idAeroportDepart, int idAeroportArrive) {
        this(idAeroportDepart, idAeroportArrive);
        this.idTrajet = idTrajet;
    }

    public int getIdTrajet() { return idTrajet; }
    public void setIdTrajet(int idTrajet) { this.idTrajet = idTrajet; }
    public int getIdAeroportDepart() { return idAeroportDepart; }
    public void setIdAeroportDepart(int idAeroportDepart) { this.idAeroportDepart = idAeroportDepart; }
    public int getIdAeroportArrive() { return idAeroportArrive; }
    public void setIdAeroportArrive(int idAeroportArrive) { this.idAeroportArrive = idAeroportArrive; }

    public static boolean isAvailable(Connection conn) throws SQLException {
        return Schema.tableExists(conn, "trajet");
    }

    public void save() throws SQLException {
        Connection conn = DB.getconnect();
        try { save(conn); }
        finally { if (conn != null) conn.close(); }
    }

    public void save(Connection conn) throws SQLException {
        if (!isAvailable(conn)) return;
        String q = "INSERT INTO trajet (idAeroportDepart, idAeroportArrive) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, this.idAeroportDepart);
            ps.setInt(2, this.idAeroportArrive);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) this.idTrajet = rs.getInt(1);
            }
        }
    }

    public void update() throws SQLException {
        Connection conn = DB.getconnect();
        try { update(conn); }
        finally { if (conn != null) conn.close(); }
    }

    public void update(Connection conn) throws SQLException {
        if (!isAvailable(conn)) return;
        String q = "UPDATE trajet SET idAeroportDepart = ?, idAeroportArrive = ? WHERE idTrajet = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, this.idAeroportDepart);
            ps.setInt(2, this.idAeroportArrive);
            ps.setInt(3, this.idTrajet);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException {
        Connection conn = DB.getconnect();
        try { delete(conn); }
        finally { if (conn != null) conn.close(); }
    }

    public void delete(Connection conn) throws SQLException {
        if (!isAvailable(conn)) return;
        String q = "DELETE FROM trajet WHERE idTrajet = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, this.idTrajet);
            ps.executeUpdate();
        }
    }

    public static Trajet findById(int id) throws SQLException {
        Connection conn = DB.getconnect();
        try { return findById(conn, id); }
        finally { if (conn != null) conn.close(); }
    }

    public static Trajet findById(Connection conn, int id) throws SQLException {
        if (!isAvailable(conn)) return null;
        String q = "SELECT * FROM trajet WHERE idTrajet = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Trajet(rs.getInt("idTrajet"), rs.getInt("idAeroportDepart"), rs.getInt("idAeroportArrive"));
                }
            }
        }
        return null;
    }

    public static Trajet findOrCreate(Connection conn, int idAeroportDepart, int idAeroportArrive) throws SQLException {
        if (!isAvailable(conn)) return null;

        String findQ = "SELECT idTrajet FROM trajet WHERE idAeroportDepart = ? AND idAeroportArrive = ?";
        try (PreparedStatement ps = conn.prepareStatement(findQ)) {
            ps.setInt(1, idAeroportDepart);
            ps.setInt(2, idAeroportArrive);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Trajet(rs.getInt(1), idAeroportDepart, idAeroportArrive);
                }
            }
        }

        Trajet t = new Trajet(idAeroportDepart, idAeroportArrive);
        try {
            t.save(conn);
            return t;
        } catch (SQLException ex) {
            // In case of race (unique constraint), retry fetch
            try (PreparedStatement ps = conn.prepareStatement(findQ)) {
                ps.setInt(1, idAeroportDepart);
                ps.setInt(2, idAeroportArrive);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return new Trajet(rs.getInt(1), idAeroportDepart, idAeroportArrive);
                }
            }
            throw ex;
        }
    }

    public static class TrajetDetail {
        private final int idTrajet;
        private final int idAeroportDepart;
        private final String departCode;
        private final String departVille;
        private final int idAeroportArrive;
        private final String arriveCode;
        private final String arriveVille;

        public TrajetDetail(int idTrajet, int idAeroportDepart, String departCode, String departVille, int idAeroportArrive, String arriveCode, String arriveVille) {
            this.idTrajet = idTrajet;
            this.idAeroportDepart = idAeroportDepart;
            this.departCode = departCode;
            this.departVille = departVille;
            this.idAeroportArrive = idAeroportArrive;
            this.arriveCode = arriveCode;
            this.arriveVille = arriveVille;
        }

        public int getIdTrajet() { return idTrajet; }
        public int getIdAeroportDepart() { return idAeroportDepart; }
        public String getDepartCode() { return departCode; }
        public String getDepartVille() { return departVille; }
        public int getIdAeroportArrive() { return idAeroportArrive; }
        public String getArriveCode() { return arriveCode; }
        public String getArriveVille() { return arriveVille; }
    }

    public static List<TrajetDetail> findAllDetailed() throws SQLException {
        Connection conn = DB.getconnect();
        try { return findAllDetailed(conn); }
        finally { if (conn != null) conn.close(); }
    }

    public static List<TrajetDetail> findAllDetailed(Connection conn) throws SQLException {
        List<TrajetDetail> list = new ArrayList<>();
        if (!isAvailable(conn)) return list;

        String q =
                "SELECT t.idTrajet, t.idAeroportDepart, ad.code AS depart_code, ad.ville AS depart_ville, " +
                "t.idAeroportArrive, aa.code AS arrive_code, aa.ville AS arrive_ville " +
                "FROM trajet t " +
                "JOIN aeroport ad ON t.idAeroportDepart = ad.idAeroport " +
                "JOIN aeroport aa ON t.idAeroportArrive = aa.idAeroport " +
                "ORDER BY t.idTrajet";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) {
                list.add(new TrajetDetail(
                        rs.getInt("idTrajet"),
                        rs.getInt("idAeroportDepart"),
                        rs.getString("depart_code"),
                        rs.getString("depart_ville"),
                        rs.getInt("idAeroportArrive"),
                        rs.getString("arrive_code"),
                        rs.getString("arrive_ville")
                ));
            }
        }
        return list;
    }

    public static class ChiffreAffaireAvion {
        private final int idAvion;
        private final String model;
        private final String code;
        private final double chiffreAffaire;
        private final int nbBillets;

        public ChiffreAffaireAvion(int idAvion, String model, String code, double chiffreAffaire, int nbBillets) {
            this.idAvion = idAvion;
            this.model = model;
            this.code = code;
            this.chiffreAffaire = chiffreAffaire;
            this.nbBillets = nbBillets;
        }

        public int getIdAvion() { return idAvion; }
        public String getModel() { return model; }
        public String getCode() { return code; }
        public double getChiffreAffaire() { return chiffreAffaire; }
        public int getNbBillets() { return nbBillets; }
    }

    public static List<ChiffreAffaireAvion> getChiffreAffaireParAvion(Connection conn, int idTrajet) throws SQLException {
        List<ChiffreAffaireAvion> list = new ArrayList<>();

        String q =
            "SELECT a.idAvion, a.modele AS model, a.code, COALESCE(SUM(b.prix), 0) AS ca, COUNT(b.idBillet) AS nb " +
            "FROM vol v " +
            "JOIN avion a ON v.idAvion = a.idAvion " +
            "LEFT JOIN reservation r ON r.idVol = v.idVol " +
            "LEFT JOIN billet b ON b.idReservation = r.idReservation " +
            "WHERE v.idTrajet = ? " +
            "GROUP BY a.idAvion, a.modele, a.code " +
            "ORDER BY ca DESC";

        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idTrajet);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ChiffreAffaireAvion(
                            rs.getInt("idAvion"),
                            rs.getString("model"),
                            rs.getString("code"),
                            rs.getDouble("ca"),
                            rs.getInt("nb")
                    ));
                }
            }
        }
        return list;
    }
}
