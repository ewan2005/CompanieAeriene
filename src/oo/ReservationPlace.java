package oo;

import utils.Schema;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;

public class ReservationPlace {
    private int idReservation;
    private int idVol;
    private int idPlace;

    public ReservationPlace() {}

    public ReservationPlace(int idReservation, int idVol, int idPlace) {
        this.idReservation = idReservation;
        this.idVol = idVol;
        this.idPlace = idPlace;
    }

    public int getIdReservation() { return idReservation; }
    public int getIdVol() { return idVol; }
    public int getIdPlace() { return idPlace; }

    public static boolean isAvailable(Connection conn) throws SQLException {
        return Schema.tableExists(conn, "reservation_place");
    }

    public static ReservationPlace findByReservation(Connection conn, int idReservation) throws SQLException {
        if (!isAvailable(conn)) return null;

        String q = "SELECT idReservation, idVol, idPlace FROM reservation_place WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idReservation);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ReservationPlace(rs.getInt("idReservation"), rs.getInt("idVol"), rs.getInt("idPlace"));
                }
            }
        }
        return null;
    }

    /** Returns reserved places for a vol (optionally excluding one reservation id). */
    public static Set<Integer> findReservedPlaceIdsForVol(Connection conn, int idVol, int excludeReservationId) throws SQLException {
        Set<Integer> set = new HashSet<>();
        if (!isAvailable(conn)) return set;

        String q = "SELECT idPlace FROM reservation_place WHERE idVol = ?" + (excludeReservationId > 0 ? " AND idReservation <> ?" : "");
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idVol);
            if (excludeReservationId > 0) ps.setInt(2, excludeReservationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) set.add(rs.getInt(1));
            }
        }
        return set;
    }

    public static void reserveSeat(Connection conn, int idReservation, int idVol, int idPlace) throws SQLException {
        if (!isAvailable(conn)) return;
        if (idReservation <= 0 || idVol <= 0 || idPlace <= 0) return;

        // Check if already reserved by someone else
        String check = "SELECT idReservation FROM reservation_place WHERE idVol = ? AND idPlace = ?";
        try (PreparedStatement ps = conn.prepareStatement(check)) {
            ps.setInt(1, idVol);
            ps.setInt(2, idPlace);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int existingReservationId = rs.getInt(1);
                    if (existingReservationId != idReservation) {
                        throw new SQLException("Cette place est déjà réservée pour ce vol.");
                    }
                    // Same reservation already has it
                    return;
                }
            }
        }

        // One seat per reservation per vol
        String insert = "INSERT INTO reservation_place (idReservation, idVol, idPlace) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(insert)) {
            ps.setInt(1, idReservation);
            ps.setInt(2, idVol);
            ps.setInt(3, idPlace);
            ps.executeUpdate();
        }
    }

    /**
     * Upsert seat for a reservation: if it already has a seat, replace it.
     * Enforces uniqueness (idVol, idPlace).
     */
    public static void upsertSeat(Connection conn, int idReservation, int idVol, int idPlace) throws SQLException {
        if (!isAvailable(conn)) return;
        if (idReservation <= 0 || idVol <= 0 || idPlace <= 0) return;

        ReservationPlace current = findByReservation(conn, idReservation);
        if (current != null && current.idVol == idVol && current.idPlace == idPlace) return;

        // Remove current mapping (if any) then reserve new seat
        String del = "DELETE FROM reservation_place WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(del)) {
            ps.setInt(1, idReservation);
            ps.executeUpdate();
        }
        reserveSeat(conn, idReservation, idVol, idPlace);
    }

    public static void deleteForReservation(Connection conn, int idReservation) throws SQLException {
        if (!isAvailable(conn)) return;
        String del = "DELETE FROM reservation_place WHERE idReservation = ?";
        try (PreparedStatement ps = conn.prepareStatement(del)) {
            ps.setInt(1, idReservation);
            ps.executeUpdate();
        }
    }
}
