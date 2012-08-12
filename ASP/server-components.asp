<% @ Language="VBScript" %>
<% Option Explicit %>
<%
Dim theComponent(18)
Dim theComponentName(18)
'## the components
theComponent(0) = "Persits.Upload"
theComponent(1) = "Persits.Jpeg"
theComponent(2) = "SMTPsvg.Mailer"
theComponent(3) = "SMTPsvg.Mailer"
theComponent(4) = "CDONTS.NewMail"
theComponent(5) = "CDONTS.NewMail"
theComponent(6) = "CDO.Message"
theComponent(7) = "dkQmail.Qmail"
theComponent(8) = "Dundas.Mailer"
theComponent(9) = "Dundas.Mailer"
theComponent(10) = "Geocel.Mailer"
theComponent(11) = "iismail.iismail.1"
theComponent(12) = "Jmail.smtpmail"
theComponent(13) = "MDUserCom.MDUser"
theComponent(14) = "ASPMail.ASPMailCtrl.1"
theComponent(15) = "ocxQmail.ocxQmailCtrl.1"
theComponent(16) = "SoftArtisans.SMTPMail"
theComponent(17) = "SmtpMail.SmtpMail.1"
theComponent(18) = "VSEmail.SMTPSendMail"
'## the name of the components
theComponentName(0) = "ASP Upload"
theComponentName(1) = "ASP JPeg"
theComponentName(2) = "ASPMail"
theComponentName(3) = "ASPQMail"
theComponentName(4) = "CDONTS (IIS 3/4/5)"
theComponentName(5) = "Chili!Mail (Chili!Soft ASP)"
theComponentName(6) = "CDOSYS (IIS 5/5.1/6)"
theComponentName(7) = "dkQMail"
theComponentName(8) = "Dundas Mail (QuickSend)"
theComponentName(9) = "Dundas Mail (SendMail)"
theComponentName(10) = "GeoCel"
theComponentName(11) = "IISMail"
theComponentName(12) = "JMail"
theComponentName(13) = "MDaemon"
theComponentName(14) = "OCXMail"
theComponentName(15) = "OCXQMail"
theComponentName(16) = "SA-Smtp Mail"
theComponentName(17) = "SMTP"
theComponentName(18) = "VSEmail"
Function IsObjInstalled(strClassString)
 on error resume next
 ' initialize default values
 IsObjInstalled = False
 Err = 0
 ' testing code
 Dim xTestObj
 Set xTestObj = Server.CreateObject(strClassString)
 If 0 = Err Then IsObjInstalled = True
 ' cleanup
 Set xTestObj = Nothing
 Err = 0
 on error goto 0
End Function
Response.Write "<html>" & vbNewLine & _
  vbNewLine & _
  "<head>" & vbNewLine & _
  "  <title>E-mail Component Test</title>" & vbNewLine & _
  "</head>" & vbNewLine & _
  vbNewLine & _
  "<body bgColor=""white"" text=""midnightblue"" link=""darkblue"" aLink=""red"" vLink=""red"">" & vbNewLine & _
  "<font face=""Verdana, Arial, Helvetica"">" & vbNewLine & _
  "<table border=""0"" cellspacing=""0"" cellpadding=""0"" align=""center"">" & vbNewLine & _
  "  <tr valign=""top"">" & vbNewLine & _
  "	<td bgcolor=""black"">" & vbNewLine & _
  "	  <table border=""0"" cellspacing=""1"" cellpadding=""4"">" & vbNewLine & _
  "		<tr valign=""top"">" & vbNewLine & _
  "		  <td bgcolor=""midnightblue"" colspan=""2"" align=""center""><font size=""2"" color=""mintcream""><b>E-mail Component Test</b></font></td>" & vbNewLine & _
  "		</tr>" & vbNewLine & _
  "		<tr valign=""top"">" & vbNewLine & _
  "		  <td bgcolor=""midnightblue"" colspan=""2"" align=""center""><font size=""2"" color=""mintcream"">The following components are currently<br />available choices in the latest<br />release of Snitz Forums 2000</font></td>" & vbNewLine & _
  "		</tr>" & vbNewLine
Dim i
for i=0 to UBound(theComponent)
 Response.Write "		<tr>" & vbNewLine & _
   "		  <td bgColor=""#9FAFDF"" align=""right""><font size=""2""><strong>" & theComponentName(i) & ":&nbsp;</strong></font></td>" & vbNewLine & _
   "		  <td bgColor=""#9FAFDF"" align=""center""><font size=""2"">"
 if Not IsObjInstalled(theComponent(i)) then
  Response.Write("not installed")
 else
  Response.Write("<strong>installed!</strong>")
 end if
 Response.Write "</font></td>" & vbNewLine & _
   "		</tr>" & vbNewline
next
Response.Write "	  </table>" & vbNewLine & _
  "	</td>" & vbNewLine & _
  "  </tr>" & vbNewLine & _
  "</table>" & vbNewLine & _
  "</font>" & vbNewLine & _
  "</body>" & vbNewLine & _
  vbNewLine & _
  "</html>" & vbNewLine
%>