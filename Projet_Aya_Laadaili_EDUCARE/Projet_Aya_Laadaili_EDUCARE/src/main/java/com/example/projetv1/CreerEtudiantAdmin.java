package com.example.projetv1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CreerEtudiantAdmin")
public class CreerEtudiantAdmin extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Database connection details
        String url = "jdbc:mysql://localhost:3306/EduCare";
        String user = "root";
        String password = ""; // Adjust your DB password

        // Student details from the form
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String dateNaissance = request.getParameter("datedenaissance");
        String email = request.getParameter("email");
        String motdepasse = request.getParameter("motdepasse");
        String sexe = request.getParameter("sexe");
        String adresse = request.getParameter("adresse");
        String telephone = request.getParameter("telephone");
        int idNiveau = Integer.parseInt(request.getParameter("niveauId"));
        String statut = request.getParameter("statut");
        int idFiliere = Integer.parseInt(request.getParameter("filiereId"));
        String[] cours = request.getParameterValues("cours");

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Insert student data into 'etudiant' table
            String sql = "INSERT INTO etudiant (nom, prenom, datedenaissance, email, motdepasse, sexe, adresse, telephone, id_niveau, statut, id_filiere) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, nom);
                pstmt.setString(2, prenom);
                pstmt.setString(3, dateNaissance);
                pstmt.setString(4, email);
                pstmt.setString(5, motdepasse);
                pstmt.setString(6, sexe);
                pstmt.setString(7, adresse);
                pstmt.setString(8, telephone);
                pstmt.setInt(9, idNiveau);
                pstmt.setString(10, statut);
                pstmt.setInt(11, idFiliere);

                pstmt.executeUpdate();

                // Retrieve the generated ID for the student
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int idEtudiant = rs.getInt(1);

                        // Insert student's course enrollments into 'etu_cours' table
                        String sqlCourse = "INSERT INTO etu_cours (id_etudiant, id_cours) VALUES (?, ?)";
                        try (PreparedStatement pstmtCourse = conn.prepareStatement(sqlCourse)) {
                            for (String idCours : cours) {
                                pstmtCourse.setInt(1, idEtudiant);
                                pstmtCourse.setInt(2, Integer.parseInt(idCours));
                                pstmtCourse.executeUpdate();
                            }
                        }
                    }
                }
            }
            response.sendRedirect("dashboard_admin.jsp"); // Redirect back to the dashboard
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exceptions
        }
    }
}
