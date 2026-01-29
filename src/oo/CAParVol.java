package oo;

import utils.DB;
import java.sql.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/**
 * Classe pour calculer le Chiffre d'Affaires par vol.
 * Combine les recettes des billets vendus, des diffusions publicitaires et des produits extra.
 * Inclut le calcul des paiements de diffusion avec répartition proportionnelle.
 */
public class CAParVol {

    /**
     * Classe pour représenter le détail d'une diffusion par société
     */
    public static class DiffusionDetail {
        private final String societeNom;
        private final int nbDiffusions;
        private final BigDecimal coutUnitaire;
        private final BigDecimal montantDu;      // nb * cout unitaire
        private final BigDecimal montantPaye;    // montant payé proportionnel
        private final BigDecimal resteAPayer;    // montantDu - montantPaye

        public DiffusionDetail(String societeNom, int nbDiffusions, BigDecimal coutUnitaire,
                               BigDecimal montantDu, BigDecimal montantPaye) {
            this.societeNom = societeNom;
            this.nbDiffusions = nbDiffusions;
            this.coutUnitaire = coutUnitaire != null ? coutUnitaire : BigDecimal.ZERO;
            this.montantDu = montantDu != null ? montantDu : BigDecimal.ZERO;
            this.montantPaye = montantPaye != null ? montantPaye : BigDecimal.ZERO;
            this.resteAPayer = this.montantDu.subtract(this.montantPaye);
        }

        public String getSocieteNom() { return societeNom; }
        public int getNbDiffusions() { return nbDiffusions; }
        public BigDecimal getCoutUnitaire() { return coutUnitaire; }
        public BigDecimal getMontantDu() { return montantDu; }
        public BigDecimal getMontantPaye() { return montantPaye; }
        public BigDecimal getResteAPayer() { return resteAPayer; }
    }

    /**
     * Classe interne pour représenter le CA d'un vol
     */
    public static class CAVolDetail {
        private final int idVol;
        private final String numeroVol;
        private final String aeroportDepart;
        private final String aeroportArrive;
        private final String avionCode;
        private final String avionModele;
        private final Date dateDepart;
        private final Time heureDepart;
        private final BigDecimal montantBillets;
        private final BigDecimal montantDiffusions;
        private final BigDecimal montantDiffusionsPaye;
        private final BigDecimal montantProduitsExtra;
        private final int nbBillets;
        private final int nbDiffusions;
        private final int nbProduitsExtra;
        private final String detailDiffusions;
        private final List<DiffusionDetail> diffusionDetails; // Détails par société

        public CAVolDetail(int idVol, String numeroVol, String aeroportDepart, String aeroportArrive,
                          String avionCode, String avionModele, Date dateDepart, Time heureDepart,
                          BigDecimal montantBillets, BigDecimal montantDiffusions, BigDecimal montantDiffusionsPaye,
                          BigDecimal montantProduitsExtra, int nbBillets, int nbDiffusions, int nbProduitsExtra,
                          String detailDiffusions, List<DiffusionDetail> diffusionDetails) {
            this.idVol = idVol;
            this.numeroVol = numeroVol;
            this.aeroportDepart = aeroportDepart;
            this.aeroportArrive = aeroportArrive;
            this.avionCode = avionCode;
            this.avionModele = avionModele;
            this.dateDepart = dateDepart;
            this.heureDepart = heureDepart;
            this.montantBillets = montantBillets != null ? montantBillets : BigDecimal.ZERO;
            this.montantDiffusions = montantDiffusions != null ? montantDiffusions : BigDecimal.ZERO;
            this.montantDiffusionsPaye = montantDiffusionsPaye != null ? montantDiffusionsPaye : BigDecimal.ZERO;
            this.montantProduitsExtra = montantProduitsExtra != null ? montantProduitsExtra : BigDecimal.ZERO;
            this.nbBillets = nbBillets;
            this.nbDiffusions = nbDiffusions;
            this.nbProduitsExtra = nbProduitsExtra;
            this.detailDiffusions = detailDiffusions;
            this.diffusionDetails = diffusionDetails != null ? diffusionDetails : new ArrayList<>();
        }

