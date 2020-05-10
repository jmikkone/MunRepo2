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
			<th colspan="6" class="oikealle"><span id="uusiAsiakas">Lisää uusi asiakas</span></th>
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

//tää on FrontEnd


$(document).ready(function(){ //mitä tämä funktio oikeastaan tekee?
	
	$(document.body).on("keydown", function(event){  //event funktion toiminta??? Tutki.
		if(event.which==13){ // enteriä painettu, ajetaan haku Tutki lisää event.which:iä. miksi ==13? Mistä tuo 13 tulee?
			haeTiedot(); //kutsuu haeTiedot-metodia
		}		
	});
	
	$("#uusiAsiakas").click(function(){ //klikkaus funktio. Käsitellään id=uusiAsiakas
		document.location="lisaaasiakas.jsp"; //klikkaamalla selaimessa kohtaa lisää uusi asiakas, siirrytään sivulle lisaaasiakas.jsp
	});
	
	$("#hae").click(function(){ //tässä sama kuin ylempänä, mutta id=hae ja klikkaus kutsuu haeTiedot-metodia.
		haeTiedot(); 
	});
										
	$("#hakusana").focus(); //viedään kursori hakusana-kenttään sivun latauksen yhteydessä
	
	haeTiedot();
		
	});
	
	function haeTiedot(){
		$("#listaus tbody").empty(); //?????miksi tässä käytetäänkin $.getJSON, eikä $.ajax niinkuin aiemmin ohjevideossa "listaus"? Vastaus: molemmat käy.
		$.getJSON({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", datatype:"json", success: function(result){ //Funktio palauttaa tiedot json-objektina
				
				$.each(result.asiakkaat, function(i, field) {
					var htmlStr;
					htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>";
					htmlStr+="<td>"+field.asiakas_id+"</td>";
					htmlStr+="<td>"+field.etunimi+"</td>"; //field viittaa ilmeisesti? DB:n taulun tietokenttään x, esim. field.etunimi viittaa etunimi kenttään
					htmlStr+="<td>"+field.sukunimi+"</td>";
					htmlStr+="<td>"+field.puhelin+"</td>";
					htmlStr+="<td>"+field.sposti+"</td>";
					htmlStr+="<td><a href='muutaAsiakas.jsp?asiakas_id="+field.asiakas_id+"'>Muuta</a>&nbsp;"; //miksi ?-merkki eikä +-merkki muutaAsiakas.jsp:n ja asiakas_id:n välissä?
					htmlStr+= "<span class='poista' onclick=poista("+field.asiakas_id+",'"+field.etunimi+"','"+field.sukunimi+"') >Poista</span></td>";
					htmlStr+="</tr>";
					$("#listaus tbody").append(htmlStr);		
			});
			}
		});
	}

	function poista(asiakas_id, etunimi, sukunimi){ // functiolle välitetään parametrit asiakas_id, etunimi, sukunimi, jotka tulee field:stä?
		if (confirm("Poista asiakas " + etunimi +" "+ sukunimi + "?")){ // confirm:lla luodaan  "kyllä/ei"-kysely laatikko selaimen puolelle?
			$.getJSON({url:"asiakkaat/"+asiakas_id, type:"DELETE", datatype:"json", success: function (result){ // ei tarvita=> var formJsonStr = formDataJsonStr($("#tiedot").serializeArray());, koska tiedot, jotka välitetään = simppelit, ei tarvi tehdä JsonObjektia!!! $.ajax({url: "TÄHÄN SERVLETIN NIMI, JOLLE TIEDOT VÄLITETÄÄN/"+TÄHÄN TIETO, JOKA VÄLITETÄÄN SERVLETILLE(tässä tiedon voi välittää suoraan, kun simppelissä muodossa jo valmiiksi. Siksi data:-kohta jää pois urlista), (eli tätä ei tässä tapauksessa tarvita=>data: TÄHÄN DATA, JOKA SERVLETILLE VÄLITETÄÄN(KTS. YLEMPI RIVI, JOSSA MUUTTUJAAN KIINNITETÄÄN KO.DATA)), type: "TÄHÄN, MILLE SERVLETIN METODILLE TIEDOT VÄLITETÄÄN (GET, POST, PUT, DELETE)"", datatype: TÄHÄN DATAN TYYPPI, MINKÄLAISENA TIEDOT SERVLETILLE VÄLITETÄÄN success: PALAUTTAA TULOKSEN (result) (MISTÄ, mikä funktio?), JOKO 1 TAI 0, RIIPPUEN ONNISTUIKO LISÄYS?  }) 
				if (result.response==0){
					$("#ilmo").html("Asiakkaan poisto epäonnistui.");
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