package com.example.projetv1;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
@WebServlet("/TraitementModifierSecretaire")
public class TraitementModifierSecretaire extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idSecretaire = Integer.parseInt(request.getParameter("id_secretaire"));
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motdepasse");
        int niveau = Integer.parseInt(request.getParameter("niveau"));

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            String url = "jdbc:mysql://localhost:3306/EduCare";
            String username = "root";
            String password = "";
            conn = DriverManager.getConnection(url, username, password);

            String sql = "UPDATE secretaire SET nom = ?, prenom = ?, email = ?, motdepasse = ?, id_niveau = ? WHERE id_secretaire = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nom);
            pstmt.setString(2, prenom);
            pstmt.setString(3, email);
            pstmt.setString(4, motDePasse);
            pstmt.setInt(5, niveau);
            pstmt.setInt(6, idSecretaire);

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        response.sendRedirect("list_secretaire.jsp");
    }
}
