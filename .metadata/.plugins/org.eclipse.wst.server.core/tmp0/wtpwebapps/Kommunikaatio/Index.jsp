<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
Hei
<a href="Toka.jsp?nimi=Jaska&ika=10">Lähetä</a><br><br>
<form action="kolmas.jsp" method="GET">
Tunnus: <input type="text" name="tunnus"><br><br>
Salasana: <input type="text" name="pwd">
<input type="submit" value="Lähetä">

</form>
</body>
</html>