<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Modifier Profil Étudiant</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f4f7f6;
      margin-top: 20px;
    }
    .main-body {
      background: #ffffff;
      box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
      margin-bottom: 20px;
      border-radius: 8px;
    }
    .card {
      border: none;
    }
    .rounded-circle {
      border-radius: 50%;
    }
  </style>
</head>
<body>
<%
  String idEtudiant = request.getParameter("idEtudiant");
  String idSecretaire = request.getParameter("idSecretaire");
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rsEtudiant = null;
  try {
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
    String query = "SELECT * FROM etudiant WHERE id_etudiant = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, idEtudiant);
    rsEtudiant = pstmt.executeQuery();

    if (!rsEtudiant.next()) {
      System.out.println("<div class='alert alert-warning'>Aucun étudiant trouvé avec l'ID " + idEtudiant + "</div>");
    } else {
%>
<div class="container">
  <div class="main-body">
    <form action="modifierEtu" method="post">
      <input type="hidden" name="idEtudiant" value="<%= request.getParameter("idEtudiant") %>">
      <input type="hidden" name="idSecretaire" value="<%= request.getParameter("idSecretaire") %>">
      <div class="form-group">
        <label for="nom">Nom</label>
        <input type="text" class="form-control" id="nom" name="nom" value="<%= rsEtudiant.getString("nom") %>">
      </div>

      <div class="form-group">
        <label for="prenom">Prénom</label>
        <input type="text" class="form-control" id="prenom" name="prenom" value="<%= rsEtudiant.getString("prenom") %>">
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" class="form-control" id="email" name="email" value="<%= rsEtudiant.getString("email") %>">
      </div>
      <div class="form-group">
        <label for="email">Mot De Passe</label>
        <input type="password" class="form-control" id="motdepasse" name="motdepasse" value="<%= rsEtudiant.getString("motdepasse") %>">
      </div>
      <div class="form-group">
        <label for="datedenaissance">Date de Naissance</label>
        <input type="date" class="form-control" id="datedenaissance" name="datedenaissance" value="<%= rsEtudiant.getDate("datedenaissance").toString() %>">
      </div>

      <div class="form-group">
        <label for="sexe">Sexe</label>
        <select class="form-control" id="sexe" name="sexe">
          <option value="Homme" <%= "Homme".equals(rsEtudiant.getString("sexe")) ? "selected" : "" %>>Homme</option>
          <option value="Femme" <%= "Femme".equals(rsEtudiant.getString("sexe")) ? "selected" : "" %>>Femme</option>
        </select>
      </div>

      <div class="form-group">
        <label for="adresse">Adresse</label>
        <input type="text" class="form-control" id="adresse" name="adresse" value="<%= rsEtudiant.getString("adresse") %>">
      </div>

      <div class="form-group">
        <label for="statut">Statut</label>
        <select class="form-control" id="statut" name="statut">
          <option value="Payé" <%= "payé".equals(rsEtudiant.getString("statut")) ? "selected" : "" %>>Payé</option>
          <option value="impayé" <%= "impayé".equals(rsEtudiant.getString("statut")) ? "selected" : "" %>>Impayé</option>
        </select>
      </div>

      <button type="submit" class="btn btn-primary">Sauvegarder les modifications</button>
    </form>
  </div>
</div>
<%
    }
  } catch (SQLException e) {
    System.out.println("<div class='alert alert-danger'>Erreur SQL: " + e.getMessage() + "</div>");
  } finally {
    if (rsEtudiant != null) try { rsEtudiant.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
  }
%>
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
