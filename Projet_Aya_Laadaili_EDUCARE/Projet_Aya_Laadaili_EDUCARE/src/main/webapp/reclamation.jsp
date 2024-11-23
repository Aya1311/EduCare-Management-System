<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Reclamation - EduCare</title>
  <link href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }

    .reclamation-container {
      background-color: white;
      width: 50%;
      margin: 5% auto;
      padding: 20px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      border-radius: 8px;
    }

    .form-group label {
      font-weight: bold;
    }

    .btn-submit {
      background-color: #0056b3;
      color: white;
      border-radius: 4px;
      padding: 10px 20px;
      border: none;
      cursor: pointer;
      display: block;
      width: 100%;
    }

    .btn-submit:hover {
      background-color: #003d82;
    }
  </style>
  <script>
    function redirectToDashboard() {
      var urlParams = new URLSearchParams(window.location.search);
      var studentId = urlParams.get('studentId');
      window.location.href = 'dashboard_s.jsp?studentId=' + studentId;
    }
  </script>
</head>
<body>
<div class="reclamation-container">
  <h2 class="text-center">Formulaire de Reclamation</h2>
  <form action="SendReclaServlet" method="post">
    <input type="hidden" name="idEtudiant" value="<%= request.getParameter("studentId") %>">
    <div class="form-group">
      <label for="message">Votre Message :</label>
      <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
    </div>
    <button type="submit" class="btn btn-submit">Envoyer</button>
  </form>
</div>
<button onclick="redirectToDashboard()" class="btn btn-primary">Retour au Dashboard</button>
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
</body>
</html>
