<%@page language='java' contentType='text/html'%>
<%@page import="java.io.*,javax.servlet.ServletException,javax.servlet.http.*,java.sql.*,java.util.Date"%>
<html>
<head>
    <meta name="viewport" content="width=device-width" />
    <title>FAST CASH WITHDRAW</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">
</head>
<body>
<form method="POST">
        <div style="background: linear-gradient(to bottom, #0099ff 0%, #fff 100%); margin-top: 250px; padding:50px; border: 2px solid;"class="container body-content">WELCOME!! Your Account Number: <%=session.getAttribute("customerid")%>	
            <div class="container" style="text-align: center"><h4 style="text-align: center; font-size: 25px;color: #000;text-transform: uppercase;font-weight: bold;border-radius: 5px;"> FAST-WITHDRAW MONEY</h4>
    		<div class="row justify-content-start" style="padding-top:10px; text-align: center;">
    			<div class="col" style="padding-top:10px; padding-left: 100px;">ENTER MONEY YOU WANT TO WITHDRAW(FAST WITHDRAWAL):
    				<label><select style="padding: 5px;border-radius: 10px;" class="form-control" name="withdrawmoney" id="withdrawmoney">
    							<option selected="true" disabled="true"></option>
    							<option value="500">500 Rs</option>
    							<option value="1000">1000 Rs</option>
    							<option value="2000">2000 Rs</option>
    							<option value="5000">5000 Rs</option>
    							<option value="10000">10000 Rs</option>
    						</select>
    				</label>
                </div>
            </div>
            <div class="row justify-content-center" style="padding-top:10px;">
                <input type="submit" class="btn btn-primary" name="withdrawtmoney" id="withdrawtmoney" onclick="getInputValue();" value="WITHDRAW">
            </div>
            <div class="row justify-content-center" style="padding-top:10px;">
                <a href="/CustomerHomePage">GO BACK
            </div>
    	</div>
        </div>
    </form>
    <script>
        function getInputValue(){
            // Selecting the input element and get its value 
            var inputVal = document.getElementById("withdrawmoney").value;
            // Displaying the value
            alert("You want to withdraw: "+inputVal+"RS");
        }
    </script>
<%
String username = "root";
String password = "muskan"; /*root user's password needs to be written here*/
Connection conn = null;
PreparedStatement stmt = null;
Statement stmt2 = null;
ResultSet rs = null;
ResultSet rs2 = null;
String url = "jdbc:mysql://localhost:3306/AtmDatabase";
String uid = (String)session.getAttribute("userid");
String cid = (String)session.getAttribute("customerid");
try{
    Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
    conn = DriverManager.getConnection(url, username, password);
    String withdraw =request.getParameter("withdrawmoney");
    String query = "insert into bank_transaction(transaction_type,transaction_amount,balance,customerid) values(?,?,?,?)";
    stmt = conn.prepareStatement(query);
    stmt2 = conn.createStatement();
    stmt2.executeUpdate("update bank_transaction SET balance  = balance - '"+withdraw+"' where customerid='"+cid+"';");
    rs = stmt.executeQuery("select * from bank_transaction where customerid='"+cid+"';");
    if(rs.next()){
    	session.setAttribute("balance",rs.getString("balance"));
        String bal = (String)session.getAttribute("balance");
        stmt.setString(1,"FastWithdraw");
        stmt.setString(2,withdraw);
        stmt.setString(3,bal);
        stmt.setString(4,cid);
        int i = stmt.executeUpdate();
        if(i!=0)
        {%>
            <script language="javascript">
            confirm("Withdraw Successfull...Redirecting to Homepage");
            window.location = '/CustomerHomePage';
            </script>
        <%}
        else
        {%>
            <script language="javascript">
            confirm("sorry");
            //window.location = '/CustomerHomePage';
            </script>
        <%}
    }else
        response.sendRedirect("/error");
}
catch(ClassNotFoundException e)
{
    System.out.println("Driver Not Loaded");
}catch (SQLException e) {
}finally {
    if(conn!=null)
    {   try{
            conn.close();
        }catch(Exception e){}
    }
}
%>
</body>
</html>	