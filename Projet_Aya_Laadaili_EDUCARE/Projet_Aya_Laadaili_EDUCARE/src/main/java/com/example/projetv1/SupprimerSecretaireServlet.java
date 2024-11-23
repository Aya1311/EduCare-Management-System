package com.example.projetv1;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/SupprimerSecretaireServlet")
public class SupprimerSecretaireServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idSecretaire = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            String url = "jdbc:mysql://localhost:3306/EduCare";
            String username = "root";
            String password = "";
            conn = DriverManager.getConnection(url, username, password);

            String sql = "DELETE FROM secretaire WHERE id_secretaire = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idSecretaire);

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        response.sendRedirect("list_secretaire.jsp"); // Redirection après suppression
    }
}