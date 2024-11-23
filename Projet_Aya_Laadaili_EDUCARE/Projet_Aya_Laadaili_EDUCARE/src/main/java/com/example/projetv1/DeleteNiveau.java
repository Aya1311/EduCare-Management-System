package com.example.projetv1;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteNiveau")
public class DeleteNiveau extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idNiveau = Integer.parseInt(request.getParameter("idNiveau"));

        String url = "jdbc:mysql://localhost:3306/EduCare";
        String user = "root";
        String password = ""; // Adjust your DB password

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Delete related rows from prof_niveau first
            String sqlDeleteProfNiveau = "DELETE FROM prof_niveau WHERE id_niveau = ?";
            try (PreparedStatement pstmtDeleteProfNiveau = conn.prepareStatement(sqlDeleteProfNiveau)) {
                pstmtDeleteProfNiveau.setInt(1, idNiveau);
                pstmtDeleteProfNiveau.executeUpdate();
            }

            // Now delete the niveau
            String sqlDeleteNiveau = "DELETE FROM niveau WHERE id_niveau = ?";
            try (PreparedStatement pstmtDeleteNiveau = conn.prepareStatement(sqlDeleteNiveau)) {
                pstmtDeleteNiveau.setInt(1, idNiveau);
                pstmtDeleteNiveau.executeUpdate();
            }
            response.sendRedirect("dashboard_admin.jsp?adminId=1"); // Redirect back to the dashboard
        } catch (Exception e) {
            e.printStackTrace();
            // Handle exceptions
        }
    }
}
