<%@page language='java' contentType='text/html'%>
<%@page import="java.io.*,javax.servlet.ServletException,javax.servlet.http.*,java.sql.*,java.util.Date"%>

<% response.setContentType("text/html; charset=UTF-8");
String username = "root";
String password = "muskan"; /*root user's password needs to be written here*/
Connection conn = null;
PreparedStatement stmt = null;
PreparedStatement stmt2 = null;
ResultSet rs = null;
ResultSet rs2 = null;
String url = "jdbc:mysql://localhost:3306/AtmDatabase";
String uid = (String)session.getAttribute("userid");
String cid = (String)session.getAttribute("customerid");
int i=1;
int count =0;
try{
	Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
	conn = DriverManager.getConnection(url, username, password);
	stmt = conn.prepareStatement("select * from bank_transaction where customerid='"+cid+"';");
	rs = stmt.executeQuery();
	while(rs.next()){%>
	<tr><td><%=i%></td>
		<td><%=rs.getString("transactionid")%></td>
		<td><%=rs.getString("customerid")%></td>
		<td><%=rs.getString("transaction_date")%></td>
	 	<td><%=rs.getString("transaction_type")%></td>
	 	<td><%=rs.getString("transaction_amount")%></td></tr>
	<%i += 1;
	session.setAttribute("balance",rs.getString("balance"));
	}
}catch(ClassNotFoundException e) {
	System.out.println("Driver Not Loaded");
}catch (SQLException e) {
	System.out.println(e);
}finally {
	if(conn!=null)
	{	try{
			conn.close();
		}catch(Exception e){}
	}
}%>