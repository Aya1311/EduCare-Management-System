<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Liste Cours</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
    <style type="text/css">
        body{
            background:#eee;
        }
        .btn-home {
            background-color: orange;
            color: darkorange;
            border: none;
        }
        .btn-home:hover {
            background-color: #ff9900;
            color: white;
        }
        .btn-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .main-box.no-header {
            padding-top: 20px;
        }
        .main-box {
            background: #FFFFFF;
            -webkit-box-shadow: 1px 1px 2px 0 #CCCCCC;
            -moz-box-shadow: 1px 1px 2px 0 #CCCCCC;
            -o-box-shadow: 1px 1px 2px 0 #CCCCCC;
            -ms-box-shadow: 1px 1px 2px 0 #CCCCCC;
            box-shadow: 1px 1px 2px 0 #CCCCCC;
            margin-bottom: 16px;
            -webikt-border-radius: 3px;
            -moz-border-radius: 3px;
            border-radius: 3px;
        }
        .table a.table-link.danger {
            color: #e74c3c;
        }
        .label {
            border-radius: 3px;
            font-size: 0.875em;
            font-weight: 600;
        }
        .user-list tbody td .user-subhead {
            font-size: 0.875em;
            font-style: italic;
        }
        .user-list tbody td .user-link {
            display: block;
            font-size: 1.25em;
            padding-top: 3px;
            margin-left: 60px;
        }
        a {
            color: #3498db;
            outline: none!important;
        }
        .user-list tbody td>img {
            position: relative;
            max-width: 50px;
            float: left;
            margin-right: 15px;
        }

        .table thead tr th {
            text-transform: uppercase;
            font-size: 0.875em;
        }
        .table thead tr th {
            border-bottom: 2px solid #e7ebee;
        }
        .table tbody tr td:first-child {
            font-size: 1.125em;
            font-weight: 300;
        }
        .table tbody tr td {
            font-size: 0.875em;
            vertical-align: middle;
            border-top: 1px solid #e7ebee;
            padding: 12px 8px;
        }
        a:hover{
            text-decoration:none;
        }
    </style>
</head>
<body>
<div class="container bootstrap snippets bootdey">
    <div class="row">
        <div class="col-lg-12">
            <div class="main-box no-header clearfix">
                <div class="main-box-body clearfix">
                    <div class="table-responsive">
                        <table class="table user-list">
                            <thead>
                            <tr>
                                <th><span>Cours</span></th>
                                <th><span>Total étudiant</span></th>
                                <th><span>Jour</span></th>
                                <th><span>Heure</span></th>
                                <th><span>Salle</span></th>
                                <th><span>Professeur</span></th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                String idS = request.getParameter("secretaireId");
                                Connection co = null;
                                PreparedStatement stm = null;
                                try {
                                    co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                                    String queryNiveau = "SELECT id_niveau FROM secretaire WHERE id_secretaire = ?";
                                    stm = co.prepareStatement(queryNiveau);
                                    stm.setString(1, idS);
                                    ResultSet rsNiveau = stm.executeQuery();

                                    if (rsNiveau.next()) {
                                        int idNiveau = rsNiveau.getInt("id_niveau");
                                        String queryCours = "SELECT * FROM cours WHERE id_niveau = ?";
                                        stm = co.prepareStatement(queryCours);
                                        stm.setInt(1, idNiveau);
                                        ResultSet rsCours = stm.executeQuery();

                                        while (rsCours.next()) {
                                            String cours = rsCours.getString("cours");
                                            int id_cours = rsCours.getInt("id_cours");
                                            int id_prof = rsCours.getInt("id_prof");

                                            // Requête pour obtenir les détails du professeur
                                            String queryProf = "SELECT * FROM professeur WHERE id_prof = ?";
                                            PreparedStatement stmProf = co.prepareStatement(queryProf);
                                            stmProf.setInt(1, id_prof);
                                            ResultSet rsProf = stmProf.executeQuery();
                                            String nomProf = "";
                                            if (rsProf.next()) {
                                                nomProf = rsProf.getString("nom");
                                            }

                                            // Requête pour obtenir le total des étudiants
                                            String queryTotEtu = "SELECT COUNT(*) AS total_etudiants FROM etu_cours WHERE id_cours = ?";
                                            PreparedStatement stmTotEtu = co.prepareStatement(queryTotEtu);
                                            stmTotEtu.setInt(1, id_cours);
                                            ResultSet rsTotEtu = stmTotEtu.executeQuery();
                                            int totalEtudiants = 0;
                                            if (rsTotEtu.next()) {
                                                totalEtudiants = rsTotEtu.getInt("total_etudiants");
                                            }

                                            // Requête pour obtenir les informations de l'horaire
                                            String queryHoraire = "SELECT jour, heure, id_salle FROM horaire WHERE id_cours = ?";
                                            PreparedStatement stmHoraire = co.prepareStatement(queryHoraire);
                                            stmHoraire.setInt(1, id_cours);
                                            ResultSet rsHoraire = stmHoraire.executeQuery();
                                            String jour = "", heure = "", salle = "";
                                            if (rsHoraire.next()) {
                                                jour = rsHoraire.getString("jour");
                                                heure = rsHoraire.getString("heure");
                                                int id_salle = rsHoraire.getInt("id_salle");

                                                // Requête pour obtenir le nom de la salle
                                                String querySalle = "SELECT salle FROM salle WHERE id_salle = ?";
                                                PreparedStatement stmSalle = co.prepareStatement(querySalle);
                                                stmSalle.setInt(1, id_salle);
                                                ResultSet rsSalle = stmSalle.executeQuery();
                                                if (rsSalle.next()) {
                                                    salle = rsSalle.getString("salle");
                                                }
                                                rsSalle.close();
                                                stmSalle.close();
                                            }
                            %>
                            <tr>
                                <td><%= cours %></td>
                                <td><%= totalEtudiants %></td>
                                <td><%= jour %></td>
                                <td><%= heure %></td>
                                <td><%= salle %></td>
                                <td><%= nomProf %></td>
                                <td>
                                    <!-- Modify Button -->
                                    <a href="modify_course.jsp?id_cours=<%= id_cours %>&secretaireId=<%= idS %>" class="btn btn-primary">Modifier</a>
                                    <!-- Delete Button -->
                                    <form action="delete_course" method="post" style="display:inline;">
                                        <input type="hidden" name="id_cours" value="<%= id_cours %>">
                                        <input type="hidden" name="secretaireId" value="<%= idS %>">
                                        <button type="submit" class="btn btn-danger">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                            rsHoraire.close();
                                            stmHoraire.close();
                                            rsTotEtu.close();
                                            stmTotEtu.close();
                                            rsProf.close();
                                            stmProf.close();
                                        }
                                        rsCours.close();
                                    }
                                    rsNiveau.close();
                                } catch (SQLException e) {
                                    e.printStackTrace();
                                } finally {
                                    if (stm != null) try { stm.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    if (co != null) try { co.close(); } catch (SQLException e) { e.printStackTrace(); }
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-12 mb-3">
        <a href=dashboard_secraitaire.jsp?secretaireId=<%= idS%>"" class="btn" style="background-color: #2aa198; color: white; text-decoration: none; padding: 5px 10px; border-radius: 4px;">Retour au Dashboard </a>
    </div>
</div>
<script data-cfasync="false" src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script><script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
</script>
</body>
</html>