        // Getters
        public int getIdVol() { return idVol; }
        public String getNumeroVol() { return numeroVol; }
        public String getAeroportDepart() { return aeroportDepart; }
        public String getAeroportArrive() { return aeroportArrive; }
        public String getAvionCode() { return avionCode; }
        public String getAvionModele() { return avionModele; }
        public Date getDateDepart() { return dateDepart; }
        public Time getHeureDepart() { return heureDepart; }
        public BigDecimal getMontantBillets() { return montantBillets; }
        public BigDecimal getMontantDiffusions() { return montantDiffusions; }
        public BigDecimal getMontantDiffusionsPaye() { return montantDiffusionsPaye; }
        public BigDecimal getMontantProduitsExtra() { return montantProduitsExtra; }
        public int getNbBillets() { return nbBillets; }
        public int getNbDiffusions() { return nbDiffusions; }
        public int getNbProduitsExtra() { return nbProduitsExtra; }
        public String getDetailDiffusions() { return detailDiffusions; }
        public List<DiffusionDetail> getDiffusionDetails() { return diffusionDetails; }

        // CA Total = billets + diffusions + produits extra
        public BigDecimal getMontantTotal() {
            return montantBillets.add(montantDiffusions).add(montantProduitsExtra);
        }
        
        // CA Total avec paiement de diffusion = billets + diffusions payées + produits extra
        public BigDecimal getMontantTotalAvecPaiement() {
            return montantBillets.add(montantDiffusionsPaye).add(montantProduitsExtra);
        }
        
        // Reste à payer pour les diffusions sur ce vol
        public BigDecimal getResteDiffusionsAPayer() {
            return montantDiffusions.subtract(montantDiffusionsPaye);
        }
    }

