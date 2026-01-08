package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DB {
    public static Connection getconnect() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            throw new SQLException("JDBC Driver not found", e);
        }
        
        String URL = "jdbc:mysql://172.80.237.53:3306/db_s2_ETU003389";
        Properties properties = new Properties();
        properties.setProperty("user", "ETU003389");
        properties.setProperty("password", "u803RF8V");

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