<%@page import="java.sql.*" %>
<html>
    <head>
      <title>:::Stock Objects:::</title>
      <style type="text/css">
          option{font-size: 15pt}
      </style>
    </head>
    <body link="blue" alink="blue" vlink="blue"  bgcolor="lightblue">
        <h1 align="center" style="color:red">Stock Objects Similarity Measure</h1><hr><hr>
        <br>
        <form method="post" action="calc.jsp">
            <table align="center">
                <tr>
                    <td><font size="+2">Select Company</font></td>  
                    <td></td>
                    <td></td>
                    <td>
                        <select name="ticker">
								<%
									try
									{
												Class c = Class.forName("com.mysql.jdbc.Driver");
									            Connection con= DriverManager.getConnection("jdbc:mysql://localhost:3306/stock","root","root");
									            Statement stmt=con.createStatement();
									            String qry="select distinct ticker from stockdata1";
									            ResultSet rs=stmt.executeQuery(qry);    
									            while(rs.next())
									            {    
								%>
														<option value="<%=rs.getString(1)%>" style="font-size: 15pt"><%=rs.getString(1)%></option>
								<%
									            }     
									} catch(Exception e) {
								      	System.out.println("Exception Occured:::"+e);
									}  
								%>                           
                        </select>    
                    </td>
                </tr>
                <tr></tr> 
                <tr></tr>
                <tr></tr>
                <tr>
		              <td><font size="+2">Select Date</font></td>
		              <td></td>
		              <td></td>
		              <td>
		                  <script type="text/javascript">
								var month_array = new Array();
								
								month_array[0] = "January";
								month_array[1] = "February";
								month_array[2] = "March";
								month_array[3] = "April";
								month_array[4] = "May";
								month_array[5] = "June";
								month_array[6] = "July";
								month_array[7] = "August";
								month_array[8] = "September";
								month_array[9] = "October";
								month_array[10] = "November";
								month_array[11] = "December";
								
								document.write('<select name="day">');
								var i = 1;
								while ( i <= 31 ) {
								   document.write('<option value=' + i + '>' + i + '</option>');
								    i++;
								}
								document.write('</select>');
								
								document.write('<select name="month">');
								var i = 1;
								while ( i <= 12 ) {
								   document.write('<option value=' + i + '>' + month_array[i-1] + '</option>');   
								   i++;
								}
								document.write('</select>');
								
								document.write('<select name="year">');
								var i = 1993;
								while ( i <= 2014 ) {   
								   document.write('<option value=' + i + '>' + i + '</option>');   
								   i++;
								}
								document.write('</select>');
							</script>
		              </td>
          		</tr>
                <tr></tr> 
                <tr></tr>
                <tr>
                	<td><font size="+2">Select Duration</font></td>
                	<td></td>
             		<td></td>
                	<td>
                		<select name="duration">
                			<option value="5">5</option>
                			<option value="10">10</option>
                			<option value="20">20</option>
                			<option value="60">60</option>
                		</select>
                	</td>
                </tr>
                <tr>
                    <td><font size="+2">Select Attribute</font></td>
                    <td></td>
                    <td></td>
                    <td>
                          <input type="checkbox" name="bidlo" value="bidlo">Bid or Low<br>
                          <input type="checkbox" name="askhi" value="askhi">Ask or High<br>
                          <input type="checkbox" name="prc" value="prc">Closing Price<br>
                          <input type="checkbox" name="vol" value="vol">Share Volume<br>
                          <input type="checkbox" name="bid" value="bid">Closing Bid<br>
                          <input type="checkbox" name="ask" value="ask">Closing Ask<br>
                          <input type="checkbox" name="shrout" value="shrout">Number of Shares Outstanding<br>
                          <input type="checkbox" name="openprc" value="openprc">Price Open<br>
                          <input type="checkbox" name="numtrd" value="numtrd">Number of Trades<br>
                          <input type="checkbox" name="vwretd" value="vwretd">Value-Weighted Return<br>
                    </td>
                </tr>
                <tr></tr>
                <tr></tr>
                <tr></tr>
                <tr align="center">
                    <td colspan="2">
                        <input type="submit" value="Analyze Data" name="Analyze Data">
                    </td>
                </tr>
            </table>    
        </form>    
    </body>
</html>