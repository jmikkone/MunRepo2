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
				<td><input type="submit" id="tallenna" value="Lis��"></td>
			</tr>
		</tbody>
	</table>
	
</form>
<span id="ilmo"></span> 
</body>
<script>
$(document).ready(function(){
	$("#takaisin").click(function(){ //k�sitell��n id=takaisin, klikkaus funktio?
		document.location="listaaasiakkaat.jsp"; //eli klikkaamalla ko. id:ll� merkattua kohtaa selaimessa, kutsuu sivua, joka kirjoitettu lainausmerkkien sis��n
	});
	

	$("#tiedot").validate({			//arvojen validointi			
		rules: {					//validoinnin s��nn�t
			
		
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
			lisaaTiedot(); //... kutsutaan lisaaTiedot-metodia
		}		
	}); 	
});
//funktio tietojen lis��mist� varten. Kutsutaan backin POST-metodia ja v�litet��n kutsun mukana uudet tiedot json-stringin�.
//POST /autot/
function lisaaTiedot(){	
	var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi formJsonDataStr=metodi, joka muuttaa tiedot json stringiksi, #tiedot=lomakkeen (jonka tiedot muutetaan) id, serializeArray=metodi,joka j�rjestelee lomakkeen tiedot arvopareiksi? Arraylistaan?
	$.ajax({url:"asiakkaat", data:formJsonStr, type:"POST", dataType:"json", success:function(result) { //result on joko {"response:1"} tai {"response:0"} $.ajax({url: "T�H�N SERVLETIN NIMI, JOLLE TIEDOT V�LITET��N", data: T�H�N DATA, JOKA SERVLETILLE V�LITET��N(KTS. YLEMPI RIVI, JOSSA MUUTTUJAAN KIINNITET��N KO.DATA), type: "T�H�N, MILLE SERVLETIN METODILLE TIEDOT V�LITET��N (GET, POST, PUT, DELETE)"", datatype: T�H�N DATAN TYYPPI, MINK�LAISENA TIEDOT SERVLETILLE V�LITET��N success: PALAUTTAA TULOKSEN (result) (MIST�, mik� funktio?), JOKO 1 TAI 0, RIIPPUEN ONNISTUIKO LIS�YS?  })      
		if(result.response==0){
      	$("#ilmo").html("Asiakkaan lis��minen ep�onnistui."); // #ilmo= id, sille kohdalle koodissa, johon kirjoitetaan viesti
      }else if(result.response==1){			
      	$("#ilmo").html("Asiakkaan lis��minen onnistui.");
      	$( "#etunimi", "#sukunimi", "#puhelin", "#sposti").val(""); //t�m� tyhjent�� valitut kent�t lomakkeelta selaimessa, kun toiminto on suoritettu
		}
  }});	
}
</script>
</body>
</html>