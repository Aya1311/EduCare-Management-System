package com.example.projetv1;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/EnregistrerEtudiantServlet")
public class EnregistrerEtudiantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nom = request.getParameter("First_Name");
        String prenom = request.getParameter("Last_Name");
        String datedenaissance = request.getParameter("date_naissance");
        String email = request.getParameter("email");
        String motdepasse = request.getParameter("password");
        String sexe = request.getParameter("sexe");
        String adresse = request.getParameter("Address");
        String niveauetude = request.getParameter("niveau");
        String nomFiliere = request.getParameter("nom_filiere");
        String telephone = request.getParameter("telephone");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/EduCare";
            String username = "root";
            String password = "";
            Connection connection = DriverManager.getConnection(url, username, password);

            // Trouver l'ID de la filière basé sur le nom
            String filiereQuery = "SELECT id_filiere FROM filiere WHERE nom_filiere = ?";
            PreparedStatement filiereStatement = connection.prepareStatement(filiereQuery);
            filiereStatement.setString(1, nomFiliere);
            ResultSet filiereResult = filiereStatement.executeQuery();
            int idFiliere = 0;
            if (filiereResult.next()) {
                idFiliere = filiereResult.getInt("id_filiere");
            }

            // Récupération de l'ID du niveau
            String niveauQuery = "SELECT id_niveau FROM niveau WHERE niveau = ?";
            PreparedStatement niveauStatement = connection.prepareStatement(niveauQuery);
            niveauStatement.setString(1, niveauetude);
            ResultSet niveauResult = niveauStatement.executeQuery();

            int niveauId = 0;
            if (niveauResult.next()) {
                niveauId = niveauResult.getInt("id_niveau");
            }

            // Insertion des données dans la table 'etudiant'
            String insertQuery = "INSERT INTO etudiant (nom, prenom, datedenaissance, email, motdepasse, sexe, adresse, id_niveau, id_filiere, telephone) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement preparedStatement = connection.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, nom);
            preparedStatement.setString(2, prenom);
            preparedStatement.setDate(3, java.sql.Date.valueOf(datedenaissance));
            preparedStatement.setString(4, email);
            preparedStatement.setString(5, motdepasse);
            preparedStatement.setString(6, sexe);
            preparedStatement.setString(7, adresse);
            preparedStatement.setInt(8, niveauId);
            preparedStatement.setInt(9, idFiliere);
            preparedStatement.setString(10, telephone);

            int rowsAffected = preparedStatement.executeUpdate();

            if (rowsAffected > 0) {
                // Redirection après une inscription réussie
                response.sendRedirect("login.jsp");
            } else {
                // Gérer l'échec de l'inscription
                response.sendRedirect("echec.jsp");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de l'enregistrement de l'étudiant : " + e.getMessage());
        }
    }
}
