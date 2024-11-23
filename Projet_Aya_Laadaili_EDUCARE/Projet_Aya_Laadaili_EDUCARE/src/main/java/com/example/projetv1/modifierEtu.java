package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/modifierEtu")
public class modifierEtu extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idEtudiant = request.getParameter("idEtudiant");
        String idSecretaire = request.getParameter("idSecretaire");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motdepasse = request.getParameter("motdepasse");
        String datedenaissance = request.getParameter("datedenaissance");
        String sexe = request.getParameter("sexe");
        String adresse = request.getParameter("adresse");
        String statut = request.getParameter("statut");
// Debugging print statements
        System.out.println("idEtudiant: " + idEtudiant);
        System.out.println("idSecretaire: " + idSecretaire);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
            String query = "UPDATE etudiant SET nom = ?, prenom = ?, email = ?, datedenaissance = ?, sexe = ?, adresse = ?, statut = ?, motdepasse = ? WHERE id_etudiant = ?";

            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setString(3, email);
            pstmt.setString(4, datedenaissance);
            pstmt.setString(5, sexe);
            pstmt.setString(6, adresse);
            pstmt.setString(7, statut);
            pstmt.setString(8, motdepasse);
            pstmt.setString(9, idEtudiant);

            pstmt.executeUpdate();
           // Redirection ou réponse en cas de succès
            response.sendRedirect("list_etudiant_sec.jsp?secretaireId="+idSecretaire);
        } catch (SQLException e) {
            e.printStackTrace();
            // Gérer l'erreur
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}

