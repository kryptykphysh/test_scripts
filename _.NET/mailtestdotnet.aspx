<%@ Page Language="C#" trace="true" debug="true" %>
<%@ Import Namespace=System.Web.Mail %>
<script runat="server">
protected void Page_Load(Object Source, EventArgs E)
{
	if(Request.QueryString.Get("submit") == "true")
	{
		MailMessage oMsg = new MailMessage(); 
		oMsg.From = Request.Form.Get("from");
		oMsg.To = Request.Form.Get("to");
		oMsg.Subject = "Test Mail from " + Request.ServerVariables.Get("SERVER_NAME");
		oMsg.BodyFormat = MailFormat.Text;
		oMsg.Body = "I'm a Test Email from " + Request.ServerVariables.Get("SERVER_NAME");
		SmtpMail.SmtpServer = "smtp." + Request.ServerVariables.Get("SERVER_NAME").Replace("www.","");
		SmtpMail.Send(oMsg);
		Label1.Text = "Mail message has been sent";
	}
	else
	{
		Label1.Text = "<form action='?submit=true' method='post'><table border='0'><tr><td>Email To</td><td><input type='text' size='30'  name='to' value='test@" + Request.ServerVariables.Get("SERVER_NAME").Replace("www.","") + "' style='background-color:#f2f2f2;border-width:1px;border-style:Solid;'></td></tr><tr><td>Email From</td><td><input type='text' size='30' name='from' value='test@" + Request.ServerVariables.Get("SERVER_NAME").Replace("www.","") + "' style='background-color:#f2f2f2;border-width:1px;border-style:Solid;'></td></tr><tr><td></td><td align='right'><input type='submit' value='Test Mail' style='background-color:#f2f2f2;border-width:1px;border-style:Solid;'></td></tr></table></form>";
	}
}
</script>
<!DOCTYPE html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>ASP.NET Mail Test</TITLE>
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
					ASP.NET Mail Test
				</td>
			</tr>
		</table>
		<br><br>
		<table style="background-color: #ffffff; width: 500px; border width: 1px solid #666666;" cellpadding="8">
			<tr>
				<td style="line-height:18px">
					This form will attempt to send a mail using ASP.NET <hr noshade width='90%' size='1px'>

				<asp:Label ID="Label1" Runat="server"></asp:Label>
				</td>
			</tr>
		</table>
		<p>&nbsp</p>
</div>
</BODY>
</HTML>
