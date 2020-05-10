<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/main.css">
<script src="Scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<title>Insert title here</title>
</head>
<body>
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="6" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th> <!-- tässä oleva span voisi olla suoraan <a href="listaaasiakkaat.jsp"></a> (nyt en ole ihan varma tuleeko ympärille tupsut vai hipsut) mutta, jos on a tagissa linkki, niin ei tarvitse scriptissä ottaa kiinni $("#takaisin).click(function(){ document.location="listaaasiakkaat.jsp"; -->
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
			<tr>
				<td><input type="text" name="asiakas_id" id="asiakas_id"></td>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td>
				<td><input type="text" name="sposti" id="sposti"></td> 
				<td><input type="submit" id="tallenna" value="Hyväksy"></td>
			</tr>
		</tbody>
	</table>
 <!--	<input type="hidden" name="id" id="id">  jos asiakas_id:tä muutettaisiin: säilötään vanha asiakas_id, että nähdään mihin id:hen muutokset kohdistuu -->
</form>
<span id="ilmo"></span> <!-- The <span> tag is an inline container used to mark up a part of a text, or a part of a document. The <span> tag provides no visual change by itself, but when it is marked, you can style it with CSS, or manipulate it with JavaScript -->
</body>
<script>
$ (document).ready(function(){ //jqueryn aloitus tagi = $ (document).ready(function(){
	$("#takaisin").click(function(){
		document.location="listaaasiakkaat.jsp";
	});
	// haetaan muutettavan asiakkaan tiedot. Kutsutaan backin "GET" metodia.
	//GET /asiakkaat/haeyksi/asiakas_id
	var asiakas_id=requestURLParam("asiakas_id");
	$.ajax({url:"asiakkaat/haeyksi/"+asiakas_id, type:"GET", dataType:"json", success: function(result){ // eli haetaan GET:llä ja se mitä GET-metodi palauttaa asettuu result:iin
		//$("#id").val(result.asiakas_id); // vanha ja uusi asiakas_id saa aluksi saman arvon, jos id:tä muutettaisiin
		$("#asiakas_id").val(result.asiakas_id);
		$("#etunimi").val(result.etunimi);
		$("#sukunimi").val(result.sukunimi);
		$("#puhelin").val(result.puhelin);
		$("#sposti").val(result.sposti);
	}});
	
	$("#tiedot").validate({			//arvojen validointi			
		rules: {					//validoinnin säännöt
			
			asiakas_id: {
				required: true,
				minlength: 1
			},
		
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
			
			asiakas_id: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
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
			paivitaTiedot(); //... kutsutaan paivitaTiedot-metodia
		}		
	}); 	
});
//funktio tietojen päivitystä varten. Kutsutaan backin PUT-metodia ja välitetään kutsun mukana uudet tiedot json-stringinä.
//PUT /autot/
function paivitaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi formJsonDataStr=metodi, joka muuttaa tiedot json stringiksi, #tiedot=lomakkeen (jonka tiedot muutetaan) id, serializeArray=metodi,joka järjestelee lomakkeen tiedot arvopareiksi? Arraylistaan?
	$.ajax({url:"asiakkaat", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"} $.ajax({url: "TÄHÄN SERVLETIN NIMI, JOLLE TIEDOT VÄLITETÄÄN", data: TÄHÄN DATA, JOKA SERVLETILLE VÄLITETÄÄN(KTS. YLEMPI RIVI, JOSSA MUUTTUJAAN KIINNITETÄÄN KO.DATA), type: "TÄHÄN, MILLE SERVLETIN METODILLE TIEDOT VÄLITETÄÄN (GET, POST, PUT, DELETE)"", datatype: TÄHÄN DATAN TYYPPI, MINKÄLAISENA TIEDOT SERVLETILLE VÄLITETÄÄN success: PALAUTTAA TULOKSEN (result) (MISTÄ, mikä funktio?), JOKO 1 TAI 0, RIIPPUEN ONNISTUIKO LISÄYS?  })      
		if(result.response==0){
      	$("#ilmo").html("Asiakkaan päivittäminen epäonnistui."); // #ilmo= id, sille kohdalle koodissa, johon kirjoitetaan viesti
      }else if(result.response==1){			
      	$("#ilmo").html("Asiakkaan päivittäminen onnistui.");
      	$( "#etunimi", "#sukunimi", "#puhelin", "#sposti").val(""); //tämä tyhjentää valitut kentät lomakkeelta selaimessa, kun toiminto on suoritettu
		}
	}});	
}
</script>
</html>