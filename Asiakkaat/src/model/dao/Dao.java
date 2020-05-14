package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;


import model.Asiakas;

public class Dao {
	
	private Connection con=null;
	private ResultSet rs = null;
	private PreparedStatement stmtPrep=null; 
	private String sql;
	private String db ="Myynti.sqlite";
	
	
	private Connection yhdista(){		
    	Connection con = null;    	
    	String path = System.getProperty("catalina.base"); //mistä tää catalina.base ois pitänyt ymmärtää repäistä?????
    	path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/");
    	String url = "jdbc:sqlite:"+path+db;    	
    	try {	       
    		Class.forName("org.sqlite.JDBC");
	        con = DriverManager.getConnection(url);	
	        System.out.println("Yhteys avattu.");
	     }catch (Exception e){	
	    	 System.out.println("Yhteyden avaus epäonnistui.");
	        e.printStackTrace();	         
	     }
	     return con;

}
	
	public ArrayList<Asiakas> listaaKaikki() {
		
		ArrayList<Asiakas> asiakkaat = new ArrayList<Asiakas>();
		
		sql = "SELECT * FROM asiakkaat";
		
		try {
			con = yhdista();
			if (con != null) {
				stmtPrep = con.prepareStatement(sql);
				rs = stmtPrep.executeQuery();
				if (rs != null) {
					while (rs.next()) {
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}
				}
			}
			con.close();
		} catch (Exception e){
			e.printStackTrace();	
		}
		
		return asiakkaat;
	}
	
