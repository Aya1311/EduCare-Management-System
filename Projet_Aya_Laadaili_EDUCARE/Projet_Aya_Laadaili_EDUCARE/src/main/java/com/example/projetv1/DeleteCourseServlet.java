package com.example.projetv1;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteCourseServlet")
public class DeleteCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         // Récupérer les paramètres du formulaire
        String courseId = request.getParameter("courseId");
        String studentId = request.getParameter("studentId");
        System.out.println("Course ID: " + courseId);
        System.out.println("Student ID: " + studentId);
        // Définir les paramètres de connexion à la base de données
        String url = "jdbc:mysql://localhost:3306/EduCare";
        String username = "root";
        String password = ""; // Remplacer avec le mot de passe de votre BD si nécessaire

        try {
            // Charger le pilote JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Établir la connexion à la base de données
            try (Connection con = DriverManager.getConnection(url, username, password)) {

                // Utiliser une PreparedStatement pour éviter les attaques par injection SQL
                String query = "DELETE FROM etu_cours WHERE id_cours = ? AND id_etudiant = ?";
                try (PreparedStatement pstmt = con.prepareStatement(query)) {
                    pstmt.setInt(1, Integer.parseInt(courseId));
                    pstmt.setInt(2, Integer.parseInt(studentId));
                    // Exécuter la mise à jour
                    int rowCount = pstmt.executeUpdate();
                }

                // Rediriger vers la page actuelle (dashboard_s.jsp) après la suppression
                response.sendRedirect("dashboard_s.jsp?studentId=" + studentId);

            }
        } catch (SQLException | ClassNotFoundException e) {
            // Gérer les exceptions
            e.printStackTrace(); // Logguer l'exception complète pour déboguer
            // Rediriger vers la page actuelle (dashboard_s.jsp) en cas d'erreur
            response.sendRedirect("dashboard_s.jsp?studentId=" + studentId);
        }
    }
}
