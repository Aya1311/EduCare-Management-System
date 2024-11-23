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
    </style>

</head>
<body>
<%
    String idProf = request.getParameter("profId");
%>
<%
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
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="main-breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page"><a href="dashboard_prof.jsp?profId=<%= idProf %>">Tableau De Bord</a> </li>
                <li class="breadcrumb-item active" aria-current="page"><a href="dashboard_prof.jsp?proftId=<%= idProf %>">Profil </a></li>
            </ol>
        </nav>

        <!-- Profil -->
        <div class="row gutters-sm">
            <div class="col-md-4 mb-3">
                <!-- Section image et nom -->
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex flex-column align-items-center text-center">
                            <img src="https://bootdey.com/img/Content/avatar/avatar7.png" alt="Admin" class="rounded-circle" width="150">
                            <div class="mt-3">
                                <h4><%= resultSet.getString("nom") %> <%= resultSet.getString("prenom") %></h4>
                                <p class="text-secondary mb-1">Professeur</p>
                                <p class="text-muted font-size-sm"><%= resultSet.getString("adresse") %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card mb-3">
                    <div class="card-body">
                        <!-- Nom -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Nom</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getString("nom") %>
                            </div>
                        </div>
                        <hr>

                        <!-- Prenom -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Prénom</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getString("prenom") %>
                            </div>
                        </div>
                        <hr>

                        <!-- Email -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Email</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getString("email") %>
                            </div>
                        </div>
                        <hr>

                        <!-- Sexe -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Sexe</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getString("sexe") %>
                            </div>
                        </div>
                        <hr>

                        <!-- Numéro de téléphone -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Téléphone</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getString("numero_telephone") %>
                            </div>
                        </div>
                        <hr>

                        <!-- Adresse -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Adresse</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getString("adresse") %>
                            </div>
                        </div>
                        <hr>

                        <!-- Age -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Âge</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getInt("age") %>
                            </div>
                        </div>
                        <hr>

                        <!-- Date de naissance -->
                        <div class="row">
                            <div class="col-sm-3">
                                <h6 class="mb-0">Date de Naissance</h6>
                            </div>
                            <div class="col-sm-9 text-secondary">
                                <%= resultSet.getDate("date_de_naissance").toString() %>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-12">
                                <a class="btn btn-info " target="__blank" href="settings_prof.jsp?profId=<%= idProf %>">Edit</a>
                            </div>
                        </div>
                    </div>
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
<script data-cfasync="false" src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script><script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
</script>
</body>
</html>