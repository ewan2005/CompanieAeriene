package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ModePaiement {
    private int idPaiement;
    private String mode;

    public ModePaiement() {}
    public ModePaiement(String mode) { this.mode = mode; }
    public ModePaiement(int idPaiement, String mode) { this.idPaiement = idPaiement; this.mode = mode; }

    public int getIdPaiement() { return idPaiement; }
    public void setIdPaiement(int idPaiement) { this.idPaiement = idPaiement; }
    public String getMode() { return mode; }
    public void setMode(String mode) { this.mode = mode; }

    public void save() throws SQLException { Connection conn = DB.getconnect(); try { save(conn);} finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO modePaiement (mode) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.mode);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idPaiement = rs.getInt(1); }
        }
    }

    public static ModePaiement findById(int id) throws SQLException { Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); } }

    public static ModePaiement findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM modePaiement WHERE idPaiement = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, id); try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return new ModePaiement(rs.getInt("idPaiement"), rs.getString("mode")); } }
        return null;
    }

    public static List<ModePaiement> findAll() throws SQLException { Connection conn = DB.getconnect(); try { return findAll(conn);} finally { if (conn != null) conn.close(); } }

    public static List<ModePaiement> findAll(Connection conn) throws SQLException {
        List<ModePaiement> list = new ArrayList<>();
        String q = "SELECT * FROM modePaiement";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) { while (rs.next()) list.add(new ModePaiement(rs.getInt("idPaiement"), rs.getString("mode"))); }
        return list;
    }
}
