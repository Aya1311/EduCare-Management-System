# EduCare-Management-System

EduCare est une plateforme développée avec Java Enterprise Edition (JEE) pour simplifier et améliorer la gestion des centres de soutien scolaire. Elle permet de centraliser les processus administratifs et éducatifs tout en offrant une expérience utilisateur fluide grâce à une interface intuitive.

---

## Fonctionnalités principales

- **Tableaux de bord personnalisés** : Adaptés aux rôles spécifiques des utilisateurs (étudiant, enseignant, secrétaire, administrateur).
- **Gestion des cours et des horaires** : Flexibilité dans la création, la modification et la suppression des cours.
- **Authentification sécurisée** : Système de connexion par rôle avec gestion des profils.
- **Gestion des utilisateurs** :
  - Étudiants : Inscription, gestion de profil, visualisation des cours et emploi du temps.
  - Enseignants : Suivi des cours, gestion des absences, communication avec les étudiants et l'administration.
  - Secrétaires : Coordination des inscriptions, horaires, et gestion administrative.
  - Administrateurs : Supervision globale, création/modification des cours et gestion des rôles.
- **Communication intégrée** : Système de messagerie interne pour tous les utilisateurs.
- **Rapports et statistiques** : Visualisation des données clés sur les étudiants, enseignants, cours, et filières.

---

## Technologies utilisées

- **Backend** :
  - Java Enterprise Edition (JEE)
  - JDBC (Java Database Connectivity)
  - SQL pour la gestion de la base de données
  - Apache Tomcat comme serveur d'application

- **Frontend** :
  - JSP (JavaServer Pages) et HTML pour la structure des pages
  - CSS et Bootstrap pour le design réactif et moderne
  - JavaScript, AJAX et jQuery pour les interactions dynamiques

- **Base de données** :
  - MySQL pour le stockage et la gestion des données

---

## Installation et exécution

### Prérequis
- JDK 11 ou version ultérieure
- Apache Tomcat 9 ou version ultérieure
- MySQL Server
- IDE comme IntelliJ IDEA ou Eclipse (recommandé)

### Étapes d'installation
1. **Clonez le repository** :
   ```bash
   git clone https://github.com/Aya1311/EduCare-Management-System.git
2. **Configurez la base de données** :
   - Créez une base de données MySQL nommée `educare`.
   - Importez le fichier `EduCare.sql` fourni dans le répertoire `resources`.

3. **Mettez à jour les informations de connexion** :
   - Modifiez le fichier `db.properties` avec les paramètres de connexion de votre base de données MySQL.

4. **Déployez l'application sur Tomcat** :
   - Importez le projet dans votre IDE préféré (IntelliJ IDEA ou Eclipse).
   - Configurez Apache Tomcat comme serveur d'application.
   - Déployez l'application sur le serveur Tomcat.

5. **Lancez l'application** :
   - Démarrez le serveur Tomcat.
   - Accédez à l'application via votre navigateur à l'adresse suivante :
     ```
     http://localhost:8080/EduCare
     ```

---
## Contributions

Les contributions à **EduCare-Management-System** sont les bienvenues ! Pour contribuer :

1. **Forkez le dépôt** sur GitHub.
2. **Clonez votre fork** localement :
   ```bash
   git clone https://github.com/username/EduCare-Management-System.git
3. **Créez une branche pour vos modifications** :
   ```bash
   git checkout -b feature/nouvelle-fonctionnalite
4. **Apportez vos modifications** :
   - Implémentez de nouvelles fonctionnalités, corrigez des bugs ou améliorez la documentation.
   - Assurez-vous que votre code respecte les bonnes pratiques de développement.
   - Commentez les parties importantes ou complexes pour faciliter la relecture.
5. **Testez vos modifications** :
   - Vérifiez que votre code fonctionne correctement et qu'il n'introduit pas de régressions.
   - Fournissez des tests unitaires ou fonctionnels si nécessaire pour valider vos changements.
6. **Commitez vos modifications** :
   ```bash
   git commit -m "Ajout d'une nouvelle fonctionnalité"

7. **Pushez votre branche vers votre fork** :
   ```bash
   git push origin feature/nouvelle-fonctionnalite
8. **Ouvrez une Pull Request** :
   - Rendez-vous sur la page GitHub du dépôt original.
   - Cliquez sur **New Pull Request**.
   - Sélectionnez votre branche et fournissez une description claire de vos modifications.
   - Expliquez pourquoi ces modifications devraient être fusionnées et mentionnez tout point nécessitant une attention particulière.
---

## Auteur

- **Aya Laadaili**  
  Master en Sciences des Données et Big Data  
  Université Hassan II - Casablanca  
  Année Universitaire : 2023-2024  

Encadré par : **Mr. Belangour**

---

## Licence

Ce projet est sous licence **MIT**.  
Veuillez consulter le fichier [`LICENSE`](./LICENSE) pour plus de détails.

---

## Aperçu

**EduCare** révolutionne la gestion des centres de soutien scolaire grâce à :  
- **Une interface intuitive** pour une prise en main facile par tous les utilisateurs.  
- **Des fonctionnalités avancées** adaptées aux besoins des centres éducatifs modernes.  
- **Une architecture robuste**, garantissant fiabilité et efficacité.

Cette plateforme offre une solution clé en main pour la gestion administrative et éducative, tout en améliorant l'expérience des utilisateurs et en facilitant les interactions entre les différents acteurs (étudiants, enseignants, secrétaires et administrateurs).
