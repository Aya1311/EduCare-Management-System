<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Liste Professeur</title>
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
    <script>
        function searchTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("professorList");
            tr = table.getElementsByTagName("tr");

            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[0]; // Index 0 pour le nom, 1 pour le prénom, etc.
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
<link rel="stylesheet" type="text/css" href="//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css">
<hr>
<div class="container">
    <h2>Liste des Professeurs</h2>

    <div class="container">
        <div class="main-box no-header clearfix">
            <div class="main-box-body clearfix">
                <div class="search-container" style="margin-bottom: 20px;">
                    <input type="text" id="searchInput" placeholder="Recherche " onkeyup="searchTable()">
                </div>
                <div class="table-responsive">
                    <table class="table user-list" id="professorList">
                        <thead>
                        <tr>
                            <th><span>Nom</span></th>
                            <th><span>Prénom</span></th>
                            <th><span>Âge</span></th>
                            <th><span>Date de Naissance</span></th>
                            <th><span>Adresse</span></th>
                            <th><span>Numéro de Téléphone</span></th>
                            <th><span>Sexe</span></th>
                            <th><span>Email</span></th>
                            <th><span>Mot De Passe</span></th>
                        </tr>
                        </thead>
                        <tbody>
        <%
            String secretaireId = request.getParameter("secretaireId");
            Connection co = null;
            PreparedStatement stm = null;
            ResultSet rs = null;

            try {
                co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

                String queryNiveau = "SELECT id_niveau FROM secretaire WHERE id_secretaire = ?";
                stm = co.prepareStatement(queryNiveau);
                stm.setString(1, secretaireId);
                ResultSet rsNiveau = stm.executeQuery();

                if (rsNiveau.next()) {
                    int idNiveau = rsNiveau.getInt("id_niveau");

                    String queryProfesseur = "SELECT p.nom, p.prenom, p.age, p.date_de_naissance, p.adresse, p.numero_telephone, p.sexe, p.email , p.motdepasse FROM professeur p JOIN prof_niveau pn ON p.id_prof = pn.id_prof WHERE pn.id_niveau = ?";
                    stm = co.prepareStatement(queryProfesseur);
                    stm.setInt(1, idNiveau);
                    rs = stm.executeQuery();

                    while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("nom") %></td>
            <td><%= rs.getString("prenom") %></td>
            <td><%= rs.getInt("age") %></td>
            <td><%= rs.getDate("date_de_naissance") %></td>
            <td><%= rs.getString("adresse") %></td>
            <td><%= rs.getString("numero_telephone") %></td>
            <td><%= rs.getString("sexe") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("motdepasse") %></td>
        </tr>
        <%
                    }
                }

                rsNiveau.close();
                if (rs != null) rs.close();
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
    <a href=dashboard_secraitaire.jsp?secretaireId=<%= secretaireId %>"" class="btn" style="background-color: #2aa198; color: white; text-decoration: none; padding: 5px 10px; border-radius: 4px;">Retour au Dashboard </a>
</div>
<script data-cfasync="false" src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script><script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
</script>
</body>
</html>