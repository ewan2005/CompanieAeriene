package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DB;
import utils.Web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class TarifServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection conn = DB.getconnect()) {
            if ("edit".equals(action)) {
                String type = request.getParameter("type");
                String q = "SELECT type_place, tarif FROM tarif_classe WHERE type_place = ?";
                try (PreparedStatement ps = conn.prepareStatement(q)) {
                    ps.setString(1, type);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("type_place", rs.getString("type_place"));
                            request.setAttribute("tarif", rs.getBigDecimal("tarif"));
                        } else {
                            request.setAttribute("type_place", type);
                            request.setAttribute("tarif", null);
                        }
                    }
                }
                request.getRequestDispatcher("formTarif.jsp").forward(request, response);
                return;
            }

            // list
            String q = "SELECT type_place, tarif FROM tarif_classe ORDER BY type_place";
            List<Object[]> list = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(q); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(new Object[]{ rs.getString("type_place"), rs.getBigDecimal("tarif") });
            }
            request.setAttribute("tarifs", list);
            request.getRequestDispatcher("listTarif.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try (Connection conn = DB.getconnect()) {
            if ("save".equals(action)) {
                String type = request.getParameter("type_place");
                String tarifStr = request.getParameter("tarif");
                if (type == null || tarifStr == null) {
                    Web.redirectError(request, response, "Type ou tarif manquant.", "/TarifServlet");
                    return;
                }
                BigDecimal tarif = new BigDecimal(tarifStr);
                String q = "INSERT INTO tarif_classe (type_place, tarif) VALUES (?, ?) ON CONFLICT (type_place) DO UPDATE SET tarif = EXCLUDED.tarif";
                try (PreparedStatement ps = conn.prepareStatement(q)) {
                    ps.setString(1, type);
                    ps.setBigDecimal(2, tarif);
                    ps.executeUpdate();
                }
                Web.redirectValidation(request, response, "Tarif enregistré.", "/TarifServlet");
                return;
            } else if ("delete".equals(action)) {
                String type = request.getParameter("type_place");
                String q = "DELETE FROM tarif_classe WHERE type_place = ?";
                try (PreparedStatement ps = conn.prepareStatement(q)) {
                    ps.setString(1, type);
                    ps.executeUpdate();
                }
                Web.redirectValidation(request, response, "Tarif supprimé.", "/TarifServlet");
                return;
            }
            Web.redirectValidation(request, response, "Opération terminée.", "/TarifServlet");
        } catch (SQLException e) {
            Web.redirectError(request, response, e.getMessage(), "/TarifServlet");
        }
    }
}
