package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/CreerEtudiant")
public class CreerEtudiant extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Récupérer les données du formulaire
        int idSecretaire = Integer.parseInt(request.getParameter("idSecretaire"));
        int idNiveau = Integer.parseInt(request.getParameter("idNiveau"));
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String datedenaissance = request.getParameter("datedenaissance");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motdepasse");
        String sexe = request.getParameter("sexe");
        String adresse = request.getParameter("adresse");
        String telephone = request.getParameter("telephone");
        int filiereId = Integer.parseInt(request.getParameter("filiereId"));
        String statut = request.getParameter("statut");

        // Connexion à la base de données
        String url = "jdbc:mysql://localhost:3306/EduCare";
        String user = "root";
        String password = "";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Insérer les données de l'étudiant dans la base de données
            String sql = "INSERT INTO etudiant (nom, prenom, datedenaissance, email, motdepasse, sexe, adresse, telephone, id_filiere, statut,id_niveau) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setString(3, datedenaissance);
            pstmt.setString(4, email);
            pstmt.setString(5, motDePasse);
            pstmt.setString(6, sexe);
            pstmt.setString(7, adresse);
            pstmt.setString(8, telephone);
            pstmt.setInt(9, filiereId);
            pstmt.setString(10, statut);
            pstmt.setInt(11, idNiveau);
            pstmt.executeUpdate();

            // Rediriger vers une page de confirmation ou de succès
            response.sendRedirect("list_etudiant_sec.jsp?secretaireId="+idSecretaire);
        } catch (SQLException e) {
            e.printStackTrace();
            // Gérer les erreurs de base de données
            // Vous pouvez rediriger vers une page d'erreur personnalisée ici
        }
    }
}
