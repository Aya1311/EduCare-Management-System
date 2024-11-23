<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Créer Nouveau Étudiant</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&family=Roboto+Slab:wght@400;700&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Roboto', sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    .wrapper {
      max-width: 800px;
      margin: 40px auto;
      padding: 20px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    h3 {
      text-align: center;
      color: #2a2a72;
      margin-bottom: 20px;
    }
    table {
      width: 100%;
      border-collapse: collapse;
    }
    td {
      padding: 8px;
    }
    input[type=text], input[type=date], input[type=password], select, textarea {
      width: 100%;
      padding: 10px;
      margin-bottom: 10px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    input[type=submit], input[type=reset], .back-btn {
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.2s;
    }
    input[type=submit] {
      background-color: #4CAF50;
      color: white;
    }
    input[type=reset] {
      background-color: #f44336;
      color: white;
    }
    .back-btn {
      background-color: #555;
      color: white;
      text-decoration: none;
      display: inline-block;
    }
    input[type=submit]:hover {
      background-color: #45a049;
    }
    input[type=reset]:hover, .back-btn:hover {
      background-color: #333;
    }
    @media screen and (max-width: 768px) {
      .wrapper {
        width: 90%;
        padding: 15px;
      }
    }
  </style>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="wrapper">

  <div class="right-container">
    <h3>Creer Etudiant</h3>

    <form action="CreerEtudiantAdmin" method="post"  >
      <table align="center" cellpadding = "10">

        <!----- First Name ---------------------------------------------------------->
        <tr>
          <td>Nom</td>
          <td><input type="text" name="nom" maxlength="30" required/>
          </td>
        </tr>

        <!----- Last Name ---------------------------------------------------------->
        <tr>
          <td>Prénom</td>
          <td><input type="text" name="prenom" maxlength="30" required/>
          </td>
        </tr>

        <!----- Date Of Birth -------------------------------------------------------->
        <tr>
          <td>Date de naissance</td>
          <td>
            <input type="date"  name="datedenaissance" placeholder="Date De Naissance" required/>
          </td>
        </tr>

        <!----- Email ---------------------------------------------------------->
        <tr>
          <td>EMAIL:</td>
          <td><input type="text" name="email" maxlength="100" required/></td>
        </tr>

        <!----- Mobile Number ---------------------------------------------------------->
        <tr>
          <td>Mot De Passe </td>
          <td>
            <input type="password" name="motdepasse" maxlength="10" required/>
          </td>
        </tr>

        <!----- Gender ----------------------------------------------------------->
        <tr>
          <td>Sexe</td>
          <td>
            Homme <input type="radio" name="sexe" value="Homme" />
            Femme <input type="radio" name="sexe" value="Femme" />
          </td>
        </tr>

        <!----- Address ---------------------------------------------------------->
        <tr>
          <td>Adresse <br /><br /><br /></td>
          <td><textarea name="adresse" rows="4" cols="30" required ></textarea></td>
        </tr>

        <!----- Telephone ---------------------------------------------------------->
        <tr>
          <td>Telephone <br /><br /><br /></td>
          <td><input type="text" name="telephone" maxlength="20" required/></td>
        </tr>
        <tr>
          <td>Niveau</td>
          <td>
            <select name="niveauId">
              <%
                String queryNiveau = "SELECT id_niveau, niveau FROM niveau";
                try (Connection connNiveau = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                     PreparedStatement pstmtNiveau = connNiveau.prepareStatement(queryNiveau);
                     ResultSet rsNiveau = pstmtNiveau.executeQuery()) {
                  while (rsNiveau.next()) {
              %>
              <option value="<%= rsNiveau.getString("id_niveau") %>"><%= rsNiveau.getString("niveau") %></option>
              <%
                  }
                } catch (SQLException e) {
                  e.printStackTrace();
                }
              %>
            </select>
          </td>
        </tr>

        <!-- Filiere Dropdown -->
        <tr>
          <td>Filiere</td>
          <td>
            <select name="filiereId">
              <%
                String queryFiliere = "SELECT id_filiere, nom_filiere FROM filiere";
                try (Connection connFiliere = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                     PreparedStatement pstmtFiliere = connFiliere.prepareStatement(queryFiliere);
                     ResultSet rsFiliere = pstmtFiliere.executeQuery()) {
                  while (rsFiliere.next()) {
              %>
              <option value="<%= rsFiliere.getString("id_filiere") %>"><%= rsFiliere.getString("nom_filiere") %></option>
              <%
                  }
                } catch (SQLException e) {
                  e.printStackTrace();
                }
              %>
            </select>
          </td>
        </tr>

        <!-- Cours Checkboxes -->
        <tr>
          <td>Cours</td>
          <td>
            <%
              String queryCours = "SELECT id_cours, cours FROM cours";
              try (Connection connCours = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                   PreparedStatement pstmtCours = connCours.prepareStatement(queryCours);
                   ResultSet rsCours = pstmtCours.executeQuery()) {
                while (rsCours.next()) {
            %>
            <input type="checkbox" name="cours" value="<%= rsCours.getString("id_cours") %>"> <%= rsCours.getString("cours") %><br>
            <%
                }
              } catch (SQLException e) {
                e.printStackTrace();
              }
            %>
          </td>
        </tr>

        <!----- Statut ---------------------------------------------------------->
        <tr>
          <td>Statut</td>
          <td>
            <select name="statut" required>
              <option value="Payé">Payé</option>
              <option value="Impayé">Impayé</option>
            </select>
          </td>
        </tr>
        <tr>
          <td colspan="2" align="center">
            <input type="submit" value="Submit">
            <input type="reset" value="Reset">
          </td>
        </tr>
      </table>
    </form>
  </div>
  <a href="dashboard_admin.jsp?adminId=1" class="back-btn">Retour au Tableau de Bord</a>
</div>
</body>
</html>

