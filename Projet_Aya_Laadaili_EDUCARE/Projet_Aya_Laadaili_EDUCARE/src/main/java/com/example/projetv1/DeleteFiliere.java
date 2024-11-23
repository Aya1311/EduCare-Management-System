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

@WebServlet("/DeleteFiliere")
public class DeleteFiliere extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idFiliere = Integer.parseInt(request.getParameter("idFiliere"));

        String url = "jdbc:mysql://localhost:3306/EduCare";
        String user = "root";
        String password = ""; // Adjust your DB password

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String sql = "DELETE FROM filiere WHERE id_filiere = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, idFiliere);
                pstmt.executeUpdate();
            }
            response.sendRedirect("dashboard_admin.jsp"); // Redirect back to the dashboard
        } catch (Exception e) {
            e.printStackTrace();
            // Handle exceptions
        }
    }
}
