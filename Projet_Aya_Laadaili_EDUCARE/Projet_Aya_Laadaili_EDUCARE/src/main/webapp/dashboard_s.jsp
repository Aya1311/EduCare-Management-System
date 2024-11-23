<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Student Dashboard</title>
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
  <link href="css/argon-dashboard.css" rel="stylesheet" />
  <style>.message-section {
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

<body class="" style="background-color: khaki">
  <nav class="navbar navbar-vertical fixed-left navbar-expand-md navbar-light bg-white" id="sidenav-main">
    <div class="container-fluid">
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#sidenav-collapse-main" aria-controls="sidenav-main" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="sidenav-collapse-main">
        <div class="navbar-collapse-header d-md-none">
          <div class="row">
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
        String idEe = request.getParameter("studentId");
        %>
        <!-- Navigation -->
        <ul class="navbar-nav">
          <li class="nav-item active">
            <a class="nav-link active" href="./index.html">
              <i class="ni ni-tv-2 text-primary"></i>Dashboard
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="camarade.jsp?studentId=<%= idEe %>">
              <i class="ni ni-calendar-grid-58 text-success">Camarade</i>
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link" href="etudiant_profile.jsp?studentId=<%= idEe %>">
              <i class="ni ni-single-02 text-danger"></i> Profile
            </a>
          </li>

          <li class="nav-item">
            <a class="nav-link" href="settings.jsp?studentId=<%= idEe %>">
              <i class="ni ni-settings-gear-65 text-warning"></i> Modification
            </a>
          </li>
          <!-- bouton pour le calendrier -->
        <li class="nav-item">
            <a class="nav-link" href="emploi.jsp?studentId=<%= idEe %>" class="btn btn-primary">
              <i class="ni ni-settings-gear-65 text-warning"></i>Voir le calendrier
            </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="reclamation.jsp?studentId=<%= idEe %>" class="btn btn-primary">
            <i class="ni ni-settings-gear-65 text-warning"></i>Faire Une Réclamation
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
          // Déclarations initiales
          String idE = request.getParameter("studentId");
          Connection conn = null;
          PreparedStatement pstmt = null;
          ResultSet rs = null;

          // Informations sur l'étudiant
          String prenometu = "Nom inconnu", nometu = "", niveauEtudiant = "", filiere = "";
          int nombreCours = 0, nombreProfs = 0;

          try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

            // Requête pour les informations de l'étudiant
            String queryInfosEtudiant = "SELECT DISTINCT e.prenom, e.nom, n.niveau, f.nom_filiere, " +
                    "(SELECT COUNT(*) FROM etu_cours ec WHERE ec.id_etudiant = e.id_etudiant) AS nombreCours, " +
                    "(SELECT COUNT(DISTINCT c.id_prof) FROM cours c JOIN etu_cours ec ON c.id_cours = ec.id_cours WHERE ec.id_etudiant = e.id_etudiant) AS nombreProfs " +
                    "FROM etudiant e " +
                    "JOIN niveau n ON e.id_niveau = n.id_niveau " +
                    "JOIN filiere f ON e.id_filiere = f.id_filiere " +
                    "WHERE e.id_etudiant = ?";
            pstmt = conn.prepareStatement(queryInfosEtudiant);
            pstmt.setString(1, idE);
            rs = pstmt.executeQuery();

            if (rs.next()) {
              prenometu = rs.getString("prenom");
              nometu = rs.getString("nom");
              niveauEtudiant = rs.getString("niveau");
              filiere = rs.getString("nom_filiere");
              nombreCours = rs.getInt("nombreCours");
              nombreProfs = rs.getInt("nombreProfs");
            }
            rs.close();
            pstmt.close();

            // Requête pour les cours disponibles
            String sqlAvailable = "SELECT DISTINCT c.id_cours, c.cours FROM cours c " +
                    "JOIN filiere_cours fc ON c.id_cours = fc.id_cours " +
                    "JOIN etudiant e ON fc.id_filiere = e.id_filiere " +
                    "WHERE e.id_etudiant = ? AND c.id_cours NOT IN (SELECT id_cours FROM etu_cours WHERE id_etudiant = ?)";
            pstmt = conn.prepareStatement(sqlAvailable);
            pstmt.setString(1, idE);
            pstmt.setString(2, idE);
            rs = pstmt.executeQuery();
        %>
        <a class="h4 mb-0 text-white text-uppercase d-none d-lg-inline-block" href="index.html"><%= prenometu %> <%= nometu %></a>
        <!-- User -->
      </div>
    </nav>
    <!-- End Navbar -->
    <!-- Header -->
    <div class="header bg-gradient-primary pb-8 pt-5 pt-md-8">
      <div class="container-fluid">
        <div class="header-body">
          <!-- Row for Card stats -->
          <div class="row">
            <!-- Card for Niveau -->
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <h5 class="card-title text-uppercase text-muted mb-0">Niveau </h5>
                  <span class="h2 font-weight-bold mb-0"><%= niveauEtudiant %></span>
                </div>
              </div>
            </div>

            <!-- Card for displaying Filière -->
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <h5 class="card-title text-uppercase text-muted mb-0">Filière</h5>
                  <span class="h2 font-weight-bold mb-0"><%= filiere %></span>
                </div>
              </div>
            </div>

            <!-- Card for Nombre de cours -->
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <h5 class="card-title text-uppercase text-muted mb-0">Nombre de cours</h5>
                  <span class="h2 font-weight-bold mb-0"><%= nombreCours %></span>
                </div>
              </div>
            </div>

            <!-- Card for Number of Professors -->
            <div class="col-xl-3 col-lg-6">
              <div class="card card-stats mb-4 mb-xl-0">
                <div class="card-body">
                  <h5 class="card-title text-uppercase text-muted mb-0">Number of Professors</h5>
                  <span class="h2 font-weight-bold mb-0"><%= nombreProfs %></span>
                </div>
              </div>
            </div>
          </div> <!-- End of Row -->
        </div>
      </div>
    </div>
    <div class="container-fluid mt--7">
      <!-- Formulaire pour l'ajout de nouveaux cours -->
      <div class="row">
        <div class="col text-right">
          <form action="AddCourseServlet" method="post">
            <input type="hidden" name="studentId" value="<%= idE %>">
            <select name="courseId">
              <%
                while (rs.next()) {
                  String courseIdAvailable = rs.getString("id_cours");
                  String courseNameAvailable = rs.getString("cours");
              %>
              <option value="<%= courseIdAvailable %>"><%= courseNameAvailable %></option>
              <%
                }
              %>
            </select>
            <button type="submit" class="btn btn-success">Ajouter un nouveau cours</button>
          </form>
        </div>
      </div>
      <%
        rs.close();
        pstmt.close();
      %>

      <!-- Tableau des cours inscrits -->
      <div class="row">
        <div class="col">
          <div class="card shadow">
            <div class="card-header border-0">
              <h3 class="mb-0">Cours Inscrits</h3>
            </div>
            <div class="table-responsive">
              <table class="table align-items-center table-flush">
                <thead class="thead-light">
                <tr>
                  <th scope="col">Cours</th>
                  <th scope="col">Jour</th>
                  <th scope="col">Heure</th>
                  <th scope="col">Salle</th>
                  <th scope="col">Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                  String queryCoursInscrits = "SELECT DISTINCT c.id_cours, c.cours, h.jour, h.heure, h.id_salle " +
                          "FROM etu_cours ec " +
                          "JOIN cours c ON ec.id_cours = c.id_cours " +
                          "JOIN horaire h ON c.id_cours = h.id_cours " +
                          "WHERE ec.id_etudiant = ?";
                  pstmt = conn.prepareStatement(queryCoursInscrits);
                  pstmt.setString(1, idE);
                  rs = pstmt.executeQuery();

                  while (rs.next()) {
                    String courseId = rs.getString("id_cours");
                    String courseName = rs.getString("cours");
                    String jour = rs.getString("jour");
                    String heure = rs.getString("heure");
                    int salle = rs.getInt("id_salle");
                %>
                <tr>
                  <td><%= courseName %></td>
                  <td><%= jour %></td>
                  <td><%= heure %></td>
                  <td>Salle <%= salle %></td>
                  <td>
                    <form action="DeleteCourseServlet" method="post">
                      <input type="hidden" name="courseId" value="<%= courseId %>">
                      <input type="hidden" name="studentId" value="<%= idE %>">
                      <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                  </td>
                </tr>
                <%
                  }
                  rs.close();
                  pstmt.close();
                %>
                </tbody>
              </table>
            </div>
            </div>
          </div>
          </div>
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
                      + "WHERE mre.id_log_recepteur = 2 AND mre.id_recepteur = ?";
              pstmt = conn.prepareStatement(queryMessages);
              pstmt.setString(1, idE); // idP est l'ID du etudiant passé en paramètre
              ResultSet rsMessages = pstmt.executeQuery();

              int messageCount = 0;
              while (rsMessages.next()) {
                messageCount++;
                String message = rsMessages.getString("message");
                int idMessage = rsMessages.getInt("id_message");
            %>
            <div class="message-item">
              <div class="message-item-number"><%= messageCount %></div>
              <div class="message-content"><%= message %></div>
              <form action="DeleteMessageEtuServlet" method="post">
                <input type="hidden" name="messageId" value="<%= idMessage %>">
                <button type="submit" class="btn btn-danger">Supprimer</button>
              </form>
            </div>
            <%
              }
              rsMessages.close();
              pstmt.close();
            %>
          </div>
        </div>
      </div>
    </div>
    </div>
      <%
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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