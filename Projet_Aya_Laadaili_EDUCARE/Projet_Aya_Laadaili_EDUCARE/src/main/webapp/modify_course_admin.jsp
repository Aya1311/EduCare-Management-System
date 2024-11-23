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
  <h2>Modifier les Détails du Cours</h2>
  <%
    String idCours = request.getParameter("id_cours");
    String secretaireId = request.getParameter("secretaireId");

    Connection co = null;
    PreparedStatement stm = null;
    ResultSet rs = null;
    try {
      co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
      String query = "SELECT * FROM cours WHERE id_cours = ?";
      stm = co.prepareStatement(query);
      stm.setString(1, idCours);
      rs = stm.executeQuery();

      if(rs.next()) {
        String cours = rs.getString("cours");
        int idProf = rs.getInt("id_prof");
  %>
  <form action="update_course_admin" method="post">
    <input type="hidden" name="id_cours" value="<%= idCours %>">
    <div class="form-group">
      <label>Nom du cours:</label>
      <input type="text" name="cours" value="<%=cours %>" required>
    </div>

    <!-- Liste déroulante des professeurs -->
    <div class="form-group">
      <label for="id_prof">Professeur:</label>
      <select name="id_prof" id="id_prof">
        <%
          String queryProf = "SELECT id_prof, nom FROM professeur";
          PreparedStatement stmProf = co.prepareStatement(queryProf);
          ResultSet rsProf = stmProf.executeQuery();
          while (rsProf.next()) {
            int profId = rsProf.getInt("id_prof");
            String profName = rsProf.getString("nom");
            String selected = (profId == idProf) ? " selected" : "";
        %>
        <option value="<%= profId %>"<%= selected %>><%= profName %></option>
        <%
          }
          rsProf.close();
          stmProf.close();
        %>
      </select>
    </div>
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
    <div class="form-group">
      <label for="id_salle">Salle Disponible:</label>
      <select name="id_salle" id="id_salle">
        <%
          String querySalle = "SELECT id_salle, salle FROM salle WHERE id_salle IN (SELECT id_salle FROM horaire WHERE id_cours IS NOT NULL)";
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

    <button type="submit" class="btn btn-primary">Mettre à jour</button>
  </form>
  <a href="list_cours.jsp" class="btn btn-primary"> Retour à la liste des cours</a>
  <%
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
      if (stm != null) try { stm.close(); } catch (SQLException e) { e.printStackTrace(); }
      if (co != null) try { co.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
  %>
</div>
</body>
</html>
