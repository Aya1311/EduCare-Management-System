<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Créer un Nouveau Secrétaire</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
        }
        .container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            margin: 0 auto;
        }
        h2 {
            color: #333;
            font-size: 24px;
            text-align: center;
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: bold;
            color: #444;
        }
        .form-control, .form-select {
            font-size: 16px;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
            border: 1px solid #ddd;
            width: 100%;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <h2>Créer un Nouveau Secrétaire</h2>
    <form action="traitementCreerSecretaire" method="post">
        <div class="mb-3">
            <label for="nom" class="form-label">Nom</label>
            <input type="text" class="form-control" id="nom" name="nom" required>
        </div>
        <div class="mb-3">
            <label for="prenom" class="form-label">Prénom</label>
            <input type="text" class="form-control" id="prenom" name="prenom" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="mb-3">
            <label for="motdepasse" class="form-label">Mot de Passe</label>
            <input type="password" class="form-control" id="motdepasse" name="motdepasse" required>
        </div>
        <div class="mb-3">
            <label for="niveau" class="form-label">Niveau</label>
            <select class="form-select" id="niveau" name="niveau">
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rsNiveaux = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
                        stmt = conn.createStatement();
                        String queryNiveaux = "SELECT * FROM niveau";
                        rsNiveaux = stmt.executeQuery(queryNiveaux);

                        while(rsNiveaux.next()) {
                %>
                <option value="<%= rsNiveaux.getInt("id_niveau") %>"><%= rsNiveaux.getString("niveau") %></option>
                <%
                        }
                    } catch(SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Créer</button>
    </form>
</div>
</body>
</html>