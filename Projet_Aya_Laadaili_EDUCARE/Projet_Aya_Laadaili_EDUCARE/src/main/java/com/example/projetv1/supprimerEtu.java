package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/supprimerEtu")
public class supprimerEtu extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idEtudiant = request.getParameter("idEtudiant");
        String idSecretaire = request.getParameter("idSecretaire");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
            String sqlDeleteEtuCours = "DELETE FROM etu_cours WHERE id_etudiant = ?";
            try (PreparedStatement pstmtDeleteEtuCours = conn.prepareStatement(sqlDeleteEtuCours)) {
                pstmtDeleteEtuCours.setInt(1, Integer.parseInt(idEtudiant));
                pstmtDeleteEtuCours.executeUpdate();
            }
            String sqlDeleteEtudiant = "DELETE FROM etudiant WHERE id_etudiant = ?";
            try (PreparedStatement pstmtDeleteEtudiant = conn.prepareStatement(sqlDeleteEtudiant)) {
                pstmtDeleteEtudiant.setInt(1, Integer.parseInt(idEtudiant));
                pstmtDeleteEtudiant.executeUpdate();
            }
            response.sendRedirect("list_etudiant_sec.jsp?secretaireId=" + idSecretaire);
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exception or redirect to an error page
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}

