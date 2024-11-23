package com.example.projetv1;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CoursServlet")
public class CoursServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String niveau = request.getParameter("niveau");
        String[] cours = {};

        if ("3eme".equals(niveau)) {
            cours = new String[]{"science3eme"};
        } else if ("1erbac".equals(niveau)) {
            cours = new String[]{"Sc.Math", "Sc.Ex", "hist_geo", "Sc.Economie"};
        } else if ("2emebac".equals(niveau)) {
            cours = new String[]{"Sc.Mathematique", "Sc.Physique", "Sc.SVT", "Sc.Eco"};
        } else if ("tronc_commun".equals(niveau)) {
            cours = new String[]{"Science_TC"};
        }

        // Affichez la liste déroulante (select) des cours avec une seule sélection possible
        out.println("<select name='nom_filiere'>");
        for (String nomCours : cours) {
            out.println("<option value='" + nomCours + "'>" + nomCours + "</option>");
        }
        out.println("</select>");
    }
}




