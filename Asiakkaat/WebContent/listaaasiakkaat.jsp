<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet", type="text/css", href="css/main.css">
<script src="Scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Insert title here</title>
<style>


</style>
</head>
<body>
<form action="Dao.java" method="POST">
<label>Hakusana:</label><input type="text", name="hakusana", size="40"><input type="submit", value="l�het�">
<table id="listaus">
		<thead>
			<tr>
				<th>puhelin</th>
				<th>etunimi</th>
				<th>sukunimi</th>
				<th>asiakas_id</th>
				<th>sposti</th>
			</tr>
		</thead>
	<tbody>
	</tbody>
</table>
<script>

$(document).ready(function() {
	//t�� on FrontEnd
	$.ajax({
		url:"asiakkaat", 
		type:"GET", 
		datatype:"json", 
		success: function(result){ //Funktio palauttaa tiedot json-objektina
			
			$.each(result.asiakkaat, function(i, field) {
				var htmlStr;
				htmlStr+="<tr>";
				htmlStr+="<td>"+field.puhelin+"</td>";
				htmlStr+="<td>"+field.etunimi+"</td>";
				htmlStr+="<td>"+field.sukunimi+"</td>";
				htmlStr+="<td>"+field.asiakas_id+"</td>";
				htmlStr+="<td>"+field.sposti+"</td>";
				htmlStr+="</tr>";
				$("#listaus tbody").append(htmlStr);		
		});
}});
});

</script>
</form>
</body>
</html>