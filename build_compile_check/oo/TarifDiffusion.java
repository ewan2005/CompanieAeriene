package oo;

import utils.DB;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class TarifDiffusion {
    private int idTarif;
    private BigDecimal coutParDiffusion;
    private Date dateDebut;
    private Date dateFin;
    private Timestamp dateCreation;

    // Tarif par défaut: 400 000 Ar
    public static final BigDecimal TARIF_DEFAULT = new BigDecimal("400000");

    public TarifDiffusion() {
        this.coutParDiffusion = TARIF_DEFAULT;
    }

    public TarifDiffusion(BigDecimal coutParDiffusion, Date dateDebut) {
        this.coutParDiffusion = coutParDiffusion;
        this.dateDebut = dateDebut;
    }

    // Getters et Setters
    public int getIdTarif() { return idTarif; }
    public void setIdTarif(int idTarif) { this.idTarif = idTarif; }
    public BigDecimal getCoutParDiffusion() { return coutParDiffusion; }
    public void setCoutParDiffusion(BigDecimal coutParDiffusion) { this.coutParDiffusion = coutParDiffusion; }
    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }
    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }
    public Timestamp getDateCreation() { return dateCreation; }
    public void setDateCreation(Timestamp dateCreation) { this.dateCreation = dateCreation; }

    // CRUD Operations
    public void save() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            save(conn);
        }
    }

    public void save(Connection conn) throws SQLException {
        String sql = "INSERT INTO tarif_diffusion (cout_par_diffusion, date_debut, date_fin) VALUES (?, ?, ?) RETURNING idtarif";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, coutParDiffusion);
            ps.setDate(2, dateDebut);
            ps.setDate(3, dateFin);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    this.idTarif = rs.getInt(1);
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
        String sql = "UPDATE tarif_diffusion SET cout_par_diffusion = ?, date_debut = ?, date_fin = ? WHERE idtarif = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, coutParDiffusion);
            ps.setDate(2, dateDebut);
            ps.setDate(3, dateFin);
            ps.setInt(4, idTarif);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            delete(conn);
        }
    }

    public void delete(Connection conn) throws SQLException {
        String sql = "DELETE FROM tarif_diffusion WHERE idtarif = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTarif);
            ps.executeUpdate();
        }
    }

    public static TarifDiffusion findById(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findById(conn, id);
        }
    }

    public static TarifDiffusion findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT * FROM tarif_diffusion WHERE idtarif = ?";
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

    public static List<TarifDiffusion> findAll() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAll(conn);
        }
    }

    public static List<TarifDiffusion> findAll(Connection conn) throws SQLException {
        List<TarifDiffusion> list = new ArrayList<>();
        String sql = "SELECT * FROM tarif_diffusion ORDER BY date_debut DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    // Récupérer le tarif en vigueur à une date donnée
    public static BigDecimal getTarifActuel() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getTarifActuel(conn);
        }
    }

    public static BigDecimal getTarifActuel(Connection conn) throws SQLException {
        // D'abord chercher un tarif actuellement en vigueur
        String sql = "SELECT cout_par_diffusion FROM tarif_diffusion " +
                     "WHERE date_debut <= CURRENT_DATE AND (date_fin IS NULL OR date_fin >= CURRENT_DATE) " +
                     "ORDER BY date_debut DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("cout_par_diffusion");
            }
        }
        
        // Si aucun tarif en vigueur, prendre le tarif le plus récent (même expiré)
        String sqlRecent = "SELECT cout_par_diffusion FROM tarif_diffusion " +
                          "ORDER BY date_debut DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sqlRecent);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("cout_par_diffusion");
            }
        }
        
        return TARIF_DEFAULT;
    }

    // Récupérer le tarif en vigueur pour une date spécifique
    public static BigDecimal getTarifPourDate(Date date) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getTarifPourDate(conn, date);
        }
    }

    public static BigDecimal getTarifPourDate(Connection conn, Date date) throws SQLException {
        String sql = "SELECT cout_par_diffusion FROM tarif_diffusion " +
                     "WHERE date_debut <= ? AND (date_fin IS NULL OR date_fin >= ?) " +
                     "ORDER BY date_debut DESC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setDate(2, date);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("cout_par_diffusion");
                }
            }
        }
        return TARIF_DEFAULT;
    }

    private static TarifDiffusion fromResultSet(ResultSet rs) throws SQLException {
        TarifDiffusion t = new TarifDiffusion();
        t.setIdTarif(rs.getInt("idtarif"));
        t.setCoutParDiffusion(rs.getBigDecimal("cout_par_diffusion"));
        t.setDateDebut(rs.getDate("date_debut"));
        t.setDateFin(rs.getDate("date_fin"));
        t.setDateCreation(rs.getTimestamp("date_creation"));
        return t;
    }
}
