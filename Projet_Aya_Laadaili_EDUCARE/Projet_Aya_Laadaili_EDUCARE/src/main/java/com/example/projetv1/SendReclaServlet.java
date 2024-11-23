package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet("/SendReclaServlet")
public class SendReclaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idEtudiant = Integer.parseInt(request.getParameter("idEtudiant"));
        String messageText = request.getParameter("message");

        String url = "jdbc:mysql://localhost:3306/EduCare";
        String user = "root";
        String password = ""; // Remplacez par votre mot de passe de base de données

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String nomEtudiant = "";
            String prenomEtudiant = "";

            // Récupérer le nom et le prénom de l'étudiant
            String sqlEtudiant = "SELECT nom, prenom FROM etudiant WHERE id_etudiant = ?";
            try (PreparedStatement pstmtEtudiant = conn.prepareStatement(sqlEtudiant)) {
                pstmtEtudiant.setInt(1, idEtudiant);
                try (ResultSet rs = pstmtEtudiant.executeQuery()) {
                    if (rs.next()) {
                        nomEtudiant = rs.getString("nom");
                        prenomEtudiant = rs.getString("prenom");
                    }
                }
            }

            // Insérer l'entrée dans msg_rcp_emt et récupérer l'ID généré
            String sqlRcpEmt = "INSERT INTO msg_rcp_emt (id_log_recepteur, id_log_emetteur, id_recepteur, id_emetteur) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmtRcpEmt = conn.prepareStatement(sqlRcpEmt, Statement.RETURN_GENERATED_KEYS)) {
                pstmtRcpEmt.setInt(1, 0); // id_log_recepteur
                pstmtRcpEmt.setInt(2, 2); // id_log_emetteur
                pstmtRcpEmt.setInt(3, 1); // id_recepteur (admin)
                pstmtRcpEmt.setInt(4, idEtudiant); // id_emetteur (étudiant)
                pstmtRcpEmt.executeUpdate();

                try (ResultSet generatedKeys = pstmtRcpEmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        long idRcpEmt = generatedKeys.getLong(1);

                        // Insérer le message dans la table message
                        String sql = "INSERT INTO message (message, id_rcp_emt) VALUES (?, ?)";
                        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                            String fullMessage = "Message de " + nomEtudiant + " " + prenomEtudiant + ": " + messageText;
                            pstmt.setString(1, fullMessage);
                            pstmt.setLong(2, idRcpEmt);
                            pstmt.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de l'accès à la base de données", e);
        }

        // Redirection vers dashboard_s.jsp avec l'ID de l'étudiant en paramètre
        response.sendRedirect("dashboard_s.jsp?studentId=" + idEtudiant);
    }
}
