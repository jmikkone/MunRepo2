<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="Scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Insert title here</title>
</head>
<body>
<%

String tunnus=request.getParameter("tunnus");
String salasana=request.getParameter("pwd");
out.print("Tunnus: "+tunnus+"<br>Salasana: "+salasana);

%>
<br>
<br>
<span id="tunnus"></span><br>
<span id="salasana"></span>
<script>

$(document).ready(function() {
	var tunnus=requestURLParam("tunnus");
	
	console.log("tunnus");
	
	$ ("#tunnus").text("Tunnus on "+tunnus);

	$ ("#salasana").text("Salasana on "+requestURLParam("pwd"));
});

</script>

</body>
</html>