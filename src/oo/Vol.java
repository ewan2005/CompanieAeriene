package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Vol {
    private int idVol;
    private Integer numeroVol;
    private Timestamp dateDepart;
    private Timestamp dateArrive;
    private Time heureDepart;
    private Time heureArrivee;
    private int idAvion;
    private int idAeroportDepart;
    private int idAeroportArrive;
    private int idPlace;
    private int idPassager;

    public Vol() {}

    public Vol(Integer numeroVol, Timestamp dateDepart, Timestamp dateArrive, Time heureDepart, Time heureArrivee, int idAvion, int idAeroportDepart, int idAeroportArrive,int idPlace,int idPassager ) {
        this.numeroVol = numeroVol;
        this.dateDepart = dateDepart;
        this.dateArrive = dateArrive;
        this.heureDepart = heureDepart;
        this.heureArrivee = heureArrivee;
        this.idAvion = idAvion;
        this.idAeroportDepart = idAeroportDepart;
        this.idAeroportArrive = idAeroportArrive;
        this.idPlace = idPlace;
        this.idPassager = idPassager;
    }

    public Vol(int idVol, Integer numeroVol, Timestamp dateDepart, Timestamp dateArrive, Time heureDepart, Time heureArrivee, int idAvion, int idAeroportDepart, int idAeroportArrive,int idPlace,int idPassager) {
        this(numeroVol, dateDepart, dateArrive, heureDepart, heureArrivee, idAvion, idAeroportDepart, idAeroportArrive,idPlace,idPassager);
        this.idVol = idVol;
    }

    // getters / setters
    public int getIdVol() { return idVol; }
    public void setIdVol(int idVol) { this.idVol = idVol; }
    public Integer getNumeroVol() { return numeroVol; }
    public void setNumeroVol(Integer numeroVol) { this.numeroVol = numeroVol; }
    public Timestamp getDateDepart() { return dateDepart; }
    public void setDateDepart(Timestamp dateDepart) { this.dateDepart = dateDepart; }
    public Timestamp getDateArrive() { return dateArrive; }
    public void setDateArrive(Timestamp dateArrive) { this.dateArrive = dateArrive; }
    public Time getHeureDepart() { return heureDepart; }
    public void setHeureDepart(Time heureDepart) { this.heureDepart = heureDepart; }
    public Time getHeureArrivee() { return heureArrivee; }
    public void setHeureArrivee(Time heureArrivee) { this.heureArrivee = heureArrivee; }
    public int getIdAvion() { return idAvion; }
    public void setIdAvion(int idAvion) { this.idAvion = idAvion; }
    public int getIdAeroportDepart() { return idAeroportDepart; }
    public void setIdAeroportDepart(int idAeroportDepart) { this.idAeroportDepart = idAeroportDepart; }
    public int getIdAeroportArrive() { return idAeroportArrive; }
    public void setIdAeroportArrive(int idAeroportArrive) { this.idAeroportArrive = idAeroportArrive; }
    public int getIdPlace() { return idPlace; }
    public void setIdPlace(int idPlace) { this.idPlace = idPlace; }
    public int getIdPassager() { return idPassager; }
    public void setIdPassager(int idPassager) { this.idPassager = idPassager; }

    public void save() throws SQLException { Connection conn = DB.getconnect(); try { save(conn);} finally { if (conn != null) conn.close(); } }

    public void save(Connection conn) throws SQLException {
        String q = "INSERT INTO Vol (numeroVol, dateDepart, dateArrive, heureDepart, heureArrivee, idAvion, idAeroportDepart, idAeroportArrive, idPlace, idPassager) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(q, Statement.RETURN_GENERATED_KEYS)) {
            if (this.numeroVol != null) ps.setInt(1, this.numeroVol); else ps.setNull(1, Types.INTEGER);
            ps.setTimestamp(2, this.dateDepart);
            ps.setTimestamp(3, this.dateArrive);
            ps.setTime(4, this.heureDepart);
            ps.setTime(5, this.heureArrivee);
            ps.setInt(6, this.idAvion);
            ps.setInt(7, this.idAeroportDepart);
            ps.setInt(8, this.idAeroportArrive);
            ps.setInt(9, this.idPlace);
            ps.setInt(10, this.idPassager);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idVol = rs.getInt(1); }
        }
    }

    public static Vol findById(int id) throws SQLException { Connection conn = DB.getconnect(); try { return findById(conn, id);} finally { if (conn != null) conn.close(); } }

    public static Vol findById(Connection conn, int id) throws SQLException {
        String q = "SELECT * FROM Vol WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return new Vol(rs.getInt("idVol"), rs.getInt("numeroVol"), rs.getTimestamp("dateDepart"), rs.getTimestamp("dateArrive"), rs.getTime("heureDepart"), rs.getTime("heureArrivee"), rs.getInt("idAvion"), rs.getInt("idAeroportDepart"), rs.getInt("idAeroportArrive"), rs.getInt("idPlace"), rs.getInt("idPassager")); }
        }
        return null;
    }

    public static List<Vol> findAll() throws SQLException { Connection conn = DB.getconnect(); try { return findAll(conn);} finally { if (conn != null) conn.close(); } }

    public static List<Vol> findAll(Connection conn) throws SQLException {
        List<Vol> list = new ArrayList<>();
        String q = "SELECT * FROM Vol";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(q)) {
            while (rs.next()) list.add(new Vol(rs.getInt("idVol"), rs.getInt("numeroVol"), rs.getTimestamp("dateDepart"), rs.getTimestamp("dateArrive"), rs.getTime("heureDepart"), rs.getTime("heureArrivee"), rs.getInt("idAvion"), rs.getInt("idAeroportDepart"), rs.getInt("idAeroportArrive"), rs.getInt("idPlace"), rs.getInt("idPassager")));
        }
        return list;
    }

    public void update() throws SQLException { Connection conn = DB.getconnect(); try { update(conn);} finally { if (conn != null) conn.close(); } }

    public void update(Connection conn) throws SQLException {
        String q = "UPDATE Vol SET numeroVol = ?, dateDepart = ?, dateArrive = ?, heureDepart = ?, heureArrivee = ?, idAvion = ?, idAeroportDepart = ?, idAeroportArrive = ?, idPlace = ?, idPassager = ? WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            if (this.numeroVol != null) ps.setInt(1, this.numeroVol); else ps.setNull(1, Types.INTEGER);
            ps.setTimestamp(2, this.dateDepart);
            ps.setTimestamp(3, this.dateArrive);
            ps.setTime(4, this.heureDepart);
            ps.setTime(5, this.heureArrivee);
            ps.setInt(6, this.idAvion);
            ps.setInt(7, this.idAeroportDepart);
            ps.setInt(8, this.idAeroportArrive);
            ps.setInt(9, this.idPlace);
            ps.setInt(10, this.idPassager);
            ps.setInt(11, this.idVol);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { Connection conn = DB.getconnect(); try { delete(conn);} finally { if (conn != null) conn.close(); } }

    public void delete(Connection conn) throws SQLException {
        // Prevent deletion if billets exist
        String countQ = "SELECT COUNT(*) FROM billet WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(countQ)) {
            ps.setInt(1, this.idVol);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next() && rs.getInt(1) > 0) throw new SQLException("Impossible de supprimer le vol: des billets sont associés."); }
        }

        String q = "DELETE FROM Vol WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, this.idVol); ps.executeUpdate(); }
    }

    public int countBillets(Connection conn) throws SQLException {
        String q = "SELECT COUNT(*) FROM billet WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) { ps.setInt(1, this.idVol); try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); } }
        return 0;
    }

    public boolean hasDifferentAirports() {
        return this.idAeroportDepart != this.idAeroportArrive;
    }
}
