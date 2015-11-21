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

	public String dt;
	public String ticker;
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

	public  Float BildoForGiven;

	public   Connection connection ;
	public   Statement statement;
	
	public List<Stockdata1> main(String ticker, String date, int number) {

		List<Stockdata1> givenStockList = getBydate(ticker, date, number);

		List<Stockdata1> stockListKO = getByCompany("KO");

		BildoForGiven = getHForBildo(givenStockList);

		return findSimalarity(stockListKO, number);
	}

	public List<Stockdata1> findSimalarity(List<Stockdata1> list, int counter) {
		Float averageOfMiniList;
		List<Stockdata1> miniList = new ArrayList<Stockdata1>();

		for (int i = 0; i < list.size(); i= i+counter) {
			miniList = list.subList(i, i+counter);
			averageOfMiniList = getHForBildo(miniList);

			if (isSimilar(BildoForGiven, averageOfMiniList )) {
				return miniList;
			}
		}

		return null;
	}

	// avg1 is the supreme one.
	public boolean isSimilar(Float avg1, Float avg2 ) {
		float percent = (avg1 * 100.0f) / 10;

		return (avg1< avg2+percent || avg1>avg2-percent);
	}

	public Float getHForBildo(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getBidlo()).floatValue()));
			}
		}

		if (sum == 0) {
			return (float) 0;
		}
		return stockList.size() / sum.floatValue();
	}
	public float getHForAskhi(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getAskhi()).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public float getHForPrc(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getPrc()).floatValue()));
			}
		}


		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public float getHForVol(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getVol()).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public float getHForBid(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getBid()).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public float getHForAsk(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getAsk()).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public float getHForOpenrc(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getOpenprc()).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public float getHForNumtrd(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getNumtrd()).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public float getHForVwretd(List<Stockdata1> stockList) {
		Double sum = new Double(0);

		for (Stockdata1 stock : stockList) {
			if (stock.getBidlo() != null && !stock.getBidlo().equals("0")){
				sum = sum + (new Double(1.0 / new BigDecimal(stock.getVwretd()).floatValue()));
			}
		}

		if (sum == 0) {
			return 0;
		}
		return stockList.size() / sum.floatValue();
	}

	public List<Stockdata1> getStockdata1(String Stockdata1Id) throws SQLException {
		String query = "SELECT * FROM Stockdata1 WHERE dt=" + Stockdata1Id;
		ResultSet rs = null;
		List<Stockdata1> stock = new ArrayList<Stockdata1>();
		try {
			connection = createConnection();
			statement = connection.createStatement();
			rs = statement.executeQuery(query);
			stock =  convertToListStockData1(rs);
		} finally {
			close(rs);
			close(statement);
			close(connection);
		}
		return stock;
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
			System.out.println("Bubu in the converter");
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

//Mock data
similarCompanies.put("KO","June 2012");

//CODE HERE

Similar similar = new Similar();
List<Stockdata1> stockdatas = similar.main("MSFT", "19960603", 5);

String dataJson = "{\"bidlo\":[";
for(Stockdata1 stockData : stockdatas) {
	dataJson = dataJson + "{\"date\":\""+stockData.getDt()+"\",\"value\":\""+stockData.getBidlo()+"\"},";
}
dataJson = dataJson.substring(0, dataJson.length()-1);
dataJson = dataJson + "]}";

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
					String date = dataJson;
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