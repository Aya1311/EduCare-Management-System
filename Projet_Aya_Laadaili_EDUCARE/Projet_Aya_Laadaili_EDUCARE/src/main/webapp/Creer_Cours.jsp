<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Modifier Cours</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
        }
        h2 {
            text-align: center;
            padding: 10px 0;
        }
        form {
            width: 50%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input[type="text"], .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            display: block;
            width: 100%;
            padding: 10px;
            border: none;
            background-color: #333;
            color: white;
            cursor: pointer;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Créer Cours</h2>
    <form action="create_course" method="post">
        <div class="form-group">
            <label>Nom du cours:</label>
            <input type="text" name="cours" required>
        </div>
        <!-- Liste déroulante des professeurs -->
        <div class="form-group">
            <label for="id_prof">Professeur:</label>
            <select name="id_prof" id="id_prof">
                <%
                    Connection co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                    String queryProf = "SELECT id_prof, nom FROM professeur";
                    PreparedStatement stmProf = co.prepareStatement(queryProf);
                    ResultSet rsProf = stmProf.executeQuery();
                    while (rsProf.next()) {
                        int profId = rsProf.getInt("id_prof");
                        String profName = rsProf.getString("nom");
                %>
                <option value="<%= profId %>"><%= profName %></option>
                <%
                    }
                    rsProf.close();
                    stmProf.close();
                %>
            </select>
        </div>
        <!-- Liste déroulante des niveaux -->
        <div class="form-group">
            <label for="id_niveau">Niveau:</label>
            <select name="id_niveau" id="id_niveau">
                <%
                    String queryNiveau = "SELECT id_niveau, niveau FROM niveau";
                    PreparedStatement stmNiveau = co.prepareStatement(queryNiveau);
                    ResultSet rsNiveau = stmNiveau.executeQuery();
                    while (rsNiveau.next()) {
                        int niveauId = rsNiveau.getInt("id_niveau");
                        String niveauName = rsNiveau.getString("niveau");
                %>
                <option value="<%= niveauId %>"><%= niveauName %></option>
                <%
                    }
                    rsNiveau.close();
                    stmNiveau.close();
                %>
            </select>
        </div>

        <!-- Liste déroulante des filières -->
        <div class="form-group">
            <label for="id_filiere">Filiere:</label>
            <select name="id_filiere" id="id_filiere">
                <%
                    String queryFiliere = "SELECT id_filiere, nom_filiere FROM filiere";
                    PreparedStatement stmFiliere = co.prepareStatement(queryFiliere);
                    ResultSet rsFiliere = stmFiliere.executeQuery();
                    while (rsFiliere.next()) {
                        int filiereId = rsFiliere.getInt("id_filiere");
                        String filiereName = rsFiliere.getString("nom_filiere");
                %>
                <option value="<%= filiereId %>"><%= filiereName %></option>
                <%
                    }
                    rsFiliere.close();
                    stmFiliere.close();
                %>
            </select>
        </div>
        <!-- Liste déroulante des horaires disponibles -->
        <div class="form-group">
            <label for="horaire">Horaire Disponible:</label>
            <select name="id_horaire" id="horaire">
                <%
                    String queryHoraire = "SELECT id_horaire, jour, heure FROM horaire WHERE id_cours IS NULL";
                    PreparedStatement stmHoraire = co.prepareStatement(queryHoraire);
                    ResultSet rsHoraire = stmHoraire.executeQuery();
                    while (rsHoraire.next()) {
                        int idHoraire = rsHoraire.getInt("id_horaire");
                        String jour = rsHoraire.getString("jour");
                        String heure = rsHoraire.getString("heure");
                %>
                <option value="<%= idHoraire %>"><%= jour + " - " + heure %></option>
                <%
                    }
                    rsHoraire.close();
                    stmHoraire.close();
                %>
            </select>
        </div>

        <!-- Liste déroulante des salles disponibles -->
        <div class="form-group">
            <label for="id_salle">Salle Disponible:</label>
            <select name="id_salle" id="id_salle">
                <%
                    String querySalle = "SELECT id_salle, salle FROM salle";
                    PreparedStatement stmSalle = co.prepareStatement(querySalle);
                    ResultSet rsSalle = stmSalle.executeQuery();
                    while (rsSalle.next()) {
                        int idSalle = rsSalle.getInt("id_salle");
                        String nomSalle = rsSalle.getString("salle");
                %>
                <option value="<%= idSalle %>"><%= nomSalle %></option>
                <%
                    }
                    rsSalle.close();
                    stmSalle.close();
                %>
            </select>
        </div>

        <button type="submit" class="btn">Créer Cours</button>
    </form>
</div>
</body>
</html>