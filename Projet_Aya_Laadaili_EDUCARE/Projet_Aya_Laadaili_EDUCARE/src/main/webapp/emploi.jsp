<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Emploi du Temps et Calendrier</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/6.1.10/index.global.min.js" integrity="sha512-JCQkxdym6GmQ+AFVioDUq8dWaWN6tbKRhRyHvYZPupQ6DxpXzkW106FXS1ORgo/m3gxtt5lHRMqSdm2OfPajtg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <!-- Votre style ici -->
</head>
<body>
<%
  String idEtudiant = request.getParameter("studentId");
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
  Calendar cal = Calendar.getInstance();
  cal.set(Calendar.DAY_OF_MONTH, 1); // Premier jour du mois courant
  Date monthStart = cal.getTime();

  cal.add(Calendar.MONTH, 1);
  cal.add(Calendar.DAY_OF_MONTH, -1); // Dernier jour du mois courant
  Date monthEnd = cal.getTime();

  Map<String, Integer> dayMap = new HashMap<>();
  dayMap.put("Lundi", Calendar.MONDAY);
  dayMap.put("Mardi", Calendar.TUESDAY);
  dayMap.put("Mercredi", Calendar.WEDNESDAY);
  dayMap.put("Jeudi", Calendar.THURSDAY);
  dayMap.put("Vendredi", Calendar.FRIDAY);
  dayMap.put("Samedi", Calendar.SATURDAY);
  dayMap.put("Dimanche", Calendar.SUNDAY);

  ArrayList<String> events = new ArrayList<>();

  try {
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/EduCare", "root", "");
    String sqlEmploi = "SELECT DISTINCT c.cours, h.jour, h.heure FROM etu_cours ec JOIN cours c ON ec.id_cours = c.id_cours JOIN horaire h ON c.id_cours = h.id_cours WHERE ec.id_etudiant = ?";
    pstmt = conn.prepareStatement(sqlEmploi);
    pstmt.setString(1, idEtudiant);
    rs = pstmt.executeQuery();

    while (rs.next()) {
      String cours = rs.getString("cours");
      String jour = rs.getString("jour");
      Time heure = rs.getTime("heure");

      Integer dayOfWeek = dayMap.get(jour);

      if (dayOfWeek != null) {
        Calendar iterCal = Calendar.getInstance();
        iterCal.setTime(monthStart);
        while (iterCal.getTime().before(monthEnd) || iterCal.getTime().equals(monthEnd)) {
          if (iterCal.get(Calendar.DAY_OF_WEEK) == dayOfWeek) {
            String eventDate = sdf.format(iterCal.getTime()) + "T" + heure.toString();
            events.add("{ title: '" + cours + "', start: '" + eventDate + "' }");
          }
          iterCal.add(Calendar.DATE, 1);
        }
      }
    }
  } catch (SQLException e) {
    e.printStackTrace();
  } finally {
    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
  }
%>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      events: <%= events.toString() %>
    });
    calendar.render();
  });
</script>
<div id='calendar'></div>
</body>
</html>
