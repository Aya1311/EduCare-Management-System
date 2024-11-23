package com.example.projetv1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("username");
        String password = request.getParameter("password");

        if (validateCredentials(email, password, "etudiant")) {
            int studentId = getUserId(email, "etudiant", "id_etudiant");
            response.sendRedirect("dashboard_s.jsp?studentId=" + studentId);
        } else if (validateCredentials(email, password, "professeur")) {
            int profId = getUserId(email, "professeur", "id_prof");
            response.sendRedirect("dashboard_prof.jsp?profId=" + profId);
        } else if (validateCredentials(email, password, "admin")) {
            int adminId = getUserId(email, "admin", "id_admin");
            response.sendRedirect("dashboard_admin.jsp?adminId=" + adminId);
        } else if (validateCredentials(email, password, "secretaire")) {
            int secretaireId = getUserId(email, "secretaire", "id_secretaire");
            response.sendRedirect("dashboard_secraitaire.jsp?secretaireId=" + secretaireId);
        } else {
            request.setAttribute("error", "E-mail ou mot de passe incorrects");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private boolean validateCredentials(String email, String password, String tableName) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost/EduCare";
            String username = "root";
            String dbPassword = "";

            try (Connection connection = DriverManager.getConnection(url, username, dbPassword);
                 PreparedStatement statement = connection.prepareStatement("SELECT * FROM " + tableName + " WHERE email=? AND motdepasse=?")) {

                statement.setString(1, email);
                statement.setString(2, password);

                try (ResultSet resultSet = statement.executeQuery()) {
                    return resultSet.next();
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private int getUserId(String email, String tableName, String idColumnName) {
        int userId = -1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost/EduCare";
            String username = "root";
            String dbPassword = "";

            try (Connection connection = DriverManager.getConnection(url, username, dbPassword);
                 PreparedStatement statement = connection.prepareStatement("SELECT " + idColumnName + " FROM " + tableName + " WHERE email=?")) {

                statement.setString(1, email);

                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        userId = resultSet.getInt(idColumnName);
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        return userId;
    }
}
