package oo;

import utils.DB;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class PaiementSociete {
    private int idPaiement;
    private int idAchat;
    private BigDecimal montant;
    private Date datePaiement;
    private String reference;
    private Timestamp dateCreation;
    
    // Objets liés
    private AchatDiffusion achat;

    public PaiementSociete() {
        this.montant = BigDecimal.ZERO;
        this.datePaiement = new Date(System.currentTimeMillis());
    }

    // Getters et Setters
    public int getIdPaiement() { return idPaiement; }
    public void setIdPaiement(int idPaiement) { this.idPaiement = idPaiement; }
    
    public int getIdAchat() { return idAchat; }
    public void setIdAchat(int idAchat) { this.idAchat = idAchat; }
    
    public BigDecimal getMontant() { return montant; }
    public void setMontant(BigDecimal montant) { this.montant = montant; }
    
    public Date getDatePaiement() { return datePaiement; }
    public void setDatePaiement(Date datePaiement) { this.datePaiement = datePaiement; }
    
    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }
    
    public Timestamp getDateCreation() { return dateCreation; }
    public void setDateCreation(Timestamp dateCreation) { this.dateCreation = dateCreation; }
    
    public AchatDiffusion getAchat() throws SQLException {
        if (achat == null && idAchat > 0) {
            achat = AchatDiffusion.findById(idAchat);
        }
        return achat;
    }
    public void setAchat(AchatDiffusion achat) { this.achat = achat; }

    // CRUD Operations
    public void save() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            save(conn);
        }
    }

    public void save(Connection conn) throws SQLException {
        String sql = "INSERT INTO paiement_societe (idachat, montant, date_paiement, reference) VALUES (?, ?, ?, ?) RETURNING idpaiement";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            ps.setBigDecimal(2, montant);
            ps.setDate(3, datePaiement);
            ps.setString(4, reference);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    this.idPaiement = rs.getInt(1);
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
        String sql = "UPDATE paiement_societe SET idachat = ?, montant = ?, date_paiement = ?, reference = ? WHERE idpaiement = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            ps.setBigDecimal(2, montant);
            ps.setDate(3, datePaiement);
            ps.setString(4, reference);
            ps.setInt(5, idPaiement);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            delete(conn);
        }
    }

    public void delete(Connection conn) throws SQLException {
        String sql = "DELETE FROM paiement_societe WHERE idpaiement = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idPaiement);
            ps.executeUpdate();
        }
    }

    public static PaiementSociete findById(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findById(conn, id);
        }
    }

    public static PaiementSociete findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT * FROM paiement_societe WHERE idpaiement = ?";
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

    public static List<PaiementSociete> findAll() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAll(conn);
        }
    }

    public static List<PaiementSociete> findAll(Connection conn) throws SQLException {
        List<PaiementSociete> list = new ArrayList<>();
        String sql = "SELECT * FROM paiement_societe ORDER BY date_paiement DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    // Trouver tous les paiements pour un achat
    public static List<PaiementSociete> findByAchat(int idAchat) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findByAchat(conn, idAchat);
        }
    }

    public static List<PaiementSociete> findByAchat(Connection conn, int idAchat) throws SQLException {
        List<PaiementSociete> list = new ArrayList<>();
        String sql = "SELECT * FROM paiement_societe WHERE idachat = ? ORDER BY date_paiement DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(fromResultSet(rs));
                }
            }
        }
        return list;
    }

    // Total payé pour un achat
    public static BigDecimal getTotalPayeByAchat(int idAchat) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getTotalPayeByAchat(conn, idAchat);
        }
    }

    public static BigDecimal getTotalPayeByAchat(Connection conn, int idAchat) throws SQLException {
        String sql = "SELECT COALESCE(SUM(montant), 0) FROM paiement_societe WHERE idachat = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // Total payé par une société pour un mois/année
    public static BigDecimal getTotalPayeBySociete(int idSociete, int mois, int annee) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getTotalPayeBySociete(conn, idSociete, mois, annee);
        }
    }

    public static BigDecimal getTotalPayeBySociete(Connection conn, int idSociete, int mois, int annee) throws SQLException {
        String sql = "SELECT COALESCE(SUM(ps.montant), 0) FROM paiement_societe ps " +
                     "JOIN achat_diffusion a ON ps.idachat = a.idachat " +
                     "WHERE a.idsociete = ? AND a.mois = ? AND a.annee = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSociete);
            ps.setInt(2, mois);
            ps.setInt(3, annee);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        }
        return BigDecimal.ZERO;
    }

    private static PaiementSociete fromResultSet(ResultSet rs) throws SQLException {
        PaiementSociete p = new PaiementSociete();
        p.setIdPaiement(rs.getInt("idpaiement"));
        p.setIdAchat(rs.getInt("idachat"));
        p.setMontant(rs.getBigDecimal("montant"));
        p.setDatePaiement(rs.getDate("date_paiement"));
        p.setReference(rs.getString("reference"));
        p.setDateCreation(rs.getTimestamp("date_creation"));
        return p;
    }
}
