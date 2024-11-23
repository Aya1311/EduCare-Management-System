<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Créer Nouveau Étudiant</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Roboto:ital,wght@0,400;0,500;1,400&display=swap" rel="stylesheet">
    <style>
        /* General Styles */
        body {
            font-family: 'Roboto', sans-serif;
            color: #333;
            background-color: #f4f4f4;
            line-height: 1.6;
        }

        .wrapper {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        /* Typography */
        h3 {
            font-family: 'Playfair Display', serif;
            color: #2a2a72;
            margin-bottom: 20px;
        }

        /* Form Styling */
        form {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        input[type="text"],
        input[type="date"],
        input[type="password"],
        textarea,
        select {
            width: 100%;
            padding: 8px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        input[type="submit"],
        input[type="reset"] {
            background: #2a2a72;
            color: #ffffff;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover,
        input[type="reset"]:hover {
            background-color: #43458b;
        }

        /* Accessibility Improvements */
        a:focus,
        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #2a2a72;
            box-shadow: 0 0 5px rgba(42, 42, 114, 0.5);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            form {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<body>
<div class="wrapper">
    <h3>Créer Nouveau Étudiant</h3>
    <form action="CreerEtudiant" method="post">
        <input type="hidden" name="idSecretaire" value="<%= request.getParameter("secretaireId") %>">

        <div>
            <label for="nom">Nom</label>
            <input type="text" name="nom" id="nom" maxlength="30" required>
        </div>

        <div>
            <label for="prenom">Prénom</label>
            <input type="text" name="prenom" id="prenom" maxlength="30" required>
        </div>

        <div>
            <label for="datedenaissance">Date de naissance</label>
            <input type="date" name="datedenaissance" id="datedenaissance" required>
        </div>

        <div>
            <label for="email">EMAIL</label>
            <input type="text" name="email" id="email" maxlength="100" required>
        </div>

        <div>
            <label for="motdepasse">Mot De Passe</label>
            <input type="password" name="motdepasse" id="motdepasse" maxlength="10" required>
        </div>

        <div>
            <label>Sexe</label>
            Homme <input type="radio" name="sexe" value="Homme">
            Femme <input type="radio" name="sexe" value="Femme">
        </div>

        <div>
            <label for="adresse">Adresse</label>
            <textarea name="adresse" id="adresse" rows="4" required></textarea>
        </div>

        <div>
            <label for="telephone">Téléphone</label>
            <input type="text" name="telephone" id="telephone" maxlength="20" required>
        </div>

        <div>
            <label for="filiereSelect">Filière</label>
            <select id="filiereSelect" name="filiereId">
                <%
                    String idSecretaire = request.getParameter("secretaireId");
                    List<String[]> filieres = new ArrayList<>(); // Utilize an array to store the ID and the name of the filiere
                    int idNiveau = -1; // Initialize with a default value or appropriate default

                    // Paramètres de connexion à la base de données
                    String url = "jdbc:mysql://localhost:3306/EduCare";
                    String user = "root";
                    String password = "";
                    String query = "SELECT f.id_filiere, f.nom_filiere, s.id_niveau FROM filiere f JOIN secretaire s ON f.id_niveau = s.id_niveau WHERE s.id_secretaire = ?";

                    try (Connection conn = DriverManager.getConnection(url, user, password);
                         PreparedStatement pstmt = conn.prepareStatement(query)) {

                        pstmt.setString(1, idSecretaire);
                        try (ResultSet rs = pstmt.executeQuery()) {
                            while (rs.next()) {
                                String[] filiereData = {rs.getString("id_filiere"), rs.getString("nom_filiere")};
                                filieres.add(filiereData);
                                idNiveau = rs.getInt("id_niveau");
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace(); // Gestion des exceptions
                    }

                    for (String[] filiere : filieres) {
                %>
                <option value="<%= filiere[0] %>"><%= filiere[1] %></option>
                <%
                    }
                %>
            </select>
            <input type="hidden" name="idNiveau" value="<%= idNiveau %>">
        </div>

        <div>
            <label for="statut">Statut</label>
            <select name="statut" id="statut" required>
                <option value="Payé">Payé</option>
                <option value="Impayé">Impayé</option>
            </select>
        </div>

        <div style="grid-column: span 2; text-align: center;">
            <input type="submit" value="Submit">
            <input type="reset" value="Reset">
        </div>
    </form>
</div>
</body>
</html>
