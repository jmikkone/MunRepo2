<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>K�ytt�j�n tiedot lomake</title>
 <style type="text/css">
		label {
				display: block;
				width: 8em;
				float: left;
		}
		</style>
</head>
<body>
<h3>K�ytt�j�tietolomake</h3>
<form action="Nayta.jsp" method="POST">
<label>Etunimi:</label> <input type="text" name="eNimi"><br><br>
<label>Sukunimi:</label> <input type="text" name="sNimi"><br><br>
<label>S�hk�posti:</label> <input type="text" name="sPosti"><br><br>
<label>Puhelinnumero:</label> <input type="text" name="puh"><br><br>
<label>Syntym�vuosi:</label> <input type="text" name="syntA"><br>
<p><input type="submit" value="L�het�"></p>

</form>
</body>
</html>
