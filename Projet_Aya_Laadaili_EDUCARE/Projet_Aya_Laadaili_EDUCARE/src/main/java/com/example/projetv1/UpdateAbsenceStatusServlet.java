package com.example.projetv1;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateAbsenceStatusServlet")
public class UpdateAbsenceStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String studentId = request.getParameter("id");
        String courseId = request.getParameter("courseId");
        int currentState = Integer.parseInt(request.getParameter("state"));

        boolean updateSuccess = updateOrInsertAbsence(studentId, courseId, currentState);

        PrintWriter out = response.getWriter();
        response.setContentType("text/html");

        if (updateSuccess) {
            out.print("success");
        } else {
            out.print("failure");
        }
    }

    private boolean updateOrInsertAbsence(String studentId, String courseId, int currentState) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/EduCare";
            String login = "root";
            String password = "";

            try (Connection con = DriverManager.getConnection(url, login, password)) {
                // Vérifier si une entrée existe déjà pour la date actuelle
                String checkQuery = "SELECT COUNT(*) FROM absence WHERE id_etudiant = ? AND id_cours = ? AND date_click = CURRENT_DATE";
                try (PreparedStatement checkStmt = con.prepareStatement(checkQuery)) {
                    checkStmt.setString(1, studentId);
                    checkStmt.setString(2, courseId);
                    ResultSet rs = checkStmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Mise à jour de l'entrée existante
                        String updateQuery = "UPDATE absence SET absence = ? WHERE id_etudiant = ? AND id_cours = ? AND date_click = CURRENT_DATE";
                        try (PreparedStatement updateStmt = con.prepareStatement(updateQuery)) {
                            updateStmt.setInt(1, 1 - currentState);
                            updateStmt.setString(2, studentId);
                            updateStmt.setString(3, courseId);
                            updateStmt.executeUpdate();
                            return true;
                        }
                    } else {
                        // Insérer une nouvelle entrée
                        String insertQuery = "INSERT INTO absence (id_etudiant, id_cours, absence, date_click) VALUES (?, ?, ?, CURRENT_DATE)";
                        try (PreparedStatement insertStmt = con.prepareStatement(insertQuery)) {
                            insertStmt.setString(1, studentId);
                            insertStmt.setString(2, courseId);
                            insertStmt.setInt(3, 1 - currentState);
                            insertStmt.executeUpdate();
                            return true;
                        }
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}