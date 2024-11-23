package com.example.projetv1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/create_course")
public class create_course extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cours = request.getParameter("cours");
        int idProf = Integer.parseInt(request.getParameter("id_prof"));
        int idNiveau = Integer.parseInt(request.getParameter("id_niveau"));
        int idFiliere = Integer.parseInt(request.getParameter("id_filiere"));
        int idHoraire = Integer.parseInt(request.getParameter("id_horaire"));
        int idSalle = Integer.parseInt(request.getParameter("id_salle"));

        String url = "jdbc:mysql://localhost:3306/EduCare";
        String user = "root";
        String password = ""; // Adjust your DB password as needed

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Insert a new course
            String sql = "INSERT INTO cours (cours, id_niveau, id_prof) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, cours);
                pstmt.setInt(2, idNiveau);
                pstmt.setInt(3, idProf);
                pstmt.executeUpdate();

                // Get the generated course ID
                int generatedIdCours = 0;
                try (var rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedIdCours = rs.getInt(1);
                    }
                }

                // Update the horaire to assign it to the newly created course
                String updateHoraireSql = "UPDATE horaire SET id_cours = ?, id_salle = ? WHERE id_horaire = ?";
                try (PreparedStatement pstmtHoraire = conn.prepareStatement(updateHoraireSql)) {
                    pstmtHoraire.setInt(1, generatedIdCours);
                    pstmtHoraire.setInt(2, idSalle);
                    pstmtHoraire.setInt(3, idHoraire);
                    pstmtHoraire.executeUpdate();
                }

                // Link the course to its filiere
                String linkFiliereSql = "INSERT INTO filiere_cours (id_filiere, id_cours) VALUES (?, ?)";
                try (PreparedStatement pstmtFiliere = conn.prepareStatement(linkFiliereSql)) {
                    pstmtFiliere.setInt(1, idFiliere);
                    pstmtFiliere.setInt(2, generatedIdCours);
                    pstmtFiliere.executeUpdate();
                }

                // Link the professor to the niveau for the course
                String insertProfNiveauSql = "INSERT INTO prof_niveau (id_prof, id_niveau) VALUES (?, ?)";
                try (PreparedStatement pstmtProfNiveau = conn.prepareStatement(insertProfNiveauSql)) {
                    pstmtProfNiveau.setInt(1, idProf);
                    pstmtProfNiveau.setInt(2, idNiveau);
                    pstmtProfNiveau.executeUpdate();
                }
            }

            response.sendRedirect("dashboard_admin.jsp"); // Redirect back to the dashboard
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exceptions
        }
    }
}
