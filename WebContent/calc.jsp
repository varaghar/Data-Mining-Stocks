<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.math.BigDecimal" %>

<%
String ticker=request.getParameter("ticker");
String day=request.getParameter("day");
String month=request.getParameter("month");
String year=request.getParameter("year");
String duration=request.getParameter("duration");
String bidlo=request.getParameter("bidlo");
String askhi=request.getParameter("askhi");
String prc=request.getParameter("prc");
String vol=request.getParameter("vol");
String ask=request.getParameter("ask");
String shrout=request.getParameter("shrout");
String openprc=request.getParameter("openprc");
String numtrd=request.getParameter("numtrd");
String vwretd=request.getParameter("vwretd");

final class Stockdata1 {
	public String ticker;
	
	public String dt;
	public String bidlo;
	public String askhi;
	public String prc;
	public String vol;
	public String bid;
	public String ask;
	public String shrout;
	public String openprc;
	public String numtrd;
	public String vwretd;
	
	public String get(String attribute){
        if(attribute.equals("dt")){
       		return dt;
        }
        if(attribute.equals("bidlo")){
       		return bidlo;
        }
        if(attribute.equals("askhi")){
       		return askhi;
        }
        if(attribute.equals("prc")){
       		return prc;
        }
        if(attribute.equals("vol")){
       		return vol;
        }
        if(attribute.equals("bid")){
       		return bid;
        }
        if(attribute.equals("ask")){
       		return ask;
        }
        if(attribute.equals("shrout")){
       		return shrout;
        }
        if(attribute.equals("openprc")){
       		return openprc;
        }
        if(attribute.equals("numtrd")){
       		return numtrd;
        }
        if(attribute.equals("vwretd")){
       		return vwretd;
        }
        return "";
	}

	public String getDt() {
		return dt;
	}
	public void setDt(String dt) {
		this.dt = dt;
	}
	public String getTicker() {
		return ticker;
	}
	public void setTicker(String ticker) {
		this.ticker = ticker;
	}
	public String getBidlo() {
		return bidlo;
	}
	public void setBidlo(String bidlo) {
		this.bidlo = bidlo;
	}
	public String getAskhi() {
		return askhi;
	}
	public void setAskhi(String askhi) {
		this.askhi = askhi;
	}
	public String getPrc() {
		return prc;
	}
	public void setPrc(String prc) {
		this.prc = prc;
	}
	public String getVol() {
		return vol;
	}
	public void setVol(String vol) {
		this.vol = vol;
	}
	public String getBid() {
		return bid;
	}
	public void setBid(String bid) {
		this.bid = bid;
	}
	public String getAsk() {
		return ask;
	}
	public void setAsk(String ask) {
		this.ask = ask;
	}
	public String getShrout() {
		return shrout;
	}
	public void setShrout(String shrout) {
		this.shrout = shrout;
	}
	public String getOpenprc() {
		return openprc;
	}
	public void setOpenprc(String openprc) {
		this.openprc = openprc;
	}
	public String getNumtrd() {
		return numtrd;
	}
	public void setNumtrd(String numtrd) {
		this.numtrd = numtrd;
	}
	public String getVwretd() {
		return vwretd;
	}
	public void setVwretd(String vwretd) {
		this.vwretd = vwretd;
	}
}

final class Similar {
	
	public   Connection connection ;
	public   Statement statement;
	
