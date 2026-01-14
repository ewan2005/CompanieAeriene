package oo;

import utils.Schema;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public final class VolTrajet {
    private VolTrajet() {}

    public static boolean isAvailable(Connection conn) throws SQLException {
        return Schema.tableExists(conn, "vol_trajet");
    }

    public static void link(Connection conn, int idVol, int idTrajet) throws SQLException {
        if (!isAvailable(conn)) return;

        String q = "INSERT INTO vol_trajet (idVol, idTrajet) VALUES (?, ?) " +
                "ON CONFLICT (idVol) DO UPDATE SET idTrajet = EXCLUDED.idTrajet";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idVol);
            ps.setInt(2, idTrajet);
            ps.executeUpdate();
        }
    }

    public static Integer findTrajetIdByVol(Connection conn, int idVol) throws SQLException {
        if (!isAvailable(conn)) return null;

        String q = "SELECT idTrajet FROM vol_trajet WHERE idVol = ?";
        try (PreparedStatement ps = conn.prepareStatement(q)) {
            ps.setInt(1, idVol);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int v = rs.getInt(1);
                    return rs.wasNull() ? null : v;
                }
            }
        }
        return null;
    }
}
