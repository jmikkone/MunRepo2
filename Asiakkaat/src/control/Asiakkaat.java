package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import model.Asiakas;
import model.dao.Dao;

/**
 * Servlet implementation class Asiakkaat
 *//* asiakkaat per‰‰n lis‰t‰‰n /* t‰m‰ viittaa alikansioihin. ƒl‰ h‰m‰‰nny vaikka "palauttaa" tyhj‰n Json stringin. Koodi toimii kyll‰. Tutki t‰t‰ kuitenkin lis‰‰, ett‰ ymm‰rr‰t*/
@WebServlet("/asiakkaat/*") //frontEndiss‰ viitataan t‰h‰n kohtaan kun haetaan backEndist‰ tietoja 
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	//T‰m‰ on servlet, joka keskustelee daon kanssa
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Asiakkaat() {
        super();
       System.out.println("Asiakkaat.Asiakkaat()");
    }

// GET:ll‰ haetaan asiakkaan tiedot
    //GET /asiakkaat/{hakusana}
    //GET /asiakkaat/haeyksi/asiakas_id
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()");
		
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /aalto			
		System.out.println("polku: "+pathInfo);
		
		
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat;
		String strJSON="";					// jos kutsutaan backEndi‰ ilman kauttaviivaa, polku(pathInfo)=null;
		if (pathInfo==null) { // jos pathInfo on null, niin siin‰ tapauksessa haetaan kaikkien asiakkaiden tiedot
			 asiakkaat = dao.listaaKaikki(); // eli kutsutaan daon listaaKaikki-metodia, mutta ei v‰litet‰ sille parametreja, esim. hakusanaa // localhost:8080/Asiakkaat/asiakkaat
			 strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
			 System.out.println(asiakkaat); //System.out.print tulostaa konsoliin
		}
		else if (pathInfo.indexOf("haeyksi")!=-1) { // jos polussa on mukana "haeyksi" k‰yttˆˆn otetaan t‰m‰ ehto // idexOf:lla haetaan merkki' tai merkkijonoa toisen merkkijonon sis‰ll‰ eli jos polku sis‰lt‰‰ merkkijonon "haeyksi", niin silloin k‰ettˆˆn otetaan t‰m‰ ehto ja haetaan yksi asiakas, se asiakas, jonka asiakas_id t‰h‰n napataan muutaAsiakas.jsp:st‰
			
			String asiakas_id = pathInfo.replace("/haeyksi/", ""); // t‰ss‰ napataan kiinni asiakas_id:n, parseroidaan se int arvoksi int asiakas_id=Integer.parseInt(pathInfo.replace("/haeyksi/", "")); ja poistetaan polusta /haeyksi/ n‰m‰ merkit ja korvataan ne "" (tyhj‰ll‰), niin j‰ljelle j‰‰ vain asiakas_id
			//huomio vaikka en muuttanut String asiakas_id:t‰ intiksi, koodi hyv‰ksyi sen silti. Johtuukohan siit‰, ett‰ JSONStringin‰ tulleet tiedot on muutettu JSONObjektiksi ja JSONObjektilta voi lukea arvot suoraan?
			// toisaalta t‰ss‰ kohtaa en kyll‰ ole luonut JsonObjektia ja l‰het‰n asiakas_id:n dao:n stringin‰. Miksi dao hyv‰ksyy sen kun luon uutta asiakasta: asiakas = new Asiakas(); asiakas.setAsiakas_id(rs.getInt(1)); Huom! getInt???
			// mit‰h‰n seurauksia t‰ll‰ voi olla??? ja miksi sain koodin ylip‰‰t‰‰n n‰in toimimaan, ilman String=>int muutosta???
			Asiakas asiakas = dao.etsiAsiakas(asiakas_id); // luodaan asiakas objekti ja kutsutaan dao:n etsiAsiakas-metodia ja v‰litet‰‰n sille parametrin‰ asiakas_id
			if(asiakas==null) { //jos dao:lle v‰litetty uusi asiakas (objekti) palauttaa null...
				strJSON = "{}";
			}
			else {
			JSONObject JSON = new JSONObject(); // luodaan uusi json objekti 
			JSON.put("asiakas_id", asiakas.getAsiakas_id());
			JSON.put("etunimi", asiakas.getEtunimi());		//put:lla vied‰‰n tiedot JSON objektiin
			JSON.put("sukunimi", asiakas.getSukunimi());
			JSON.put("puhelin", asiakas.getPuhelin());
			JSON.put("sposti", asiakas.getSposti());
			strJSON = JSON.toString();			// asetetaan tiedot palautus stringiin
			}
		}
		else { // jos polussa on hakusana mukana, haetaan hakusanan mukaiset asiakkaat ja k‰yttˆˆn otetaan t‰m‰ ehto // http://localhost:8080/Asiakkaat/asiakkaat/s
		String hakusana= pathInfo.replace("/", "");//korvataan pathInfo hakusanalla, esim. aalto (?)
		asiakkaat = dao.listaaKaikki(hakusana);
		strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
		System.out.println(asiakkaat); //System.out.print tulostaa konsoliin
		}
		
		response.setContentType("application/json"); //t‰ss‰ m‰‰ritell‰‰n sen kirjoituksen, joka tullaan kirjoittamaan, tyypiksi ("application/json");
		PrintWriter out = response.getWriter(); // PrintWriter, jonka nimi on out
		out.println(strJSON); // t‰ss‰ tulostetaan ulos (strJSON) selaimeen
		}
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()"); //t‰m‰ kirjoittaa konsoliin, sen mit‰ lainausmerkkien sis‰ll‰ on.
		JSONObject jsonObj= new JsonStrToObj().convert(request); // otetaan tietoa vastaan JSONOBJECT luokan
		//avulla. Ottaa vastaan kaikki kutsun mukana tulevat json Stringit ja muuttaa ne json objekteiksi. Json stringit ovat teksti‰, josta ei voi suoraan lukea arvoja. Siksi se pit‰‰ muuttaa objektiksi.
		//Kun tieto on json objektina silt‰ voidaan lukea suoraan arvoja
		Asiakas asiakas = new Asiakas(); // t‰ss‰ luodaan uusi asiakas Asiakas luokan parametrittˆm‰n konstruktorin avulla
		//asiakas.setAsiakas_id(jsonObj.getInt("asiakas_id")); // tietokannassa on p‰‰ll‰ autoincrement, mutta siit‰ huolimatta, jos ei muuta myˆs asiakas_id:t‰, niin ei anna lis‰t‰???
		//daossa pit‰‰ muistaa m‰‰ritt‰‰ mitk‰ arvot haluaa lis‰t‰, jos ei lis‰‰ kaikkia, siksi ignoorasi AN:n!!!
		
		asiakas.setEtunimi(jsonObj.getString("etunimi")); // t‰ss‰ asetetaan k‰ytt‰j‰n antamat arvot parametrittˆm‰‰n konstruktoriin
		asiakas.setSukunimi(jsonObj.getString("sukunimi")); //jotka luetaan json objektiksi muutetusta json stringist‰
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		
		
		response.setContentType("application/json"); //t‰ss‰ m‰‰ritell‰‰n sen kirjoituksen, joka tullaan kirjoittamaan, tyypiksi ("application/json");
		PrintWriter out = response.getWriter(); // PrintWriter, jonka nimi on out
		
		Dao dao = new Dao();
		if(dao.lisaaAsiakas(asiakas)) { //Huom! metodi palauttaa true tai false arvon
			out.println("{\"response\":1}"); //1= aiakkaan lis‰‰minen onnistui
		}
		else {
			out.println("{\"response\":0}"); // 0= asiakkaan lis‰‰‰minen ep‰onnistui
		}
	}

	/**
	 * @see HttpServlet#doPut(HttpServletRequest, HttpServletResponse)
	 */
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()");
		
		JSONObject jsonObj= new JsonStrToObj().convert(request); // otetaan tietoa vastaan JSONOBJECT luokan
		//avulla. Ottaa vastaan kaikki kutsun mukana tulevat json Stringit ja muuttaa ne json objekteiksi. Json stringit ovat teksti‰, josta ei voi suoraan lukea arvoja. Siksi se pit‰‰ muuttaa objektiksi.
		//Kun tieto on json objektina silt‰ voidaan lukea suoraan arvoja
		
		//int vanha_id = jsonObj.getInt("vanha_id"); jos id:t‰ tai siis taulun p‰‰avainta muutettaisiin?
		int asiakas_id = jsonObj.getInt("asiakas_id");
		Asiakas asiakas = new Asiakas(); // t‰ss‰ luodaan uusi asiakas Asiakas luokan parametrittˆm‰n konstruktorin avulla
		//asiakas.setAsiakas_id(jsonObj.getInt("asiakas_id")); // tietokannassa on p‰‰ll‰ autoincrement, mutta siit‰ huolimatta, jos ei muuta myˆs asiakas_id:t‰, niin ei anna lis‰t‰???
		//daossa pit‰‰ muistaa m‰‰ritt‰‰ mitk‰ arvot haluaa lis‰t‰, jos ei lis‰‰ kaikkia, siksi ignoorasi AN:n!!!
		asiakas.setAsiakas_id(asiakas_id);  //teht‰v‰n vastauksessa oli n‰in asiakas.setAsiakas_id(integer.parseInt(jsonObj.getString("asiakas_id))); Onko parserointi tarpeellinen, jos kerta jsonObjektilta voi lukea suoraan arvoja???
		// olisi varmaan voinut tehd‰ suoraan n‰inkin asiakas.setAsiakas(jsonObj.getInt("asiakas_id");, jos kerran suostuu lukemaan jsonOjektista arvot suoraan???
		asiakas.setEtunimi(jsonObj.getString("etunimi")); // t‰ss‰ asetetaan k‰ytt‰j‰n antamat arvot parametrittˆm‰‰n konstruktoriin
		asiakas.setSukunimi(jsonObj.getString("sukunimi")); //jotka luetaan json objektiksi muutetusta json stringist‰
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		
		
		response.setContentType("application/json"); //t‰ss‰ m‰‰ritell‰‰n sen kirjoituksen, joka tullaan kirjoittamaan, tyypiksi ("application/json");
		PrintWriter out = response.getWriter(); // PrintWriter, jonka nimi on out
		
		Dao dao = new Dao();
		if(dao.muutaAsiakas(asiakas, asiakas_id)) { //Huom! metodi palauttaa true tai false arvon voisi olla myˆs n‰in if(dao.muutaAsiakas(asiakas)) { ei tarvi erikseen v‰litt‰‰ en‰‰ asiakas_id parametria, huomioi muutokset dao muutaAsiakas metodissa
			out.println("{\"response\":1}"); //1= aiakkaan lis‰‰minen onnistui
		}
		else {
			out.println("{\"response\":0}"); // 0= asiakkaan lis‰‰‰minen ep‰onnistui
		}
		
	}

	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /5 (5=asiakas_id)			
		System.out.println("polku: "+pathInfo);	
		
			
		//String poistettava = pathInfo.replace("/", "");//pit‰iskˆh‰n t‰ss‰ muuttaa int asiakas_id jotenkin Stringiksi?
		// eikun stringi muutettiinkiin intiksi!!!
		int asiakas_id=Integer.parseInt(pathInfo.replace("/", "")); //poistetaan polusta "/" => kauttaviiva, j‰ljelle j‰‰ asiakas_id, joka muutetaan Integer.parseInt:ll‰ int tyyppiseksi arvoksi. Asiakas_id on tietokannassa int (AN) arvona! siksi... ehk‰?
		// toimiiko replace niin, ett‰ ensin tulee merkit, jotka poistetaan (/) ja pilkun j‰lkeen merkit("(tyhj‰)"), jotka halutaan tilalle???
		response.setContentType("application/json"); //t‰ss‰ m‰‰ritell‰‰n sen kirjoituksen, joka tullaan kirjoittamaan, tyypiksi ("application/json");
		PrintWriter out = response.getWriter(); // PrintWriter, jonka nimi on out
		Dao dao = new Dao();
		if(dao.poistaAsiakas(asiakas_id)) { //Huom! metodi palauttaa true tai false arvon
			out.println("{\"response\":1}"); //1= asiakkaan poistaminen onnistui
		}
		else {
			out.println("{\"response\":0}"); // 0= asiakkaan poistaminen ep‰onnistui
		}
	}

}
