<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Liste Professeur</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style type="text/css">
        body {
            background: #eee url('https://i.imgur.com/eeQeRmk.png');
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            font-size: 62.5%;
            line-height: 1;
            color: #585858;
            padding: 22px 10px;
            padding-bottom: 55px;
            margin: 0;
        }
        ::selection { background: #5f74a0; color: #fff; }
        ::-moz-selection { background: #5f74a0; color: #fff; }
        br { display: block; line-height: 1.6em; }
        article, aside, details, figcaption, figure, footer, header, hgroup, menu, nav, section { display: block; }
        ol, ul { list-style: none; }
        input, textarea {
            -webkit-font-smoothing: antialiased;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            outline: none;
        }
        blockquote, q { quotes: none; }
        blockquote:before, blockquote:after, q:before, q:after { content: ''; content: none; }
        strong, b { font-weight: bold; }
        table { border-collapse: collapse; border-spacing: 0; }
        img { border: 0; max-width: 100%; }
        h1 {
            font-family: 'Amarante', Tahoma, sans-serif;
            font-weight: bold;
            font-size: 3.6em;
            line-height: 1.7em;
            margin-bottom: 10px;
            text-align: center;
        }
        /* Styles for the table */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto;
            background: #fff;
            box-shadow: 2px 2px 3px -1px rgba(0,0,0,0.35);
            border-radius: 5px;
            padding: 10px 17px;
        }
        .table th, .table td {
            border: 1px solid #dee2e6;
            padding: 10px;
            text-align: center;
        }
        .table th {
            background-color: #c9dff0;
            cursor: pointer;
        }
        .table th.headerSortUp, .table th.headerSortDown {
            background: #acc8dd;
        }
        .table th.headerSortUp span {
            background-image: url('https://i.imgur.com/SP99ZPJ.png');
            background-repeat: no-repeat;
            background-position: 100% 100%;
            padding-right: 20px;
        }
        .table th.headerSortDown span {
            background-image: url('https://i.imgur.com/RkA9MBo.png');
            background-repeat: no-repeat;
            background-position: 100% 100%;
            padding-right: 20px;
        }
        .table tbody tr {
            color: #555;
        }
        .table tbody tr td {
            text-align: center;
            padding: 15px 10px;
        }
        .table tbody tr td.lalign {
            text-align: left;
        }
        /* Button styles */
        .btn-home {
            background-color: #3e588f;
            color: #fff;
            border: none;
        }
        .btn-home:hover {
            background-color: #2c446d;
        }
        .btn-success {
            background-color: #7194ec;
            color: #fff;
            border: none;
        }
        .btn-success:hover {
            background-color: #5d80d0;
        }
        .btn-danger {
            background-color: #ff6b6b;
            color: #fff;
            border: none;
        }
        .btn-danger:hover {
            background-color: #e75b5b;
        }
        /* Style pour la zone de recherche */
        #searchInputProfesseur {
            width: 100%; /* Largeur à 100% pour remplir la largeur du conteneur parent */
            padding: 10px; /* Espacement intérieur pour un meilleur aspect */
            font-size: 16px; /* Taille de police */
            border: 1px solid #ccc; /* Bordure grise */
            border-radius: 4px; /* Coins arrondis */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Ombre légère */
            outline: none; /* Supprimer la bordure de mise au point */
        }

        #searchInputProfesseur::placeholder {
            color: #999;
        }

        /* Style au focus (lorsque la zone de recherche est active) */
        #searchInputProfesseur:focus {
            border-color: #007bff; /* Bordure bleue en cas de mise au point */
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.2); /* Ombre légère en cas de mise au point */
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.2/xlsx.full.min.js"></script>
    <script>
        function searchTableProfesseur() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInputProfesseur");
            filter = input.value.toUpperCase();
            table = document.getElementById("dataTableProf");
            tr = table.querySelectorAll("tbody tr");

            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[0]; // Colonne du nom du professeur (ajustez l'index en fonction de votre structure)
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
        function downloadTableProfAsExcel() {
            var table = document.getElementById("dataTableProf").cloneNode(true); // Cloner le tableau
            var rows = table.rows;

            // Parcourir chaque ligne pour supprimer la dernière cellule (Action)
            for (var i = 0; i < rows.length; i++) {
                rows[i].deleteCell(-1); // Supprime la dernière cellule de chaque ligne
            }

            var workbook = XLSX.utils.table_to_book(table, { sheet: "Liste Professeur" });
            XLSX.writeFile(workbook, 'Liste_Professeur.xlsx');
        }
    </script>
