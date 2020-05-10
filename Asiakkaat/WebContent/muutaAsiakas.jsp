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
				<th colspan="6" class="oikealle"><span id="takaisin">Takaisin listaukseen</span></th> <!-- t�ss� oleva span voisi olla suoraan <a href="listaaasiakkaat.jsp"></a> (nyt en ole ihan varma tuleeko ymp�rille tupsut vai hipsut) mutta, jos on a tagissa linkki, niin ei tarvitse scriptiss� ottaa kiinni $("#takaisin).click(function(){ document.location="listaaasiakkaat.jsp"; -->
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
				<td><input type="submit" id="tallenna" value="Hyv�ksy"></td>
			</tr>
		</tbody>
	</table>
 <!--	<input type="hidden" name="id" id="id">  jos asiakas_id:t� muutettaisiin: s�il�t��n vanha asiakas_id, ett� n�hd��n mihin id:hen muutokset kohdistuu -->
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
	$.ajax({url:"asiakkaat/haeyksi/"+asiakas_id, type:"GET", dataType:"json", success: function(result){ // eli haetaan GET:ll� ja se mit� GET-metodi palauttaa asettuu result:iin
		//$("#id").val(result.asiakas_id); // vanha ja uusi asiakas_id saa aluksi saman arvon, jos id:t� muutettaisiin
		$("#asiakas_id").val(result.asiakas_id);
		$("#etunimi").val(result.etunimi);
		$("#sukunimi").val(result.sukunimi);
		$("#puhelin").val(result.puhelin);
		$("#sposti").val(result.sposti);
	}});
	
	$("#tiedot").validate({			//arvojen validointi			
		rules: {					//validoinnin s��nn�t
			
			asiakas_id: {
				required: true,
				minlength: 1
			},
		
			etunimi:  {				//kertoo mik� arvo validoidaan ja mill� s��nn�ill�
				required: true,		//true m��rittelee, ett� kent�ss� on oltava jotain/joku arvo
				minlength: 3		//arvon minimi pituus on oltava 3 merkki�		
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
		messages: {					//jos s��nn�t ei toteudu
			
			asiakas_id: {
				required: "Puuttuu",
				minlength: "Liian lyhyt"
			},
			etunimi: {     
				required: "Puuttuu",		//kirjoittaa selaimeen arvokent�n kohdalle mit� lainausmerkkien sis�ll� on
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
		submitHandler: function(form) {	//t�m� toteaa lomakkeen toiminnot suoritetuiksi, jonka j�lkeen...
			paivitaTiedot(); //... kutsutaan paivitaTiedot-metodia
		}		
	}); 	
});
//funktio tietojen p�ivityst� varten. Kutsutaan backin PUT-metodia ja v�litet��n kutsun mukana uudet tiedot json-stringin�.
//PUT /autot/
function paivitaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi formJsonDataStr=metodi, joka muuttaa tiedot json stringiksi, #tiedot=lomakkeen (jonka tiedot muutetaan) id, serializeArray=metodi,joka j�rjestelee lomakkeen tiedot arvopareiksi? Arraylistaan?
	$.ajax({url:"asiakkaat", data:formJsonStr, type:"PUT", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"} $.ajax({url: "T�H�N SERVLETIN NIMI, JOLLE TIEDOT V�LITET��N", data: T�H�N DATA, JOKA SERVLETILLE V�LITET��N(KTS. YLEMPI RIVI, JOSSA MUUTTUJAAN KIINNITET��N KO.DATA), type: "T�H�N, MILLE SERVLETIN METODILLE TIEDOT V�LITET��N (GET, POST, PUT, DELETE)"", datatype: T�H�N DATAN TYYPPI, MINK�LAISENA TIEDOT SERVLETILLE V�LITET��N success: PALAUTTAA TULOKSEN (result) (MIST�, mik� funktio?), JOKO 1 TAI 0, RIIPPUEN ONNISTUIKO LIS�YS?  })      
		if(result.response==0){
      	$("#ilmo").html("Asiakkaan p�ivitt�minen ep�onnistui."); // #ilmo= id, sille kohdalle koodissa, johon kirjoitetaan viesti
      }else if(result.response==1){			
      	$("#ilmo").html("Asiakkaan p�ivitt�minen onnistui.");
      	$( "#etunimi", "#sukunimi", "#puhelin", "#sposti").val(""); //t�m� tyhjent�� valitut kent�t lomakkeelta selaimessa, kun toiminto on suoritettu
		}
	}});	
}
</script>
</html>