<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>ADMINISTRATION EduCare Hub</title>
    <link href="css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">
    <link href="css/sb-admin-2.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.2/xlsx.full.min.js"></script>
    <script>
        var niveaux = [
                <%
        String queryNivea = "SELECT id_niveau, niveau FROM niveau";
        PreparedStatement stm;
        Connection co= DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");;
        stm = co.prepareStatement(queryNivea);
        ResultSet rsNivea = stm.executeQuery();
        while (rsNivea.next()) {
            %>{ id: <%=rsNivea.getInt("id_niveau")%>, name: "<%=rsNivea.getString("niveau")%>" },<%
                }
                rsNivea.close();
                stm.close();
                %>
        ];
        function searchTable() {
            var input, filter, table, tr, td, i, txtValue;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.getElementById("dataTable");
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
        function createFiliere() {
            var filiereName = prompt("Entrez le nom de la nouvelle filière:");
            if (filiereName != null && filiereName != "") {
                var niveauOptions = niveaux.map(niveau => niveau.id + ": " + niveau.name).join("\n");
                var niveauId = prompt("Choisissez un niveau pour cette filière:\n" + niveauOptions);

                // AJAX request to send data to the server
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        alert("Filière créée avec succès!");
                        location.reload(); // Reload the page to update the list
                    }
                };
                xhttp.open("POST", "CreateFiliereServlet", true);
                xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhttp.send("filiereName=" + filiereName + "&niveauId=" + niveauId);
            }
        }
        function createNiveau() {
            var niveauName = prompt("Entrez le nom du nouveau niveau:");
            if (niveauName != null && niveauName != "") {
                // AJAX request to send data to the server
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        // Handle response here
                        alert("Niveau créé avec succès!");
                        location.reload(); // Reload the page to update the list
                    }
                };
                xhttp.open("POST", "CreateNiveauServlet", true);
                xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhttp.send("niveauName=" + niveauName);
            }
        }
        function loadReceivers() {
            var role = document.getElementById('roleSelect').value;
            var receiverSelect = document.getElementById('receiverSelect');
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    receiverSelect.innerHTML = this.responseText;
                }
            };
            xhttp.open("GET", "GetReceiversServlet?role=" + role, true);
            xhttp.send();
        }
         function downloadTableFiliereAsExcel() {
            var table = document.getElementById("dataTable").cloneNode(true); // Cloner le tableau
            var rows = table.rows;

            for (var i = 0; i < rows.length; i++) {
                rows[i].deleteCell(-1); // Supprime la dernière cellule de chaque ligne (Actions)
            }

            var workbook = XLSX.utils.table_to_book(table, { sheet: "Liste Filiere" });
            XLSX.writeFile(workbook, 'Liste_Filiere.xlsx');
        }

        function downloadTableNiveauAsExcel() {
            var table = document.getElementById("dataTabl").cloneNode(true); // Cloner le tableau
            var rows = table.rows;

            // Parcourir chaque ligne pour supprimer la dernière cellule (Actions)
            for (var i = 0; i < rows.length; i++) {
                rows[i].deleteCell(-1); // Supprime la dernière cellule de chaque ligne
            }

            var workbook = XLSX.utils.table_to_book(table, { sheet: "Liste_Niveaux" });
            XLSX.writeFile(workbook, 'Liste_Niveaux.xlsx');
        }

    </script>
    <style>
        .btn-primary {
            background-color: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            color: white;
        }
        .messaging-section {
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        padding: 20px;
        margin-top: 20px;
        border-radius: 5px;
    }

    .messaging-section label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }

    .messaging-section select,
    .messaging-section textarea {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box; /* Makes sure padding doesn't affect overall width */
    }

    .messaging-section textarea {
        height: 100px;
        resize: vertical; /* Allows the user to vertically resize the textarea (not horizontally) */
    }

    .messaging-section button {
        background-color: #4e73df;
        color: white;
        padding: 10px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
    }

    .messaging-section button:hover {
        background-color: #2e59d9;
    }
    /* Responsive adjustments */
    @media (max-width: 768px) {
        .messaging-section {
            padding: 10px;
        }
    }
        message-section {
            background-color: #fff;
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
            background-color: #f8f9fc;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            border-left: 4px solid #4e73df;
        }

        .message-content {
            font-size: 1rem;
            color: #5a5c69;
            margin-bottom: 10px;
        }

        .message-actions {
            text-align: right;
        }

        .message-actions form {
            display: inline;
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
        }
    </style>
