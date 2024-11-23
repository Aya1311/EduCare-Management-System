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
        #searchInput {
            font-size: 16px; /* Taille de la police */
            padding: 10px; /* Espacement intérieur */
            border: 1px solid #ddd; /* Bordure */
            border-radius: 4px; /* Coins arrondis */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Ombre subtile */
            width: 100%; /* Largeur complète */
            margin-bottom: 20px; /* Marge en dessous */
        }

        #searchInput::placeholder {
            color: #999; /* Couleur du texte indicatif */
        }

        #searchInput:focus {
            border-color: #0056b3; /* Couleur de la bordure lors de la focalisation */
            box-shadow: 0 0 8px rgba(0, 86, 179, 0.2); /* Ombre lors de la focalisation */
            outline: none; /* Supprimer l'outline par défaut */
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.2/xlsx.full.min.js"></script>
    <script>
        function searchTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementsByClassName("user-list")[0];
            tr = table.getElementsByTagName("tr");

            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[0]; // Index 0 pour la première colonne
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
        function downloadTableCoursAsExcel() {
            var table = document.getElementById("dataTableCours").cloneNode(true); // Cloner le tableau
            var rows = table.rows;

            // Parcourir chaque ligne pour supprimer la dernière cellule (Action)
            for (var i = 0; i < rows.length; i++) {
                rows[i].deleteCell(-1); // Supprime la dernière cellule de chaque ligne
            }

            var workbook = XLSX.utils.table_to_book(table, { sheet: "Liste Cours" });
            XLSX.writeFile(workbook, 'Liste_Cours.xlsx');
        }
    </script>
</head>
<body>
<div class="container bootstrap snippets bootdey">
    <div class="row">
        <div class="col-lg-12">
            <div class="main-box no-header clearfix">
                <div class="main-box-body clearfix">
                    <div class="mb-3">
                        <input type="text" id="searchInput" onkeyup="searchTable()" placeholder="Recherche dans les cours..." class="form-control">
                    </div>
                    <div class="mb-3">
                        <button onclick="downloadTableCoursAsExcel()" class="btn btn-primary">Télécharger en Excel</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table user-list" id="dataTableCours">
                            <thead>
                            <tr>
                                <th><span>Cours</span></th>
                                <th><span>Niveau</span></th>
                                <th><span>Total étudiant</span></th>
                                <th><span>Jour</span></th>
                                <th><span>Heure</span></th>
                                <th><span>Salle</span></th>
                                <th><span>Professeur</span></th>
                                <th><span>Actions</span></th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                Connection co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                                String queryCours = "SELECT DISTINCT c.id_cours, c.cours, n.niveau, h.jour, h.heure, s.salle, p.nom, p.prenom FROM cours c JOIN niveau n ON c.id_niveau = n.id_niveau JOIN horaire h ON c.id_cours = h.id_cours JOIN salle s ON h.id_salle = s.id_salle JOIN professeur p ON c.id_prof = p.id_prof";
                                PreparedStatement stm = co.prepareStatement(queryCours);
                                ResultSet rsCours = stm.executeQuery();

                                while (rsCours.next()) {
                                    int idCours = rsCours.getInt("id_cours");
                                    String cours = rsCours.getString("cours");
                                    String niveau = rsCours.getString("niveau");
                                    String jour = rsCours.getString("jour");
                                    String heure = rsCours.getString("heure");
                                    String salle = rsCours.getString("salle");
                                    String nomProf = rsCours.getString("nom") + " " + rsCours.getString("prenom");

                                    // Query for total students
                                    String queryTotEtu = "SELECT COUNT(*) AS total_etudiants FROM etu_cours WHERE id_cours = ?";
                                    PreparedStatement stmTotEtu = co.prepareStatement(queryTotEtu);
                                    stmTotEtu.setInt(1, idCours);
                                    ResultSet rsTotEtu = stmTotEtu.executeQuery();
                                    int totalEtudiants = 0;
                                    if (rsTotEtu.next()) {
                                        totalEtudiants = rsTotEtu.getInt("total_etudiants");
                                    }
                            %>
                            <tr>
                                <td><%= cours %></td>
                                <td><%= niveau %></td>
                                <td><%= totalEtudiants %></td>
                                <td><%= jour %></td>
                                <td><%= heure %></td>
                                <td><%= salle %></td>
                                <td><%= nomProf %></td>
                                <td>
                                    <!-- Modify and Delete Buttons -->
                                    <a href="modify_course_admin.jsp?id_cours=<%= idCours %>" class="btn btn-primary">Modifier</a>
                                    <form action="supp_cours_admin" method="post" style="display:inline;">
                                        <input type="hidden" name="id_cours" value="<%= idCours %>">
                                        <button type="submit" class="btn btn-danger">Supprimer</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    rsTotEtu.close();
                                    stmTotEtu.close();
                                }
                                rsCours.close();
                                stm.close();
                                co.close();
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-12 mb-3">
        <a href="dashboard_admin.jsp" class="btn" style="background-color: #2aa198; color: white; text-decoration: none; padding: 5px 10px; border-radius: 4px;">Retour au Dashboard </a>
    </div>
    <div class="col-12 mb-3">
        <a href="Creer_Cours.jsp" class="btn" style="background-color: #3d027b ; color: white; text-decoration: none; padding: 5px 10px; border-radius: 4px;">Creer Nouveau Cours</a>
    </div>
</div>
<script data-cfasync="false" src="/cdn-cgi/scripts/5c5dd728/cloudflare-static/email-decode.min.js"></script><script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
</script>
</body>
</html>