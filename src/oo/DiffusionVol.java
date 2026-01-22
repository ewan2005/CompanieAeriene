package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Représente une diffusion de publicité sur un vol spécifique.
 * Chaque ligne = 1 diffusion affectée à 1 vol.
 */
public class DiffusionVol {
    private int idDiffusion;
    private int idAchat;
    private int idVol;
    private Timestamp dateCreation;

    // Objets liés (pour affichage)
    private AchatDiffusion achat;
    private Vol vol;

    public DiffusionVol() {}

    public DiffusionVol(int idAchat, int idVol) {
        this.idAchat = idAchat;
        this.idVol = idVol;
    }

    // Getters et Setters
    public int getIdDiffusion() { return idDiffusion; }
    public void setIdDiffusion(int idDiffusion) { this.idDiffusion = idDiffusion; }
    public int getIdAchat() { return idAchat; }
    public void setIdAchat(int idAchat) { this.idAchat = idAchat; }
    public int getIdVol() { return idVol; }
    public void setIdVol(int idVol) { this.idVol = idVol; }
    public Timestamp getDateCreation() { return dateCreation; }
    public void setDateCreation(Timestamp dateCreation) { this.dateCreation = dateCreation; }
    public AchatDiffusion getAchat() { return achat; }
    public void setAchat(AchatDiffusion achat) { this.achat = achat; }
    public Vol getVol() { return vol; }
    public void setVol(Vol vol) { this.vol = vol; }

