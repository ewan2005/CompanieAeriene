package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public final class Web {
    private Web() {}

    public static void redirectValidation(HttpServletRequest request, HttpServletResponse response, String message, String backPath) throws IOException {
        String msg = message == null ? "" : message;
        String back = (backPath == null || backPath.isEmpty()) ? (request.getContextPath() + "/Accueil.jsp") : (request.getContextPath() + backPath);

        String url = request.getContextPath()
                + "/validation.jsp?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8)
                + "&back=" + URLEncoder.encode(back, StandardCharsets.UTF_8);
        response.sendRedirect(url);
    }

    public static void redirectError(HttpServletRequest request, HttpServletResponse response, String message, String backPath) throws IOException {
        String msg = message == null ? "" : message;
        String back = (backPath == null || backPath.isEmpty()) ? (request.getContextPath() + "/Accueil.jsp") : (request.getContextPath() + backPath);

        String url = request.getContextPath()
                + "/error.jsp?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8)
                + "&back=" + URLEncoder.encode(back, StandardCharsets.UTF_8);
        response.sendRedirect(url);
    }
}
