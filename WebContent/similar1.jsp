<%@page import="java.sql.*" %>

<html>
    <head>
      <title>:::Stock Objects:::</title>
      <style type="text/css">
          option{font-size: 15pt}
      </style>
    </head>
    <body link="blue" alink="blue" vlink="blue" bgcolor="lightblue">
        <h1 align="center" style="color:red">Stock Objects Similarity Measure</h1><hr><hr>
        <br>
        <a href="load.jsp" style="font-size: 20pt"><b>Load Dataset</b></a>&nbsp;&nbsp;&nbsp;&nbsp;
        <a href="similar.jsp" style="font-size: 20pt"><b>Similarity Measure</b></a>
        <br><br><br><br>
<%
String attr=request.getParameter("attr");
session.setAttribute("attr", attr);
System.out.println("****Selected Company****");
String ticker=request.getParameter("ticker");
session.setAttribute("ticker", ticker);
System.out.println(ticker);
String day=request.getParameter("day");
session.setAttribute("day", day);
int day1=Integer.parseInt(day);
if(day1>=1 && day1<=9)
{
    day="0"+day;
}    
String month=request.getParameter("month");
session.setAttribute("month", month);
int month1=Integer.parseInt(month);
if(month1>=1 && month1<=9)
{
    month="0"+month;
}  
String year=request.getParameter("year");
session.setAttribute("year", year);
int d1=day1+1;
if(d1>=1 && d1<=9)
{
    day="0"+day;
} 
System.out.println("*****6 Dates*****");
String d=null;
float col[] = new float[100];
String date=null;
int i,j=0;
for(i=1;i<=6;i++)
{
    //System.out.println(day1);
    if(day1>=1 && day1<=9)
    {
           d=Integer.toString(day1);
           d="0"+d;
    } 
    else
    {
        d=Integer.toString(day1);
    } 
    date=year+month+d;
    System.out.println(date);
    try
    {
		Class c = Class.forName("com.mysql.jdbc.Driver");
        Connection con= DriverManager.getConnection("jdbc:mysql://localhost:3306/stock","root","root");
        ResultSet rs= con.createStatement().executeQuery("select "+attr+" from stockdata1 where ticker='"+ticker+"' and dt='"+date+"'         ");
        if(rs.next())
        {
            col[j]=rs.getFloat(1);
        } 
        if(rs.next()==false)
        {
            ;
        }    
    }   
    catch(Exception e)
    {
        System.out.println(e);
    }    
    j++;
    day1=day1+1;
}    
int k;
System.out.println("*****Price Values*****");
for(k=0;k<j;k++)
{
    System.out.println(col[k]);
}    
int p,count=0;
float var=0.0f;
System.out.println("*****Differences*****");
for(p=0;p<5;p++)
{
        var=col[p+1]-col[p];
        if(var>0)
        {
            count=count+1;
        }    
        System.out.println(var);  
}    
System.out.println("increases:::"+count);
response.sendRedirect("similar2.jsp?"+count+"");
%>
    </body>
</html>