<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="Scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Insert title here</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="5" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="submit" id="tallenna" value="Lisää"></td>
			</tr>
		</tbody>
	</table>
	
</form>
<span id="ilmo"></span> 
</body>
<script>
$(document).ready(function(){
	$("#takaisin").click(function(){ //käsitellään id=takaisin, klikkaus funktio?
		document.location="listaaasiakkaat.jsp"; //eli klikkaamalla ko. id:llä merkattua kohtaa selaimessa, kutsuu sivua, joka kirjoitettu lainausmerkkien sisään
	});
	

	$("#tiedot").validate({			//arvojen validointi			
		rules: {					//validoinnin säännöt
			
		
			etunimi:  {				//kertoo mikä arvo validoidaan ja millä säännöillä
				required: true,		//true määrittelee, että kentässä on oltava jotain/joku arvo
				minlength: 3		//arvon minimi pituus on oltava 3 merkkiä		
			},	
			sukunimi:  {
				required: true,
				minlength: 2				
			},
			puhelin:  {
				required: true,
				minlength: 1
			},	
			sposti:  {
				required: true,
				minlength: 6,
				
			}	
		},
		messages: {					//jos säännöt ei toteudu
			
		
			etunimi: {     
				required: "Puuttuu",		//kirjoittaa selaimeen arvokentän kohdalle mitä lainausmerkkien sisällä on
				minlength: "Liian lyhyt"			
			},
			sukunimi: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			puhelin: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			sposti: {
				required: "Puuttuu",
				minlength: "Liian lyhyt",
				
			}
		},			
		submitHandler: function(form) {	//tämä toteaa lomakkeen toiminnot suoritetuiksi, jonka jälkeen...
			lisaaTiedot(); //... kutsutaan lisaaTiedot-metodia
		}		
	}); 	
});
//funktio tietojen lisäämistä varten. Kutsutaan backin POST-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//POST /autot/
function lisaaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi formJsonDataStr=metodi, joka muuttaa tiedot json stringiksi, #tiedot=lomakkeen (jonka tiedot muutetaan) id, serializeArray=metodi,joka järjestelee lomakkeen tiedot arvopareiksi? Arraylistaan?
	$.ajax({url:"asiakkaat", data:formJsonStr, type:"POST", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"} $.ajax({url: "TÄHÄN SERVLETIN NIMI, JOLLE TIEDOT VÄLITETÄÄN", data: TÄHÄN DATA, JOKA SERVLETILLE VÄLITETÄÄN(KTS. YLEMPI RIVI, JOSSA MUUTTUJAAN KIINNITETÄÄN KO.DATA), type: "TÄHÄN, MILLE SERVLETIN METODILLE TIEDOT VÄLITETÄÄN (GET, POST, PUT, DELETE)"", datatype: TÄHÄN DATAN TYYPPI, MINKÄLAISENA TIEDOT SERVLETILLE VÄLITETÄÄN success: PALAUTTAA TULOKSEN (result) (MISTÄ, mikä funktio?), JOKO 1 TAI 0, RIIPPUEN ONNISTUIKO LISÄYS?  })      
		if(result.response==0){
      	$("#ilmo").html("Asiakkaan lisääminen epäonnistui."); // #ilmo= id, sille kohdalle koodissa, johon kirjoitetaan viesti
      }else if(result.response==1){			
      	$("#ilmo").html("Asiakkaan lisääminen onnistui.");
      	$( "#etunimi", "#sukunimi", "#puhelin", "#sposti").val(""); //tämä tyhjentää valitut kentät lomakkeelta selaimessa, kun toiminto on suoritettu
		}
  }});	
}
</script>
</body>
</html>