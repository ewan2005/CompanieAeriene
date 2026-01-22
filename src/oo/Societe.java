package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Societe {
    private int idSociete;
    private String nom;
    private String adresse;
    private String telephone;
    private String email;
    private Timestamp dateCreation;

    public Societe() {}

    public Societe(String nom, String adresse, String telephone, String email) {
        this.nom = nom;
        this.adresse = adresse;
        this.telephone = telephone;
        this.email = email;
    }

    public Societe(int idSociete, String nom, String adresse, String telephone, String email) {
        this.idSociete = idSociete;
        this.nom = nom;
        this.adresse = adresse;
        this.telephone = telephone;
        this.email = email;
    }

    // Getters et Setters
    public int getIdSociete() { return idSociete; }
    public void setIdSociete(int idSociete) { this.idSociete = idSociete; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public Timestamp getDateCreation() { return dateCreation; }
    public void setDateCreation(Timestamp dateCreation) { this.dateCreation = dateCreation; }

    // CRUD Operations
    public void save() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            save(conn);
        }
    }

    public void save(Connection conn) throws SQLException {
        String sql = "INSERT INTO societe (nom, adresse, telephone, email) VALUES (?, ?, ?, ?) RETURNING idsociete";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nom);
            ps.setString(2, adresse);
            ps.setString(3, telephone);
            ps.setString(4, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    this.idSociete = rs.getInt(1);
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
        String sql = "UPDATE societe SET nom = ?, adresse = ?, telephone = ?, email = ? WHERE idsociete = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nom);
            ps.setString(2, adresse);
            ps.setString(3, telephone);
            ps.setString(4, email);
            ps.setInt(5, idSociete);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            delete(conn);
        }
    }

    public void delete(Connection conn) throws SQLException {
        String sql = "DELETE FROM societe WHERE idsociete = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idSociete);
            ps.executeUpdate();
        }
    }

    public static Societe findById(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findById(conn, id);
        }
    }

    public static Societe findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT * FROM societe WHERE idsociete = ?";
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

    public static List<Societe> findAll() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAll(conn);
        }
    }

    public static List<Societe> findAll(Connection conn) throws SQLException {
        List<Societe> list = new ArrayList<>();
        String sql = "SELECT * FROM societe ORDER BY nom";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    private static Societe fromResultSet(ResultSet rs) throws SQLException {
        Societe s = new Societe();
        s.setIdSociete(rs.getInt("idsociete"));
        s.setNom(rs.getString("nom"));
        s.setAdresse(rs.getString("adresse"));
        s.setTelephone(rs.getString("telephone"));
        s.setEmail(rs.getString("email"));
        s.setDateCreation(rs.getTimestamp("date_creation"));
        return s;
    }
}
