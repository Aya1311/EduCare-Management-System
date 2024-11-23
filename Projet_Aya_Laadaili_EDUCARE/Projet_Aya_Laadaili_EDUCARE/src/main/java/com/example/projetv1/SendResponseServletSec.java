package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/SendResponseServletSec")
public class SendResponseServletSec extends HttpServlet  {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("message");
        int userId = Integer.parseInt(request.getParameter("userId")); // ID de l'utilisateur (secrétaire)
        // Déterminer l'ID du destinataire et de l'émetteur pour msg_rcp_emt
        int idLogRecepteur = 0; // ID log du destinataire, fixe à 0
        int idLogEmetteur = 1; // ID log de l'émetteur, fixe à 1
        int idRecepteur = 1; // ID du destinataire, fixe à 1
        int idEmetteur = userId; // ID de l'émetteur, récupéré de l'URL

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "")) {
            // Commencez par insérer dans msg_rcp_emt
            try (PreparedStatement statementRcpEmt = connection.prepareStatement(
                    "INSERT INTO msg_rcp_emt (id_log_recepteur, id_log_emetteur, id_recepteur, id_emetteur) VALUES (?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                statementRcpEmt.setInt(1, idLogRecepteur);
                statementRcpEmt.setInt(2, idLogEmetteur);
                statementRcpEmt.setInt(3, idRecepteur);
                statementRcpEmt.setInt(4, idEmetteur);

                int affectedRowsRcpEmt = statementRcpEmt.executeUpdate();
                if (affectedRowsRcpEmt == 0) {
                    throw new SQLException("La création de l'entrée msg_rcp_emt a échoué, aucune ligne affectée.");
                }

                try (ResultSet generatedKeysRcpEmt = statementRcpEmt.getGeneratedKeys()) {
                    if (generatedKeysRcpEmt.next()) {
                        int idRcpEmt = generatedKeysRcpEmt.getInt(1);

                        // Puis insérez dans message avec l'id_rcp_emt récupéré
                        try (PreparedStatement statementMessage = connection.prepareStatement(
                                "INSERT INTO message (message, id_rcp_emt) VALUES (?, ?)")) {
                            statementMessage.setString(1, message);
                            statementMessage.setInt(2, idRcpEmt);
                            int affectedRowsMessage = statementMessage.executeUpdate();
                            if (affectedRowsMessage == 0) {
                                throw new SQLException("L'insertion du message a échoué, aucune ligne affectée.");
                            }
                        }
                    } else {
                        throw new SQLException("La création de l'entrée msg_rcp_emt a échoué, aucune clé générée.");
                    }
                }
            }
            response.getWriter().println("Réponse envoyée avec succès !");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de l'envoi de la réponse.");
        }  }  }