    // CRUD Operations
    public void save() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            save(conn);
        }
    }

    public void save(Connection conn) throws SQLException {
        String sql = "INSERT INTO diffusion_vol (idachat, idvol) VALUES (?, ?) RETURNING iddiffusion";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            ps.setInt(2, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    this.idDiffusion = rs.getInt(1);
                }
            }
        }
    }

    // Affecter plusieurs diffusions d'un coup à un vol
    public static void affecterDiffusions(int idAchat, int idVol, int nombre) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            affecterDiffusions(conn, idAchat, idVol, nombre);
        }
    }

    public static void affecterDiffusions(Connection conn, int idAchat, int idVol, int nombre) throws SQLException {
        String sql = "INSERT INTO diffusion_vol (idachat, idvol) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < nombre; i++) {
                ps.setInt(1, idAchat);
                ps.setInt(2, idVol);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public void delete() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            delete(conn);
        }
    }

    public void delete(Connection conn) throws SQLException {
        String sql = "DELETE FROM diffusion_vol WHERE iddiffusion = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idDiffusion);
            ps.executeUpdate();
        }
    }

    // Supprimer des diffusions pour un achat et un vol
    public static void supprimerDiffusions(int idAchat, int idVol, int nombre) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            supprimerDiffusions(conn, idAchat, idVol, nombre);
        }
    }

    public static void supprimerDiffusions(Connection conn, int idAchat, int idVol, int nombre) throws SQLException {
        // Supprimer X diffusions pour cet achat et ce vol
        String sql = "DELETE FROM diffusion_vol WHERE iddiffusion IN " +
                     "(SELECT iddiffusion FROM diffusion_vol WHERE idachat = ? AND idvol = ? LIMIT ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            ps.setInt(2, idVol);
            ps.setInt(3, nombre);
            ps.executeUpdate();
        }
    }

    public static DiffusionVol findById(int id) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findById(conn, id);
        }
    }

    public static DiffusionVol findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT dv.*, v.numerovol, v.datedepart, s.nom as societe_nom, a.mois, a.annee " +
                     "FROM diffusion_vol dv " +
                     "JOIN achat_diffusion a ON dv.idachat = a.idachat " +
                     "JOIN societe s ON a.idsociete = s.idsociete " +
                     "JOIN vol v ON dv.idvol = v.idvol " +
                     "WHERE dv.iddiffusion = ?";
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

    public static List<DiffusionVol> findAll() throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findAll(conn);
        }
    }

    public static List<DiffusionVol> findAll(Connection conn) throws SQLException {
        List<DiffusionVol> list = new ArrayList<>();
        String sql = "SELECT dv.*, v.numerovol, v.datedepart, s.nom as societe_nom, a.mois, a.annee " +
                     "FROM diffusion_vol dv " +
                     "JOIN achat_diffusion a ON dv.idachat = a.idachat " +
                     "JOIN societe s ON a.idsociete = s.idsociete " +
                     "JOIN vol v ON dv.idvol = v.idvol " +
                     "ORDER BY v.datedepart DESC, s.nom";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        }
        return list;
    }

    // Trouver les diffusions par vol
    public static List<DiffusionVol> findByVol(int idVol) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return findByVol(conn, idVol);
        }
    }

    public static List<DiffusionVol> findByVol(Connection conn, int idVol) throws SQLException {
        List<DiffusionVol> list = new ArrayList<>();
        String sql = "SELECT dv.*, v.numerovol, v.datedepart, s.nom as societe_nom, a.mois, a.annee " +
                     "FROM diffusion_vol dv " +
                     "JOIN achat_diffusion a ON dv.idachat = a.idachat " +
                     "JOIN societe s ON a.idsociete = s.idsociete " +
                     "JOIN vol v ON dv.idvol = v.idvol " +
                     "WHERE dv.idvol = ? ORDER BY s.nom";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(fromResultSet(rs));
                }
            }
        }
        return list;
    }

    // Compter les diffusions par société pour un vol
    public static List<Object[]> countBySocieteForVol(int idVol) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return countBySocieteForVol(conn, idVol);
        }
    }

    public static List<Object[]> countBySocieteForVol(Connection conn, int idVol) throws SQLException {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT s.nom, COUNT(dv.iddiffusion) as nb_diffusions " +
                     "FROM diffusion_vol dv " +
                     "JOIN achat_diffusion a ON dv.idachat = a.idachat " +
                     "JOIN societe s ON a.idsociete = s.idsociete " +
                     "WHERE dv.idvol = ? GROUP BY s.nom ORDER BY s.nom";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Object[]{
                        rs.getString("nom"),
                        rs.getInt("nb_diffusions")
                    });
                }
            }
        }
        return list;
    }

    // Résumé des diffusions par vol pour un mois/année
    public static List<Object[]> getResumeParVol(int mois, int annee) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return getResumeParVol(conn, mois, annee);
        }
    }

    public static List<Object[]> getResumeParVol(Connection conn, int mois, int annee) throws SQLException {
        List<Object[]> list = new ArrayList<>();
        // D'abord récupérer les vols distincts avec le nombre total de diffusions et les sociétés
        String sql = "SELECT v.idvol, v.numerovol, v.datedepart, " +
                     "COUNT(dv.iddiffusion) as nb_diffusions, " +
                     "STRING_AGG(DISTINCT s.nom, ', ' ORDER BY s.nom) as societes " +
                     "FROM diffusion_vol dv " +
                     "JOIN achat_diffusion a ON dv.idachat = a.idachat " +
                     "JOIN societe s ON a.idsociete = s.idsociete " +
                     "JOIN vol v ON dv.idvol = v.idvol " +
                     "WHERE a.mois = ? AND a.annee = ? " +
                     "GROUP BY v.idvol, v.numerovol, v.datedepart " +
                     "ORDER BY v.datedepart";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, mois);
            ps.setInt(2, annee);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Object[]{
                        rs.getInt("idvol"),           // 0: idVol
                        rs.getString("numerovol"),    // 1: numeroVol
                        rs.getDate("datedepart"),     // 2: dateDepart
                        rs.getInt("nb_diffusions"),   // 3: nbDiffusions
                        rs.getString("societes")      // 4: societes (concatenées)
                    });
                }
            }
        }
        return list;
    }

    // Compter les diffusions déjà affectées pour un achat
    public static int countByAchat(int idAchat) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return countByAchat(conn, idAchat);
        }
    }

    public static int countByAchat(Connection conn, int idAchat) throws SQLException {
        String sql = "SELECT COUNT(*) FROM diffusion_vol WHERE idachat = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // Compter les diffusions par achat et vol
    public static int countByAchatAndVol(int idAchat, int idVol) throws SQLException {
        try (Connection conn = DB.getconnect()) {
            return countByAchatAndVol(conn, idAchat, idVol);
        }
    }

    public static int countByAchatAndVol(Connection conn, int idAchat, int idVol) throws SQLException {
        String sql = "SELECT COUNT(*) FROM diffusion_vol WHERE idachat = ? AND idvol = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idAchat);
            ps.setInt(2, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private static DiffusionVol fromResultSet(ResultSet rs) throws SQLException {
        DiffusionVol dv = new DiffusionVol();
        dv.setIdDiffusion(rs.getInt("iddiffusion"));
        dv.setIdAchat(rs.getInt("idachat"));
        dv.setIdVol(rs.getInt("idvol"));
        dv.setDateCreation(rs.getTimestamp("date_creation"));

        // Créer les objets liés
        AchatDiffusion a = new AchatDiffusion();
        a.setIdAchat(dv.getIdAchat());
        a.setMois(rs.getInt("mois"));
        a.setAnnee(rs.getInt("annee"));
        Societe s = new Societe();
        s.setNom(rs.getString("societe_nom"));
        a.setSociete(s);
        dv.setAchat(a);

        Vol v = new Vol();
        v.setIdVol(dv.getIdVol());
        v.setNumeroVol(rs.getString("numerovol"));
        v.setDateDepart(rs.getTimestamp("datedepart"));
        dv.setVol(v);

        return dv;
    }
}
