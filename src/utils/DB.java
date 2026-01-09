package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DB {
    public static Connection getconnect() throws SQLException {
        // Use PostgreSQL driver and allow configuration through environment variables.
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("PostgreSQL JDBC Driver not found: " + e.getMessage());
            throw new SQLException("JDBC Driver not found", e);
        }

        // Read DB connection info from environment variables with sensible defaults
        String host = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
        String port = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "5432";
        String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "compagnie";
        String user = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "postgres";
        String password = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "ewan2005";

        // Also accept a system property (useful when Tomcat is started with -DDB_PASSWORD=...)
        if (password == null || password.isEmpty()) {
            password = System.getProperty("DB_PASSWORD");
        }

        // If still missing, fail with a clear message so we don't attempt a connection with an empty password
        if (password == null || password.isEmpty()) {
            String msg = "Database password not provided. Set the environment variable DB_PASSWORD or start the JVM with -DDB_PASSWORD=<password>.";
            System.err.println(msg);
            throw new SQLException(msg);
        }

        String URL = String.format("jdbc:postgresql://%s:%s/%s", host, port, dbName);

        Properties properties = new Properties();
        properties.setProperty("user", user);
        properties.setProperty("password", password);

        Connection connection = null;
        try {
            connection = DriverManager.getConnection(URL, properties);
        } catch (SQLException e) {
            System.err.println("Erreur de connexion : " + e.getMessage());
            throw e;
        }

        return connection;
    }
}