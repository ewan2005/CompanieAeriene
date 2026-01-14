package oo;

import utils.DB;
import java.sql.*;

public class Paiement {
    private int idPaiement;
    private double montant;
    private Timestamp datePaiement;
    private Integer idModePaiement;

    public Paiement() {}

    public Paiement(int idPaiement, double montant, Timestamp datePaiement) {
        this.idPaiement = idPaiement;
        this.montant = montant;
        this.datePaiement = datePaiement;
    }

    public Paiement(int idPaiement, double montant, Timestamp datePaiement, Integer idModePaiement) {
        this.idPaiement = idPaiement;
        this.montant = montant;
        this.datePaiement = datePaiement;
        this.idModePaiement = idModePaiement;
    }

    public Paiement(double montant, Timestamp datePaiement) {
        this.montant = montant;
        this.datePaiement = datePaiement;
    }

    public Paiement(double montant, Timestamp datePaiement, Integer idModePaiement) {
        this.montant = montant;
        this.datePaiement = datePaiement;
        this.idModePaiement = idModePaiement;
    }

    public int getIdPaiement() { return idPaiement; }
    public void setIdPaiement(int idPaiement) { this.idPaiement = idPaiement; }
    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }
    public Timestamp getDatePaiement() { return datePaiement; }
    public void setDatePaiement(Timestamp datePaiement) { this.datePaiement = datePaiement; }

    public Integer getIdModePaiement() { return idModePaiement; }
    public void setIdModePaiement(Integer idModePaiement) { this.idModePaiement = idModePaiement; }

    public void save() throws SQLException { Connection conn = null; try { conn = DB.getconnect(); save(conn); } finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        String query = "INSERT INTO paiement (montant, datePaiement, idmodepaiement) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDouble(1, this.montant);
            ps.setTimestamp(2, this.datePaiement);
            if (this.idModePaiement == null || this.idModePaiement <= 0) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, this.idModePaiement);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idPaiement = rs.getInt(1); }
        }
    }

    public void update() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            update(conn);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public void update(Connection conn) throws SQLException {
        String query = "UPDATE paiement SET montant = ?, datePaiement = ?, idmodepaiement = ? WHERE idPaiement = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDouble(1, this.montant);
            ps.setTimestamp(2, this.datePaiement);
            if (this.idModePaiement == null || this.idModePaiement <= 0) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, this.idModePaiement);
            ps.setInt(4, this.idPaiement);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            delete(conn);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public void delete(Connection conn) throws SQLException {
        String query = "DELETE FROM paiement WHERE idPaiement = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, this.idPaiement);
            ps.executeUpdate();
        }
    }

    public static Paiement findById(int id) throws SQLException {
        java.sql.Connection conn = DB.getconnect();
        try {
            String q = "SELECT * FROM paiement WHERE idPaiement = ?";
            try (PreparedStatement ps = conn.prepareStatement(q)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Integer modeId = rs.getObject("idmodepaiement") != null ? rs.getInt("idmodepaiement") : null;
                        return new Paiement(rs.getInt("idPaiement"), rs.getDouble("montant"), rs.getTimestamp("datePaiement"), modeId);
                    }
                }
            }
        } finally { if (conn != null) conn.close(); }
        return null;
    }

    public static java.util.List<Paiement> findAll() throws SQLException {
        java.sql.Connection conn = DB.getconnect();
        try {
            java.util.List<Paiement> list = new java.util.ArrayList<>();
            String q = "SELECT * FROM paiement";
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
                while (rs.next()) {
                    Integer modeId = rs.getObject("idmodepaiement") != null ? rs.getInt("idmodepaiement") : null;
                    list.add(new Paiement(rs.getInt("idPaiement"), rs.getDouble("montant"), rs.getTimestamp("datePaiement"), modeId));
                }
            }
            return list;
        } finally { if (conn != null) conn.close(); }
    }
}
