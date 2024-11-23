package com.example.projetv1;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
@WebServlet("/supprimerProfesseurServlet")

public class supprimerProfesseurServlet extends HttpServlet{
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idProf = request.getParameter("id");
        Connection conn = null;

        try {
            // Connexion à la base de données
            String url = "jdbc:mysql://localhost:3306/EduCare";
            String username = "root";
            String password = "";
            conn = DriverManager.getConnection(url, username, password);

            // Désactive l'auto-commit
            conn.setAutoCommit(false);

            // Étape 3 : Suppression des données associées
            supprimerDonneesAssociees(conn, idProf);

            // Étape 4 : Suppression du professeur
            supprimerProfesseur(conn, idProf);

            // Commit les modifications
            conn.commit();

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException se) {
                se.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            // Fermeture de la connexion
            try {
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }

        // Redirection vers une page ou servlet après l'opération
        response.sendRedirect("liste_prof_admin.jsp");
    }

    private void supprimerDonneesAssociees(Connection conn, String idProf) throws SQLException {
        // Suppression des données dans prof_niveau
        try (PreparedStatement pstmt = conn.prepareStatement("DELETE FROM prof_niveau WHERE id_prof = ?")) {
            pstmt.setInt(1, Integer.parseInt(idProf));
            pstmt.executeUpdate();
        }

        // Mise à jour de l'id_prof dans la table cours
        try (PreparedStatement pstmt = conn.prepareStatement("UPDATE cours SET id_prof = NULL WHERE id_prof = ?")) {
            pstmt.setInt(1, Integer.parseInt(idProf));
            pstmt.executeUpdate();
        }
    }

    private void supprimerProfesseur(Connection conn, String idProf) throws SQLException {
        // Suppression du professeur dans la table professeur
        try (PreparedStatement pstmt = conn.prepareStatement("DELETE FROM professeur WHERE id_prof = ?")) {
            pstmt.setInt(1, Integer.parseInt(idProf));
            pstmt.executeUpdate();
        }
    }
}