package com.example.projetv1;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/traitementCreerProfesseur")
public class traitementCreerProfesseur extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        int age = Integer.parseInt(request.getParameter("age"));
        String dateDeNaissance = request.getParameter("date_de_naissance");
        String adresse = request.getParameter("adresse");
        String numeroTelephone = request.getParameter("numero_telephone");
        String sexe = request.getParameter("sexe");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("mot_de_passe");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Connexion à la base de données
            String url = "jdbc:mysql://localhost:3306/EduCare";
            String username = "root";
            String password = "";
            conn = DriverManager.getConnection(url, username, password);

            // Requête SQL pour insérer les données
            String sql = "INSERT INTO professeur (nom, prenom, age, date_de_naissance, adresse, numero_telephone, sexe, email, motdepasse) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setInt(3, age);
            pstmt.setString(4, dateDeNaissance);
            pstmt.setString(5, adresse);
            pstmt.setString(6, numeroTelephone);
            pstmt.setString(7, sexe);
            pstmt.setString(8, email);
            pstmt.setString(9, motDePasse);

            // Exécution de la requête
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Fermeture des ressources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Redirection vers une page après l'insertion (à modifier selon votre besoin)
        response.sendRedirect("liste_prof_admin.jsp");
    }
}