</head>
<body>
<div class="container mt-4">
    <div class="row">
        <div class="col-12 mb-3">
            <a href="dashboard_admin.jsp" class="btn btn-home">Retour au Dashboard</a>
        </div>
        <div class="mb-3">
        <input type="text" id="searchInputProfesseur" onkeyup="searchTableProfesseur()" placeholder="Rechercher un professeur...">
        </div>
        <div class="mb-3">
            <button onclick="downloadTableProfAsExcel()" class="btn btn-primary">Télécharger en Excel</button>
        </div>
        <div class="col-12">
            <div class="main-box">
                <div class="table-responsive" >
                    <table class="table align-middle" id="dataTableProf">
                        <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Age</th>
                            <th>Date De Naissance</th>
                            <th>Numero de Telephone</th>
                            <th>Sexe</th>
                            <th>Email</th>
                            <th>Niveau</th>
                            <th>Cours</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/EduCare";
        String username = "root";
        String password = "";
        conn = DriverManager.getConnection(url, username, password);

        String sql = "SELECT * FROM professeur";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while(rs.next()) {
            int idProf = rs.getInt("id_prof");
            String niveaux = "";
            String cours = "";

            // Requête pour obtenir les noms des niveaux associés au professeur
            String sqlNiveaux = "SELECT n.niveau FROM prof_niveau pn JOIN niveau n ON pn.id_niveau = n.id_niveau WHERE pn.id_prof = ?";
            try (PreparedStatement pstmtNiveaux = conn.prepareStatement(sqlNiveaux)) {
                pstmtNiveaux.setInt(1, idProf);
                try (ResultSet rsNiveaux = pstmtNiveaux.executeQuery()) {
                    while (rsNiveaux.next()) {
                        String nomNiveau = rsNiveaux.getString("niveau");
                        niveaux += nomNiveau + ", "; // Concaténer les noms des niveaux
                    }
                }
            }

            // Requête pour obtenir les cours associés au professeur
            String sqlCours = "SELECT * FROM cours WHERE id_prof = ?";
            try (PreparedStatement pstmtCours = conn.prepareStatement(sqlCours)) {
                pstmtCours.setInt(1, idProf);
                try (ResultSet rsCours = pstmtCours.executeQuery()) {
                    while (rsCours.next()) {
                        String nomCours = rsCours.getString("cours");
                        cours += nomCours + ", "; // Concaténer les noms des cours
                    }
                }
            }

%>
                        <tr>
                            <td><%= rs.getString("nom") %></td>
                            <td><%= rs.getString("prenom") %></td>
                            <td><%= rs.getInt("age") %></td>
                            <td><%= rs.getDate("date_de_naissance") %></td>
                            <td><%= rs.getString("numero_telephone") %></td>
                            <td><%= rs.getString("sexe") %></td>
                            <td><%= rs.getString("email") %></td>
                            <td><%= niveaux %></td>
                            <td><%= cours %></td>
                            <td>
                                <a href="supprimerProfesseurServlet?id=<%= rs.getInt("id_prof") %>" class="btn btn-danger">Supprimer</a>
                            </td>
                        </tr>
                        <%
                                }
                            } catch(Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <div class="col-12 mb-3">
                    <a href="creerProfesseur.jsp" class="btn btn-success">Créer un nouveau professeur</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>