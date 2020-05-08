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
 *//* asiakkaat per‰‰n lis‰t‰‰n /* t‰m‰ viittaa alikansioihin*/
@WebServlet("/asiakkaat/") //frontEndiss‰ viitataan t‰h‰n kohtaan kun haetaan backEndist‰ tietoja 
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

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()");
		
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /aalto			
		System.out.println("polku: "+pathInfo);	
		String hakusana="";
		if(pathInfo!=null) {		
		hakusana = pathInfo.replace("/", "");//korvataan pathInfo hakusanalla, esim. aalto (?)
		}
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat = dao.listaaKaikki(hakusana);
		System.out.println(asiakkaat); //System.out.print tulostaa konsoliin
		String strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
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
	}

	/**
	 * @see HttpServlet#doDelete(HttpServletRequest, HttpServletResponse)
	 */
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
