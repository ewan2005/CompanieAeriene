package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Passager {
    private int idPassager;
    private String nom;
    private String prenom;
    private Timestamp dateNaissance;
    private String numeroPasseport;
    private String nationnalite;
    private int idReservation;

    public Passager() {}

    public Passager(String nom, String prenom, Timestamp dateNaissance, String numeroPasseport, String nationnalite, int idReservation) {
        this.nom = nom; this.prenom = prenom; this.dateNaissance = dateNaissance; this.numeroPasseport = numeroPasseport; this.nationnalite = nationnalite; this.idReservation = idReservation;
    }

    public Passager(int idPassager, String nom, String prenom, Timestamp dateNaissance, String numeroPasseport, String nationnalite, int idReservation) {
        this(nom, prenom, dateNaissance, numeroPasseport, nationnalite, idReservation); this.idPassager = idPassager;
    }

    // getters/setters
    public int getIdPassager() { return idPassager; }
    public void setIdPassager(int idPassager) { this.idPassager = idPassager; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public Timestamp getDateNaissance() { return dateNaissance; }
    public void setDateNaissance(Timestamp dateNaissance) { this.dateNaissance = dateNaissance; }
    public String getNumeroPasseport() { return numeroPasseport; }
    public void setNumeroPasseport(String numeroPasseport) { this.numeroPasseport = numeroPasseport; }
    public String getNationnalite() { return nationnalite; }
    public void setNationnalite(String nationnalite) { this.nationnalite = nationnalite; }
    public int getIdReservation() { return idReservation; }
    public void setIdReservation(int idReservation) { this.idReservation = idReservation; }

    public void save() throws SQLException { Connection conn = DB.getconnect(); try { save(conn);} finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO passager (nom, prenom, dateNaissance, numeroPasseport, nationalite, idReservation) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.nom);
            ps.setString(2, this.prenom);
            ps.setTimestamp(3, this.dateNaissance);
            if (this.numeroPasseport != null && !this.numeroPasseport.trim().isEmpty()) ps.setString(4, this.numeroPasseport.trim()); else ps.setNull(4, Types.VARCHAR);
            ps.setString(5, this.nationnalite);
            ps.setInt(6, this.idReservation);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idPassager = rs.getInt(1); }
        }
    }

    public static Passager findById(int id) throws SQLException { Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); } }

    public static Passager findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM passager WHERE idPassager = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Passager(
                            rs.getInt("idPassager"),
                            rs.getString("nom"),
                            rs.getString("prenom"),
                            rs.getTimestamp("dateNaissance"),
                            rs.getString("numeroPasseport"),
                            rs.getString("nationalite"),
                            rs.getInt("idReservation")
                    );
                }
            }
        }
        return null;
    }

    public static List<Passager> findAll() throws SQLException { Connection conn = DB.getconnect(); try { return findAll(conn);} finally { if (conn != null) conn.close(); } }

    public static List<Passager> findAll(Connection conn) throws SQLException {
        List<Passager> list = new ArrayList<>();
        String q = "SELECT * FROM passager";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) {
                list.add(new Passager(
                        rs.getInt("idPassager"),
                        rs.getString("nom"),
                        rs.getString("prenom"),
                        rs.getTimestamp("dateNaissance"),
                        rs.getString("numeroPasseport"),
                        rs.getString("nationalite"),
                        rs.getInt("idReservation")
                ));
            }
        }
        return list;
    }

    public void update() throws SQLException { Connection conn = DB.getconnect(); try { update(conn);} finally { if (conn != null) conn.close(); } }

    public void update(Connection conn) throws SQLException {
        String q = "UPDATE passager SET nom = ?, prenom = ?, dateNaissance = ?, numeroPasseport = ?, nationalite = ?, idReservation = ? WHERE idPassager = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setString(1, this.nom);
            ps.setString(2, this.prenom);
            ps.setTimestamp(3, this.dateNaissance);
            if (this.numeroPasseport != null && !this.numeroPasseport.trim().isEmpty()) ps.setString(4, this.numeroPasseport.trim()); else ps.setNull(4, Types.VARCHAR);
            ps.setString(5, this.nationnalite);
            ps.setInt(6, this.idReservation);
            ps.setInt(7, this.idPassager);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { Connection conn = DB.getconnect(); try { delete(conn);} finally { if (conn != null) conn.close(); } }

    public void delete(Connection conn) throws SQLException { String q = "DELETE FROM passager WHERE idPassager = ?"; try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, this.idPassager); ps.executeUpdate(); } }

    public static List<Passager> findByNameOrPassport(Connection conn, String nameOrPassport) throws SQLException {
        List<Passager> list = new ArrayList<>();
        String q = "SELECT * FROM passager WHERE nom ILIKE ? OR numeroPasseport = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setString(1, "%" + nameOrPassport + "%");
            ps.setString(2, nameOrPassport);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Passager(
                            rs.getInt("idPassager"),
                            rs.getString("nom"),
                            rs.getString("prenom"),
                            rs.getTimestamp("dateNaissance"),
                            rs.getString("numeroPasseport"),
                            rs.getString("nationalite"),
                            rs.getInt("idReservation")
                    ));
                }
            }
        }
        return list;
    }

    public static List<Passager> findByNameOrPassport(String nameOrPassport) throws SQLException {
        Connection conn = DB.getconnect();
        try {
            return findByNameOrPassport(conn, nameOrPassport);
        } finally {
            if (conn != null) conn.close();
        }
    }
}
