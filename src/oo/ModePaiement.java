package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ModePaiement {
    private int idModePaiement;
    private String libelle;

    public ModePaiement() {}
    public ModePaiement(String libelle) { this.libelle = libelle; }
    public ModePaiement(int idModePaiement, String libelle) { this.idModePaiement = idModePaiement; this.libelle = libelle; }

    public int getIdModePaiement() { return idModePaiement; }
    public void setIdModePaiement(int idModePaiement) { this.idModePaiement = idModePaiement; }
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    // Compatibilité JSP: ancien nom "nom"
    public String getNom() { return libelle; }

    public void save() throws SQLException { Connection conn = DB.getconnect(); try { save(conn);} finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO modepaiement (libelle) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.libelle);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idModePaiement = rs.getInt(1); }
        }
    }

    public static ModePaiement findById(int id) throws SQLException { Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); } }

    public static ModePaiement findById(Connection conn, int id) throws SQLException {
        String q = "SELECT idmodepaiement, libelle FROM modepaiement WHERE idmodepaiement = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new ModePaiement(rs.getInt("idmodepaiement"), rs.getString("libelle"));
            }
        }
        return null;
    }

    public static List<ModePaiement> findAll() throws SQLException { Connection conn = DB.getconnect(); try { return findAll(conn);} finally { if (conn != null) conn.close(); } }

    public static List<ModePaiement> findAll(Connection conn) throws SQLException {
        List<ModePaiement> list = new ArrayList<>();
        String q = "SELECT idmodepaiement, libelle FROM modepaiement ORDER BY libelle";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) list.add(new ModePaiement(rs.getInt("idmodepaiement"), rs.getString("libelle")));
        }
        return list;
    }
}