	//Mode 0 = harmonic mean Mode 1 = runing average 2 = least squares
	public Map<String, List<Stockdata1>> main(String ticker, String date, int number, List<String> attributes, int mode) {

		Map<String, List<Stockdata1>> finalresult = new HashMap<String,List<Stockdata1>>();
		//THE FIRST SHOULD BE PARAMETRIZED WITH THE GIVEN PARAMS FROM THE FRONT_END
		List<Stockdata1> givenStockList = getBydate("MRK", "19960603", number);
		//Map to hold measure for chosen company
		Map<String, Float> measureForAttribute = new HashMap<String, Float>();
		for(String attribute : attributes){
			measureForAttribute.put(attribute, getForAttribute(givenStockList,attribute,mode,givenStockList));
		}

		//replace with something generic later
		List<String> companies = new LinkedList<String>();
		companies.add("PFE");
		companies.add("MMM");
		companies.add("MRK");
		companies.add("DIS");
		companies.add("MCD");
		companies.add("JPM");
		companies.add("NKE");
		companies.add("WMT");
		companies.add("MSFT");
		companies.add("AXP");
		companies.add("INTC");
		companies.add("TRV");
		companies.add("VZ");
		companies.add("KO");
		companies.add("DD");
		companies.add("XOM");
		companies.add("GE");
		companies.add("IBM");
		companies.add("CVS");
		companies.add("AAPL");
		companies.add("UTX");
		companies.add("PG");
		companies.add("CAT");
		companies.add("BA");
		companies.add("JNJ");
		
		for (String company : companies){
			finalresult.put(company, getResultsForCompany(company, number, attributes, measureForAttribute, givenStockList, mode));
		}

		return finalresult;
	}
	
	
	public List<Stockdata1> getResultsForCompany(String company, int counter, List<String> attributes, Map<String, Float> measureForAttribute, List<Stockdata1> givenStockList, int mode) {

		List<Stockdata1> stockList = getByCompany(company);
		HashMap<String, List<Stockdata1>> attributeMap = new HashMap<String, List<Stockdata1>>();
		Float averageOfMiniList;
		
		//Find similar parts
		List<Stockdata1> miniList = new ArrayList<Stockdata1>();
		for (int i = 0; i < stockList.size()-counter; i++) {
			miniList = stockList.subList(i, i+counter);
			int countOfSimilar = attributes.size();
			
			for(String attribute : attributes){
				if(mode == 2) {
					float dif = 0;
					float sum =0;
					int index=0;
					for(Stockdata1 entry : miniList){
						float reference = new Float(givenStockList.get(index).get(attribute));
						index++;
						sum+=reference;
						dif+= Math.sqrt(Math.pow(new Float(entry.get(attribute))-reference,2));
					}
					if(dif<100){
						System.out.println(dif);
						countOfSimilar--;
					}
					
				} else {
					averageOfMiniList = getForAttribute(miniList, attribute, mode, givenStockList);
					if (isSimilar(measureForAttribute.get(attribute), averageOfMiniList )) {
						countOfSimilar--;
					}
				}
			}
			
			if(countOfSimilar == 0){
				return miniList;
			}
		}
		
		return null;
	}

	public boolean isZero(float value){
	    return value >= -0.02 && value <= 0.02;
	}
	

	public boolean isSimilar(Float avg1, Float avg2 ) {
		if(avg1==null || avg2 == null) {
			return false;
		}
		
		float percent = (avg1) / 100;
		return (avg1< avg2+percent && avg1>avg2-percent);
	}	
	
	
	public float getForAttribute(List<Stockdata1> stockList, String attribute, int mode, List<Stockdata1> givenStockList) {
		if (mode == 0){
			return getHarmonicMeanForAttribute(stockList, attribute);
		}
		
		if (mode == 1){
			return getWeightedMovingAverageForAttribute(stockList, attribute);
		}
		
		if(mode == 2){
			
		}
		
		return 0;
	}
	
