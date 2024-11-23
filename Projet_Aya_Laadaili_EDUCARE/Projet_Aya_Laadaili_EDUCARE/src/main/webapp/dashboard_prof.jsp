<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Professeur Dashboard</title>
  <link href="img/logo.png" rel="icon" type="image/x-icon">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
  <link href="css/argon-dashboard.css?v=1.1.2" rel="stylesheet" />
  <style>
    .message-section {
    background-color: #ffffff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
  }

  .message-section h4 {
    color: #4e73df;
    font-weight: 600;
    margin-bottom: 15px;
  }

  .message-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background-color: #f8f9fc;
    padding: 10px 15px;
    border-radius: 8px;
    margin-bottom: 10px;
  }

  .message-item-number {
    font-weight: bold;
    color: #4e73df;
    margin-right: 15px;
  }

  .message-content {
    flex-grow: 1;
    font-size: 1rem;
    color: #5a5c69;
  }

  .btn-danger {
    color: #fff;
    background-color: #e74a3b;
    border-color: #e74a3b;
    padding: 5px 10px;
    font-size: 0.8rem;
    border-radius: 5px;
  }

  .btn-danger:hover {
    background-color: #c0392b;
    border-color: #bd3e31;
  }</style>
</head>
<body class="">
  <nav class="navbar navbar-vertical fixed-left navbar-expand-md navbar-light bg-white" id="sidenav-main">
    <div class="container-fluid">
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#sidenav-collapse-main" aria-controls="sidenav-main" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="sidenav-collapse-main">
        <div class="navbar-collapse-header d-md-none">
          <div class="row">
            <div class="col-6 collapse-brand">
            </div>
            <div class="col-6 collapse-close">
              <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#sidenav-collapse-main" aria-controls="sidenav-main" aria-expanded="false" aria-label="Toggle sidenav">
                <span></span>
                <span></span>
              </button>
            </div>
          </div>
        </div>
        <!-- Form -->
        <form class="mt-4 mb-3 d-md-none">
          <div class="input-group input-group-rounded input-group-merge">
            <div class="input-group-prepend">
              <div class="input-group-text">
                <span class="fa fa-search"></span>
              </div>
            </div>
          </div>
        </form>
        <%
        String idP = request.getParameter("profId");
        %>
        <!-- Navigation -->
        <ul class="navbar-nav">
          <li class="nav-item active">
            <a class="nav-link active" href="./index.html">
              <i class="ni ni-tv-2 text-primary"></i>Dashboard
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="eleve_prof.jsp?profId=<%= idP %>">
              <i class="ni ni-calendar-grid-58 text-success">Eleves</i>
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link" href="prof_profile.jsp?profId=<%= idP %>">
              <i class="ni ni-single-02 text-danger"></i> Profile
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link" href="settings_prof.jsp?profId=<%= idP %>">
              <i class="ni ni-settings-gear-65 text-warning"></i> Modification
            </a>
          </li>
        </ul>

        <!-- Divider -->
        <hr class="my-3">
        <!-- Navigation -->
        <ul class="navbar-nav mb-md-3">
          <li class="nav-item">
            <a class="nav-link" href="login.jsp">
              <i class="ni ni-user-run text-danger"></i> Logout
            </a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  <div class="main-content">
    <!-- Navbar -->
    <nav class="navbar navbar-top navbar-expand-md navbar-dark" id="navbar-main">
      <div class="container-fluid">
        <!-- Brand -->
        <%
          Connection co = null;
          PreparedStatement stm = null;
          ResultSet r = null;
          try {
            co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
            String prenomQuery = "SELECT prenom,nom  FROM professeur  WHERE id_prof = ?";
            stm = co.prepareStatement(prenomQuery);
            stm.setString(1, idP);
            r = stm.executeQuery();

            String prenomprof = "";
            String nomprof = "";

            if (r.next()) { // Vérifie s'il y a des résultats dans le ResultSet
              prenomprof = r.getString("prenom");
              nomprof = r.getString("nom");

            } else {
              prenomprof = "Nom inconnu"; // Valeur par défaut si aucun résultat n'est trouvé
            }
        %>
        <a class="h4 mb-0 text-white text-uppercase d-none d-lg-inline-block" href="index.html"><%= prenomprof %> <%= nomprof %></a>
        <%
          } catch (SQLException e) {
            e.printStackTrace();
          } finally {
            if (r != null) try { r.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stm != null) try { stm.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (co != null) try { co.close(); } catch (SQLException e) { e.printStackTrace(); }
          }
        %>
        <!-- User -->
      </div>
    </nav>
    <!-- End Navbar -->
    <!-- Header -->
    <div class="header bg-gradient-primary pb-8 pt-5 pt-md-8">
      <div class="container-fluid">
        <div class="header-body">
          <%
            String idProf = request.getParameter("profId");
            if (idProf != null && !idProf.isEmpty()) {
              Connection con = null;
              PreparedStatement stmt = null;
              ResultSet rs = null;
              try {
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

                // Récupérer le nbr de filliere
                String nbrfiliere = "SELECT COUNT(DISTINCT f.id_filiere) AS nombreFiliereEnseignees FROM cours c JOIN filiere_cours fc ON c.id_cours = fc.id_cours JOIN filiere f ON fc.id_filiere = f.id_filiere WHERE c.id_prof = ?";
                PreparedStatement pstmt = con.prepareStatement(nbrfiliere);
                pstmt.setInt(1, Integer.parseInt(idProf));
                rs = pstmt.executeQuery();
                int nombreFiliereEnseignees = 0;

                if (rs.next()) {
                  nombreFiliereEnseignees = rs.getInt("nombreFiliereEnseignees");
                }

                rs.close();
                pstmt.close();

                // Récupérer le nombre de cours enseignés par le professeur
                String sqlCours = "SELECT COUNT(*) AS nombreCours FROM cours WHERE id_prof = ?";
                stmt = con.prepareStatement(sqlCours);
                stmt.setInt(1, Integer.parseInt(idProf));
                rs = stmt.executeQuery();
                int nombreCours = 0;
                if (rs.next()) {
                  nombreCours = rs.getInt("nombreCours");
                }
                rs.close();
                stmt.close();

                // Récupérer le nombre d'élèves enseignés par le professeur
                String sqlEleves = "SELECT COUNT(DISTINCT id_etudiant) AS nombreEleves FROM etu_cours JOIN cours ON etu_cours.id_cours = cours.id_cours WHERE id_prof = ?";
                stmt = con.prepareStatement(sqlEleves);
                stmt.setInt(1, Integer.parseInt(idProf));
                rs = stmt.executeQuery();
                int nombreEleves = 0;
                if (rs.next()) {
                  nombreEleves = rs.getInt("nombreEleves");
                }
                rs.close();
                stmt.close();

                // Récupérer le nombre de niveaux enseignés par le professeur
                String sqlNiveaux = "SELECT COUNT(DISTINCT id_niveau) AS nombreNiveaux FROM cours WHERE id_prof = ?";
                stmt = con.prepareStatement(sqlNiveaux);
                stmt.setInt(1, Integer.parseInt(idProf));
                rs = stmt.executeQuery();
                int nombreNiveaux = 0;
                if (rs.next()) {
                  nombreNiveaux = rs.getInt("nombreNiveaux");
                }
          %>
          <div class="row">
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h5 class="card-title text-uppercase text-muted mb-0">Nombre de filiere </h5>
                      <span class="h2 font-weight-bold mb-0"><%= nombreFiliereEnseignees %></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h5 class="card-title text-uppercase text-muted mb-0">Nombre de cours</h5>
                      <span class="h2 font-weight-bold mb-0"><%= nombreCours %></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h5 class="card-title text-uppercase text-muted mb-0">Nombre d'élèves</h5>
                      <span class="h2 font-weight-bold mb-0"><%= nombreEleves %></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <div class="row">
                    <div class="col">
                      <h5 class="card-title text-uppercase text-muted mb-0">Nombre de niveaux</h5>
                      <span class="h2 font-weight-bold mb-0"><%= nombreNiveaux %></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
              <%
if (idProf != null && !idProf.isEmpty()) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rss = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

        // Récupérer le nom et le prénom du professeur
        String queryProfInfo = "SELECT nom, prenom FROM professeur WHERE id_prof = ?";
        ps = conn.prepareStatement(queryProfInfo);
        ps.setInt(1, Integer.parseInt(idProf));
        rss = ps.executeQuery();
        String prenomProf = "";
        String nomProf = "";

        if (rss.next()) {
            nomProf = rss.getString("nom");
            prenomProf = rss.getString("prenom");
        }
%>
            <h1>Bienvenue, Mr. <%= prenomProf %> <%= nomProf %></h1>
              <%
        String queryCours = "SELECT DISTINCT c.id_cours, c.cours, h.jour, h.heure, h.id_salle FROM cours c JOIN horaire h ON c.id_cours = h.id_cours WHERE c.id_prof=?";
        ps = conn.prepareStatement(queryCours);
        ps.setString(1, idProf);
        rss = ps.executeQuery();
%>
            <h2>Vos Cours </h2>
            <table class="table" style="background-color: white">
              <thead>
              <tr>
                <th>Intitulé du Cours</th>
                <th>Jour</th>
                <th>Heure</th>
                <th>Salle</th>
                <th>Actions</th>
              </tr>
              </thead>
              <tbody>
              <%
                while (rss.next()) {
                  String idCours = rss.getString("id_cours");
                  String cours = rss.getString("cours");
                  String jour = rss.getString("jour");
                  String heure = rss.getString("heure");
                  int salle = rss.getInt("id_salle");
              %>
              <tr>
                <td><%= cours %></td>
                <td><%= jour %></td>
                <td><%= heure %></td>
                <td><%= salle %></td>
                <td>
                  <form action="SuppCoursProf" method="post">
                    <input type="hidden" name="idCours" value="<%= idCours %>">
                    <input type="hidden" name="profId" value="<%= idProf %>">
                    <button type="submit" class="btn btn-danger">Supprimer</button>
                  </form>
                </td>
              </tr>
              <%
                }
              %>
              </tbody>
            </table>
          </br>
          <hr>
          <!-- Messages Section -->
          <div class="row">
            <div class="col-lg-12">
              <div class="message-section">
                <h4>Messages Reçus de l'Administrateur</h4>
                <%
                  // Requête SQL pour récupérer les messages
                  String queryMessages = "SELECT m.message, m.id_message FROM message m "
                          + "JOIN msg_rcp_emt mre ON m.id_rcp_emt = mre.id_rcp_emt "
                          + "WHERE mre.id_log_recepteur = 3 AND mre.id_recepteur = ?";
                  stm = conn.prepareStatement(queryMessages);
                  stm.setString(1, idP); // idP est l'ID du prof passé en paramètre
                  ResultSet rsMessages = stm.executeQuery();

                  int messageCount = 0;
                  while (rsMessages.next()) {
                    messageCount++;
                    String message = rsMessages.getString("message");
                    int idMessage = rsMessages.getInt("id_message");
                %>
                <div class="message-item">
                  <div class="message-item-number"><%= messageCount %></div>
                  <div class="message-content"><%= message %></div>
                  <form action="DeleteMessageProfServlet" method="post">
                    <input type="hidden" name="messageId" value="<%= idMessage %>">
                    <button type="submit" class="btn btn-danger">Supprimer</button>
                  </form>
                </div>
                <%
                  }
                  rsMessages.close();
                  stm.close();
                %>
              </div>
            </div>
          </div>
        </div>
              <%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rss != null) try { rss.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
%>
  <%
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
          }
    }
  %>
    <script src="jquery/jquery.min.js"></script>
  <script src="js/bootstrap.bundle.min.js"></script>
  <script src="js/plugins/chart.js/dist/Chart.min.js"></script>
  <script src="/js/plugins/chart.js/dist/Chart.extension.js"></script>
  <script src="/js/argon-dashboard.min.js?v=1.1.2"></script>
  <script src="https://cdn.trackjs.com/agent/v3/latest/t.js"></script>
</body>
</html>