package oo;

import utils.DB;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe représentant une vente de produit extra sur un vol.
 * Pas de logique de paiement, juste un enregistrement de vente.
 */
public class VenteProduitExtra {
    private int idVente;
    private int idProduit;
    private int idVol;
    private int quantite;
    private BigDecimal prixUnitaire;
    private Timestamp dateVente;
    private Timestamp dateCreation;

    // Champs additionnels pour l'affichage (jointures)
    private String produitNom;
    private String volNumero;

    public VenteProduitExtra() {
        this.quantite = 1;
    }

    public VenteProduitExtra(int idProduit, int idVol, int quantite, BigDecimal prixUnitaire) {
        this();
        this.idProduit = idProduit;
        this.idVol = idVol;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
    }

    public VenteProduitExtra(int idVente, int idProduit, int idVol, int quantite, 
                             BigDecimal prixUnitaire, Timestamp dateVente, Timestamp dateCreation) {
        this.idVente = idVente;
        this.idProduit = idProduit;
        this.idVol = idVol;
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
        this.dateVente = dateVente;
        this.dateCreation = dateCreation;
    }

    // Getters et Setters
    public int getIdVente() { return idVente; }
    public void setIdVente(int idVente) { this.idVente = idVente; }

    public int getIdProduit() { return idProduit; }
    public void setIdProduit(int idProduit) { this.idProduit = idProduit; }

    public int getIdVol() { return idVol; }
    public void setIdVol(int idVol) { this.idVol = idVol; }

    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }

    public BigDecimal getPrixUnitaire() { return prixUnitaire; }
    public void setPrixUnitaire(BigDecimal prixUnitaire) { this.prixUnitaire = prixUnitaire; }

    public Timestamp getDateVente() { return dateVente; }
    public void setDateVente(Timestamp dateVente) { this.dateVente = dateVente; }

    public Timestamp getDateCreation() { return dateCreation; }
    public void setDateCreation(Timestamp dateCreation) { this.dateCreation = dateCreation; }

    public String getProduitNom() { return produitNom; }
    public void setProduitNom(String produitNom) { this.produitNom = produitNom; }

    public String getVolNumero() { return volNumero; }
    public void setVolNumero(String volNumero) { this.volNumero = volNumero; }

    // Montant total de la vente
    public BigDecimal getMontantTotal() {
        if (prixUnitaire == null) return BigDecimal.ZERO;
        return prixUnitaire.multiply(new BigDecimal(quantite));
    }

    // ========================
    // Méthodes CRUD
    // ========================

    public void save() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            save(conn);
        }
    }

    public void save(Connection conn) throws SQLException {
        String sql = "INSERT INTO vente_produit_extra (idproduit, idvol, quantite, prix_unitaire, date_vente) VALUES (?, ?, ?, ?, COALESCE(?, CURRENT_TIMESTAMP))";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, this.idProduit);
            ps.setInt(2, this.idVol);
            ps.setInt(3, this.quantite);
            ps.setBigDecimal(4, this.prixUnitaire);
            if (this.dateVente != null) {
                ps.setTimestamp(5, this.dateVente);
            } else {
                ps.setNull(5, Types.TIMESTAMP);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    this.idVente = rs.getInt(1);
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
        String sql = "UPDATE vente_produit_extra SET idproduit = ?, idvol = ?, quantite = ?, prix_unitaire = ?, date_vente = ? WHERE idvente = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, this.idProduit);
            ps.setInt(2, this.idVol);
            ps.setInt(3, this.quantite);
            ps.setBigDecimal(4, this.prixUnitaire);
            ps.setTimestamp(5, this.dateVente);
            ps.setInt(6, this.idVente);
            ps.executeUpdate();
        }
    }

    public static void delete(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            delete(conn, id);
        }
    }

    public static void delete(Connection conn, int id) throws SQLException {
        String sql = "DELETE FROM vente_produit_extra WHERE idvente = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public static VenteProduitExtra findById(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findById(conn, id);
        }
    }

    public static VenteProduitExtra findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT v.*, p.nom AS produit_nom, vol.numerovol AS vol_numero " +
                     "FROM vente_produit_extra v " +
                     "JOIN produit_extra p ON v.idproduit = p.idproduit " +
                     "JOIN vol ON v.idvol = vol.idvol " +
                     "WHERE v.idvente = ?";
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

    public static List<VenteProduitExtra> findAll() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAll(conn);
        }
    }

    public static List<VenteProduitExtra> findAll(Connection conn) throws SQLException {
        List<VenteProduitExtra> list = new ArrayList<>();
        String sql = "SELECT v.*, p.nom AS produit_nom, vol.numerovol AS vol_numero " +
                     "FROM vente_produit_extra v " +
                     "JOIN produit_extra p ON v.idproduit = p.idproduit " +
                     "JOIN vol ON v.idvol = vol.idvol " +
                     "ORDER BY v.date_vente DESC";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    public static List<VenteProduitExtra> findByVol(int idVol) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findByVol(conn, idVol);
        }
    }

    public static List<VenteProduitExtra> findByVol(Connection conn, int idVol) throws SQLException {
        List<VenteProduitExtra> list = new ArrayList<>();
        String sql = "SELECT v.*, p.nom AS produit_nom, vol.numerovol AS vol_numero " +
                     "FROM vente_produit_extra v " +
                     "JOIN produit_extra p ON v.idproduit = p.idproduit " +
                     "JOIN vol ON v.idvol = vol.idvol " +
                     "WHERE v.idvol = ? " +
                     "ORDER BY v.date_vente DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(fromResultSet(rs));
                }
            }
        }
        return list;
    }

    /**
     * Calcule le CA total des produits extra pour un vol donné
     */
    public static BigDecimal getCAProduitsExtraByVol(int idVol) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getCAProduitsExtraByVol(conn, idVol);
        }
    }

    public static BigDecimal getCAProduitsExtraByVol(Connection conn, int idVol) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantite * prix_unitaire), 0) FROM vente_produit_extra WHERE idvol = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        }
        return BigDecimal.ZERO;
    }

    /**
     * Calcule le CA total des produits extra globalement
     */
    public static BigDecimal getCATotalProduitsExtra() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getCATotalProduitsExtra(conn);
        }
    }

    public static BigDecimal getCATotalProduitsExtra(Connection conn) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantite * prix_unitaire), 0) FROM vente_produit_extra";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    private static VenteProduitExtra fromResultSet(ResultSet rs) throws SQLException {
        VenteProduitExtra v = new VenteProduitExtra(
            rs.getInt("idvente"),
            rs.getInt("idproduit"),
            rs.getInt("idvol"),
            rs.getInt("quantite"),
            rs.getBigDecimal("prix_unitaire"),
            rs.getTimestamp("date_vente"),
            rs.getTimestamp("date_creation")
        );
        // Champs additionnels si présents
        try {
            v.setProduitNom(rs.getString("produit_nom"));
        } catch (SQLException ignored) {}
        try {
            v.setVolNumero(rs.getString("vol_numero"));
        } catch (SQLException ignored) {}
        return v;
    }
}
