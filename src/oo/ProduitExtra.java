package oo;

import utils.DB;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe représentant un produit extra vendu à bord des vols.
 * Exemples: tablette de chocolat, boissons, snacks, etc.
 */
public class ProduitExtra {
    private int idProduit;
    private String nom;
    private BigDecimal prix;
    private String description;
    private boolean actif;
    private Timestamp dateCreation;

    public ProduitExtra() {
        this.actif = true;
    }

    public ProduitExtra(String nom, BigDecimal prix, String description) {
        this();
        this.nom = nom;
        this.prix = prix;
        this.description = description;
    }

    public ProduitExtra(int idProduit, String nom, BigDecimal prix, String description, boolean actif, Timestamp dateCreation) {
        this.idProduit = idProduit;
        this.nom = nom;
        this.prix = prix;
        this.description = description;
        this.actif = actif;
        this.dateCreation = dateCreation;
    }

    // Getters et Setters
    public int getIdProduit() { return idProduit; }
    public void setIdProduit(int idProduit) { this.idProduit = idProduit; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public BigDecimal getPrix() { return prix; }
    public void setPrix(BigDecimal prix) { this.prix = prix; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }

    public Timestamp getDateCreation() { return dateCreation; }
    public void setDateCreation(Timestamp dateCreation) { this.dateCreation = dateCreation; }

    // ========================
    // Méthodes CRUD
    // ========================

    public void save() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            save(conn);
        }
    }

    public void save(Connection conn) throws SQLException {
        String sql = "INSERT INTO produit_extra (nom, prix, description, actif) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.nom);
            ps.setBigDecimal(2, this.prix);
            ps.setString(3, this.description);
            ps.setBoolean(4, this.actif);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    this.idProduit = rs.getInt(1);
                }
            }
        }
    }

    public void update() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            update(conn);
        }
    }

    public void update(Connection conn) throws SQLException {
        String sql = "UPDATE produit_extra SET nom = ?, prix = ?, description = ?, actif = ? WHERE idproduit = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, this.nom);
            ps.setBigDecimal(2, this.prix);
            ps.setString(3, this.description);
            ps.setBoolean(4, this.actif);
            ps.setInt(5, this.idProduit);
            ps.executeUpdate();
        }
    }

    public static void delete(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            delete(conn, id);
        }
    }

    public static void delete(Connection conn, int id) throws SQLException {
        String sql = "DELETE FROM produit_extra WHERE idproduit = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public static ProduitExtra findById(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findById(conn, id);
        }
    }

    public static ProduitExtra findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT * FROM produit_extra WHERE idproduit = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return fromResultSet(rs);
                }
            }
        }
        return null;
    }

    public static List<ProduitExtra> findAll() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAll(conn);
        }
    }

    public static List<ProduitExtra> findAll(Connection conn) throws SQLException {
        List<ProduitExtra> list = new ArrayList<>();
        String sql = "SELECT * FROM produit_extra ORDER BY nom";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    public static List<ProduitExtra> findAllActifs() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAllActifs(conn);
        }
    }

    public static List<ProduitExtra> findAllActifs(Connection conn) throws SQLException {
        List<ProduitExtra> list = new ArrayList<>();
        String sql = "SELECT * FROM produit_extra WHERE actif = true ORDER BY nom";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    private static ProduitExtra fromResultSet(ResultSet rs) throws SQLException {
        return new ProduitExtra(
            rs.getInt("idproduit"),
            rs.getString("nom"),
            rs.getBigDecimal("prix"),
            rs.getString("description"),
            rs.getBoolean("actif"),
            rs.getTimestamp("date_creation")
        );
    }
}
