<%@ Page Language="C#"%>
<%@ Import Namespace=Microsoft.Win32 %>

<script runat="server">
  void Page_Load(Object s, EventArgs e) 
  {
    Label1.Text = "The .NET Framework <b>is</b> correctly installed and working";
    Label2.Text = "Running on machine " + Environment.MachineName + " at " + System.DateTime.Now.ToString();
  }    
</script>


<!DOCTYPE html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>ASP.NET Test</TITLE>
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
					ASP.NET Test
				</td>
			</tr>
		</table>
		<br><br>
		<table style="background-color: #ffffff; width: 500px; border width: 1px solid #666666;" cellpadding="8">
			<tr>
				<td style="line-height:18px">
					This form will determine if .NET is working correctly <hr noshade width='90%' size='1px'>

				<asp:Label ID="Label1" Runat="server">If you can read this then .NET is <b>not</b> working correctly!</asp:Label><br><br>
				<asp:Label ID="Label2" Runat="server"></asp:Label>
				</td>
			</tr>
		</table>
		<p>&nbsp</p>
</div>
</BODY>
</HTML>