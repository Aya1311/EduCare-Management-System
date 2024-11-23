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


@WebServlet("/EditProfProfile")
public class EditProfProfile extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idProf = request.getParameter("idProf");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String telephone = request.getParameter("numero_telephone");
        String adresse = request.getParameter("adresse");
        String email = request.getParameter("email");
        String sexe = request.getParameter("sexe");

        Connection conn = null;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
            String sql = "UPDATE professeur SET nom = ?, prenom = ?, numero_telephone = ?, adresse = ?, email = ?, sexe = ? WHERE id_prof = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setString(3, telephone);
            pstmt.setString(4, adresse);
            pstmt.setString(5, email);
            pstmt.setString(6, sexe);
            pstmt.setString(7, idProf);

            pstmt.executeUpdate();
            // Redirection ou gestion de la réponse
            response.sendRedirect("prof_profile.jsp?profId=" + idProf);
        } catch (SQLException e) {
            throw new ServletException("Erreur lors de la mise à jour du profil", e);
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
}
