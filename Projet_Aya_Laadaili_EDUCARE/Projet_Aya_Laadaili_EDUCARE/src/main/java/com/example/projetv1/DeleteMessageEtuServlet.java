package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteMessageEtuServlet")
public class DeleteMessageEtuServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int messageId = Integer.parseInt(request.getParameter("messageId"));
        Connection connection = null;

        try {
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
            connection.setAutoCommit(false);

            // Récupérer id_recepteur
            int idRecepteur = 0;
            String getIdRecepteurQuery = "SELECT id_recepteur FROM msg_rcp_emt WHERE id_rcp_emt IN (SELECT id_rcp_emt FROM message WHERE id_message = ?)";
            try (PreparedStatement getIdRecepteurStmt = connection.prepareStatement(getIdRecepteurQuery)) {
                getIdRecepteurStmt.setInt(1, messageId);
                ResultSet rs = getIdRecepteurStmt.executeQuery();
                if (rs.next()) {
                    idRecepteur = rs.getInt("id_recepteur");
                }
            }

            // Suppression dans msg_rcp_emt
            try (PreparedStatement statementMsgRcpEmt = connection.prepareStatement(
                    "DELETE FROM msg_rcp_emt WHERE id_rcp_emt IN (SELECT id_rcp_emt FROM message WHERE id_message = ?)")) {
                statementMsgRcpEmt.setInt(1, messageId);
                statementMsgRcpEmt.executeUpdate();
            }

            connection.commit(); // Valider la transaction
            response.getWriter().println("Message supprimé avec succès !");

            // Redirection avec id_recepteur
            response.sendRedirect("dashboard_s.jsp?studentId=" + idRecepteur);
        } catch (Exception e) {
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la suppression du message.");
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
}
