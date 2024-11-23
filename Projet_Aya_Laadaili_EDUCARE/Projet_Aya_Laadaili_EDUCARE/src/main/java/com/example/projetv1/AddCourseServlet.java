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

@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String courseId = request.getParameter("courseId");
        String studentId = request.getParameter("studentId");
        System.out.println("Course ID: " + courseId);
        System.out.println("Student ID: " + studentId);


        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO etu_cours (id_etudiant, id_cours) VALUES (?, ?)")) {
            pstmt.setInt(1, Integer.parseInt(studentId));
            pstmt.setInt(2, Integer.parseInt(courseId));
            pstmt.executeUpdate();

            response.sendRedirect("dashboard_s.jsp?studentId=" + studentId);
        } catch (SQLException e) {
            throw new ServletException("Erreur de base de données", e);
        }
    }
}

