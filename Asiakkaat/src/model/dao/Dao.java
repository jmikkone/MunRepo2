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
    	String path = System.getProperty("catalina.base"); //mist‰ t‰‰ catalina.base ois pit‰nyt ymm‰rt‰‰ rep‰ist‰?????
    	path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/");
    	String url = "jdbc:sqlite:"+path+db;    	
    	try {	       
    		Class.forName("org.sqlite.JDBC");
	        con = DriverManager.getConnection(url);	
	        System.out.println("Yhteys avattu.");
	     }catch (Exception e){	
	    	 System.out.println("Yhteyden avaus ep‰onnistui.");
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
	
	public boolean lisaaAsiakas(Asiakas asiakas){ //parametrin‰ tulee asiakas
		boolean paluuArvo=true;
		sql="INSERT INTO asiakkaat (etunimi, sukunimi, puhelin, sposti) VALUES(?,?,?,?)";	//MUISTA! m‰‰rit‰ arvot, mit‰ lis‰‰t, jos et lis‰‰ arvoja kaikkiin (kyselyn kohteena olevan taulun) sarakkeisiin. Kuten t‰ss‰, kun ei lis‰t‰ arvoa AN kentt‰‰n, vaan etunimest‰ alkaen!!!					  
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql);
			stmtPrep.setString(1, asiakas.getEtunimi()); // t‰ss‰ luetaan parametrin‰ tulleen asiakkaan tiedot
			stmtPrep.setString(2, asiakas.getSukunimi()); // tiedot asetetaan kysymysmerkkien kohdalle 1= eka ?=etunimi 2= toka?=sukunimi jne...
			stmtPrep.setString(3, asiakas.getPuhelin());
			stmtPrep.setString(4, asiakas.getSposti());
			stmtPrep.executeUpdate();
			//System.out.println("Uusin id on "+ stmtPrep.getGeneratedKeys().getInt(1)); n‰in saa tiet‰‰ mik‰ on uusin id
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
			stmtPrep=con.prepareStatement(sql); //t‰ss‰ "valmistellaan SQL-lauseke
			stmtPrep.setInt(1, asiakas_id); // t‰ss‰ katenoidaan parametrin‰ tullut asiakas_id kiinni SQL-lauseen ?-merkkiin
			stmtPrep.executeUpdate();		// MUISTA! t‰‰ pit‰‰ olla, koska executeUpdate suorittaa p‰ivityksen. Koodi ei tee mit‰‰n, jos t‰t‰ ei oo!!!
			 //Huom! oikeasti ei poistella tietoja, vaan ne vain merkit‰‰n "poistetuksi" tietokannan taulussa olisi sarake, jossa arvo 1 tai 0, vertaa tuotteet continued kentt‰ Tietokannat kurssilla
			con.close();
	} catch (Exception e) {				
		e.printStackTrace();
		paluuArvo=false;
	}				
	return paluuArvo;
}
		
}
