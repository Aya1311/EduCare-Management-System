<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Liste Etudiant</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style type="text/css">
        body {
            background: #f5f5f5;
            font-family: 'Arial', sans-serif;
        }
        .main-box {
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-radius: 5px;
            margin-bottom: 20px;
            padding: 20px;
        }
        .table thead th {
            background-color: #007bff;
            color: white;
        }
        .btn-home {
            background-color: #007bff;
            color: white;
        }
        .btn-home:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<%
    String idEtudiantParam = request.getParameter("studentId");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");

        String sql = "SELECT e2.nom, e2.prenom, e2.adresse, e2.telephone FROM etudiant AS e1 JOIN etudiant AS e2 ON e1.id_niveau = e2.id_niveau WHERE e1.id_etudiant = ? AND e2.id_etudiant != ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, idEtudiantParam);
        pstmt.setString(2, idEtudiantParam);
        rs = pstmt.executeQuery();
%>

<div class="container mt-4">
    <div class="row">
        <div class="col-12 mb-3">
            <a href=dashboard_s.jsp?studentId=<%= idEtudiantParam %>"" class="btn btn-home">Retour au Dashboard </a>
        </div>
        <div class="col-12">
            <div class="main-box">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Adresse</th>
                            <th>Téléphone</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tbody>
                        <%
                            while(rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getString("nom") %></td>
                            <td><%= rs.getString("prenom") %></td>
                            <td><%= rs.getString("adresse") %></td>
                            <td><%= rs.getString("telephone") %></td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <%
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>