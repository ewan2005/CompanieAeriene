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
    
    // Calculer la valeur maximale d'un avion (somme des tarifs via tarif_classe join)
    public static BigDecimal getValeurMaximaleByAvion(Connection conn, int idAvion) throws SQLException {
        String q = "SELECT COALESCE(SUM(tc.tarif), 0) FROM place p JOIN tarif_classe tc ON p.type_place = tc.type_place WHERE p.idavion = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idAvion);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }
    
    public static BigDecimal getValeurMaximaleByAvion(int idAvion) throws SQLException {
        Connection conn = DB.getconnect(); 
        try { return getValeurMaximaleByAvion(conn, idAvion);} finally { if (conn != null) conn.close(); }
    }
}
