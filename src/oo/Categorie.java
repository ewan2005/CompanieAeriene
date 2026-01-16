package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Categorie {
    private int idCategorie;
    private String libelle;

    public Categorie() {}

    public Categorie(int idCategorie, String libelle) {
        this.idCategorie = idCategorie;
        this.libelle = libelle;
    }

    public int getIdCategorie() { return idCategorie; }
    public void setIdCategorie(int idCategorie) { this.idCategorie = idCategorie; }
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }

    public static List<Categorie> findAll() throws SQLException {
        Connection conn = DB.getconnect();
        try { return findAll(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<Categorie> findAll(Connection conn) throws SQLException {
        List<Categorie> list = new ArrayList<>();
        String q = "SELECT idcategorie, libelle FROM categorie ORDER BY idcategorie";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) list.add(new Categorie(rs.getInt(1), rs.getString(2)));
        }
        return list;
    }

    public static Categorie findByLibelle(String libelle) throws SQLException {
        Connection conn = DB.getconnect();
        try { return findByLibelle(conn, libelle); } finally { if (conn != null) conn.close(); }
    }

    public static Categorie findByLibelle(Connection conn, String libelle) throws SQLException {
        String q = "SELECT idcategorie, libelle FROM categorie WHERE libelle = ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setString(1, libelle);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new Categorie(rs.getInt(1), rs.getString(2));
            }
        }
        return null;
    }
}
