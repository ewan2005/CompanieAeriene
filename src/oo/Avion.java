package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
