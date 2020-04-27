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
 */
@WebServlet("/asiakkaat") //frontEndiss� viitataan t�h�n kohtaan kun haetaan backEndist� tietoja
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	//T�m� on backEndi�
       
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
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat = dao.listaaKaikki();
		System.out.println(asiakkaat);
		String strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();
		response.setContentType("application/json"); //t�ss� m��ritell��n sen kirjoituksen, joka tullaan kirjoittamaan, tyypiksi ("application/json");
		PrintWriter out = response.getWriter(); // PrintWriter, jonka nimi on out
		out.println(strJSON); // t�ss� tulostetaan ulos (strJSON)
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()");
		
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
	}

}
