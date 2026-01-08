package oo;

import utils.DB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class User {
    private int id;
    private String name;
    private String password;
    

    public User() {
    }
    
    public User(String name, String password) {
        this.name = name;
        this.password = password;
    }
    
    public User(int id, String name, String password) {
        this.id = id;
        this.name = name;
        this.password = password;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public void save() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            save(conn);
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    public void save(Connection conn) throws SQLException {
        String query = "INSERT INTO user (name, password) VALUES (?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, this.name);
            ps.setString(2, this.password);
            
            ps.executeUpdate();
            
            // Get the generated ID
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    this.id = rs.getInt(1);
                }
            }
        }
    }
    
    public static User findById(int id) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return findById(conn, id);
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    public static User findById(Connection conn, int id) throws SQLException {
        String query = "SELECT * FROM user WHERE id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("password")
                    );
                }
            }
        }
        
        return null;
    }
    
    public static List<User> findAll() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return findAll(conn);
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    public static List<User> findAll(Connection conn) throws SQLException {
        List<User> users = new ArrayList<>();
        String query = "SELECT * FROM user";
        
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                users.add(new User(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("password")
                ));
            }
        }
        
        return users;
    }
    
    public void update() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            update(conn);
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    public void update(Connection conn) throws SQLException {
        String query = "UPDATE user SET name = ?, password = ? WHERE id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, this.name);
            ps.setString(2, this.password);
            ps.setInt(3, this.id);
            
            ps.executeUpdate();
        }
    }
    
    public void delete() throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            delete(conn);
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    public void delete(Connection conn) throws SQLException {
        String query = "DELETE FROM user WHERE id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, this.id);
            ps.executeUpdate();
        }
    }


    public static User authenticate(String username, String password) throws SQLException {
        Connection conn = null;
        try {
            conn = DB.getconnect();
            return authenticate(conn, username, password);
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    public static User authenticate(Connection conn, String username, String password) throws SQLException {
        String query = "SELECT * FROM user WHERE name = ? AND password = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("password")
                    );
                }
            }
        }
        
        return null; 
    }

}