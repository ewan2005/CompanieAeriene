package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Place {
    private int idPlace;
    private int numeroPlace;

    public int getNumeroPlace() {
        return numeroPlace;
    }
    public void setNumeroPlace(int numeroPlace) {
        this.numeroPlace = numeroPlace;
    }
    public Place() {}
    public Place(int idPlace,int numeroPlace ){ this.idPlace = idPlace; this.numeroPlace = numeroPlace; }

    public int getIdPlace() { return idPlace; }
    public void setIdPlace(int idPlace) { this.idPlace = idPlace; }
    

    public void save() throws SQLException { Connection conn = DB.getconnect(); try { save(conn);} finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO place (numeroPlace) VALUES (?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, this.numeroPlace);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idPlace = rs.getInt(1); }
        }
    }

    public static Place findById(int id) throws SQLException { Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); } }
    public static Place findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM place WHERE idPlace = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, id); try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return new Place(rs.getInt("idPlace"), rs.getInt("numeroPlace")); } }
        return null;
    }

    public static List<Place> findAll() throws SQLException { Connection conn = DB.getconnect(); try { return findAll(conn);} finally { if (conn != null) conn.close(); } }
    public static List<Place> findAll(Connection conn) throws SQLException {
        List<Place> list = new ArrayList<>();
        String q = "SELECT * FROM place";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) { while (rs.next()) list.add(new Place(rs.getInt("idPlace"), rs.getInt("numeroPlace"))); }
        return list;
    }
}
