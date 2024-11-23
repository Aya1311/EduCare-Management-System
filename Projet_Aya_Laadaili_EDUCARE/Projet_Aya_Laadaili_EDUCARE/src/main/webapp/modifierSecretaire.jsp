<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Modifier Secrétaire</title>
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
<%
    String secretaireId = request.getParameter("id");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String nom = "", prenom = "", email = "", motdepasse = "";
    int niveauId = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
        pstmt = conn.prepareStatement("SELECT * FROM secretaire WHERE id_secretaire = ?");
        pstmt.setInt(1, Integer.parseInt(secretaireId));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            nom = rs.getString("nom");
            prenom = rs.getString("prenom");
            email = rs.getString("email");
            motdepasse = rs.getString("motdepasse");
            niveauId = rs.getInt("id_niveau");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<div class="container mt-4">
    <h2>Modifier Secrétaire</h2>
    <form action="TraitementModifierSecretaire" method="post">
        <input type="hidden" name="id_secretaire" value="<%= secretaireId %>">
        <div class="mb-3">
            <label for="nom" class="form-label">Nom</label>
            <input type="text" class="form-control" id="nom" name="nom" required value="<%= nom %>">
        </div>
        <div class="mb-3">
            <label for="prenom" class="form-label">Prénom</label>
            <input type="text" class="form-control" id="prenom" name="prenom" required value="<%= prenom %>">
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required value="<%= email %>">
        </div>
        <div class="mb-3">
            <label for="motdepasse" class="form-label">Mot de Passe</label>
            <input type="password" class="form-control" id="motdepasse" name="motdepasse" required value="<%= motdepasse %>">
        </div>
        <div class="mb-3">
            <label for="niveau" class="form-label">Niveau</label>
            <select class="form-select" id="niveau" name="niveau">
                <%
                    try {
                        PreparedStatement pstmtNiveau = conn.prepareStatement("SELECT * FROM niveau");
                        ResultSet rsNiveau = pstmtNiveau.executeQuery();
                        while (rsNiveau.next()) {
                            int idNiveau = rsNiveau.getInt("id_niveau");
                            String niveau = rsNiveau.getString("niveau");
                            String selected = (idNiveau == niveauId) ? " selected" : "";
                %>
                <option value="<%= idNiveau %>"<%= selected %>><%= niveau %></option>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Modifier</button>
    </form>
</div>
</body>
</html>
