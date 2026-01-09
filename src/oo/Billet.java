package oo;

import utils.DB;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Billet {
    private int idBillet;
    private BigDecimal prix;
    private String classe;
    private int idReservation;
    private int idVol;

    public Billet() {}

    public Billet(BigDecimal prix, String classe, int idReservation, int idVol) {
        this.prix = prix; this.classe = classe; this.idReservation = idReservation; this.idVol = idVol;
    }

    public Billet(int idBillet, BigDecimal prix, String classe, int idReservation, int idVol) { this(prix, classe, idReservation, idVol); this.idBillet = idBillet; }

    // getters/setters
    public int getIdBillet() { return idBillet; }
    public void setIdBillet(int idBillet) { this.idBillet = idBillet; }
    public BigDecimal getPrix() { return prix; }
    public void setPrix(BigDecimal prix) { this.prix = prix; }
    public String getClasse() { return classe; }
    public void setClasse(String classe) { this.classe = classe; }
    public int getIdReservation() { return idReservation; }
    public void setIdReservation(int idReservation) { this.idReservation = idReservation; }
    public int getIdVol() { return idVol; }
    public void setIdVol(int idVol) { this.idVol = idVol; }

    public void save() throws SQLException { Connection conn = DB.getconnect(); try { save(conn);} finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        // Verify that vol exists
        Vol vol = Vol.findById(conn, this.idVol);
        if (vol == null) throw new SQLException("Vol introuvable pour idVol=" + this.idVol);

        String q = "INSERT INTO billet (prix, classe, idReservation, idVol) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setBigDecimal(1, this.prix);
            ps.setString(2, this.classe);
            ps.setInt(3, this.idReservation);
            ps.setInt(4, this.idVol);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idBillet = rs.getInt(1); }
        }
    }

    public static Billet findById(int id) throws SQLException { Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); } }

    public static Billet findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM billet WHERE idBillet = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, id); try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return new Billet(rs.getInt("idBillet"), rs.getBigDecimal("prix"), rs.getString("classe"), rs.getInt("idReservation"), rs.getInt("idVol")); } }
        return null;
    }

    public static List<Billet> findAllByVol(Connection conn, int idVol) throws SQLException {
        List<Billet> list = new ArrayList<>();
        String q = "SELECT * FROM billet WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, idVol); try (ResultSet rs = ps.executeQuery()) { while (rs.next()) list.add(new Billet(rs.getInt("idBillet"), rs.getBigDecimal("prix"), rs.getString("classe"), rs.getInt("idReservation"), rs.getInt("idVol"))); } }
        return list;
    }

    public static List<Billet> findAllByVol(int idVol) throws SQLException {
        java.sql.Connection conn = DB.getconnect();
        try {
            return findAllByVol(conn, idVol);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public void update() throws SQLException { Connection conn = DB.getconnect(); try { update(conn);} finally { if (conn != null) conn.close(); } }

    public void update(Connection conn) throws SQLException {
        String q = "UPDATE billet SET prix = ?, classe = ?, idReservation = ?, idVol = ? WHERE idBillet = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setBigDecimal(1, this.prix);
            ps.setString(2, this.classe);
            ps.setInt(3, this.idReservation);
            ps.setInt(4, this.idVol);
            ps.setInt(5, this.idBillet);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { Connection conn = DB.getconnect(); try { delete(conn);} finally { if (conn != null) conn.close(); } }

    public void delete(Connection conn) throws SQLException { String q = "DELETE FROM billet WHERE idBillet = ?"; try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, this.idBillet); ps.executeUpdate(); } }
}
