package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class Place {
    private int idPlace;
    private int numeroPlace;
    private String typePlace; // 'premiere_classe' ou 'economique'
    private int idAvion;
    // Note: tarif is now managed globally in table `tarif_classe`
    public static final String TYPE_PREMIERE_CLASSE = "premiere_classe";
    public static final String TYPE_ECONOMIQUE = "economique";
    public static final String TYPE_PREMIUM = "premium";
    
    public static final BigDecimal TARIF_PREMIERE_CLASSE = new BigDecimal("1200000");
    public static final BigDecimal TARIF_ECONOMIQUE = new BigDecimal("800000");
    public static final BigDecimal TARIF_PREMIUM = new BigDecimal("1000000");

    public int getNumeroPlace() {
        return numeroPlace;
    }
    public void setNumeroPlace(int numeroPlace) {
        this.numeroPlace = numeroPlace;
    }
    public String getTypePlace() {
        return typePlace;
    }
    public void setTypePlace(String typePlace) {
        this.typePlace = typePlace;
    }
    public int getIdAvion() {
        return idAvion;
    }
    public void setIdAvion(int idAvion) {
        this.idAvion = idAvion;
    }
    // tarif field removed: tariffs are managed via table `tarif_classe`.
    
    public boolean isPremiereClasse() {
        return TYPE_PREMIERE_CLASSE.equals(typePlace);
    }
    
    public boolean isEconomique() {
        return TYPE_ECONOMIQUE.equals(typePlace);
    }
    
    public boolean isPremium() {
        return TYPE_PREMIUM.equals(typePlace);
    }
    
    public String getTypePlaceLibelle() {
        if (TYPE_PREMIERE_CLASSE.equals(typePlace)) return "Première Classe";
        if (TYPE_PREMIUM.equals(typePlace)) return "Premium";
        if (TYPE_ECONOMIQUE.equals(typePlace)) return "Économique";
        return typePlace;
    }

    public Place() {}
    
    public Place(int idPlace, int numeroPlace, String typePlace, int idAvion) { 
        this.idPlace = idPlace; 
        this.numeroPlace = numeroPlace; 
        this.typePlace = typePlace;
        this.idAvion = idAvion;
    }

    public int getIdPlace() { return idPlace; }
    public void setIdPlace(int idPlace) { this.idPlace = idPlace; }

    public void save() throws SQLException { Connection conn = DB.getconnect(); try { save(conn);} finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO place (numeroPlace, type_place, idavion) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, this.numeroPlace);
            ps.setString(2, this.typePlace != null ? this.typePlace : TYPE_ECONOMIQUE);
            ps.setInt(3, this.idAvion);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idPlace = rs.getInt(1); }
        }
    }

    public static Place findById(int id) throws SQLException { Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); } }
    public static Place findById(Connection conn, int id) throws SQLException {
        String q = "SELECT idPlace, numeroPlace, type_place, idavion FROM place WHERE idPlace = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { 
            ps.setInt(1, id); 
            try (ResultSet rs = ps.executeQuery()) { 
                if (rs.next()) return new Place(rs.getInt("idPlace"), rs.getInt("numeroPlace"), rs.getString("type_place"), rs.getInt("idavion")); 
            } 
        }
        return null;
    }
    public static List<Place> findAll() throws SQLException { Connection conn = DB.getconnect(); try { return findAll(conn);} finally { if (conn != null) conn.close(); } }
    public static List<Place> findAll(Connection conn) throws SQLException {
        List<Place> list = new ArrayList<>();
        String q = "SELECT idPlace, numeroPlace, type_place, idavion FROM place ORDER BY idavion, type_place DESC, numeroplace";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) { 
            while (rs.next()) list.add(new Place(rs.getInt("idPlace"), rs.getInt("numeroPlace"), rs.getString("type_place"), rs.getInt("idavion"))); 
        }
        return list;
    }
    
    // Trouver toutes les places d'un avion
    public static List<Place> findByAvion(int idAvion) throws SQLException { 
        Connection conn = DB.getconnect(); 
        try { return findByAvion(conn, idAvion);} finally { if (conn != null) conn.close(); } 
    }
    
    public static List<Place> findByAvion(Connection conn, int idAvion) throws SQLException {
        List<Place> list = new ArrayList<>();
        String q = "SELECT idPlace, numeroPlace, type_place, idavion FROM place WHERE idavion = ? ORDER BY type_place DESC, numeroplace";
        try (PreparedStatement ps = conn.prepareStatement(q)) { 
            ps.setInt(1, idAvion);
            try (ResultSet rs = ps.executeQuery()) { 
                while (rs.next()) list.add(new Place(rs.getInt("idPlace"), rs.getInt("numeroPlace"), rs.getString("type_place"), rs.getInt("idavion"))); 
            }
        }
        return list;
    }
    
    // Compter les places par type pour un avion
    public static int countByTypeAndAvion(Connection conn, int idAvion, String typePlace) throws SQLException {
        String q = "SELECT COUNT(*) FROM place WHERE idavion = ? AND type_place = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idAvion);
            ps.setString(2, typePlace);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
    
    public static int countByTypeAndAvion(int idAvion, String typePlace) throws SQLException {
        Connection conn = DB.getconnect(); 
        try { return countByTypeAndAvion(conn, idAvion, typePlace);} finally { if (conn != null) conn.close(); }
    }

    // Compter le nombre de places payées (réservation ayant un billet) pour un avion et un type de place
    public static int countPaidByTypeAndAvion(Connection conn, int idAvion, String typePlace) throws SQLException {
        String q = "SELECT COUNT(*) FROM place p " +
                   "JOIN reservation r ON r.idplace = p.idplace " +
                   "JOIN billet b ON b.idreservation = r.idreservation " +
                   "WHERE p.idavion = ? AND p.type_place = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idAvion);
            ps.setString(2, typePlace);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        }
        return 0;
    }

    public static int countPaidByTypeAndAvion(int idAvion, String typePlace) throws SQLException {
        Connection conn = DB.getconnect();
        try { return countPaidByTypeAndAvion(conn, idAvion, typePlace); } finally { if (conn != null) conn.close(); }
    }

    // Compter les places payées (réservation ayant un billet) pour un avion, un type de place et une catégorie
    public static int countPaidByTypeAndAvionAndCategorie(Connection conn, int idAvion, String typePlace, int idCategorie) throws SQLException {
        String q = "SELECT COUNT(*) FROM place p " +
                   "JOIN reservation r ON r.idplace = p.idplace " +
                   "JOIN billet b ON b.idreservation = r.idreservation " +
                   "WHERE p.idavion = ? AND p.type_place = ? AND r.idcategorie = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idAvion);
            ps.setString(2, typePlace);
            ps.setInt(3, idCategorie);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        }
        return 0;
    }

    public static int countPaidByTypeAndAvionAndCategorie(int idAvion, String typePlace, int idCategorie) throws SQLException {
        Connection conn = DB.getconnect();
        try { return countPaidByTypeAndAvionAndCategorie(conn, idAvion, typePlace, idCategorie); } finally { if (conn != null) conn.close(); }
    }
    
    // Calculer la valeur maximale d'un avion **pour les places déjà payées** (i.e. réservations ayant un billet)
    public static BigDecimal getValeurMaximaleByAvion(Connection conn, int idAvion) throws SQLException {
        // Compute final price per paid reservation taking into account remise_categorie rules:
        // - If place.type_place = 'economique' and remise_categorie.montant_remise > 0 => use montant_remise as FIXED final price
        // - Otherwise final price = tc.tarif - COALESCE(rc.montant_remise, 0)
        // Ensure final price is not negative using GREATEST(..., 0)
        String q = "SELECT COALESCE(SUM(GREATEST( (CASE WHEN p.type_place = 'economique' AND COALESCE(rc.montant_remise,0) > 0 " +
                   "THEN rc.montant_remise ELSE (tc.tarif - COALESCE(rc.montant_remise,0)) END), 0)), 0) " +
                   "FROM place p " +
                   "JOIN tarif_classe tc ON p.type_place = tc.type_place " +
                   "JOIN reservation r ON r.idplace = p.idplace " +
                   "JOIN billet b ON b.idreservation = r.idreservation " +
                   "LEFT JOIN remise_categorie rc ON rc.type_place = tc.type_place AND rc.idcategorie = r.idcategorie " +
                   "WHERE p.idavion = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idAvion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    // Calculer la valeur maximale d'un avion **pour les places déjà payées** filtrée par catégorie (ex: enfant)
    public static BigDecimal getValeurMaximaleByAvionAndCategorie(Connection conn, int idAvion, int idCategorie) throws SQLException {
        // Same logic as getValeurMaximaleByAvion but restricted to reservations in the given category
        String q = "SELECT COALESCE(SUM(GREATEST( (CASE WHEN p.type_place = 'economique' AND COALESCE(rc.montant_remise,0) > 0 " +
                   "THEN rc.montant_remise ELSE (tc.tarif - COALESCE(rc.montant_remise,0)) END), 0)), 0) " +
                   "FROM place p " +
                   "JOIN tarif_classe tc ON p.type_place = tc.type_place " +
                   "JOIN reservation r ON r.idplace = p.idplace " +
                   "JOIN billet b ON b.idreservation = r.idreservation " +
                   "LEFT JOIN remise_categorie rc ON rc.type_place = tc.type_place AND rc.idcategorie = r.idcategorie " +
                   "WHERE p.idavion = ? AND r.idcategorie = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idAvion);
            ps.setInt(2, idCategorie);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    public static BigDecimal getValeurMaximaleByAvionAndCategorie(int idAvion, int idCategorie) throws SQLException {
        Connection conn = DB.getconnect();
        try { return getValeurMaximaleByAvionAndCategorie(conn, idAvion, idCategorie);} finally { if (conn != null) conn.close(); }
    }
    
    public static BigDecimal getValeurMaximaleByAvion(int idAvion) throws SQLException {
        Connection conn = DB.getconnect(); 
        try { return getValeurMaximaleByAvion(conn, idAvion);} finally { if (conn != null) conn.close(); }
    }
}