    /**
     * Récupère le CA de tous les vols avec détails
     */
    public static List<CAVolDetail> getCAParVol() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getCAParVol(conn, null, null);
        }
    }

    /**
     * Récupère le CA de tous les vols avec filtre par date
     */
    public static List<CAVolDetail> getCAParVol(Date dateDebut, Date dateFin) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getCAParVol(conn, dateDebut, dateFin);
        }
    }

    public static List<CAVolDetail> getCAParVol(Connection conn) throws SQLException {
        return getCAParVol(conn, null, null);
    }

    public static List<CAVolDetail> getCAParVol(Connection conn, Date dateDebut, Date dateFin) throws SQLException {
        List<CAVolDetail> list = new ArrayList<>();
        
        // Requête pour obtenir les informations de base du vol + CA billets
        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "  v.idvol, " +
            "  v.numerovol, " +
            "  ad.nom AS aeroport_depart, " +
            "  aa.nom AS aeroport_arrive, " +
            "  av.code AS avion_code, " +
            "  av.modele AS avion_modele, " +
            "  v.datedepart, " +
            "  v.heuredepart, " +
            "  COALESCE(SUM(b.prix), 0) AS montant_billets, " +
            "  COUNT(DISTINCT b.idbillet) AS nb_billets " +
            "FROM vol v " +
            "JOIN trajet t ON v.idtrajet = t.idtrajet " +
            "JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport " +
            "JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport " +
            "JOIN avion av ON v.idavion = av.idavion " +
            "LEFT JOIN reservation r ON r.idvol = v.idvol " +
            "LEFT JOIN billet b ON b.idreservation = r.idreservation "
        );
        
        // Ajouter les conditions de date si spécifiées
        boolean hasDateDebut = dateDebut != null;
        boolean hasDateFin = dateFin != null;
        if (hasDateDebut || hasDateFin) {
            sql.append("WHERE ");
            if (hasDateDebut && hasDateFin) {
                sql.append("v.datedepart BETWEEN ? AND ? ");
            } else if (hasDateDebut) {
                sql.append("v.datedepart >= ? ");
            } else {
                sql.append("v.datedepart <= ? ");
            }
        }
        
        sql.append("GROUP BY v.idvol, v.numerovol, ad.nom, aa.nom, av.code, av.modele, v.datedepart, v.heuredepart ");
        sql.append("ORDER BY v.datedepart DESC, v.heuredepart DESC");
        
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (hasDateDebut) {
                ps.setDate(paramIndex++, dateDebut);
            }
            if (hasDateFin) {
                ps.setDate(paramIndex++, dateFin);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int idVol = rs.getInt("idvol");
                    
                    // Récupérer les diffusions pour ce vol (avec montant payé proportionnel)
                    Object[] diffInfo = getDiffusionsInfoForVolWithPayment(conn, idVol);
                    BigDecimal montantDiffusions = (BigDecimal) diffInfo[0];
                    BigDecimal montantDiffusionsPaye = (BigDecimal) diffInfo[1];
                    int nbDiffusions = (Integer) diffInfo[2];
                    String detailDiffusions = (String) diffInfo[3];
                    @SuppressWarnings("unchecked")
                    List<DiffusionDetail> diffusionDetails = (List<DiffusionDetail>) diffInfo[4];
                    
                    // Récupérer le CA des produits extra pour ce vol
                    Object[] produitInfo = getProduitsExtraInfoForVol(conn, idVol);
                    BigDecimal montantProduitsExtra = (BigDecimal) produitInfo[0];
                    int nbProduitsExtra = (Integer) produitInfo[1];
                    
                    list.add(new CAVolDetail(
                        idVol,
                        rs.getString("numerovol"),
                        rs.getString("aeroport_depart"),
                        rs.getString("aeroport_arrive"),
                        rs.getString("avion_code"),
                        rs.getString("avion_modele"),
                        rs.getDate("datedepart"),
                        rs.getTime("heuredepart"),
                        rs.getBigDecimal("montant_billets"),
                        montantDiffusions,
                        montantDiffusionsPaye,
                        montantProduitsExtra,
                        rs.getInt("nb_billets"),
                        nbDiffusions,
                        nbProduitsExtra,
                        detailDiffusions,
                        diffusionDetails
                    ));
                }
            }
        }
        return list;
    }

    /**
     * Récupère les informations des produits extra pour un vol donné
     * @return Object[] {montantTotal, nbProduitsVendus}
     */
    private static Object[] getProduitsExtraInfoForVol(Connection conn, int idVol) throws SQLException {
        BigDecimal montantTotal = BigDecimal.ZERO;
        int nbProduits = 0;
        
        String sql = "SELECT COALESCE(SUM(quantite * prix_unitaire), 0) AS montant, " +
                     "COALESCE(SUM(quantite), 0) AS nb " +
                     "FROM vente_produit_extra WHERE idvol = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    montantTotal = rs.getBigDecimal("montant");
                    nbProduits = rs.getInt("nb");
                }
            }
        }
        
        return new Object[] { montantTotal, nbProduits };
    }

    /**
     * Récupère le CA d'un vol spécifique par son ID
     */
    public static CAVolDetail getCAByVolId(int idVol) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getCAByVolId(conn, idVol);
        }
    }

    public static CAVolDetail getCAByVolId(Connection conn, int idVol) throws SQLException {
        String sql = 
            "SELECT " +
            "  v.idvol, " +
            "  v.numerovol, " +
            "  ad.nom AS aeroport_depart, " +
            "  aa.nom AS aeroport_arrive, " +
            "  av.code AS avion_code, " +
            "  av.modele AS avion_modele, " +
            "  v.datedepart, " +
            "  v.heuredepart, " +
            "  COALESCE(SUM(b.prix), 0) AS montant_billets, " +
            "  COUNT(DISTINCT b.idbillet) AS nb_billets " +
            "FROM vol v " +
            "JOIN trajet t ON v.idtrajet = t.idtrajet " +
            "JOIN aeroport ad ON t.idaeroportdepart = ad.idaeroport " +
            "JOIN aeroport aa ON t.idaeroportarrive = aa.idaeroport " +
            "JOIN avion av ON v.idavion = av.idavion " +
            "LEFT JOIN reservation r ON r.idvol = v.idvol " +
            "LEFT JOIN billet b ON b.idreservation = r.idreservation " +
            "WHERE v.idvol = ? " +
            "GROUP BY v.idvol, v.numerovol, ad.nom, aa.nom, av.code, av.modele, v.datedepart, v.heuredepart";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Object[] diffInfo = getDiffusionsInfoForVolWithPayment(conn, idVol);
                    BigDecimal montantDiffusions = (BigDecimal) diffInfo[0];
                    BigDecimal montantDiffusionsPaye = (BigDecimal) diffInfo[1];
                    int nbDiffusions = (Integer) diffInfo[2];
                    String detailDiffusions = (String) diffInfo[3];
                    @SuppressWarnings("unchecked")
                    List<DiffusionDetail> diffusionDetails = (List<DiffusionDetail>) diffInfo[4];
                    
                    // Récupérer le CA des produits extra pour ce vol
                    Object[] produitInfo = getProduitsExtraInfoForVol(conn, idVol);
                    BigDecimal montantProduitsExtra = (BigDecimal) produitInfo[0];
                    int nbProduitsExtra = (Integer) produitInfo[1];
                    
                    return new CAVolDetail(
                        idVol,
                        rs.getString("numerovol"),
                        rs.getString("aeroport_depart"),
                        rs.getString("aeroport_arrive"),
                        rs.getString("avion_code"),
                        rs.getString("avion_modele"),
                        rs.getDate("datedepart"),
                        rs.getTime("heuredepart"),
                        rs.getBigDecimal("montant_billets"),
                        montantDiffusions,
                        montantDiffusionsPaye,
                        montantProduitsExtra,
                        rs.getInt("nb_billets"),
                        nbDiffusions,
                        nbProduitsExtra,
                        detailDiffusions,
                        diffusionDetails
                    );
                }
            }
        }
        return null;
    }

    /**
     * Récupère les informations de diffusions pour un vol donné avec calcul du paiement proportionnel.
     * 
     * Règle de gestion:
     * - Pour chaque achat de diffusion, on calcule le pourcentage payé = (montant payé / montant total dû) * 100
     * - Pour chaque diffusion sur le vol, le montant payé = montant diffusion * pourcentage payé
     * 
     * @return Object[] {montantTotal, montantPaye, nbDiffusions, detailString, List<DiffusionDetail>}
     */
    private static Object[] getDiffusionsInfoForVolWithPayment(Connection conn, int idVol) throws SQLException {
        BigDecimal montantTotal = BigDecimal.ZERO;
        BigDecimal montantPaye = BigDecimal.ZERO;
        int nbDiffusionsTotal = 0;
        StringBuilder detail = new StringBuilder();
        List<DiffusionDetail> diffusionDetails = new ArrayList<>();
        
        // Requête pour obtenir les diffusions par achat pour ce vol
        // avec le montant total de l'achat et le montant payé
        String sql = 
            "SELECT s.nom AS societe_nom, " +
            "       COUNT(dv.iddiffusion) AS nb_diff, " +
            "       a.cout_unitaire, " +
            "       a.idachat, " +
            "       (a.nombre_diffusions * a.cout_unitaire) AS montant_total_achat, " +
            "       COALESCE((SELECT SUM(ps.montant) FROM paiement_societe ps WHERE ps.idachat = a.idachat), 0) AS montant_paye_achat " +
            "FROM diffusion_vol dv " +
            "JOIN achat_diffusion a ON dv.idachat = a.idachat " +
            "JOIN societe s ON a.idsociete = s.idsociete " +
            "WHERE dv.idvol = ? " +
            "GROUP BY s.nom, a.cout_unitaire, a.idachat, a.nombre_diffusions " +
            "ORDER BY s.nom";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    String societeNom = rs.getString("societe_nom");
                    int nbDiff = rs.getInt("nb_diff");
                    BigDecimal coutUnitaire = rs.getBigDecimal("cout_unitaire");
                    BigDecimal montantTotalAchat = rs.getBigDecimal("montant_total_achat");
                    BigDecimal montantPayeAchat = rs.getBigDecimal("montant_paye_achat");
                    
                    // Montant des diffusions pour ce vol (pour cet achat)
                    BigDecimal montantDiffVol = coutUnitaire.multiply(new BigDecimal(nbDiff));
                    montantTotal = montantTotal.add(montantDiffVol);
                    nbDiffusionsTotal += nbDiff;
                    
                    // Calcul du pourcentage payé pour cet achat
                    // pourcentage = (montant payé / montant total) * 100
                    BigDecimal pourcentagePaye = BigDecimal.ZERO;
                    if (montantTotalAchat.compareTo(BigDecimal.ZERO) > 0) {
                        pourcentagePaye = montantPayeAchat
                            .multiply(new BigDecimal("100"))
                            .divide(montantTotalAchat, 10, RoundingMode.HALF_UP);
                    }
                    
                    // Montant payé pour les diffusions de ce vol = montant diffusion vol * pourcentage / 100
                    BigDecimal montantPayeDiffVol = montantDiffVol
                        .multiply(pourcentagePaye)
                        .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
                    montantPaye = montantPaye.add(montantPayeDiffVol);
                    
                    // Ajouter le détail de cette diffusion
                    diffusionDetails.add(new DiffusionDetail(
                        societeNom, nbDiff, coutUnitaire, montantDiffVol, montantPayeDiffVol
                    ));
                    
                    if (!first) {
                        detail.append("\n");
                    }
                    detail.append("Pub ").append(societeNom).append(" ").append(nbDiff);
                    first = false;
                }
            }
        }
        
        String detailStr = detail.length() > 0 ? detail.toString() : "0 pub";
        return new Object[] { montantTotal, montantPaye, nbDiffusionsTotal, detailStr, diffusionDetails };
    }

    /**
     * Ancienne méthode conservée pour compatibilité (sans calcul de paiement)
     * @deprecated Utiliser getDiffusionsInfoForVolWithPayment à la place
     */
    @Deprecated
    private static Object[] getDiffusionsInfoForVol(Connection conn, int idVol) throws SQLException {
        Object[] result = getDiffusionsInfoForVolWithPayment(conn, idVol);
        // Retourne format ancien: {montantTotal, nbDiffusions, detailString}
        return new Object[] { result[0], result[2], result[3] };
    }

    /**
     * Calcule le CA total global (tous les vols)
     */
    public static BigDecimal getCATotalGlobal() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getCATotalGlobal(conn);
        }
    }

    public static BigDecimal getCATotalGlobal(Connection conn) throws SQLException {
        BigDecimal total = BigDecimal.ZERO;
        
        // CA Billets
        String sqlBillets = "SELECT COALESCE(SUM(prix), 0) FROM billet";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sqlBillets)) {
            if (rs.next()) {
                total = total.add(rs.getBigDecimal(1));
            }
        }
        
        // CA Diffusions
        String sqlDiffusions = 
            "SELECT COALESCE(SUM(a.cout_unitaire), 0) " +
            "FROM diffusion_vol dv " +
            "JOIN achat_diffusion a ON dv.idachat = a.idachat";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sqlDiffusions)) {
            if (rs.next()) {
                total = total.add(rs.getBigDecimal(1));
            }
        }
        
        // CA Produits Extra
        String sqlProduitsExtra = "SELECT COALESCE(SUM(quantite * prix_unitaire), 0) FROM vente_produit_extra";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sqlProduitsExtra)) {
            if (rs.next()) {
                total = total.add(rs.getBigDecimal(1));
            }
        }
        
        return total;
    }
}
