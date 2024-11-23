package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/GetMessagesServletAdmin")
public class GetMessagesServletAdmin extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String query = "SELECT m.message FROM message m JOIN msg_rcp_emt mre ON m.id_rcp_emt = mre.id_rcp_emt WHERE mre.id_log_recepteur = 0;";
        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                String message = resultSet.getString("message");
                response.getWriter().println("<p>" + message + "</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la récupération des messages.");
        }
    }
}