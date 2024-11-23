<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="fonts/icomoon/style.css">

    <link rel="stylesheet" href="css/owl.carousel.min.css">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    
    <!-- Style -->
    <link rel="stylesheet" href="css/style.css">
<style>
  .btn-home {
    background-color: #4a67a1; /* Couleur de fond */
    color: #ffffff; /* Couleur du texte */
    padding: 10px 20px; /* Padding autour du texte */
    border-radius: 5px; /* Bordures arrondies */
    border: none; /* Pas de bordure */
    font-size: 16px; /* Taille du texte */
    font-weight: bold; /* Gras */
    transition: background-color 0.3s ease; /* Transition pour le survol */
  }

  .btn-home:hover {
    background-color: #3b4f7a; /* Couleur de fond au survol */
    color: #ffffff; /* Couleur du texte au survol */
    text-decoration: none; /* Pas de soulignement au survol */
  }
  #searchInputSecretaire {
    font-size: 16px;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    width: 100%;
    margin-bottom: 20px;
  }

  #searchInputSecretaire::placeholder {
    color: #999;
  }

  #searchInputSecretaire:focus {
    border-color: #0056b3;
    box-shadow: 0 0 8px rgba(0, 86, 179, 0.2);
    outline: none;
  }
</style>
    <title>Liste Secrétaire</title>
    <script>
      function searchTableSecretaire() {
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById("searchInputSecretaire");
        filter = input.value.toUpperCase();
        table = document.getElementById("dataTableSecretaire");
        tr = table.getElementsByTagName("tr");

        for (i = 0; i < tr.length; i++) {
          td = tr[i].getElementsByTagName("td")[0]; // Ajustez l'indice si nécessaire
          if (td) {
            txtValue = td.textContent || td.innerText;
            if (txtValue.toUpperCase().indexOf(filter) > -1) {
              tr[i].style.display = "";
            } else {
              tr[i].style.display = "none";
            }
          }
        }
      }
    </script>
  </head>
  <body>
  <div class="content">
    <div class="container">
      <h2 class="mb-5">Liste Secrétaire</h2>
      <div class="col-12 mb-3">
        <a href="dashboard_admin.jsp" class="btn btn-home">Retour au Dashboard</a>
      </div>
      <div class="table-responsive">
        <div class="mb-3">
          <input type="text" id="searchInputSecretaire" onkeyup="searchTableSecretaire()" placeholder="Rechercher parmi les secrétaires..." class="form-control">
        </div>
        <table class="table table-striped custom-table" id="dataTableSecretaire">
          <thead>
          <tr>
            <th scope="col">Nom</th>
            <th scope="col">Prénom</th>
            <th scope="col">Email</th>
            <th scope="col">Mot de Passe</th>
            <th scope="col">Niveau</th>
            <th scope="col">Action</th>
          </tr>
          </thead>
          <tbody>
          <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            try {
              Class.forName("com.mysql.cj.jdbc.Driver");
              conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

              stmt = conn.createStatement();
              String sql = "SELECT secretaire.*, niveau.niveau FROM secretaire INNER JOIN niveau ON secretaire.id_niveau = niveau.id_niveau";
              rs = stmt.executeQuery(sql);

              while(rs.next()) {
          %>
          <tr>
            <td><%= rs.getString("nom") %></td>
            <td><%= rs.getString("prenom") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("motdepasse") %></td>
            <td><%= rs.getString("niveau") %></td>
            <td>
              <a href='modifierSecretaire.jsp?id=<%= rs.getInt("id_secretaire") %>' class='btn btn-primary'>Modifier</a>
              <a href='SupprimerSecretaireServlet?id=<%= rs.getInt("id_secretaire") %>' class='btn btn-danger'>Supprimer</a>
            </td>
          </tr>
          <%  }
            } catch(Exception e) {
            e.printStackTrace();
          } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { }
            if (conn != null) try { conn.close(); } catch (SQLException e) { }
          }
          %>
          </tbody>
        </table>
      </div>
      <div class="col-12 mb-3">
        <a href="creerSecretaire.jsp" class="btn btn-success" style="background-color: #DD4A68">Créer secretaire</a>
      </div>
    </div>
  </div>
  <!-- JS Scripts -->
  <script src="js/jquery-3.3.1.min.js"></script>
  <script src="js/popper.min.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="js/main.js"></script>
  </body>
</html>