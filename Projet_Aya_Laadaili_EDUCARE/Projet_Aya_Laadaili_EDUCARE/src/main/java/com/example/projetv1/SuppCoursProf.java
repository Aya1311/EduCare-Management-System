package com.example.projetv1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/SuppCoursProf")
public class SuppCoursProf extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idCours = request.getParameter("idCours");
        String idProf = request.getParameter("profId");

        String sql = "UPDATE cours SET id_prof = NULL WHERE id_cours = ?";
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, idCours);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("dashboard_prof.jsp?profId=" + idProf);
            } else {
                response.sendRedirect("erreur.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("erreur.jsp");
        }
    }
}
