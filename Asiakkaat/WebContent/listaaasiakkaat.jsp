<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/main.css">
<script src="Scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<title>Insert title here</title> 
<style>


</style>
</head>
<body>

<table id="listaus">
		
		<thead>
		<tr>
			<th colspan="6" class="oikealle"><span id="uusiAsiakas">Lis�� uusi asiakas</span></th>
		</tr>
			
		<tr>
		<th colspan="2" class="oikealle">Hakusana:</th>
		<th colspan="3"><input type="text" id="hakusana" size="30"></th>
		<th colspan="1" class="oikealle"><input type="button" id="hae" value="Hae"></th>
		</tr>
			<tr>
				<th>Asiakas_id</th>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th></th>
			</tr>
		</thead>
	<tbody>
	
	</tbody>
</table>
<script>

//t�� on FrontEnd


$(document).ready(function() {
	
	$(document.body).on("keydown", function(event){ //opettaja ei ole selitt�nyt t�t� toimintoa ohjevideoilla. Ensimm�isen kerran k�ytiin teht�v� 4. vastausvideolla l�pi??? 
		if(event.which==13){ // enteri� painettu, ajetaan haku
			haeTiedot();
		}		
	});
	
	$("#uusiAsiakas").click(function(){ //opettaja ei ole selitt�nyt t�t� toimintoa ohjevideoilla. Ensimm�isen kerran k�ytiin teht�v� 4. vastausvideolla l�pi???
		document.location="lisaaasiakas.jsp";
	});
	
	$("#hae").click(function(){ //opettaja ei ole selitt�nyt t�t� toimintoa ohjevideoilla. Ensimm�isen kerran k�ytiin teht�v� 4. vastausvideolla l�pi???
		haeTiedot(); //huom! t�m�n tyyppiset komennot eiv�t kuuluneet orientaatio kurssiin
	});
										
	$("#hakusana").focus(function (){ //vied��n kursori hakusana-kentt��n sivun latauksen yhteydess�
		 //opettaja ei ole selitt�nyt t�t� toimintoa ohjevideoilla. Ensimm�isen kerran k�ytiin teht�v� 4. vastausvideolla l�pi???
	});
	
	function haeTiedot(){
		$("#listaus tbody").empty();
		$.getJSON({url:"asiakkaat/"+$("#hakusana").val(), //?????miksi t�ss� k�ytet��nkin $.getJSON, eik� $.ajax niinkuin aiemmin ohjevideossa "listaus" ja miksi asiakkaat j�lkeen on /??? ei ollut videossa "listaus", mutta silti viikkoteht�v� 4. vastaus videossa on???
			type:"GET", 
			datatype:"json", 
			success: function(result){ //Funktio palauttaa tiedot json-objektina
				
				$.each(result.asiakkaat, function(i, field) {
					var htmlStr;
					htmlStr+="<tr id='rivi_"+field.asiakas_id+"''>";
					htmlStr+="<td>"+field.asiakas_id+"</td>";
					htmlStr+="<td>"+field.etunimi+"</td>";
					htmlStr+="<td>"+field.sukunimi+"</td>";
					htmlStr+="<td>"+field.puhelin+"</td>";
					htmlStr+="<td>"+field.sposti+"</td>";
					htmlStr+="<td><span class='poista', onclick=poista('"+field.asiakas_id+"')>Poista</span></td>";
					htmlStr+="</tr>";
					$("#listaus tbody").append(htmlStr);		
			});
			}
		});
	}
});
	function poista (asiakas_id){
		
		if (confirm("Poista asiakas " + asiakas_id+ "?")){
			$.ajax({url:"asiakkaat/"+asiakas_id, type: "DELETE", datatype:"json", success: function (result){
				if (result.response==0){
					$("#ilmo").html("Asiakkaan poisto ep�onnistui.");
				}
				else if (result.response==1){
					$("#rivi_"+asiakas_id).css("background-color", "red");
					$("#ilmo").html("Asiakkaan" +asiakas_id+ " poisto onnistui.");
					
					haeTiedot;
				}
			}})
		}
	}
	

</script>

</body>
</html>