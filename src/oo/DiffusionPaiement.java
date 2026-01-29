package oo;

import utils.DB;
import java.sql.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe pour gérer l'affichage des diffusions avec leurs paiements proportionnels.
 */
public class DiffusionPaiement {

    /**
     * Représente une diffusion avec ses détails de paiement
     */
    public static class DiffusionPaiementDetail {
        private final int idAchat;
        private final String societeNom;
        private final int mois;
        private final int annee;
        private final int nombreDiffusionsAchetees;
        private final int nombreDiffusionsAffectees;
        private final BigDecimal coutUnitaire;
        private final BigDecimal montantTotalDu;
        private final BigDecimal montantTotalPaye;
        private final BigDecimal resteAPayer;
        private final double pourcentagePaye;
        private final List<DiffusionVolDetail> diffusionsParVol;

        public DiffusionPaiementDetail(int idAchat, String societeNom, int mois, int annee,
                                       int nombreDiffusionsAchetees, int nombreDiffusionsAffectees,
                                       BigDecimal coutUnitaire, BigDecimal montantTotalDu,
                                       BigDecimal montantTotalPaye, List<DiffusionVolDetail> diffusionsParVol) {
            this.idAchat = idAchat;
            this.societeNom = societeNom;
            this.mois = mois;
            this.annee = annee;
            this.nombreDiffusionsAchetees = nombreDiffusionsAchetees;
            this.nombreDiffusionsAffectees = nombreDiffusionsAffectees;
            this.coutUnitaire = coutUnitaire != null ? coutUnitaire : BigDecimal.ZERO;
            this.montantTotalDu = montantTotalDu != null ? montantTotalDu : BigDecimal.ZERO;
            this.montantTotalPaye = montantTotalPaye != null ? montantTotalPaye : BigDecimal.ZERO;
            this.resteAPayer = this.montantTotalDu.subtract(this.montantTotalPaye);
            this.diffusionsParVol = diffusionsParVol != null ? diffusionsParVol : new ArrayList<>();
            
            // Calcul du pourcentage payé
            if (this.montantTotalDu.compareTo(BigDecimal.ZERO) > 0) {
                this.pourcentagePaye = this.montantTotalPaye
                    .multiply(new BigDecimal("100"))
                    .divide(this.montantTotalDu, 2, RoundingMode.HALF_UP)
                    .doubleValue();
            } else {
                this.pourcentagePaye = 0;
            }
        }

        // Getters
        public int getIdAchat() { return idAchat; }
        public String getSocieteNom() { return societeNom; }
        public int getMois() { return mois; }
        public int getAnnee() { return annee; }
        public int getNombreDiffusionsAchetees() { return nombreDiffusionsAchetees; }
        public int getNombreDiffusionsAffectees() { return nombreDiffusionsAffectees; }
        public BigDecimal getCoutUnitaire() { return coutUnitaire; }
        public BigDecimal getMontantTotalDu() { return montantTotalDu; }
        public BigDecimal getMontantTotalPaye() { return montantTotalPaye; }
        public BigDecimal getResteAPayer() { return resteAPayer; }
        public double getPourcentagePaye() { return pourcentagePaye; }
        public List<DiffusionVolDetail> getDiffusionsParVol() { return diffusionsParVol; }
        
        public String getMoisNom() {
            String[] moisNoms = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                                 "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
            return mois >= 1 && mois <= 12 ? moisNoms[mois] : "";
        }
    }

    /**
     * Représente les diffusions affectées à un vol spécifique
     */
    public static class DiffusionVolDetail {
        private final int idVol;
        private final String numeroVol;
        private final Date dateVol;
        private final Time heureVol;
        private final int nbDiffusions;
        private final BigDecimal montantDu;
        private final BigDecimal montantPaye;
        private final BigDecimal resteAPayer;

        public DiffusionVolDetail(int idVol, String numeroVol, Date dateVol, Time heureVol,
                                  int nbDiffusions, BigDecimal coutUnitaire, double pourcentagePaye) {
            this.idVol = idVol;
            this.numeroVol = numeroVol;
            this.dateVol = dateVol;
            this.heureVol = heureVol;
            this.nbDiffusions = nbDiffusions;
            this.montantDu = coutUnitaire.multiply(new BigDecimal(nbDiffusions));
            this.montantPaye = this.montantDu
                .multiply(new BigDecimal(pourcentagePaye))
                .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
            this.resteAPayer = this.montantDu.subtract(this.montantPaye);
        }

        public int getIdVol() { return idVol; }
        public String getNumeroVol() { return numeroVol; }
        public Date getDateVol() { return dateVol; }
        public Time getHeureVol() { return heureVol; }
        public int getNbDiffusions() { return nbDiffusions; }
        public BigDecimal getMontantDu() { return montantDu; }
        public BigDecimal getMontantPaye() { return montantPaye; }
        public BigDecimal getResteAPayer() { return resteAPayer; }
    }

