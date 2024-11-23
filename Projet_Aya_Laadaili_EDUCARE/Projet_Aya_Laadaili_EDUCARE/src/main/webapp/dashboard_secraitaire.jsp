<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Secraitaire DashBoard</title>
    <link href="css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <style>
        .message-section {
            background-color: #f8f9fc;
            border: 1px solid #e3e6f0;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }

        .message-item {
            margin-bottom: 15px;
            padding: 15px;
            background-color: #ffffff;
            border-radius: 5px;
            border-left: 4px solid #4e73df;
        }

        .message-content {
            margin: 0;
            color: #5a5c69;
        }

        .message-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-sm {
            padding: 5px 10px;
            font-size: 0.875rem;
        }
    </style>
</head>
<body id="page-top">
<div id="wrapper">
    <%
        String idS = request.getParameter("secretaireId");
        String prenomSecraitaire = "";
        String nomSecraitaire = "";
        int idNiveau = 0;
        String niveauName = "";
        int numberOfFiliere = 0;
        int numberOfCours = 0;
        int numberOfEtudiants = 0;

        Connection co = null;
        PreparedStatement stm = null;
        ResultSet r = null;
        ResultSet filiereRs = null;
        try {
            co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
            String dataQuery = "SELECT * FROM secretaire WHERE id_secretaire = ?";
            stm = co.prepareStatement(dataQuery);
            stm.setString(1, idS);
            r = stm.executeQuery();
            if (r.next()) {
                prenomSecraitaire = r.getString("prenom");
                nomSecraitaire = r.getString("nom");
                idNiveau = r.getInt("id_niveau");
            } else {
                nomSecraitaire = "Secrétaire Non Existante. Vérifiez la création du compte avec l'admin.";
            }
            r.close();
            stm.close();

            // Niveau Query
            String niveauQuery = "SELECT niveau FROM niveau WHERE id_niveau = ?";
            stm = co.prepareStatement(niveauQuery);
            stm.setInt(1, idNiveau);
            r = stm.executeQuery();
            if (r.next()) {
                niveauName = r.getString("niveau");
            }
            r.close();
            stm.close();

            // Count Query
            String countQuery = "SELECT (SELECT COUNT(*) FROM filiere WHERE id_niveau = ?) AS filiereCount, " +
                    "(SELECT COUNT(*) FROM cours WHERE id_niveau = ?) AS coursCount, " +
                    "(SELECT COUNT(*) FROM etudiant WHERE id_niveau = ?) AS etudiantCount";
            stm = co.prepareStatement(countQuery);
            stm.setInt(1, idNiveau);
            stm.setInt(2, idNiveau);
            stm.setInt(3, idNiveau);
            r = stm.executeQuery();
            if (r.next()) {
                numberOfFiliere = r.getInt("filiereCount");
                numberOfCours = r.getInt("coursCount");
                numberOfEtudiants = r.getInt("etudiantCount");
            }
            r.close();
            stm.close();
            // Filiere Query
            String filiereQuery = "SELECT f.id_filiere, f.nom_filiere, COUNT(e.id_etudiant) as studentCount "
                    + "FROM filiere f LEFT JOIN etudiant e ON f.id_filiere = e.id_filiere "
                    + "WHERE f.id_niveau = ? "
                    + "GROUP BY f.id_filiere";
            stm = co.prepareStatement(filiereQuery);
            stm.setInt(1, idNiveau);
            filiereRs = stm.executeQuery();
    %>
        <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
            <a class="sidebar-brand d-flex align-items-center justify-content-center" href="#">
                <div class="sidebar-brand-icon rotate-n-15">
                    <i class="fas fa-laugh-wink"></i>
                </div>
                <div class="sidebar-brand-text mx-3">DashBoard <%=nomSecraitaire %> <%=prenomSecraitaire %></div>
            </a>
            <hr class="sidebar-divider my-0">
            <li class="nav-item active">
                <a class="nav-link" href="#">
                    <i class="fas fa-fw fa-tachometer-alt"></i>
                    <span>Bonjour <%=nomSecraitaire %> <%=prenomSecraitaire %></span></a>
            </li>
            <hr class="sidebar-divider">
            <div class="sidebar-heading">
                Gestion
            </div>
            <li class="nav-item">
                <a class="nav-link collapsed" href="list_cours_sec.jsp?secretaireId=<%= idS %>"  data-toggle="collapse" data-target="#collapseTwo"
                    aria-expanded="true" aria-controls="collapseTwo">
                    <i class="fas fa-fw fa-cog"></i>
                    <span>Cours</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collapsed" href="list_etudiant_sec.jsp?secretaireId=<%= idS %>" data-toggle="collapse" data-target="#collapseUtilities"
                    aria-expanded="true" aria-controls="collapseUtilities">
                    <i class="fas fa-fw fa-wrench"></i>
                    <span>Eleves</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collapsed" href="list_prof_sec.jsp?secretaireId=<%= idS %>" data-toggle="collapse" data-target="#collapseUtilities"
                   aria-expanded="true" aria-controls="collapseUtilities">
                    <i class="fas fa-fw fa-wrench"></i>
                    <span>Prof</span>
                </a>
            </li>

            <hr class="sidebar-divider">
            <div class="sidebar-heading">
                Logout
            </div>
            <li class="nav-item">
                <a class="nav-link collapsed" href="login.jsp" data-toggle="collapse" data-target="#collapsePages"
                   aria-expanded="true" aria-controls="collapsePages">
                    <i class="fas fa-fw fa-folder"></i>
                    <span>LogOut</span>
                </a>
            </li>
            <div class="text-center d-none d-md-inline">
                <button class="rounded-circle border-0" id="sidebarToggle"></button>
            </div>

        </ul>
        <div id="content-wrapper" class="d-flex flex-column">
            <div id="content">
                <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
                    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                        <i class="fa fa-bars"></i>
                    </button>
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item dropdown no-arrow d-sm-none">
                            <a class="nav-link dropdown-toggle" href="#" id="searchDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-search fa-fw"></i>
                            </a>
                        </li>
                        <li class="nav-item dropdown no-arrow">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="mr-2 d-none d-lg-inline text-gray-600 small" href="eleve_prof.jsp?secretaireId=<%= idS %>"></span>
                                <img class="img-profile rounded-circle"
                                    src="img/sf.svg">
                            </a>
                            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="sec_profile.jsp?secretaireId=<%= idS %>">
                                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Profile
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" data-toggle="modal" data-target="#logoutModal" href="login.jsp">
                                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Logout
                                </a>
                            </div>
                        </li>
                    </ul>
                </nav>
                <div class="container-fluid">
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800">Dashboard</h1>
                           </div>
                    <div class="row">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-primary shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                Niveau</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"> <%= niveauName %></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-calendar fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-success shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                Nombre de filiere</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"><%= numberOfFiliere %></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-info shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Nombre de cours
                                            </div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"><%= numberOfCours %></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-warning shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Nombre d'etudiant</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"> <%= numberOfEtudiants %></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-comments fa-2x text-gray-300"></i>
                                        </div></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Filiere List Section -->
                    <div class="row">
                        <div class="col-xl-8 col-lg-7">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3">
                                    <h6 class="m-0 font-weight-bold text-primary">Liste des Filieres</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                            <thead>
                                            <tr>
                                                <th>Nom Filiere</th>
                                                <th>Nombre d'Etudiants</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <% while (filiereRs != null && filiereRs.next()) { %>
                                            <tr>
                                                <td><%= filiereRs.getString("nom_filiere") %></td>
                                                <td><%= filiereRs.getInt("studentCount") %></td>
                                            </tr>
                                            <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Messages Section -->
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="message-section">
                                <h4>Messages Reçus de l'Administrateur</h4>
                                <%
                                        // Requête SQL pour récupérer les messages
                                        String queryMessages = "SELECT m.message, m.id_message FROM message m "
                                                + "JOIN msg_rcp_emt mre ON m.id_rcp_emt = mre.id_rcp_emt "
                                                + "WHERE mre.id_log_recepteur = 1 AND mre.id_recepteur = ?";
                                        stm = co.prepareStatement(queryMessages);
                                        stm.setString(1, idS); // idS est l'ID du secrétaire passé en paramètre
                                        ResultSet rsMessages = stm.executeQuery();

                                        while (rsMessages.next()) {
                                            String message = rsMessages.getString("message");
                                            int idMessage = rsMessages.getInt("id_message");
                                    %>
                                <div class="message-item">
                                    <div class="message-content"><%= message %></div>
                                    <div class="message-actions">
                                        <button onclick="replyMessage(<%= idMessage %>)" class="btn btn-primary btn-sm">Répondre</button>
                                        <form action="DeleteMessageSecServlet" method="post" class="d-inline">
                                            <input type="hidden" name="messageId" value="<%= idMessage %>">
                                            <button type="submit" class="btn btn-danger btn-sm">Supprimer</button>
                                        </form>
                                    </div>
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
                        if (r != null) try { r.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stm != null) try { stm.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (co != null) try { co.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                    %>
            <footer class="sticky-footer bg-white">
                <div class="container my-auto">
                    <div class="copyright text-center my-auto">
                        <span>Copyright &copy; EduCare 2023</span>
                    </div>
                </div>
            </footer>
        </div>
  </div></div>

<script src="jquery/jquery.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="query/jquery.easing.min.js"></script>
    <script src="js/sb-admin-2.min.js"></script>
    <script src="js/Chart.min.js"></script>
    <script src="js/demo/chart-area-demo.js"></script>
    <script src="js/demo/chart-pie-demo.js"></script>
<script>
    function replyMessage(messageId) {
        var reply = prompt("Votre réponse:");
        if (reply) {
            var userId = <%= idS %>;
            var userType = 1;

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "SendResponseServletSec", true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhr.send("message=" + encodeURIComponent(reply) + "&userId=" + userId + "&userType=" + userType);
        }
    }
</script>
</body>
</html>