	//Returns the harmonic mean for an attribute of the list
	public float getHarmonicMeanForAttribute(List<Stockdata1> stockList, String attribute) {
		Double sum = new Double(0);
		for (Stockdata1 stock : stockList) {
			String clean = stock.get(attribute).replaceAll("\\s", "").replace(',', '.');

			if (stock.getShrout() != null && !isZero(new BigDecimal(clean).floatValue())){
				sum = sum + (new Double(1.0 / new BigDecimal(clean).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}
	
	
	public float getWeightedMovingAverageForAttribute(List<Stockdata1> stockList, String attribute) {
		float sum = 0;
		int counter = stockList.size();
		int div = (counter +1)*counter/2;
		for (Stockdata1 stock : stockList) {
			sum+=new Float(stock.get(attribute))*counter;
			counter--;
		}
		
		if(!isZero(div)) {
			return sum/div;
		} else {
			return 0;
		}
	}
	
	

	public List<Stockdata1> getBydate(String companyName, String startingDate, int number) {
		String query = "SELECT * FROM StockData1 WHERE ticker='" + companyName + "' AND dt> " + startingDate + " LIMIT "+number ;
		ResultSet rs = null;
		List<Stockdata1> stock = new ArrayList<Stockdata1>();
		try {
			connection = createConnection();
			statement = connection.createStatement();
			rs = statement.executeQuery(query);
			stock =  convertToListStockData1(rs);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(statement);
			close(connection);
		}
		return stock;
	}

	public List<Stockdata1> getByCompany(String companyName) {
		String query = "SELECT * FROM StockData1 WHERE ticker='" + companyName + "'";
		ResultSet rs = null;
		List<Stockdata1> stock = new ArrayList<Stockdata1>();
		try {
			connection = createConnection();
			statement = connection.createStatement();
			rs = statement.executeQuery(query);
			stock =  convertToListStockData1(rs);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs);
			close(statement);
			close(connection);
		}
		return stock;
	}



	private List<Stockdata1> convertToListStockData1(ResultSet rs) {
		Stockdata1 stock = new Stockdata1();
		List<Stockdata1> stockList = new ArrayList<Stockdata1>();

		try {
			while (rs.next()) {
				stock = new Stockdata1();
				stock.setDt(rs.getString(1));
				stock.setTicker(rs.getString(2));
				stock.setBidlo(rs.getString(3));
				stock.setAskhi(rs.getString(4));
				stock.setPrc(rs.getString(5));
				stock.setVol(rs.getString(6));
				stock.setBid(rs.getString(7));
				stock.setAsk(rs.getString(8));
				stock.setShrout(rs.getString(9));
				stock.setOpenprc(rs.getString(10));
				stock.setNumtrd(rs.getString(11));
				stock.setVwretd(rs.getString(12));

				stockList.add(stock);
			}
		} catch (SQLException e) {
			System.out.println("Error in the converter");
			e.printStackTrace();
		}

		return stockList;
	}

	private Connection createConnection() {
		Connection connection = null;
		try {
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/stock","root","root");
		} catch (SQLException e) {
			System.out.println("ERROR: Unable to Connect to Database.");
		}
		return connection;
	}

	public void close(Connection connection) {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				/*log or print or ignore*/
			}
		}
	}

	public void close(Statement statement) {
		if (statement != null) {
			try {
				statement.close();
			} catch (SQLException e) {
				/*log or print or ignore*/
			}
		}
	}

	public void close(ResultSet resultSet) {
		if (resultSet != null) {
			try {
				resultSet.close();
			} catch (SQLException e) {
				/*log or print or ignore*/
			}
		}
	}

}


Map<String, String> similarCompanies = new HashMap<String, String>();
Similar similar = new Similar();
List<String> attributes =  new LinkedList<String>();
attributes.add("bidlo");
// attributes.add("ask");
Map<String,List<Stockdata1>> stockdatas = similar.main("MSFT", "19960603", 60, attributes,2);
Map<String, String> companyDataJsons = new HashMap<String, String>();
Set<String> companyKeys = stockdatas.keySet();
Iterator<String> companyKeysIterator = companyKeys.iterator();

while (companyKeysIterator.hasNext()){
	boolean similarCompany = false;
	String companyKey = companyKeysIterator.next();
	if(stockdatas.get(companyKey)!=null) {
		// Check the similarity returned for each company and add date it was similar on
		List<Stockdata1> stockDataForCompanyAttribute = stockdatas.get(companyKey);
		if(!stockDataForCompanyAttribute.isEmpty()) {
			String dateOfSimilarity = stockDataForCompanyAttribute.get(0).getDt();
			similarCompanies.put(companyKey, dateOfSimilarity);
			
			//Format JSON containing the values required for graph creation
			String dataJson = "{";
			for (String attribute : attributes){
				dataJson = dataJson +"\""+attribute+"\":[";
					
				for(Stockdata1 stockdata: stockDataForCompanyAttribute) {
					dataJson = dataJson + "{\"date\":\""+stockdata.getDt()+"\",\"value\":\""+stockdata.get(attribute)+"\"},";
				}
				dataJson = dataJson.substring(0, dataJson.length()-1);//Remove last ,
				dataJson = dataJson + "],";
			}
			dataJson = dataJson.substring(0, dataJson.length()-1);//Remove last ,
			dataJson = dataJson + "}";
			if(dataJson.length()>1) {
				companyDataJsons.put(companyKey, dataJson);
			}
		}
	}
}


%>

<html>
    <head>
      <title>:::Stock Objects:::</title>
      <style type="text/css">
          option{font-size: 15pt}
      </style>
      <script src="jquery.js"></script>
      <script src="d3.min.js"></script>
      <style>
		body {
		  font: 10px sans-serif;
		}
		
