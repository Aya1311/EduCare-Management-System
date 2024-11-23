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

    .submit {
      background-color: orange;
      border-color: blue;
      color: white;
    }

    .btn-primary:hover {
      background-color: indianred;
      border-color: #0056b3;
    }

    .row {
      display: flex;
      margin-right: 0;
      margin-left: 0;
      align-items: center;
    }

    .col-sm-3 {
      flex: 0 0 30%;
    }

    .col-sm-3 h6 {
      white-space: nowrap;
      margin-right: 10px;
    }

    .col-sm-9 .text-secondary {
      white-space: nowrap;
    }

    .editable-field {
      display: none;
    }
  </style>
</head>
<body>
<%
  String idE = request.getParameter("studentId");
%>
<%
  String idEtudiant = request.getParameter("studentId");
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet resultSet = null;
  try {
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
    String query = "SELECT e.*, n.niveau FROM etudiant e JOIN niveau n ON e.id_niveau = n.id_niveau WHERE e.id_etudiant = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, idEtudiant);
    resultSet = pstmt.executeQuery();

    if (!resultSet.next()) {
      System.out.println("Aucun étudiant trouvé avec cet ID.");
      return;
    }
%>
<div class="container">
  <div class="main-body">
    <nav aria-label="breadcrumb" class="main-breadcrumb">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
        <li class="breadcrumb-item"><a href="dashboard_s.jsp?studentId=<%= idE %>">User</a></li>
        <li class="breadcrumb-item active" ><a href="etudiant_profile.jsp?studentId=<%= idE %>">User Profile</a></li>
      </ol>
    </nav>
    <div class="row gutters-sm">
      <div class="col-md-4 mb-3">
        <div class="card">
            <div class="card-body">
              <div class="d-flex flex-column align-items-center text-center">
                <%
                  String cheminImage = resultSet.getString("chemin_image");
                  System.out.println(cheminImage);
                  if (cheminImage == null || cheminImage.isEmpty()) {
                    cheminImage = "img/sf.svg";
                  }
                %>
                <img src="<%= cheminImage %>" alt="Profile Image" class="rounded-circle" width="150">
                <div class="mt-3">
                  <h4><%= resultSet.getString("nom") %> <%= resultSet.getString("prenom") %></h4>
                  <p class="text-muted font-size-sm"><%= resultSet.getString("adresse") %></p>
                  <button class="btn btn-primary"><a href="index.html">Déconnexion</a></button>
                </div>
              </div>
            </div>
        </div>
      </div>
      <form action="EditProfileServlet" method="post">
        <input type="hidden" name="idUtilisateur" value="<%= idE %>">
      <div class="card mb-3">
        <div class="card-body">
          <div class="row">
            <div class="col-sm-3">
              <h6 class="mb-0">Nom </h6>
            </div>
            <div class="col-sm-9 text-secondary">
              <span class="editable-field"><%= resultSet.getString("nom") %></span>
              <input type="text" id="nom" name="nom" class="form-control" value="<%= resultSet.getString("nom") %>">
            </div>
          </div>
          <hr>
          <div class="row">
            <div class="col-sm-3">
              <h6 class="mb-0">Prenom </h6>
            </div>
            <div class="col-sm-9 text-secondary">
              <span class="editable-field"><%= resultSet.getString("prenom") %></span>
              <input type="text" id="prenom" name="prenom" class="form-control" value="<%= resultSet.getString("prenom") %>">
            </div>
          </div>
          <hr>
          <div class="row">
            <div class="col-sm-3">
              <h6 class="mb-0">Téléphone</h6>
            </div>
            <div class="col-sm-9 text-secondary">
              <span class="editable-field"><%= resultSet.getString("telephone") %></span>
              <input type="text" id="telephone" name="telephone" class="form-control" value="<%= resultSet.getString("telephone") %>">
            </div>
          </div>
          <hr>
          <div class="row">
            <div class="col-sm-3">
              <h6 class="mb-0">Adresse</h6>
            </div>
            <div class="col-sm-9 text-secondary">
              <span class="editable-field"><%= resultSet.getString("adresse") %></span>
              <input type="text" id="adresse" name="adresse" class="form-control" value="<%= resultSet.getString("adresse") %>">
            </div>
          </div>
          <hr>
          <div class="row">
            <div class="col-sm-3">
              <h6 class="mb-0">Email</h6>
            </div>
            <div class="col-sm-9 text-secondary">
              <span class="editable-field"><%= resultSet.getString("email") %></span>
              <input type="text" id="email" name="email" class="form-control" value="<%= resultSet.getString("email") %>">
            </div>
          </div>
          <hr>
          <div class="row">
            <div class="col-sm-3">
              <h6 class="mb-0">Sexe</h6>
            </div>
            <div class="col-sm-9 text-secondary">
              <span class="editable-field"><%= resultSet.getString("sexe") %></span>
              <select id="sexe" name="sexe" class="form-control">
                <option value="Homme" <%= resultSet.getString("sexe").equals("Homme") ? "selected" : "" %>>Homme</option>
                <option value="Femme" <%= resultSet.getString("sexe").equals("Femme") ? "selected" : "" %>>Femme</option>
              </select>
            </div>
          </div>
          <hr>
          <button type="submit" class="btn submit">Enregistrer les modifications</button>
          <hr>
        </div>
      </div>
      </form>
    </div>
  </div>
</div>
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
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
  $(document).ready(function() {
    // Gérez l'édition des champs
    var editable = false;

    $(".editable-field").on("click", function() {
      if (editable) {
        // Si en mode édition, mettez à jour la valeur dans le champ caché
        var fieldName = $(this).attr("id");
        var newValue = $("#" + fieldName).val();
        $("span#" + fieldName).text(newValue);
      }

      // Basculer entre le mode édition et le mode non édition
      $(this).toggleClass("non-editable");
      $("#" + $(this).attr("id")).toggleClass("non-editable");
      editable = !editable;
    });
  });
</script>
</body>
</html>
