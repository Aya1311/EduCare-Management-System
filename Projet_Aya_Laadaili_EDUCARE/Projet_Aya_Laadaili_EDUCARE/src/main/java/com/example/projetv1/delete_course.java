package com.example.projetv1;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/delete_course")
public class delete_course extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idCours = request.getParameter("id_cours");
        String secretaireId = request.getParameter("secretaireId");

        Connection co = null;
        PreparedStatement stm = null;

        try {
            co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

            // Supprimer d'abord les enregistrements dépendants dans 'horaire'
            String queryDeleteHoraire = "DELETE FROM horaire WHERE id_cours = ?";
            stm = co.prepareStatement(queryDeleteHoraire);
            stm.setString(1, idCours);
            stm.executeUpdate();

            // Ensuite, supprimer le cours
            String queryDeleteCours = "DELETE FROM cours WHERE id_cours = ?";
            stm = co.prepareStatement(queryDeleteCours);
            stm.setString(1, idCours);
            stm.executeUpdate();

            response.sendRedirect("list_cours_sec.jsp?secretaireId=" + secretaireId);
        } catch (SQLException e) {
            e.printStackTrace();
            // Gérer l'exception ou rediriger vers une page d'erreur
        } finally {
            if (stm != null) try { stm.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (co != null) try { co.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}