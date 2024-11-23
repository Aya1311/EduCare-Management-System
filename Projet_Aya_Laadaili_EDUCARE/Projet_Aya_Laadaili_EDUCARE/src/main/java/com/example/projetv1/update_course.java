package com.example.projetv1;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/update_course")
public class update_course extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idCours = request.getParameter("id_cours");
        String secretaireId = request.getParameter("secretaireId");
        String cours = request.getParameter("cours");
        int idProf = Integer.parseInt(request.getParameter("id_prof"));
        int idHoraire = Integer.parseInt(request.getParameter("id_horaire"));
        int idSalle = Integer.parseInt(request.getParameter("id_salle"));
        Connection co = null;
        PreparedStatement stmCours = null;
        PreparedStatement stmHoraireUpdate = null;
        PreparedStatement stmHoraireReset = null;

        try {
            co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

            // Mise à jour de la table cours
            String queryCours = "UPDATE cours SET cours = ?, id_prof = ? WHERE id_cours = ?";
            stmCours = co.prepareStatement(queryCours);
            stmCours.setString(1, cours);
            stmCours.setInt(2, idProf);
            stmCours.setString(3, idCours);
            stmCours.executeUpdate();

            // Réinitialiser la relation dans la table horaire
            String queryHoraireReset = "UPDATE horaire SET id_cours = NULL WHERE id_cours = ?";
            stmHoraireReset = co.prepareStatement(queryHoraireReset);
            stmHoraireReset.setString(1, idCours);
            stmHoraireReset.executeUpdate();

            // Mise à jour de la table horaire
            String queryHoraireUpdate = "UPDATE horaire SET id_cours = ?, id_salle = ? WHERE id_horaire = ?";
            stmHoraireUpdate = co.prepareStatement(queryHoraireUpdate);
            stmHoraireUpdate.setString(1, idCours);
            stmHoraireUpdate.setInt(2, idSalle);
            stmHoraireUpdate.setInt(3, idHoraire);
            stmHoraireUpdate.executeUpdate();

            response.sendRedirect("list_cours_sec.jsp?secretaireId=" + secretaireId);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error", e);
        } finally {
            if (stmCours != null) try { stmCours.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmHoraireUpdate != null) try { stmHoraireUpdate.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmHoraireReset != null) try { stmHoraireReset.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (co != null) try { co.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
