<!DOCTYPE html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>ASP Mail Test</TITLE>
<style>
body {
	background-color : #f2f2f2;
	color : #000000;
	font-family : verdana, geneva;
	font-size:11px;
	line-height:15px;
}


TD, P, PRE {
	color : #000000;
	font-family : verdana, geneva;
	font-size:11px;
	line-height:15px;
}

</style>
</HEAD>
<BODY>
<DIV align="center" style="margin-top:60px">
		<table style="background-color:#ffffff; width:500px; border width:1px solid #666666;" cellpadding="8">
			<tr>
				<td style="font-family: arial; font-size: 17px; font-weight: bold; color: #000000;">
					ASP & CDONTS Mail Test
				</td>
			</tr>
		</table>
		<br><br>
		<table style="background-color: #ffffff; width: 500px; border width: 1px solid #666666;" cellpadding="8">
			<tr>
				<td style="line-height:18px">
					This form will attempt to send a mail using ASP and CDONTS <hr noshade width='90%' size='1px'>
<%

	If (Request("to") <> "") and (Request("from") <> "") Then
		Set iMsg = Server.CreateObject("CDONTS.Newmail")
		iMsg.To = Request("to")
		iMsg.From = Request("from")
		iMsg.Subject = "Test email from " & Request("SERVER_NAME")
		iMsg.Body = "Test ASP & CDONTS email from " & Request("SERVER_NAME")
		iMsg.Send
		Set iMsg = Nothing
		Response.Write "Test Email sent"
	Else
		Response.Write "<form action='?' method='post'><table border='0'>" & _
			"<tr><td>Email To</td><td><input type='text' size='30'  name='to' value='test@" & Request("SERVER_NAME") & "' style='background-color:#f2f2f2;border-width:1px;border-style:Solid;'></td></tr>" & _
			"<tr><td>Email From</td><td><input type='text' size='30'  name='from' value='test@" & Request("SERVER_NAME") &  "' style='background-color:#f2f2f2;border-width:1px;border-style:Solid;'></td></tr>" & _ 
			"<tr><td></td><td align='right'><input type='submit' value='Test Mail' style='background-color:#f2f2f2;border-width:1px;border-style:Solid;'></td></tr>" & _
			"</table></form>"
	End If
	
%>
				</td>
			</tr>
		</table>
</div>
</BODY>
</HTML>