</head>

<body id="page-top">
    <div id="wrapper">
        <%
                String prenomAdmin = "";
                String nomAdmin = "";
                int total_etudiant = 0;
                int totale_prof = 0;
                int totale_cours = 0;
                int totale_filiere = 0;
                co = null;
                ResultSet A = null;
                ResultSet TE = null;
                ResultSet TF = null;
                ResultSet TC = null;
                ResultSet TP = null;
                try {
                    co = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                    String AdminQuery = "SELECT * FROM admin ";
                    stm = co.prepareStatement(AdminQuery);
                    A = stm.executeQuery();
                    if (A.next()) {
                        prenomAdmin = A.getString("prenom");
                        nomAdmin = A.getString("nom");
                    }
                    A.close();
                    stm.close();
                    // Count Etudiant
                    String etudiantQuery = "SELECT COUNT(*) AS total_etudiant FROM etudiant";
                    stm = co.prepareStatement(etudiantQuery);
                    TE = stm.executeQuery();
                    if (TE.next()) {
                        total_etudiant = TE.getInt(1);
                    }
                    TE.close();
                    stm.close();
                    // Count Professeur
                    String profQuery = "SELECT COUNT(*) AS total_prof FROM professeur";
                    stm = co.prepareStatement(profQuery);
                    TP = stm.executeQuery();
                    if (TP.next()) {
                        totale_prof = TP.getInt(1);
                    }
                    TP.close();
                    stm.close();

                    // Count Cours
                    String coursQuery = "SELECT COUNT(*) AS total_cours FROM cours";
                    stm = co.prepareStatement(coursQuery);
                    TC = stm.executeQuery();
                    if (TC.next()) {
                        totale_cours = TC.getInt(1);
                    }
                    TC.close();
                    stm.close();

                    // Count Filiere
                    String filiereQuery = "SELECT COUNT(*) AS total_filiere FROM filiere";
                    stm = co.prepareStatement(filiereQuery);
                    TF = stm.executeQuery();
                    if (TF.next()) {
                        totale_filiere = TF.getInt(1);
                    }
                    TF.close();
                    stm.close();

                    %>
        <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">
            <hr class="sidebar-divider my-0">
            <li class="nav-item active">
                <a class="nav-link" href="dashboard_admin.jsp">
                    <i class="fas fa-fw fa-tachometer-alt"></i>
                    <span>Administration <%=nomAdmin%> <%=prenomAdmin%></span></a>
            </li>
            <hr class="sidebar-divider">
            <div class="sidebar-heading">
                Visualisation
            </div>
            <li class="nav-item">
                <a class="nav-link collapsed" href="list_etudiant.jsp" data-toggle="collapse" data-target="#collapseTwo"
                    aria-expanded="true" >
                    <i class="fas fa-fw fa-cog"></i>
                    <span>Etudiant</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link collapsed" href="list_cours.jsp" data-toggle="collapse" data-target="#collapseUtilities"
                    aria-expanded="true" >
                    <i class="fas fa-fw fa-wrench"></i>
                    <span>Cours</span>
                </a>
            </li>
            <hr class="sidebar-divider">
            <div class="sidebar-heading">
                Gestion
            </div>
            <li class="nav-item">
                <a class="nav-link" href="list_secretaire.jsp">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>Secretaire</span></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="liste_prof_admin.jsp">
                    <i class="fas fa-fw fa-table"></i>
                    <span>Professeur</span></a>
            </li>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" data-toggle="modal" data-target="#logoutModal" href="login.jsp">
                <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                Logout
            </a>
            <hr class="sidebar-divider d-none d-md-block">

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
                                <span class="mr-2 d-none d-lg-inline text-gray-600 small" href=""></span>
                                <img class="img-profile rounded-circle"
                                     src="img/sf.svg">
                            </a>
                            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                 aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="">
                                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Profile
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal" href="login.jsp">
                                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Logout
                                </a>
                            </div>
                        </li>
                    </ul>
                </nav>
                <div class="container-fluid">

                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                    <h1 class="h3 mb-0 text-gray-800">Gestion des Niveaux et Filières</h1>
                </div>
                <div class="row">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-primary shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                Nombre Totale d'Etudiants du centre</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"><%=total_etudiant%></div>
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
                                                Nombre Totale des Professeurs</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"><%=totale_prof%></div>
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
                                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Nombre Totale De Cours
                                            </div>
                                            <div class="row no-gutters align-items-center">
                                                <div class="col-auto">
                                                    <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">
                                                        <%=totale_cours%></div>
                                                </div>

                                            </div>
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
                                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                                Nombre Totale de filieres</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"><%=totale_filiere%></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-comments fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        <div class="col-xl-12 col-lg-7">
                            <div class="card shadow mb-4">
                                <div
                                    class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">Liste Filiere</h6>
                                    </div>
                                <div class="card-body">
                                        <div class="table-responsive">
                                            <div class="mb-3">
                                                <input type="text" id="searchInput" onkeyup="searchTable()" placeholder="Recherche dans la filière..." class="form-control">
                                            </div>
                                            <div class="mb-3">
                                                <button onclick="createFiliere()" class="btn btn-success btn-sm">Ajouter Nouvelle Filière</button>
                                                <button onclick="downloadTableFiliereAsExcel()" class="btn btn-primary btn-sm">Télécharger en Excel</button>
                                            </div>
                                            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                                                <thead>
                                                 <tr>
                                                    <th>Nom Filiere</th>
                                                    <th>Nombre d'Etudiants</th>
                                                    <th>Niveau</th>
                                                    <th>Nombre de Professeurs</th>
                                                    <th>Nombre de Cours</th>
                                                    <th>Actions</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <%
                                                    try {
                                                        String queryFilier = "SELECT f.nom_filiere, f.id_filiere, n.niveau FROM filiere f JOIN niveau n ON f.id_niveau = n.id_niveau";
                                                        stm = co.prepareStatement(queryFilier);
                                                        ResultSet rsFilier = stm.executeQuery();
                                                        while (rsFilier.next()) {
                                                            String nomFiliere = rsFilier.getString("nom_filiere");
                                                            int idFiliere = rsFilier.getInt("id_filiere");
                                                            String niveau = rsFilier.getString("niveau");

                                                            // Compter les étudiants dans cette filière
                                                            String queryEtudiant = "SELECT COUNT(*) FROM etudiant WHERE id_filiere = ?";
                                                            PreparedStatement stmEtudiant = co.prepareStatement(queryEtudiant);
                                                            stmEtudiant.setInt(1, idFiliere);
                                                            ResultSet rsEtudiant = stmEtudiant.executeQuery();
                                                            rsEtudiant.next();
                                                            int totalEtudiants = rsEtudiant.getInt(1);

                                                            // Compter les cours dans cette filière
                                                            String queryCours = "SELECT COUNT(*) FROM filiere_cours WHERE id_filiere = ?";
                                                            PreparedStatement stmCours = co.prepareStatement(queryCours);
                                                            stmCours.setInt(1, idFiliere);
                                                            ResultSet rsCours = stmCours.executeQuery();
                                                            rsCours.next();
                                                            int totalCours = rsCours.getInt(1);

                                                            String queryProf = "SELECT COUNT(DISTINCT p.id_prof) AS total_profs " +
                                                                    "FROM professeur p " +
                                                                    "JOIN cours c ON p.id_prof = c.id_prof " +
                                                                    "JOIN filiere_cours fc ON c.id_cours = fc.id_cours " +
                                                                    "WHERE fc.id_filiere = ?";
                                                            PreparedStatement stmProf = co.prepareStatement(queryProf);
                                                            stmProf.setInt(1, idFiliere);
                                                            ResultSet rsProf = stmProf.executeQuery();
                                                            int totalProfs = 0;
                                                            if (rsProf.next()) {
                                                                totalProfs = rsProf.getInt("total_profs");
                                                            }
                                                %>
                                                <tr>
                                                    <td><%=nomFiliere%></td>
                                                    <td><%=totalEtudiants%></td>
                                                    <td><%=niveau%></td>
                                                    <td><%=totalProfs%></td>
                                                    <td><%=totalCours%></td>
                                                    <td>
                                                        <a href="DeleteFiliere?idFiliere=<%=idFiliere%>" class="btn btn-danger btn-sm">Supprimer</a>
                                                    </td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                                </tbody>
                                            </table>
                                        </div>
                                </div>
                            </div>
                        </div>
                        <!-- Pie Chart -->
                        <div class="col-xl-12 col-lg-7">
                            <div class="card shadow mb-4">
                                <div class="col-xl-12 col-lg-7">
                                    <div class="card shadow mb-4">
                                        <div
                                                class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                            <h6 class="m-0 font-weight-bold text-primary">Liste Niveaux</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <div class="mb-3">
                                                    <button onclick="createNiveau()" class="btn btn-success btn-sm">Ajouter Nouveau Niveau</button>
                                                    <button onclick="downloadTableNiveauAsExcel()" class="btn btn-primary btn-sm">Télécharger en Excel</button>
                                                </div>
                                                <table class="table table-bordered" id="dataTabl" width="100%" cellspacing="0">
                                                    <thead>
                                                    <tr>
                                                        <th>Nom Niveau</th>
                                                        <th>Totale Filiere</th>
                                                        <th>Totale Etudiant</th>
                                                        <th>Totale Professeurs</th>
                                                        <th>Totale Cours</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                    </thead>
                                            <tbody>
                                            <%
                                                try {
                                                    String queryNiveau = "SELECT n.id_niveau, n.niveau FROM niveau n";
                                                    stm = co.prepareStatement(queryNiveau);
                                                    ResultSet rsNiveau = stm.executeQuery();

                                                    while (rsNiveau.next()) {
                                                        String nomNiveau = rsNiveau.getString("niveau");
                                                        int idNiveau = rsNiveau.getInt("id_niveau");

                                                        // Count the number of filières for this niveau
                                                        String queryFilie = "SELECT COUNT(*) FROM filiere WHERE id_niveau = ?";
                                                        PreparedStatement stmFilie = co.prepareStatement(queryFilie);
                                                        stmFilie.setInt(1, idNiveau);
                                                        ResultSet rsFilie = stmFilie.executeQuery();
                                                        rsFilie.next();
                                                        int Filier = rsFilie.getInt(1);
                                                        rsFilie.close();
                                                        stmFilie.close();

                                                        // Count the number of students in this niveau
                                                        String queryEtudiant = "SELECT COUNT(*) FROM etudiant WHERE id_niveau = ?";
                                                        PreparedStatement stmEtudiant = co.prepareStatement(queryEtudiant);
                                                        stmEtudiant.setInt(1, idNiveau);
                                                        ResultSet rsEtudiant = stmEtudiant.executeQuery();
                                                        rsEtudiant.next();
                                                        int totalEtudiant = rsEtudiant.getInt(1);
                                                        rsEtudiant.close();
                                                        stmEtudiant.close();

                                                        // Count the number of courses for this niveau
                                                        String queryCours = "SELECT COUNT(*) FROM cours WHERE id_niveau = ?";
                                                        PreparedStatement stmCours = co.prepareStatement(queryCours);
                                                        stmCours.setInt(1, idNiveau);
                                                        ResultSet rsCours = stmCours.executeQuery();
                                                        rsCours.next();
                                                        int totalCour = rsCours.getInt(1);
                                                        rsCours.close();
                                                        stmCours.close();

                                                        // Count the number of professors associated with this niveau
                                                        String queryProf = "SELECT COUNT(*) FROM prof_niveau WHERE id_niveau = ?";
                                                        PreparedStatement stmProf = co.prepareStatement(queryProf);
                                                        stmProf.setInt(1, idNiveau);
                                                        ResultSet rsProf = stmProf.executeQuery();
                                                        int totalProf = 0;
                                                        if (rsProf.next()) {
                                                            totalProf = rsProf.getInt(1);
                                                        }
                                                        rsProf.close();
                                                        stmProf.close();

                                            %>
                                            <!-- Affichage des données dans le tableau -->
                                            <tr>
                                                <td><%=nomNiveau%></td>
                                                <td><%=Filier%></td>
                                                <td><%=totalEtudiant%></td>
                                                <td><%=totalProf%></td>
                                                <td><%=totalCour%></td>
                                                <td>
                                                    <a href="DeleteNiveau?idNiveau=<%=idNiveau%>" class="btn btn-danger btn-sm">Supprimer</a>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                            </tbody>
                                        </table>
                                </div>
                                </div>
                        </div>
                        </div>
                    </div>
            </div>
                    <div class="messaging-section">
                        <form action="SendMessageServlet" method="post">
                            <label for="roleSelect">Choisir le rôle:</label>
                            <select id="roleSelect" name="role" onchange="loadReceivers()">
                                <option value="etudiant">Étudiant</option>
                                <option value="professeur">Professeur</option>
                                <option value="secretaire">Secrétaire</option>
                            </select>
                            <label for="receiverSelect">Choisir le récepteur:</label>
                            <select id="receiverSelect" name="receiver"></select>

                            <label for="messageBox">Message:</label>
                            <textarea id="messageBox" name="message"></textarea>

                            <button type="submit">Envoyer</button>
                        </form>
                    </div>
                    <div class="row">
                        <div class="col-lg-12">
                            <!-- Messages Reçus des Secrétaire -->
                            <div class="message-section">
                                <h4>Messages Reçus des Secrétaire</h4>
                                <%
                                    String queryMessagesSec = "SELECT m.message, m.id_message FROM message m "
                                            + "JOIN msg_rcp_emt mre ON m.id_rcp_emt = mre.id_rcp_emt "
                                            + "WHERE mre.id_log_emetteur = 1";
                                    stm = co.prepareStatement(queryMessagesSec);
                                    ResultSet rsMessagesSec = stm.executeQuery();

                                    while (rsMessagesSec.next()) {
                                        String message = rsMessagesSec.getString("message");
                                        int idMessage = rsMessagesSec.getInt("id_message");
                                        // Affichage des messages
                                %>
                                <div class="message-item">
                                    <div class="message-content"><%= message %></div>
                                    <div class="message-actions">
                                        <form action="DeleteMessageAdServlet" method="post">
                                            <input type="hidden" name="messageId" value="<%= idMessage %>">
                                            <button type="submit" class="btn btn-danger">Supprimer</button>
                                        </form>
                                    </div>
                                </div>
                                <%
                                    }
                                    rsMessagesSec.close();
                                %>
                            </div>
                            <!-- Réclamations des Étudiants -->
                            <div class="message-section">
                                <h4>Réclamations des Étudiants</h4>
                                <%
                                    String queryReclamations = "SELECT m.message, m.id_message FROM message m "
                                            + "JOIN msg_rcp_emt mre ON m.id_rcp_emt = mre.id_rcp_emt "
                                            + "WHERE mre.id_log_emetteur = 2";
                                    stm = co.prepareStatement(queryReclamations);
                                    ResultSet rsReclamations = stm.executeQuery();

                                    while (rsReclamations.next()) {
                                        String reclamation = rsReclamations.getString("message");
                                        int idMessage = rsReclamations.getInt("id_message");
                                %>
                                <div class="message-item">
                                    <div class="message-content"><%= reclamation %></div>
                                    <div class="message-actions">
                                        <form action="DeleteMessageAdServlet" method="post">
                                            <input type="hidden" name="messageId" value="<%= idMessage %>">
                                            <button type="submit" class="btn btn-danger">Supprimer</button>
                                        </form>
                                    </div>
                                </div>
                                <%
                                    }
                                    rsReclamations.close();
                                %>
                            </div>
                        </div>
                    </div>

                    <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->
    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>

    <!-- Bootstrap core JavaScript-->
    <script src="jquery/jquery.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="query/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="js/sb-admin-2.min.js"></script>

    <!-- Page level plugins -->
    <script src="js/Chart.min.js"></script>

    <!-- Page level custom scripts -->
    <script src="js/demo/chart-area-demo.js"></script>
    <script src="js/demo/chart-pie-demo.js"></script>
                <%
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (co != null) try {
                                co.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        %>
                <%
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (co != null) try {
                            co.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    %>
                <%
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (co != null) try {
                        co.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                %>
</body>
<footer class="sticky-footer bg-white">
    <div class="container my-auto">
        <div class="copyright text-center my-auto">
            <span>Copyright &copy; EduCare Hub 2023</span>
        </div>
    </div>
</footer>
</html>
