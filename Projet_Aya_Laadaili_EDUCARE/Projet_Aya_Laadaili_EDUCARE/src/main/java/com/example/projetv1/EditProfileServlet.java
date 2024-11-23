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

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Récupérez les valeurs soumises du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String telephone = request.getParameter("telephone");
        String adresse = request.getParameter("adresse");
        String email = request.getParameter("email");
        String sexe = request.getParameter("sexe");
        int idUtilisateur = Integer.parseInt(request.getParameter("idUtilisateur"));

        // Mettez à jour les données dans la base de données
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

            // Mettez à jour la table etudiant avec les nouvelles valeurs
            String query = "UPDATE etudiant SET nom=?, prenom=?, telephone=?, adresse=?, email=?, sexe=? WHERE id_etudiant=?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setString(3, telephone);
            pstmt.setString(4, adresse);
            pstmt.setString(5, email);
            pstmt.setString(6, sexe);
            pstmt.setInt(7, idUtilisateur);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Mise à jour réussie
                response.sendRedirect("etudiant_profile.jsp?studentId=" + idUtilisateur);
            } else {
                // Échec de la mise à jour
                // Gérer l'erreur ou renvoyer un message d'erreur à l'utilisateur
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Gérer l'erreur SQL
        } finally {
            // Fermez les ressources (conn, pstmt, etc.)
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
