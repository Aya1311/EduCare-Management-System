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

@WebServlet("/CreateFiliereServlet")
public class CreateFiliereServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filiereName = request.getParameter("filiereName");
        int niveauId = Integer.parseInt(request.getParameter("niveauId"));

        String url = "jdbc:mysql://localhost:3306/EduCare";
        String user = "root";
        String password = ""; // Adjust your DB password

        // Database connection and insert logic
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql = "INSERT INTO filiere (nom_filiere, id_niveau) VALUES (?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, filiereName);
                pstmt.setInt(2, niveauId);
                pstmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exceptions properly in production code
        }

        // Redirect back to the dashboard
        response.sendRedirect("dashboard_admin.jsp");
    }
}

