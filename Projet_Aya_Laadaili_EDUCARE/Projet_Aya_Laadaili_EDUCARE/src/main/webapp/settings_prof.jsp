<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Profile</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" rel="stylesheet">
  <style type="text/css">
    body {
      background-color: #f4f7f6;
      margin-top: 20px;
      font-family: 'Arial', sans-serif;
      color: #4a4a4a;
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
      box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    }

    .text-secondary {
      color: #6c757d !important;
    }

    .breadcrumb {
      background: none;
      margin-bottom: 0;
    }

    .breadcrumb-item + .breadcrumb-item::before {
      content: ">";
    }

    .btn-primary {
      background-color: white;
      border-color: #007bff;
    }

    .btn-primary:hover {
      background-color: indianred;
      border-color: #0056b3;
    }

    .row {
      display: flex;
      margin-right: 0;
      margin-left: 0;
      align-items: center; /* Alignement vertical au centre */
    }

    .col-sm-3 {
      flex: 0 0 30%; /* Largeur fixe de 30% */
    }

    .col-sm-3 h6 {
      white-space: nowrap; /* Empêche les sauts à la ligne */
      margin-right: 10px; /* Espacement entre le libellé et la valeur */
    }

    .col-sm-9 .text-secondary {
      white-space: nowrap; /* Empêche les sauts à la ligne */
    }

    /* Responsive */
    @media (max-width: 768px) {
      .col-sm-3, .col-sm-9 {
        flex: 0 0 100%;
        max-width: 100%;
      }

      .profile-header h4 {
        font-size: 22px;
        margin-bottom: 0;
      }

      .profile-header p {
        font-size: 14px;
      }
    }
    .submit {
      background-color: orange;
      border-color: orangered;
      color: white;
    }
    .submit:hover {
      background-color: blue;
      border-color: blue;
    }
  </style>
</head>
<body>
<%
  String idProf = request.getParameter("profId");
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet resultSet = null;
  try {
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
    String query = "SELECT * FROM professeur WHERE id_prof = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, idProf);
    resultSet = pstmt.executeQuery();

    if (!resultSet.next()) {
      System.out.println("Aucun professeur trouvé avec cet ID.");
      return;
    }
%>
<div class="container">
  <div class="main-body">
    <!-- Breadcrumb et autres éléments si nécessaire -->
    <form action="EditProfProfile" method="post">
      <!-- Section pour le nom -->
      <div class="row">
        <div class="col-sm-3">
          <h6 class="mb-0">Nom</h6>
        </div>
        <div class="col-sm-9 text-secondary">
          <input type="text" id="nom" name="nom" class="form-control" value="<%= resultSet.getString("nom") %>">
        </div>
      </div>
      <hr>

      <!-- Section pour le prénom -->
      <div class="row">
        <div class="col-sm-3">
          <h6 class="mb-0">Prénom</h6>
        </div>
        <div class="col-sm-9 text-secondary">
          <input type="text" id="prenom" name="prenom" class="form-control" value="<%= resultSet.getString("prenom") %>">
        </div>
      </div>
      <hr>

      <!-- Section pour le téléphone -->
      <div class="row">
        <div class="col-sm-3">
          <h6 class="mb-0">Téléphone</h6>
        </div>
        <div class="col-sm-9 text-secondary">
          <input type="text" id="telephone" name="numero_telephone" class="form-control" value="<%= resultSet.getString("numero_telephone") %>">
        </div>
      </div>
      <hr>

      <!-- Section pour l'adresse -->
      <div class="row">
        <div class="col-sm-3">
          <h6 class="mb-0">Adresse</h6>
        </div>
        <div class="col-sm-9 text-secondary">
          <input type="text" id="adresse" name="adresse" class="form-control" value="<%= resultSet.getString("adresse") %>">
        </div>
      </div>
      <hr>

      <!-- Section pour l'email -->
      <div class="row">
        <div class="col-sm-3">
          <h6 class="mb-0">Email</h6>
        </div>
        <div class="col-sm-9 text-secondary">
          <input type="text" id="email" name="email" class="form-control" value="<%= resultSet.getString("email") %>">
        </div>
      </div>
      <hr>

      <!-- Section pour le sexe -->
      <div class="row">
        <div class="col-sm-3">
          <h6 class="mb-0">Sexe</h6>
        </div>
        <div class="col-sm-9 text-secondary">
          <select id="sexe" name="sexe" class="form-control">
            <option value="Homme" <%= resultSet.getString("sexe").equals("Homme") ? "selected" : "" %>>Homme</option>
            <option value="Femme" <%= resultSet.getString("sexe").equals("Femme") ? "selected" : "" %>>Femme</option>
          </select>
        </div>
      </div>
      <hr>
      <!-- Champ caché pour l'ID du professeur -->
      <input type="hidden" name="idProf" value="<%= idProf %>">

      <!-- Bouton pour soumettre le formulaire -->
      <button type="submit" class="btn submit">Enregistrer les modifications</button>
    </form>
  </div>
</div>
<%
  } catch (SQLException e) {
    e.printStackTrace();
    System.out.println("Erreur SQL: " + e.getMessage());
  } finally {
    if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
  }
%>
</body>
</html>