	public ArrayList<Asiakas> listaaKaikki(String hakusana){
		ArrayList<Asiakas> asiakkaat = new ArrayList<Asiakas>();
		sql = "SELECT * FROM asiakkaat WHERE etunimi LIKE ? or sukunimi LIKE ? or sposti LIKE ?";		
		try {
			con=yhdista();
			if(con!=null){ //jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);  
				stmtPrep.setString(1, "%" + hakusana + "%");
				stmtPrep.setString(2, "%" + hakusana + "%");   
				stmtPrep.setString(3, "%" + hakusana + "%");   
        		rs = stmtPrep.executeQuery();   
				if(rs!=null){ //jos kysely onnistui							
					while(rs.next()){
						Asiakas asiakas = new Asiakas();
						asiakas.setAsiakas_id(rs.getInt(1));
						asiakas.setEtunimi(rs.getString(2));
						asiakas.setSukunimi(rs.getString(3));
						asiakas.setPuhelin(rs.getString(4));
						asiakas.setSposti(rs.getString(5));
						asiakkaat.add(asiakas);
					}						
				}
				con.close();
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return asiakkaat;
	}
	
	public boolean lisaaAsiakas(Asiakas asiakas){ //parametrinä tulee asiakas
		boolean paluuArvo=true;
		sql="INSERT INTO asiakkaat (etunimi, sukunimi, puhelin, sposti) VALUES(?,?,?,?)";	//MUISTA! määritä arvot, mitä lisäät, jos et lisää arvoja kaikkiin (kyselyn kohteena olevan taulun) sarakkeisiin. Kuten tässä, kun ei lisätä arvoa AN kenttään, vaan etunimestä alkaen!!!					  
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql);
			stmtPrep.setString(1, asiakas.getEtunimi()); // tässä luetaan parametrinä tulleen asiakkaan tiedot
			stmtPrep.setString(2, asiakas.getSukunimi()); // tiedot asetetaan kysymysmerkkien kohdalle 1= eka ?=etunimi 2= toka?=sukunimi jne...
			stmtPrep.setString(3, asiakas.getPuhelin());
			stmtPrep.setString(4, asiakas.getSposti());
			stmtPrep.executeUpdate();
			//System.out.println("Uusin id on "+ stmtPrep.getGeneratedKeys().getInt(1)); näin saa tietää mikä on uusin id
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}
	
	public boolean poistaAsiakas(int asiakas_id) {
		boolean paluuArvo=true;
		sql="DELETE FROM asiakkaat WHERE asiakas_id=?";
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql); //tässä "valmistellaan SQL-lauseke
			stmtPrep.setInt(1, asiakas_id); // tässä katenoidaan parametrinä tullut asiakas_id kiinni SQL-lauseen ?-merkkiin
			stmtPrep.executeUpdate();		// MUISTA! tää pitää olla, koska executeUpdate suorittaa päivityksen. Koodi ei tee mitään, jos tätä ei oo!!!
			 //Huom! oikeasti ei poistella tietoja, vaan ne vain merkitään "poistetuksi" tietokannan taulussa olisi sarake, jossa arvo 1 tai 0, vertaa tuotteet continued kenttä Tietokannat kurssilla
			con.close();
	} catch (Exception e) {				
		e.printStackTrace();
		paluuArvo=false;
	}				
	return paluuArvo;
}
	
	public Asiakas etsiAsiakas(String asiakas_id) {  //public Asiakas etsiasiakas(int asiakas_id) jos olisin muuttanut servletistä tulevan arvon intiksi
		Asiakas asiakas = null;
		sql = "SELECT * FROM asiakkaat WHERE asiakas_id = ?"; // haetaan kaikki asiakkaat taulusta kun asiakas_id on parametrina tullut asiakas_id
		try {
			con = yhdista();
			if (con != null) {
			stmtPrep = con.prepareStatement(sql); //tässä "valmistellaan SQL-lauseke
			stmtPrep.setString(1, asiakas_id); // tässä katenoidaan parametrinä tullut asiakas_id kiinni SQL-lauseen ?-merkkiin //stmtPrep.setInt(1, asiakas_id); jos olisin muuttanut servletistä tulevan arvon intiksi
			rs = stmtPrep.executeQuery();		// MUISTA! tää pitää olla, koska executeQuery suorittaa SQL-kyselyn.
			if (rs.isBeforeFirst()) { 		//jos kysely tuotti dataa, eli asiakas_id on käytössä // rs.isBeforeFirst => "kursori" on kytiksellä ennen ekaa datariviä
				rs.next();
				asiakas = new Asiakas(); //luodaan asiakas ja annetaan sille arvot
				asiakas.setAsiakas_id(rs.getInt(1));  //huomio hyväksyi suoraan tähän int arvon vaikka servlettiin otin vastaan asiakas_id:n stringinä, enkä siellä muuttanut sitä intiksi???
				asiakas.setEtunimi(rs.getString(2));
				asiakas.setSukunimi(rs.getString(3));
				asiakas.setPuhelin(rs.getString(4));
				asiakas.setSposti(rs.getString(5));	
				
				// uuden asiakkaan voi luoda myös näin asiakas= new Asiakas(rs.getInt("asiakas_id"), rs.getString("etunimi"), rs.getString("sukunimi"), rs.getString("puhelin"), rs.getString("sposti"));
			}
			}
			con.close();
	} catch (Exception e) {				
		e.printStackTrace();
		}				
	return asiakas;
	}
	
	public boolean muutaAsiakas(Asiakas asiakas, int asiakas_id) { // voi olla myös näin jos servletin doPutista välitetään vain asiakas objekti parametrina public boolean muutaAsiakas(Asiakas asiakas) {
		boolean paluuArvo = true;
		sql = "UPDATE asiakkaat SET etunimi=?, sukunimi=?, puhelin=?, sposti=? WHERE asiakas_id=?";
		try {
			con = yhdista();
			stmtPrep = con.prepareStatement(sql);
			
			stmtPrep.setString(1, asiakas.getEtunimi()); // tässä luetaan parametrinä tulleen asiakkaan tiedot
			stmtPrep.setString(2, asiakas.getSukunimi()); // tiedot asetetaan kysymysmerkkien kohdalle 1= eka ?=etunimi 2= toka?=sukunimi jne...
			stmtPrep.setString(3, asiakas.getPuhelin());
			stmtPrep.setString(4, asiakas.getSposti());
			stmtPrep.setInt(5, asiakas_id);  //jos servletista ei välitetä asiakas_id:ta parametrina niin, stmtPrep.setInt(5, asiakas.getAsiakas_id());
			stmtPrep.executeUpdate();
			//System.out.println("Uusin id on "+ stmtPrep.getGeneratedKeys().getInt(1)); näin saa tietää mikä on uusin id
	        con.close();
		} catch (Exception e) {				
			e.printStackTrace();
			paluuArvo=false;
		}				
		return paluuArvo;
	}
}
