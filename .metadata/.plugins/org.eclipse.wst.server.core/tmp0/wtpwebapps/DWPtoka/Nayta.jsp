<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"  import="java.util.Calendar"  import="java.util.Timer" import="java.util.TimerTask" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="Scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>K�ytt�j�n tiedot</title>
</head>
<body>
<h3>K�ytt�j�n tiedot</h3>

<% 

String eNimi=request.getParameter("eNimi");

String sNimi=request.getParameter("sNimi");

String sPosti=request.getParameter("sPosti");

String puhNro=request.getParameter("puh");

String syntVuosi=request.getParameter("syntA");

int syntV=Integer.parseInt(syntVuosi);

int nytVuosi=Calendar.getInstance().get(Calendar.YEAR);

int ika=nytVuosi-syntV;

if (ika>= 18){
	
	out.print("Etunimi on "+eNimi+"<br>");
	out.print("Sukunimi on "+sNimi+"<br>");
	out.print("S�hk�postiosoite on "+sPosti+"<br>");
	out.print("Puhelinnumero on "+puhNro+"<br>");
	out.print("Ik� on "+ ika);

}
else {
	
	out.print("Alaik�inen");
	
	response.setHeader("Refresh","5;url=Kysy.jsp");
	
}
%>


</body>
</html>
