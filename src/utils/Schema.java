package utils;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;

public final class Schema {
    private Schema() {}

    /**
     * Checks if a table exists in the current connection schema.
     * Keeps new features backward-compatible when DB migrations weren't applied yet.
     */
    public static boolean tableExists(Connection conn, String tableName) throws SQLException {
        if (conn == null) return false;
        if (tableName == null || tableName.trim().isEmpty()) return false;

        String tn = tableName.trim();
        DatabaseMetaData meta = conn.getMetaData();

        try (ResultSet rs = meta.getTables(null, null, tn, new String[]{"TABLE"})) {
            if (rs.next()) return true;
        }
        // PostgreSQL sometimes stores names in lower-case when unquoted
        try (ResultSet rs = meta.getTables(null, null, tn.toLowerCase(), new String[]{"TABLE"})) {
            return rs.next();
        }
    }
}
