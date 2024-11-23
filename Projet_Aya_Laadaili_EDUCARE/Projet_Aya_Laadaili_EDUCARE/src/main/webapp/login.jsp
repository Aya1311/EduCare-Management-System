<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="fonts/icomoon/style.css">
    <link rel="stylesheet" href="css/owl.carousel.min.css">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <!-- Style -->
    <link rel="stylesheet" href="css/style.css">
    <title>Login EduCare</title>
</head>
<body>
<div class="d-lg-flex half">
    <div class="bg order-1 order-md-2" style="background-image: url('img/logo.png');"></div>
    <div class="contents order-2 order-md-1">
        <div class="container">
            <div class="row align-items-center justify-content-center">
                <div class="col-md-7">
                    <h3>Login to <strong>Edu Care Hub</strong></h3>
                    <% String errorMessage = (String) request.getAttribute("error");
                        if (errorMessage != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= errorMessage %>
                    </div>
                    <% } %>
                    <p class="mb-4">Éduquer pour l'avenir, connectés pour réussir :</br> Bienvenue sur Educare Hub.</p>
                    <form action="login" method="post">
                        <div class="form-group first">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" placeholder="your-email@gmail.com" id="username" name="username">
                        </div>
                        <div class="form-group last mb-3">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" placeholder="Your Password" id="password" name="password">
                        </div>
                        <div class="d-flex mb-5 align-items-center">
                            <label class="control control--checkbox mb-0"><span class="caption">Remember me</span>
                                <input type="checkbox" checked="checked"/>
                                <div class="control__indicator"></div>
                            </label>
                            <span class="ml-auto"><a href="reset_password.jsp" class="forgot-pass">Forgot Password</a></span>
                        </div>
                        <input type="submit" value="Log In" class="btn btn-block btn-primary">
                        <button class="btn btn-block btn-primary" id="signupBtn" type="button">
                            Sign Up
                            <!-- Sign Up font icon -->
                            <i class="fa fa-user-plus" aria-hidden="true"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    document.getElementById("signupBtn").addEventListener("click", function() {
        fetch("redirectServlet")
            .then(function(response) {
                if (response.ok) {
                    window.location.href = "inscription.jsp";
                } else {
                    console.log("La redirection a échoué.");
                }
            })
            .catch(function(error) {
                console.error("Erreur lors de la requête fetch:", error);
            });
    });
</script>
</body>
</html>
