package com.example.projetv1;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/FiliereServlet")
public class FiliereServlet extends HttpServlet {

    // Définir un tableau de filières
    private String[] filieres = {
            "3eme", "1erbac", "2emebac", "tron_commun",
            "Sc.Math", "Sc.Ex", "Sc.Economie", "Sc.Math2",
            "Sc.Physique", "Sc.SVT", "Sc.Eco2", "Science_TC", "science3eme"
    };

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String niveauId = request.getParameter("niveau");

        try {
            // Parcourir le tableau de filières
            for (String filiere : filieres) {
                // Vérifier si la filière correspond au niveau sélectionné
                if (filiere.equals(niveauId)) {
                    out.println("<option value='" + filiere + "'>" + filiere + "</option>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Gérer l'exception
        }
    }
}
