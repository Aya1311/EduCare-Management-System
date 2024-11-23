<%@ page import="java.sql.*, javax.sql.*, java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Liste Étudiants</title>
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
            background-color: #e3e3e3;
            color: #333;
        }
        .btn-home, .btn-present, .btn-absent {
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 14px;
        }
        .btn-home {
            background-color: #007bff;
            color: white;
            display: block;
            margin: 20px auto 0;
            text-align: center;
        }
        .btn-home:hover {
            background-color: #0056b3;
        }
        .btn-absent {
            background-color: #d9534f;
            color: white;
        }
        .btn-present {
            background-color: #5cb85c;
            color: white;
        }
        h3 {
            color: #007bff;
            margin-bottom: 15px;
        }
        .date-display {
            font-weight: bold;
            text-align: center;
            margin: 20px 0;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function togglePresence(button, courseId) {
            var studentId = button.getAttribute('data-student-id');
            var currentState = button.getAttribute('data-current-state');
            var newState = currentState === '1' ? '0' : '1';

            $.post('UpdateAbsenceStatusServlet', {id: studentId, state: newState, courseId: courseId}, function(response) {
                if (response.trim() === 'success') {
                    // Mise à jour de l'état du bouton
                    if (newState === '1') {
                        button.innerHTML = 'Absent';
                        button.className = 'btn btn-absent';
                    } else {
                        button.innerHTML = 'Présent';
                        button.className = 'btn btn-present';
                    }
                    button.setAttribute('data-current-state', newState);
                } else {
                    alert('La mise à jour a échoué.');
                }
            });
        }
    </script>
</head>
<body>
<%
    String idProf = request.getParameter("profId");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rsCours = null;
    ResultSet rsEtudiants = null;
    Date date = new Date();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
        String sqlCours = "SELECT id_cours, cours FROM cours WHERE id_prof = ?";
        pstmt = conn.prepareStatement(sqlCours);
        pstmt.setString(1, idProf);
        rsCours = pstmt.executeQuery();
%>
<div class="container mt-4">
    <p class="date-display">Date: <%= date.toString() %></p>

    <div class="row">
        <%
            while (rsCours.next()) {
                String nomCours = rsCours.getString("cours");
                String idCours = rsCours.getString("id_cours");

                String sqlEtudiants = "SELECT e.id_etudiant, e.nom, e.prenom, e.adresse, e.telephone, IFNULL((SELECT absence FROM absence WHERE id_etudiant = e.id_etudiant AND id_cours = ? AND date_click = CURDATE()), -1) AS absence FROM etudiant e JOIN etu_cours ec ON e.id_etudiant = ec.id_etudiant WHERE ec.id_cours = ?";
                pstmt = conn.prepareStatement(sqlEtudiants);
                pstmt.setString(1, idCours);
                pstmt.setString(2, idCours);
                rsEtudiants = pstmt.executeQuery();
        %>
        <div class="col-12 mb-4">
            <h3><%= nomCours %></h3>
            <div class="main-box">
                <div class="table-responsive">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Adresse</th>
                                <th>Téléphone</th>
                                <th>Absence</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                while(rsEtudiants.next()) {
                                    int absence = rsEtudiants.getInt("absence");
                                    String buttonLabel, buttonClass;
                                    if (absence == 0) {
                                        buttonLabel = "Absent";
                                        buttonClass = "btn btn-absent";
                                    } else {
                                        buttonLabel = "Présent";
                                        buttonClass = "btn btn-present";
                                    }
                            %>
                            <tr>
                                <td><%= rsEtudiants.getString("nom") %></td>
                                <td><%= rsEtudiants.getString("prenom") %></td>
                                <td><%= rsEtudiants.getString("adresse") %></td>
                                <td><%= rsEtudiants.getString("telephone") %></td>
                                <td>
                                    <button class="<%= buttonClass %>"
                                            onclick="togglePresence(this, '<%= idCours %>')"
                                            data-student-id="<%= rsEtudiants.getString("id_etudiant") %>"
                                            data-current-state="<%= absence == 0 ? 1 : 0 %>">
                                        <%= buttonLabel %>
                                    </button>
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

        <%
            }
        %>
    </div>

    <a href="dashboard_prof.jsp?profId=<%= idProf %>" class="btn btn-home">Retour au Tableau De Bord </a>

    <%
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (rsCours != null) try { rsCours.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (rsEtudiants != null) try { rsEtudiants.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>