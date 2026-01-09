package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Aeroport {
    private int idAeroport;
    private String nom;
    private String ville;
    private String code;

    public Aeroport() {}

    public Aeroport(String nom, String ville, String code) {
        this.nom = nom;
        this.ville = ville;
        this.code = code;
    }

    public Aeroport(int idAeroport, String nom, String ville, String code) {
        this.idAeroport = idAeroport;
        this.nom = nom;
        this.ville = ville;
        this.code = code;
    }

    public int getIdAeroport() { return idAeroport; }
    public void setIdAeroport(int idAeroport) { this.idAeroport = idAeroport; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public void save() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); save(conn); } finally { if (conn != null) conn.close(); }
    }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO aeroport (nom, ville, code) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.nom);
            ps.setString(2, this.ville);
            ps.setString(3, this.code);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idAeroport = rs.getInt(1); }
        }
    }

    public static Aeroport findById(int id) throws SQLException {
        Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); }
    }

    public static Aeroport findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM aeroport WHERE idAeroport = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return new Aeroport(rs.getInt("idAeroport"), rs.getString("nom"), rs.getString("ville"), rs.getString("code")); }
        }
        return null;
    }

    public static List<Aeroport> findAll() throws SQLException {
        Connection conn = DB.getconnect(); try { return findAll(conn);} finally { if (conn != null) conn.close(); }
    }

    public static List<Aeroport> findAll(Connection conn) throws SQLException {
        List<Aeroport> list = new ArrayList<>();
        String q = "SELECT * FROM aeroport";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) list.add(new Aeroport(rs.getInt("idAeroport"), rs.getString("nom"), rs.getString("ville"), rs.getString("code")));
        }
        return list;
    }

    public void update() throws SQLException { Connection conn = DB.getconnect(); try { update(conn);} finally { if (conn != null) conn.close(); } }

    public void update(Connection conn) throws SQLException {
        String q = "UPDATE aeroport SET nom = ?, ville = ?, code = ? WHERE idAeroport = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setString(1, this.nom);
            ps.setString(2, this.ville);
            ps.setString(3, this.code);
            ps.setInt(4, this.idAeroport);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { Connection conn = DB.getconnect(); try { delete(conn);} finally { if (conn != null) conn.close(); } }

    public void delete(Connection conn) throws SQLException {
        String q = "DELETE FROM aeroport WHERE idAeroport = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, this.idAeroport); ps.executeUpdate(); }
    }
}
