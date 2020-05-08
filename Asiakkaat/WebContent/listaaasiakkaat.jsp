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
				<th>&nbsp;</th>
			</tr>
		</thead>
	<tbody>
	
	</tbody>
</table>
<script>

//t�� on FrontEnd


$(document).ready(function(){ //mit� t�m� funktio oikeastaan tekee?
	
	$(document.body).on("keydown", function(event){  //event funktion toiminta??? Tutki.
		if(event.which==13){ // enteri� painettu, ajetaan haku Tutki lis�� event.which:i�. miksi ==13? Mist� tuo 13 tulee?
			haeTiedot(); //kutsuu haeTiedot-metodia
		}		
	});
	
	$("#uusiAsiakas").click(function(){ //klikkaus funktio. K�sitell��n id=uusiAsiakas
		document.location="lisaaasiakas.jsp"; //klikkaamalla selaimessa kohtaa lis�� uusi asiakas, siirryt��n sivulle lisaaasiakas.jsp
	});
	
	$("#hae").click(function(){ //t�ss� sama kuin ylemp�n�, mutta id=hae ja klikkaus kutsuu haeTiedot-metodia.
		haeTiedot(); 
	});
										
	$("#hakusana").focus(); //vied��n kursori hakusana-kentt��n sivun latauksen yhteydess�
	
	haeTiedot();
		
	});
	
	function haeTiedot(){
		$("#listaus tbody").empty(); //?????miksi t�ss� k�ytet��nkin $.getJSON, eik� $.ajax niinkuin aiemmin ohjevideossa "listaus"? Vastaus: molemmat k�y.
		$.getJSON({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", datatype:"json", success: function(result){ //Funktio palauttaa tiedot json-objektina
				
				$.each(result.asiakkaat, function(i, field) {
					var htmlStr;
					htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>";
					htmlStr+="<td>"+field.asiakas_id+"</td>";
					htmlStr+="<td>"+field.etunimi+"</td>"; //field viittaa ilmeisesti? DB:n taulun tietokentt��n x, esim. field.etunimi viittaa etunimi kentt��n
					htmlStr+="<td>"+field.sukunimi+"</td>";
					htmlStr+="<td>"+field.puhelin+"</td>";
					htmlStr+="<td>"+field.sposti+"</td>";
					htmlStr+="<td><span class='poista' onclick = poista("+field.asiakas_id+",'"+field.etunimi+"', '"+field.sukunimi+"')>Poista</span></td>";
					htmlStr+="</tr>";
					$("#listaus tbody").append(htmlStr);		
			});
			}
		});
	}

	function poista(asiakas_id, etunimi, sukunimi){ // functiolle v�litet��n parametrit asiakas_id, etunimi, sukunimi, jotka tulee field:st�?
		
		if (confirm("Poista asiakas " + etunimi +" "+ sukunimi + "?")){ // confirm:lla luodaan  "kyll�/ei"-kysely laatikko selaimen puolelle?
			$.ajax({url:"asiakkaat/"+asiakas_id, type: "DELETE", datatype:"json", success: function (result){ // ei tarvita=> var formJsonStr = formDataJsonStr($("#tiedot").serializeArray());, koska tiedot, jotka v�litet��n = simppelit, ei tarvi tehd� JsonObjektia!!! $.ajax({url: "T�H�N SERVLETIN NIMI, JOLLE TIEDOT V�LITET��N/"+T�H�N TIETO, JOKA V�LITET��N SERVLETILLE(t�ss� tiedon voi v�litt�� suoraan, kun simppeliss� muodossa jo valmiiksi. Siksi data:-kohta j�� pois urlista), (eli t�t� ei t�ss� tapauksessa tarvita=>data: T�H�N DATA, JOKA SERVLETILLE V�LITET��N(KTS. YLEMPI RIVI, JOSSA MUUTTUJAAN KIINNITET��N KO.DATA)), type: "T�H�N, MILLE SERVLETIN METODILLE TIEDOT V�LITET��N (GET, POST, PUT, DELETE)"", datatype: T�H�N DATAN TYYPPI, MINK�LAISENA TIEDOT SERVLETILLE V�LITET��N success: PALAUTTAA TULOKSEN (result) (MIST�, mik� funktio?), JOKO 1 TAI 0, RIIPPUEN ONNISTUIKO LIS�YS?  }) 
				if (result.response==0){
					$("#ilmo").html("Asiakkaan poisto ep�onnistui.");
				}
				else if (result.response==1){
					$("#rivi_"+asiakas_id).css("background-color", "red");
					alert("Asiakkaan " + etunimi +" "+ sukunimi +" poisto onnistui.");
					
					haeTiedot();
				}
			}});
		
		}
	}
</script>
</body>
</html>