		.axis path,
		.axis line {
		  fill: none;
		  stroke: #000;
		  shape-rendering: crispEdges;
		}
		
		
		.x.axis path {
		  display: none;
		}
		
		.bidlo {
		  fill: none;
		  stroke: steelblue;
		  stroke-width: 1.5px;
		}
		
		.vol {
		  fill: none;
		  stroke: red;
		  stroke-width: 1.5px;
		}
		
		.askhi {
		  fill: none;
		  stroke: green;
		  stroke-width: 1.5px;
		}
		
		.prc {
		  fill: none;
		  stroke: pink;
		  stroke-width: 1.5px;
		}
		
		.openprc {
		  fill: none;
		  stroke: brown;
		  stroke-width: 1.5px;
		}
		.shrout {
		  fill: none;
		  stroke: black;
		  stroke-width: 1.5px;
		}
		.ask {
		  fill: none;
		  stroke: yellow;
		  stroke-width: 1.5px;
		}
		.bid {
		  fill: none;
		  stroke: purple;
		  stroke-width: 1.5px;
		}
		.vol {
		  fill: none;
		  stroke: orange;
		  stroke-width: 1.5px;
		}
		.dt {
		  fill: none;
		  stroke: magenta;
		  stroke-width: 1.5px;
		}
		.numtrd {
		  fill: none;
		  stroke: gray;
		  stroke-width: 1.5px;
		}
		.vwretd {
		  fill: azure;
		  stroke: blue;
		  stroke-width: 1.5px;
		}
		

		</style>
    </head>
    <body link="blue" alink="blue" vlink="blue"  bgcolor="lightblue">
        <h1 align="center" style="color:red">Stock Objects Similarity Measure</h1><hr><hr>
        <br>
        <form>
            <table align="center">
                <tr>
                    <td><font size="+2">Selected Company</font></td>  
                    <td></td>
                    <td></td>
                    <td><font size="+2">comp</font></td>
                </tr>
                <tr></tr> 
                <tr></tr>
                <tr></tr>
                <tr></tr>
				
				<%
				Set<String> keys = similarCompanies.keySet();
				Iterator<String> it = keys.iterator();
				while(it.hasNext()){
					String key = it.next();
					String value = similarCompanies.get(key);
					out.println("<tr>");
					String date = companyDataJsons.get(key);
					out.println("<td class=\"similar\" data-graph="+date+"><font size=\"+1\">"+key+"</font></td>");
					out.println("<td></td>");
					out.println("<td></td>");
					out.println("<td>"+value+"</td>");
					out.println("</tr>");
					out.println("<tr></tr>");
					out.println("<tr></tr>");
					out.println("<tr></tr>");
				}
				%>

                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr align="center">
                    <td colspan="2">
                        <button type="button" id="graph" name="Generate graph">Generate graph</button>
                    </td>
                </tr>
            </table>    
        </form>    
    </body>
   <script src="graph.js"></script>
</html>