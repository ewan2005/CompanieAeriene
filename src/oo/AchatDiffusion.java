package oo;

import utils.DB;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Représente un achat de diffusions publicitaires par une société pour un mois donné.
 * Une société achète X diffusions pour un mois, ces diffusions sont ensuite affectées aux vols.
 */
public class AchatDiffusion {
    private int idAchat;
    private int idSociete;
    private int mois;
    private int annee;
    private int nombreDiffusions;
    private BigDecimal coutUnitaire;
    private Timestamp dateCreation;

    // Objet lié (pour affichage)
    private Societe societe;

    // Tarif par défaut: 400 000 Ar
    public static final BigDecimal TARIF_DEFAULT = new BigDecimal("400000");

    public AchatDiffusion() {
        this.nombreDiffusions = 1;
        this.coutUnitaire = TARIF_DEFAULT;
    }

    public AchatDiffusion(int idSociete, int mois, int annee, int nombreDiffusions, BigDecimal coutUnitaire) {
        this.idSociete = idSociete;
        this.mois = mois;
        this.annee = annee;
        this.nombreDiffusions = nombreDiffusions;
        this.coutUnitaire = coutUnitaire;
    }

    // Getters et Setters
    public int getIdAchat() { return idAchat; }
    public void setIdAchat(int idAchat) { this.idAchat = idAchat; }
    public int getIdSociete() { return idSociete; }
    public void setIdSociete(int idSociete) { this.idSociete = idSociete; }
    public int getMois() { return mois; }
    public void setMois(int mois) { this.mois = mois; }
    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }
    public int getNombreDiffusions() { return nombreDiffusions; }
    public void setNombreDiffusions(int nombreDiffusions) { this.nombreDiffusions = nombreDiffusions; }
    public BigDecimal getCoutUnitaire() { return coutUnitaire; }
    public void setCoutUnitaire(BigDecimal coutUnitaire) { this.coutUnitaire = coutUnitaire; }
    public Timestamp getDateCreation() { return dateCreation; }
    public void setDateCreation(Timestamp dateCreation) { this.dateCreation = dateCreation; }
    public Societe getSociete() { return societe; }
    public void setSociete(Societe societe) { this.societe = societe; }

    // Calculer le montant total de cet achat
    public BigDecimal getMontantTotal() {
        return coutUnitaire.multiply(new BigDecimal(nombreDiffusions));
    }

    // Nom du mois en français
    public String getNomMois() {
        String[] moisNoms = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                            "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
        return mois >= 1 && mois <= 12 ? moisNoms[mois] : "";
    }

    // Période formatée
    public String getPeriode() {
        return getNomMois() + " " + annee;
    }

    // Calculer le montant total payé pour cet achat
    public BigDecimal getMontantPaye() throws SQLException {
        return PaiementSociete.getTotalPayeByAchat(idAchat);
    }

    // Calculer le reste à payer pour cet achat
    public BigDecimal getResteAPayer() throws SQLException {
        return getMontantTotal().subtract(getMontantPaye());
    }

    // CRUD Operations
    public void save() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            save(conn);
        }
    }

    public void save(Connection conn) throws SQLException {
        String sql = "INSERT INTO achat_diffusion (idsociete, mois, annee, nombre_diffusions, cout_unitaire) " +
                     "VALUES (?, ?, ?, ?, ?) RETURNING idachat";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSociete);
            ps.setInt(2, mois);
            ps.setInt(3, annee);
            ps.setInt(4, nombreDiffusions);
            ps.setBigDecimal(5, coutUnitaire);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    this.idAchat = rs.getInt(1);
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
        String sql = "UPDATE achat_diffusion SET idsociete = ?, mois = ?, annee = ?, " +
                     "nombre_diffusions = ?, cout_unitaire = ? WHERE idachat = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSociete);
            ps.setInt(2, mois);
            ps.setInt(3, annee);
            ps.setInt(4, nombreDiffusions);
            ps.setBigDecimal(5, coutUnitaire);
            ps.setInt(6, idAchat);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            delete(conn);
        }
    }

    public void delete(Connection conn) throws SQLException {
        String sql = "DELETE FROM achat_diffusion WHERE idachat = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            ps.executeUpdate();
        }
    }

    public static AchatDiffusion findById(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findById(conn, id);
        }
    }

    public static AchatDiffusion findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT a.*, s.nom as societe_nom FROM achat_diffusion a " +
                     "JOIN societe s ON a.idsociete = s.idsociete WHERE a.idachat = ?";
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

    public static List<AchatDiffusion> findAll() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAll(conn);
        }
    }

    public static List<AchatDiffusion> findAll(Connection conn) throws SQLException {
        List<AchatDiffusion> list = new ArrayList<>();
        String sql = "SELECT a.*, s.nom as societe_nom FROM achat_diffusion a " +
                     "JOIN societe s ON a.idsociete = s.idsociete ORDER BY a.annee DESC, a.mois DESC, s.nom";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    // Trouver les achats par mois/année
    public static List<AchatDiffusion> findByMoisAnnee(int mois, int annee) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findByMoisAnnee(conn, mois, annee);
        }
    }

    public static List<AchatDiffusion> findByMoisAnnee(Connection conn, int mois, int annee) throws SQLException {
        List<AchatDiffusion> list = new ArrayList<>();
        String sql = "SELECT a.*, s.nom as societe_nom FROM achat_diffusion a " +
                     "JOIN societe s ON a.idsociete = s.idsociete " +
                     "WHERE a.mois = ? AND a.annee = ? ORDER BY s.nom";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mois);
            ps.setInt(2, annee);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(fromResultSet(rs));
                }
            }
        }
        return list;
    }

    // Calculer le CA total pour un mois/année
    public static BigDecimal getCAByMoisAnnee(int mois, int annee) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getCAByMoisAnnee(conn, mois, annee);
        }
    }

    public static BigDecimal getCAByMoisAnnee(Connection conn, int mois, int annee) throws SQLException {
        String sql = "SELECT COALESCE(SUM(nombre_diffusions * cout_unitaire), 0) as ca_total " +
                     "FROM achat_diffusion WHERE mois = ? AND annee = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mois);
            ps.setInt(2, annee);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("ca_total");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // Nombre de diffusions déjà affectées à des vols
    public int getDiffusionsAffectees() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getDiffusionsAffectees(conn);
        }
    }

    public int getDiffusionsAffectees(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM diffusion_vol WHERE idachat = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // Diffusions restantes (non affectées)
    public int getDiffusionsRestantes() throws SQLException {
        return nombreDiffusions - getDiffusionsAffectees();
    }

    public int getDiffusionsRestantes(Connection conn) throws SQLException {
        return nombreDiffusions - getDiffusionsAffectees(conn);
    }

    private static AchatDiffusion fromResultSet(ResultSet rs) throws SQLException {
        AchatDiffusion a = new AchatDiffusion();
        a.setIdAchat(rs.getInt("idachat"));
        a.setIdSociete(rs.getInt("idsociete"));
        a.setMois(rs.getInt("mois"));
        a.setAnnee(rs.getInt("annee"));
        a.setNombreDiffusions(rs.getInt("nombre_diffusions"));
        a.setCoutUnitaire(rs.getBigDecimal("cout_unitaire"));
        a.setDateCreation(rs.getTimestamp("date_creation"));

        // Créer l'objet Societe avec le nom
        Societe s = new Societe();
        s.setIdSociete(a.getIdSociete());
        s.setNom(rs.getString("societe_nom"));
        a.setSociete(s);

        return a;
    }
}
