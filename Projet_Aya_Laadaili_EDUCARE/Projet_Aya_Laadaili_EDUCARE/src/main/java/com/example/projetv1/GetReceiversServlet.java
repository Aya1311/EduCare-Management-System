package com.example.projetv1;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
@WebServlet("/GetReceiversServlet")

public class GetReceiversServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        StringBuilder options = new StringBuilder();

        try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "")) {
            String query = "";
            if ("etudiant".equals(role)) {
                query = "SELECT id_etudiant as id, nom, prenom FROM etudiant";
            } else if ("professeur".equals(role)) {
                query = "SELECT id_prof as id, nom, prenom FROM professeur";
            } else if ("secretaire".equals(role)) {
                query = "SELECT id_secretaire as id, nom, prenom FROM secretaire";
            }

            try (PreparedStatement statement = connection.prepareStatement(query)) {
                ResultSet resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    String nom = resultSet.getString("nom");
                    String prenom = resultSet.getString("prenom");
                    options.append("<option value='").append(id).append("'>")
                            .append(nom).append(" ").append(prenom)
                            .append("</option>");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(options);
        out.flush();
    }
}