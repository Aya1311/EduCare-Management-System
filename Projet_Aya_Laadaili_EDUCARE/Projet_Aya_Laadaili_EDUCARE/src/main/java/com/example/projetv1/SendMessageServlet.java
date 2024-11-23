package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/SendMessageServlet")
public class SendMessageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        int receiverId = Integer.parseInt(request.getParameter("receiver"));
        String messageContent = request.getParameter("message");

        // Identifiants pour l'émetteur et le récepteur
        int idLogEmetteur = 0;
        int idEmetteur = 1;
        int idLogRecepteur = determineRoleLogId(role);
        int idRecepteur = receiverId;

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "")) {
            // Insertion de la relation émetteur-récepteur dans msg_rcp_emt
            String insertRcpEmt = "INSERT INTO msg_rcp_emt (id_log_recepteur, id_log_emetteur, id_recepteur, id_emetteur) VALUES (?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(insertRcpEmt, Statement.RETURN_GENERATED_KEYS)) {
                preparedStatement.setInt(1, idLogRecepteur);
                preparedStatement.setInt(2, idLogEmetteur);
                preparedStatement.setInt(3, idRecepteur);
                preparedStatement.setInt(4, idEmetteur);
                preparedStatement.executeUpdate();

                try (ResultSet resultSet = preparedStatement.getGeneratedKeys()) {
                    if (resultSet.next()) {
                        int idRcpEmt = resultSet.getInt(1);

                        // Insertion du message
                        String queryMessage = "INSERT INTO message (message, id_rcp_emt) VALUES (?, ?)";
                        try (PreparedStatement messageStatement = connection.prepareStatement(queryMessage)) {
                            messageStatement.setString(1, messageContent);
                            messageStatement.setInt(2, idRcpEmt);
                            messageStatement.executeUpdate();
                        }
                    }
                }
            }
            // Redirection après envoi du message
            response.sendRedirect("dashboard_admin.jsp?adminId=1");
        } catch (SQLException e) {
            throw new ServletException("Erreur lors de l'envoi du message", e);
        }
    }

    private int determineRoleLogId(String role) {
        switch (role) {
            case "etudiant":
                return 2;
            case "professeur":
                return 3;
            case "secretaire":
                return 1;
            default:
                return 0;
        }
    }
}