    /**
     * Récupère toutes les diffusions avec leurs paiements
     */
    public static List<DiffusionPaiementDetail> getAllDiffusionsPaiements() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getAllDiffusionsPaiements(conn);
        }
    }

    public static List<DiffusionPaiementDetail> getAllDiffusionsPaiements(Connection conn) throws SQLException {
        List<DiffusionPaiementDetail> list = new ArrayList<>();
        
        // Requête pour obtenir tous les achats de diffusion avec paiements
        String sql = 
            "SELECT a.idachat, s.nom AS societe_nom, a.mois, a.annee, " +
            "       a.nombre_diffusions, a.cout_unitaire, " +
            "       (a.nombre_diffusions * a.cout_unitaire) AS montant_total_du, " +
            "       COALESCE((SELECT SUM(ps.montant) FROM paiement_societe ps WHERE ps.idachat = a.idachat), 0) AS montant_paye, " +
            "       (SELECT COUNT(*) FROM diffusion_vol dv WHERE dv.idachat = a.idachat) AS nb_diffusions_affectees " +
            "FROM achat_diffusion a " +
            "JOIN societe s ON a.idsociete = s.idsociete " +
            "ORDER BY a.annee DESC, a.mois DESC, s.nom";
        
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int idAchat = rs.getInt("idachat");
                String societeNom = rs.getString("societe_nom");
                int mois = rs.getInt("mois");
                int annee = rs.getInt("annee");
                int nombreDiffusions = rs.getInt("nombre_diffusions");
                int nbDiffusionsAffectees = rs.getInt("nb_diffusions_affectees");
                BigDecimal coutUnitaire = rs.getBigDecimal("cout_unitaire");
                BigDecimal montantTotalDu = rs.getBigDecimal("montant_total_du");
                BigDecimal montantPaye = rs.getBigDecimal("montant_paye");
                
                // Calculer le pourcentage payé pour cet achat
                double pourcentagePaye = 0;
                if (montantTotalDu.compareTo(BigDecimal.ZERO) > 0) {
                    pourcentagePaye = montantPaye
                        .multiply(new BigDecimal("100"))
                        .divide(montantTotalDu, 10, RoundingMode.HALF_UP)
                        .doubleValue();
                }
                
                // Récupérer les diffusions par vol pour cet achat
                List<DiffusionVolDetail> diffusionsParVol = getDiffusionsParVol(conn, idAchat, coutUnitaire, pourcentagePaye);
                
                list.add(new DiffusionPaiementDetail(
                    idAchat, societeNom, mois, annee,
                    nombreDiffusions, nbDiffusionsAffectees,
                    coutUnitaire, montantTotalDu, montantPaye,
                    diffusionsParVol
                ));
            }
        }
        return list;
    }

    /**
     * Récupère les diffusions par vol pour un achat donné
     */
    private static List<DiffusionVolDetail> getDiffusionsParVol(Connection conn, int idAchat, 
                                                                 BigDecimal coutUnitaire, double pourcentagePaye) throws SQLException {
        List<DiffusionVolDetail> list = new ArrayList<>();
        
        String sql = 
            "SELECT v.idvol, v.numerovol, v.datedepart, v.heuredepart, COUNT(dv.iddiffusion) AS nb_diff " +
            "FROM diffusion_vol dv " +
            "JOIN vol v ON dv.idvol = v.idvol " +
            "WHERE dv.idachat = ? " +
            "GROUP BY v.idvol, v.numerovol, v.datedepart, v.heuredepart " +
            "ORDER BY v.datedepart, v.heuredepart";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new DiffusionVolDetail(
                        rs.getInt("idvol"),
                        rs.getString("numerovol"),
                        rs.getDate("datedepart"),
                        rs.getTime("heuredepart"),
                        rs.getInt("nb_diff"),
                        coutUnitaire,
                        pourcentagePaye
                    ));
                }
            }
        }
        return list;
    }

    /**
     * Récupère les totaux globaux
     */
    public static BigDecimal[] getTotaux() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getTotaux(conn);
        }
    }

    public static BigDecimal[] getTotaux(Connection conn) throws SQLException {
        BigDecimal totalDu = BigDecimal.ZERO;
        BigDecimal totalPaye = BigDecimal.ZERO;
        
        String sql = 
            "SELECT " +
            "  COALESCE(SUM(a.nombre_diffusions * a.cout_unitaire), 0) AS total_du, " +
            "  COALESCE((SELECT SUM(ps.montant) FROM paiement_societe ps), 0) AS total_paye " +
            "FROM achat_diffusion a";
        
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                totalDu = rs.getBigDecimal("total_du");
                totalPaye = rs.getBigDecimal("total_paye");
            }
        }
        
        BigDecimal resteAPayer = totalDu.subtract(totalPaye);
        return new BigDecimal[] { totalDu, totalPaye, resteAPayer };
    }
}
