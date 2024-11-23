<head>
    <meta charset="UTF-8">
    <title>Inscription</title>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/inscription.css">
    <script>
        function afficherCours() {
            var niveau = document.getElementById("niveau").value;

            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        document.getElementById("listefiliere").innerHTML = xhr.responseText;
                    } else {
                        console.error('La requête a échoué avec un statut:', xhr.status);
                    }
                }
            };
            xhr.open('POST', 'CoursServlet', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send('niveau=' + niveau);
        }

        document.addEventListener("DOMContentLoaded", function() {
            afficherCours();
        });
    </script>
</head>
<body>
<div class="wrapper">
    <div class="left-container">

        <img src="img/frm1.webp" alt="Image">
    </div>
    <div class="right-container">
    <h3>Soutien EduCare Hub</h3>

    <form action="EnregistrerEtudiantServlet" method="post"  >
        <table align="center" cellpadding = "10">

            <!----- First Name ---------------------------------------------------------->
            <tr>
                <td>Nom</td>
                <td><input type="text" name="First_Name" maxlength="30" required/>
                </td>
            </tr>

            <!----- Last Name ---------------------------------------------------------->
            <tr>
                <td>Prenom</td>
                <td><input type="text" name="Last_Name" maxlength="30" required/>
                </td>
            </tr>

            <!----- Date Of Birth -------------------------------------------------------->
            <tr>
                <td>Date de naissance</td>
                <td>
                    <input type="date"  name="date_naissance" placeholder="Date De Naissance" required/>
                </td>
            </tr>

            <!----- Email Id ---------------------------------------------------------->
            <tr>
                <td>EMAIL:</td>
                <td><input type="text" name="email" maxlength="100" required/></td>
            </tr>

            <!----- Mobile Number ---------------------------------------------------------->
            <tr>
                <td>Mot De Passe </td>
                <td>
                    <input type="password" name="password" maxlength="10" required/>
                </td>
            </tr>

            <!----- Gender ----------------------------------------------------------->
            <tr>
                <td>Sexe</td>
                <td>
                    Homme <input type="radio" name="sexe" value="Homme" />
                    Femme <input type="radio" name="sexe" value="Femme" />
                </td>
            </tr>

            <!----- Address ---------------------------------------------------------->
            <tr>
                <td>Adresse <br /><br /><br /></td>
                <td><textarea name="Address" rows="4" cols="30" required ></textarea></td>
            </tr>

            <!----- Telephone ---------------------------------------------------------->
            <tr>
                <td>Telephone <br /><br /><br /></td>
                <td><input type="text" name="telephone" maxlength="20" required/></td>
            </tr>
            <!----- Niveau d'étude ---------------------------------------------------------->

            <td>Niveau d'etude</td>
            <td>
                <select id="niveau" name="niveau" onchange="afficherCours()">
                    <option value="tronc_commun">Tronc Commun</option>
                    <option value="3eme">3eme College</option>
                    <option value="1erbac">1ere Bac</option>
                    <option value="2emebac">2eme Bac</option>
                </select>
            </td>
            </tr>

            <tr>
                <td>Liste des Filiere</td>
                <td>
                    <div id="listefiliere"></div>
                    <!-- This div will display the list of courses -->
                </td>
            </tr>

<tr>
    <td colspan="2" align="center">
        <input type="submit" value="Submit">
        <input type="reset" value="Reset">
    </td>
</tr>
</table>
        <p class="">Already have an account? <a href="login.jsp">Log In</a></p>
    </form>
    </div>
</div>
</body>
</html>