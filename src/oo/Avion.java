package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class Avion {
    private int idAvion;
    private String model;
    private String capacite;
    private String code;

    public Avion() {}

    public Avion(String model, String capacite, String code) {
        this.model = model;
        this.capacite = capacite;
        this.code = code;
    }

    public Avion(int idAvion, String model, String capacite, String code) {
        this.idAvion = idAvion;
        this.model = model;
        this.capacite = capacite;
        this.code = code;
    }

    public int getIdAvion() { return idAvion; }
    public void setIdAvion(int idAvion) { this.idAvion = idAvion; }
    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }
    public String getCapacite() { return capacite; }
    public void setCapacite(String capacite) { this.capacite = capacite; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    
    // Obtenir le nombre de places première classe depuis la table place
    public int getNbPlacesPremiereClasse() throws SQLException {
        return Place.countByTypeAndAvion(this.idAvion, Place.TYPE_PREMIERE_CLASSE);
    }
    
    public int getNbPlacesPremiereClasse(Connection conn) throws SQLException {
        return Place.countByTypeAndAvion(conn, this.idAvion, Place.TYPE_PREMIERE_CLASSE);
    }
    
    // Obtenir le nombre de places économique depuis la table place
    public int getNbPlacesEconomique() throws SQLException {
        return Place.countByTypeAndAvion(this.idAvion, Place.TYPE_ECONOMIQUE);
    }
    
    public int getNbPlacesEconomique(Connection conn) throws SQLException {
        return Place.countByTypeAndAvion(conn, this.idAvion, Place.TYPE_ECONOMIQUE);
    }

    // Obtenir le nombre de places premium depuis la table place
    public int getNbPlacesPremium() throws SQLException {
        return Place.countByTypeAndAvion(this.idAvion, Place.TYPE_PREMIUM);
    }

    public int getNbPlacesPremium(Connection conn) throws SQLException {
        return Place.countByTypeAndAvion(conn, this.idAvion, Place.TYPE_PREMIUM);
    }
    
    // Calculer le nombre total de places
    public int getTotalPlaces() throws SQLException {
        return getNbPlacesPremiereClasse() + getNbPlacesEconomique() + getNbPlacesPremium();
    }
    
    public int getTotalPlaces(Connection conn) throws SQLException {
        return getNbPlacesPremiereClasse(conn) + getNbPlacesEconomique(conn) + getNbPlacesPremium(conn);
    }
    
    // Calculer la valeur maximale qu'un avion peut générer pour un vol (utilise les tarifs de la BD)
    public BigDecimal getValeurMaximaleVol() throws SQLException {
        return Place.getValeurMaximaleByAvion(this.idAvion);
    }
    
    public BigDecimal getValeurMaximaleVol(Connection conn) throws SQLException {
        return Place.getValeurMaximaleByAvion(conn, this.idAvion);
    }
    
    // Méthode avec prix personnalisés (pour compatibilité)
    public double getValeurMaximaleVolCustom(double prixPremiereClasse, double prixPremium, double prixEconomique) throws SQLException {
        return (getNbPlacesPremiereClasse() * prixPremiereClasse) + (getNbPlacesPremium() * prixPremium) + (getNbPlacesEconomique() * prixEconomique);
    }
    
    public double getValeurMaximaleVolCustom(Connection conn, double prixPremiereClasse, double prixPremium, double prixEconomique) throws SQLException {
        return (getNbPlacesPremiereClasse(conn) * prixPremiereClasse) + (getNbPlacesPremium(conn) * prixPremium) + (getNbPlacesEconomique(conn) * prixEconomique);
    }
    
    // Obtenir toutes les places de cet avion
    public List<Place> getPlaces() throws SQLException {
        return Place.findByAvion(this.idAvion);
    }
    
    public List<Place> getPlaces(Connection conn) throws SQLException {
        return Place.findByAvion(conn, this.idAvion);
    }

    public void save() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            save(conn);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public void save(Connection conn) throws SQLException {
        String query = "INSERT INTO avion (modele, capacite, code) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.model);
            ps.setString(2, this.capacite);
            ps.setString(3, this.code);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) this.idAvion = rs.getInt(1);
            }
        }
    }

    public static Avion findById(int id) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return findById(conn, id);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public static Avion findById(Connection conn, int id) throws SQLException {
        String query = "SELECT idAvion, modele AS model, capacite, code FROM avion WHERE idAvion = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Avion(rs.getInt("idAvion"), rs.getString("model"), rs.getString("capacite"), rs.getString("code"));
                }
            }
        }
        return null;
    }

    public static List<Avion> findAll() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return findAll(conn);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public static List<Avion> findAll(Connection conn) throws SQLException {
        List<Avion> list = new ArrayList<>();
        String query = "SELECT idAvion, modele AS model, capacite, code FROM avion";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                list.add(new Avion(rs.getInt("idAvion"), rs.getString("model"), rs.getString("capacite"), rs.getString("code")));
            }
        }
        return list;
    }

    public void update() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); update(conn); } finally { if (conn != null) conn.close(); }
    }

    public void update(Connection conn) throws SQLException {
        String query = "UPDATE avion SET modele = ?, capacite = ?, code = ? WHERE idAvion = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, this.model);
            ps.setString(2, this.capacite);
            ps.setString(3, this.code);
            ps.setInt(4, this.idAvion);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); delete(conn); } finally { if (conn != null) conn.close(); }
    }

    public void delete(Connection conn) throws SQLException {
        String query = "DELETE FROM avion WHERE idAvion = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, this.idAvion);
            ps.executeUpdate();
        }
    }
}
