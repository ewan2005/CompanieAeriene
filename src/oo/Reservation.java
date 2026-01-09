package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Reservation {
    private int idReservation;
    private Timestamp dateReservation;
    private boolean status;
    private int idPaiement;

    public Reservation() {}

    public Reservation(Timestamp dateReservation, boolean status) {
        this.dateReservation = dateReservation;
        this.status = status;
    }

    public Reservation(int idReservation, Timestamp dateReservation, boolean status, int idPaiement) {
        this.idReservation = idReservation;
        this.dateReservation = dateReservation;
        this.status = status;
        this.idPaiement = idPaiement;
    }

    public int getIdReservation() { return idReservation; }
    public void setIdReservation(int idReservation) { this.idReservation = idReservation; }
    public Timestamp getDateReservation() { return dateReservation; }
    public void setDateReservation(Timestamp dateReservation) { this.dateReservation = dateReservation; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    public int getIdPaiement() { return idPaiement; }
    public void setIdPaiement(int idPaiement) { this.idPaiement = idPaiement; }

    public void save() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); save(conn); } finally { if (conn != null) conn.close(); }
    }

    public void save(Connection conn) throws SQLException {
        String query = "INSERT INTO reservation (dateReservation, status, idPaiement) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setTimestamp(1, this.dateReservation);
            ps.setBoolean(2, this.status);
            if (this.idPaiement > 0) ps.setInt(3, this.idPaiement); else ps.setNull(3, Types.INTEGER);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) this.idReservation = rs.getInt(1); }
        }
    }

    public static Reservation findById(int id) throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findById(conn, id); } finally { if (conn != null) conn.close(); }
    }

    public static Reservation findById(Connection conn, int id) throws SQLException {
        String query = "SELECT * FROM reservation WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new Reservation(rs.getInt("idReservation"), rs.getTimestamp("dateReservation"), rs.getBoolean("status"), rs.getInt("idPaiement"));
            }
        }
        return null;
    }

    public static List<Reservation> findAll() throws SQLException {
        Connection conn = null;
        try { conn = DB.getconnect(); return findAll(conn); } finally { if (conn != null) conn.close(); }
    }

    public static List<Reservation> findAll(Connection conn) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String query = "SELECT * FROM reservation";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) list.add(new Reservation(rs.getInt("idReservation"), rs.getTimestamp("dateReservation"), rs.getBoolean("status"), rs.getInt("idPaiement")));
        }
        return list;
    }

    /**
     * Returns confirmed reservations (status=true). If includeReservationId > 0,
     * that reservation is included even if not confirmed (for edit forms).
     */
    public static List<Reservation> findConfirmedForSelect(int includeReservationId) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return findConfirmedForSelect(conn, includeReservationId);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public static List<Reservation> findConfirmedForSelect(Connection conn, int includeReservationId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String query =
                "SELECT * FROM reservation WHERE status = true" +
                (includeReservationId > 0 ? " OR idReservation = ?" : "") +
                " ORDER BY idReservation DESC";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            if (includeReservationId > 0) {
                ps.setInt(1, includeReservationId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Reservation(
                            rs.getInt("idReservation"),
                            rs.getTimestamp("dateReservation"),
                            rs.getBoolean("status"),
                            rs.getInt("idPaiement")
                    ));
                }
            }
        }
        return list;
    }

    /**
     * Returns confirmed reservations (status=true) that have no billet yet.
     * If includeReservationId > 0, that reservation is included even if it already has billets
     * (useful for edit forms).
     */
    public static List<Reservation> findConfirmedWithoutBilletForSelect(int includeReservationId) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return findConfirmedWithoutBilletForSelect(conn, includeReservationId);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public static List<Reservation> findConfirmedWithoutBilletForSelect(Connection conn, int includeReservationId) throws SQLException {
        List<Reservation> list = new ArrayList<>();

        String query =
                "SELECT r.* " +
                "FROM reservation r " +
                "WHERE r.status = true " +
                "AND (NOT EXISTS (SELECT 1 FROM billet b WHERE b.idReservation = r.idReservation)" +
                (includeReservationId > 0 ? " OR r.idReservation = ?" : "") +
                ") " +
                "ORDER BY r.idReservation DESC";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            if (includeReservationId > 0) {
                ps.setInt(1, includeReservationId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Reservation(
                            rs.getInt("idReservation"),
                            rs.getTimestamp("dateReservation"),
                            rs.getBoolean("status"),
                            rs.getInt("idPaiement")
                    ));
                }
            }
        }
        return list;
    }

    /**
     * Returns only reservations that are confirmed (status=true) and not yet linked to a passenger.
     * If includeReservationId > 0, that reservation is included even if already linked.
     */
    public static List<Reservation> findAvailableForPassager(int includeReservationId) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return findAvailableForPassager(conn, includeReservationId);
        } finally {
            if (conn != null) conn.close();
        }
    }

    public static List<Reservation> findAvailableForPassager(Connection conn, int includeReservationId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String query =
                "SELECT r.* " +
                "FROM reservation r " +
                "WHERE (r.status = true) " +
                "AND (NOT EXISTS (SELECT 1 FROM passager p WHERE p.idReservation = r.idReservation)" +
                (includeReservationId > 0 ? " OR r.idReservation = ?" : "") +
                ") " +
                "ORDER BY r.idReservation DESC";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            if (includeReservationId > 0) {
                ps.setInt(1, includeReservationId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Reservation(
                            rs.getInt("idReservation"),
                            rs.getTimestamp("dateReservation"),
                            rs.getBoolean("status"),
                            rs.getInt("idPaiement")
                    ));
                }
            }
        }
        return list;
    }

    public void update() throws SQLException { Connection conn = null; try { conn = DB.getconnect(); update(conn); } finally { if (conn != null) conn.close(); } }

    public void update(Connection conn) throws SQLException {
        String query = "UPDATE reservation SET dateReservation = ?, status = ?, idPaiement = ? WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setTimestamp(1, this.dateReservation);
            ps.setBoolean(2, this.status);
            if (this.idPaiement > 0) ps.setInt(3, this.idPaiement); else ps.setNull(3, Types.INTEGER);
            ps.setInt(4, this.idReservation);
            ps.executeUpdate();
        }
    }

    public void delete() throws SQLException { Connection conn = null; try { conn = DB.getconnect(); delete(conn); } finally { if (conn != null) conn.close(); } }

    public void delete(Connection conn) throws SQLException {
        String query = "DELETE FROM reservation WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(query)) { ps.setInt(1, this.idReservation); ps.executeUpdate(); }
    }

    // Example: create a reservation together with a payment in a single transaction
    public static Reservation createWithPayment(Reservation reservation, Paiement paiement, Connection conn) throws SQLException {
        boolean previousAuto = conn.getAutoCommit();
        try {
            conn.setAutoCommit(false);

            // save payment first
            paiement.save(conn);

            // link payment to reservation
            reservation.setIdPaiement(paiement.getIdPaiement());
            reservation.save(conn);

            // commit
            conn.commit();
            return reservation;
        } catch (SQLException ex) {
            conn.rollback();
            throw ex;
        } finally {
            conn.setAutoCommit(previousAuto);
        }
    }
}
