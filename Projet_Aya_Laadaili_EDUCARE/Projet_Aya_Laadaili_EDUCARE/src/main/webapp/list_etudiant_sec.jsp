<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Liste Etudiant</title>
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
                                <th><span>Nom</span></th>
                                <th><span>Email</span></th>
                                <th><span>Mot de Passe</span></th>
                                <th><span>Date de Naissance</span></th>
                                <th><span>Sexe</span></th>
                                <th><span>Adresse</span></th>
                                <th><span>Status</span></th>
                                <th><span>Action</span></th>
                                <th>&nbsp;</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                String idS = request.getParameter("secretaireId");
                                Connection co = null;
                                PreparedStatement stm = null;
                                ResultSet r = null;
                                try {
                                    co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                                    String querySecraitaire = "SELECT id_niveau FROM secretaire WHERE id_secretaire = ?";
                                    stm = co.prepareStatement(querySecraitaire);
                                    stm.setString(1, idS);
                                    ResultSet rsSecraitaire = stm.executeQuery();

                                    if (rsSecraitaire.next()) {
                                        int idNiveau = rsSecraitaire.getInt("id_niveau");
                                        String queryEtudiant = "SELECT * FROM etudiant WHERE id_niveau = ?";
                                        stm = co.prepareStatement(queryEtudiant);
                                        stm.setInt(1, idNiveau);
                                        ResultSet rsEtudiant = stm.executeQuery();

                                        while (rsEtudiant.next()) {
                                            String nom = rsEtudiant.getString("nom") + " " + rsEtudiant.getString("prenom");
                                            String email = rsEtudiant.getString("email");
                                            int id_etudiant = rsEtudiant.getInt("id_etudiant");
                                            String dateNaissance = rsEtudiant.getDate("datedenaissance").toString();
                                            String sexe = rsEtudiant.getString("sexe");
                                            String adresse = rsEtudiant.getString("adresse");
                                            String statut = rsEtudiant.getString("statut");
                                            String motdepasse = rsEtudiant.getString("motdepasse");
                            %>
                            <tr>
                                <td><%= nom %></td>
                                <td><%= email %></td>
                                <td><%= motdepasse %></td>
                                <td><%= dateNaissance %></td>
                                <td><%= sexe %></td>
                                <td><%= adresse %></td>
                                <td><span class="label <%= "Payé".equals(statut) ? "label-success" : "label-danger" %>"><%= statut %></span>
                                </td> <td>
                                <a href="modifierEtu.jsp?idEtudiant=<%= id_etudiant %>&idSecretaire=<%= idS %>" class="btn" style="background-color: #DD4A68; color: white; text-decoration: none; padding: 5px 10px; border-radius: 4px;">Modifier</a>
                            </td>

                                <td>
                                    <a href="supprimerEtu?idEtudiant=<%= id_etudiant %>&idSecretaire=<%= idS %>" class="btn" style="background-color: #0da5c0; color: white; text-decoration: none; padding:5px 10px; -radius: 4px;">Suuprimer</a>
                                </td>
                            </tr>
                            <%
                                        }
                                        rsEtudiant.close();
                                    }
                                    rsSecraitaire.close();
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
        <a href="creer_etudiant.jsp?secretaireId=<%= idS%>" class="btn" style="background-color: #3d027b ; color: white; text-decoration: none; padding: 5px 10px; border-radius: 4px;">Creer Nouveau etudiant</a>
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