<%@ Language="VBScript"%>
<% Response.Buffer = "true" %>
<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D" NAME="CDO for Windows 2000 Type Library" -->
<!--
      File Name : Daniel's Test Script
      Author    : Daniel Morritt [dan.morritt@fasthosts.co.uk]
      Dates     : Nov 2001, see below.
      Ref       : Script to test common mailing systems and server objects, added support for BLAT, iHTML mailer,
               session, server and application variables.
               Sept 2002 : Directory browsing added.
               Dec 2002  : Database support/browsing added. Advanced config added.
               Feb 2003  : Perl SMTP added
               June 2003 : ASP Upload added. MySQL DSN support added
               Nov 2003  : Added AttachFile func for CDONTS, some info in the general advice section etc

      The following code is for demonstration only, absolutely no warranty is expressed or implied. Like me
      its not perfect and intended for "testing" as the name implies, which is why there is minimal error
      checking [at least thats my excuse and i'm sticking to it].

      This code can be used maliciously so dont leave it lying around anywhere obvious!
//-->
<style>
BODY {     
	scrollbar-3d-light-color:#ffffff;
	scrollbar-arrow-color:#ffffff;
	scrollbar-base-color:#808080;
	scrollbar-dark-shadow-color:#000000;
	scrollbar-face-color:#808080;
	scrollbar-highlight-color:#ffffff;
	scrollbar-shadow-color:#000000
	text-decoration: none; 
	color: #336;
	font-size: 12px; 
	line-height: 12px; 
	font-family: Arial; 
}
p
{ 
	text-decoration: none; color: #336; font-size: 12px; line-height: 12px;	font-family: Arial; 
}
h3
{ 
	text-decoration: none; color: #336; font-size: 16px; font-weight: bold;	line-height: 12px; 	font-family: Arial; 
}
table
{
	cellspacing: 0px; border-color: #ffffff;
}
th
{ 
	text-decoration: none; 	color: #336; font-size: 12px; line-height: 12px; font-family: Arial;
}
td
{ 
	text-decoration: none; color: #336; font-size: 12px; line-height: 12px; font-family: Arial;
}
.style1
{ 
	border-color: black; border-width: 1px;	text-decoration: none; font-size: 11px; line-height: 12px; font-family: Arial; 
}
a:link
{ 
	text-decoration: none; color: #336; font-weight: bold; font-size: 12px; line-height: 12px; font-family: Arial;
}
a:visited 
{ 
	text-decoration: none; color: #336; font-weight: bold; font-size: 12px; line-height: 12px; font-family: Arial;
}
a:active 
{ 
	text-decoration: none; color: #336; font-weight: bold; font-size: 12px; line-height: 12px; font-family: Arial;
}
a:hover 
{ 
	text-decoration: underline; color: #336; font-weight: bold; font-size: 12px; line-height: 12px; font-family: Arial;
}
</style>
<%
'*******************************************************************
'********* Setup ***************************************************

  Dim FileSystemObject
  Dim fTextFile
  Dim sTo
  Dim sFrom
  Dim sSubject
  Dim sGenericBody
  Dim sServerSMTP
  Dim sStartTime, sEndTime, sDeltaTime
  Dim sBLATScript, sBLATScriptExists
  Dim sIHTMLScript, siHTMLScriptExists, sPerlSockScriptExists
  Dim sConfigExists, sDumpExists

  Server.ScriptTimeout = (90) 'just in case ;)
  sStartTime   = Timer 'set the timer running
  sFrom        = "test@" & replace(request.servervariables("HTTP_HOST"),"www.","")
  sSubject     = "test email from " & replace(request.servervariables("HTTP_HOST"),"www.","")
  sServerSMTP  = "smtp." & replace(request.servervariables("HTTP_HOST"),"www.","")
  sVersion     = "2.3"

'*******************************************************************
'******** code to check for existance of the installed files ******* 

  Set FileSystemObject = Server.CreateObject("Scripting.FileSystemObject") 'create a FSO object to check for installed files

'**check to see if email address has been changed**
  If (FileSystemObject.FileExists(Server.MapPath("testscriptconf.asp"))) Then
    Set fTextFile = FileSystemObject.OpenTextFile(Server.MapPath("testscriptconf.asp"),1)
    sTo         = fTextFile.readline
    sFrom       = fTextFile.readline
    sServerSMTP = fTextFile.readline
    fTextFile.close
    sConfigExists = "true"
  Else
    sTo = "dan.morritt@fasthosts.co.uk"
    sConfigExists = "false"
  End If

'**check the blat text file**
  If (FileSystemObject.FileExists(Server.MapPath("dump.txt"))) Then
    sDumpExists = "true"
  Else
    sDumpExists = "false"
  End If

'**check for the blat perl script**
  If (FileSystemObject.FileExists(Server.MapPath("testscript.pl"))) Then
    sBLATScript = "<tr><td>&nbsp;<a href='testscript.pl'>Perl BLAT</a></td></tr>"
    sBLATScriptExists = "true"
  Else
    sBLATScript = "<tr><td>&nbsp;<a href='testscript.asp?action=install&s=blat'>install</a> BLAT Script</td></tr>"
    sBLATScriptExists = "false"
  End If

'**check for the ihtml script**
  If (FileSystemObject.FileExists(Server.MapPath("testscript.ihtml"))) Then
    sIHTMLScript = "<tr><td>&nbsp;<a href='testscript.ihtml'>iHTML Script</a><br>"
    sIHTMLScriptExists = "true"
  Else
    sIHTMLScript = "<tr><td>&nbsp;<a href='testscript.asp?action=install&s=ihtml'>install</a> iHTML Script</td></tr>"
    sIHTMLScriptExists = "false"
  End If

'**check for the PerlSock script**
  If (FileSystemObject.FileExists(Server.MapPath("testscriptpsmtp.pl"))) Then
    sPerlSockScript = "<tr><td>&nbsp;<a href='testscriptpsmtp.pl'>Perl SMTP</a></td></tr>"
    sPerlSockScriptExists = "true"
  Else
    sPerlSockScript = "<tr><td>&nbsp;<a href='testscript.asp?action=install&s=perlsmtp'>install</a> Perl SMTP</td></tr>"
    sPerlSockScriptExists = "false"
  End If

'**check if server is IIS 5 and will support CDO**
  if replace(request.servervariables("SERVER_SOFTWARE"),"Microsoft-IIS/","") >= "5.0" then
    sCDOSupport = "<tr><td>&nbsp;<a href='testscript.asp?action=cdo'>CDO.Message</a></td></tr>"
  else
    sCDOSupport = "<tr><td>&nbsp;CDO.Message - Not supported</td></tr>"
  end if

  Set FileSystemObject = Nothing 'nullify object

  sGenericBody = vbcrlf & vbcrlf & "Email Generated By Daniels Test Script." & vbcrlf & vbcrlf & _
                 "Remote host [user] = " & request.servervariables("REMOTE_HOST") & vbcrlf & _
                 "Local Host [server] = " & request.servervariables("LOCAL_ADDR") & vbcrlf & _
                 "Location = http://" & request.servervariables("SERVER_NAME") & ":" & _
                                 request.servervariables("SERVER_PORT") & _
                                 request.servervariables("SCRIPT_NAME") & vbcrlf & _
                 "SMTP Address = " & sServerSMTP

'*******************************************************************
'******** the blat and ihtml script if needed to be generated ******

  sBlatFile = "# Use the cgi unit" & vbcrlf & _
              "use cgi;" & vbcrlf & _
              "$server=" & Chr(34) & sServerSMTP & Chr(34) & ";" & vbcrlf & _
              "# Output the correct header" & vbcrlf & _
              "print " & Chr(34) & "Content-type: text/html\n\n" & Chr(34) & ";" & vbcrlf & _
              "# Build the Blat command line and execute it" & vbcrlf & _
              "$blat=" & Chr(34) & "blat.exe dump.txt -s \" & Chr(34) & "Mail from BLAT\" & Chr(34) & _
               " -t \" & Chr(34) & replace(replace(sTo,"www.",""),"@","\@") & "\" & Chr(34) & " -server $server -f \" & Chr(34) & _
                 replace(sFrom,"@","\@") & "\" & Chr(34)& Chr(34) & ";" & vbcrlf & _
              "system($blat);" & vbcrlf & _
              "print $blat;" & vbcrlf & _
              "print " & Chr(34) & "<center><br><br>BLAT Done.<br><br>" & Chr(34) & ";" & vbcrlf & _
              "print " & Chr(34) & "<br><a href=\'..\/testscript.asp\'>Click here</a></center>" & Chr(34) & ";"

  sIHTMLFile = "<!ihtml>" & vbcrlf & _
               "<iMAIL host=" & Chr(34) & sServerSMTP & Chr(34) & _
                  " FROM=" & Chr(34) & sFrom & Chr(34) & _
                  " TO=" & Chr(34) & sTo & Chr(34) & _
                  " subject=" & Chr(34) & sSubject & Chr(34) & ">" & vbcrlf & _
               "Test Email using iHTML" & vbcrlf & _
               sGenericBody & vbcrlf & _
               "</iMAIL>"& vbcrlf  & _
               "<html>" & vbcrlf  & _
               "<center>" & vbcrlf & _
               "<p>iHTML test mail sent</p>" & vbcrlf & _
               "<p><a href='testscript.asp'>back to testscript.asp</a></p>" & vbcrlf & _
               "</center>" & vbcrlf & _
               "</html>"

  sPerlSockfile = "use strict;" & vbcrlf & _
              "use Net::SMTP;" & vbcrlf & _
              "use CGI;" & vbcrlf & _
              "my $cgi = new CGI;" & vbcrlf & _
              "my $smtp = Net::SMTP->new(" & Chr(34) & sServerSMTP & Chr(34) & ");" & vbcrlf & _
              "$smtp->mail(" & Chr(34) & replace(sFrom,"@","\@") & Chr(34) & ");" & vbcrlf & _
              "$smtp->to(" & Chr(34) & replace(sTo,"@","\@") & Chr(34) & ");" & vbcrlf & _
              "$smtp->data();" & vbcrlf & _
              "$smtp->datasend(" & Chr(34) & "To: " & replace(sTo,"@","\@") & "\n" & Chr(34) & ");" & vbcrlf & _
              "$smtp->datasend(" & Chr(34) & "From: " & replace(sFrom,"@","\@") & "\n" & Chr(34) & ");" & vbcrlf & _
              "$smtp->datasend(" & Chr(34) & "Subject: " & replace(sSubject,"@","\@") & "\n" & Chr(34) & ");" & vbcrlf & _
              "$smtp->datasend(" & Chr(34) & "Test Email using Perl SMTP" & vbcrlf & sGenericBody & Chr(34) &");" & vbcrlf & _
              "$smtp->dataend();" & vbcrlf & _
              "$smtp->quit;" & vbcrlf & _
              "print " & Chr(34) & "Content-Type: text/html\n\n" & Chr(34) & ";" & vbcrlf & _
              "print " & Chr(34) & "<center><br><br>Perl SMTP Done.<br><br>" & Chr(34) & ";" & vbcrlf & _
              "print " & Chr(34) & "<br><a href=\'..\/testscript.asp\'>Click here</a></center>" & Chr(34) & ";"

'*******************************************************************
'********* Functions ***********************************************

  Function fSize(sSize)
    sSize = sSize / 1024
    if sSize < 1024 then
      fSize = FormatNumber(sSize,0) & " kb"
    else
      fSize = FormatNumber(sSize / 1024,1) & " mb"
    end if
  End Function

  Function fAttrib(sAtt)
    fAttrib = "-"
    if sAtt >= 32 then
      fAttrib = fAttrib + "a-"
      sAtt = sAtt - 32
    end if
    if aAtt >= 16 then
      fAttrib = fAttrib + "d-"
      sAtt = sAtt - 16
    end if
    if sAtt >= 4 then
      fAttrib = fAttrib + "s-"
      sAtt = sAtt - 4
    end if
    if sAtt >= 2 then
      fAttrib = fAttrib + "h-"
      sAtt = sAtt - 2
    end if
    if sAtt >= 1 then
      fAttrib = fAttrib + "r-"
      sAtt = sAtt - 1
    end if
  End Function

  Function fDSNParse(sFilename,sPath)
    Dim oReg
    Set oReg = New RegExp
    oReg.IgnoreCase = True
    oReg.Pattern    = ".mdb"
    if oReg.Test(sFilename) then
      fDSNParse = "<a href='?action=dsnsetup&createdsn=" & sPath & "'>create DSN-less link to</a> -> " & sFileName
    else
      fDSNParse = sFilename
    end if
  End Function

  Function fDriveType(iType)
    'checkes drive types and returns a user friendly string value
    if iType = 0 then
      fDriveType = "Unknown"
    end if
    if iType = 1 then
      fDriveType = "Removable"
    end if
    if iType = 2 then
      fDriveType = "Fixed"
    end if
    if iType = 3 then
      fDriveType = "Remote"
    end if
    if iType = 4 then
      fDriveType = "CD"
    end if
    if iType = 5 then
      fDriveType = "RAM Disk"
    end if
  End Function

FUNCTION fFieldName(ftype)
 SELECT CASE ftype
   CASE 0    : fFieldName="Empty"
   CASE 2    : fFieldName="SmallInt"
   CASE 3    : fFieldName="Integer"
   CASE 4    : fFieldName="Single"
   CASE 5    : fFieldName="Double"
   CASE 6    : fFieldName="Currency"
   CASE 7    : fFieldName="Date"
   CASE 8    : fFieldName="BSTR"
   CASE 9    : fFieldName="IDispatch"
   CASE 10   : fFieldName="Error"
   CASE 11   : fFieldName="Boolean"
   CASE 12   : fFieldName="Variant"
   CASE 13   : fFieldName="IUnknown"
   CASE 14   : fFieldName="Decimal"
   CASE 16   : fFieldName="TinyInt"
   CASE 17   : fFieldName="UnsignedTinyInt"
   CASE 18   : fFieldName="UnsignedSmallInt"
   CASE 19   : fFieldName="UnsignedInt"
   CASE 20   : fFieldName="BigInt"
   CASE 21   : fFieldName="UnsignedBigInt"
   CASE 72   : fFieldName="GUID"
   CASE 128  : fFieldName="Binary"
   CASE 129  : fFieldName="Char"
   CASE 130  : fFieldName="WChar"
   CASE 131  : fFieldName="Numeric"
   CASE 132  : fFieldName="UserDefined"
   CASE 133  : fFieldName="DBDate"
   CASE 134  : fFieldName="DBTime"
   CASE 135  : fFieldName="DBTimeStamp"
   CASE 200  : fFieldName="VarChar"
   CASE 201  : fFieldName="LongVarChar"
   CASE 202  : fFieldName="VarWChar"
   CASE 203  : fFieldName="LongVarWChar"
   CASE 204  : fFieldName="VarBinary"
   CASE 205  : fFieldName="LongVarBinary"
   CASE ELSE   fFieldName="Undefined by ADO"
 END SELECT
END FUNCTION

  Function CheckLocale(loc)
'*** checked the locale to pring a nice english name ***
    If Loc = "2057" Then
      CheckLocale = "2057 - English United Kingdom"
    Else
      CheckLocale = loc & " - Unknown"
    End If
  End Function

'******************************************************************
'********** Subs **************************************************

  Private Sub runJmail()
'*** the Jmail send routine ***
    Set JMail = Server.CreateObject("JMail.SMTPMail")
    JMail.ServerAddress = sServerSMTP
    JMail.Sender = sFrom
    JMail.Subject = sSubject
    JMail.AddRecipient sTo
    JMail.Body = "Test Jmail" & sGenericBody
    JMail.Priority = 3
    JMail.Execute
    Set JMail = Nothing
    response.write "Jmail.SMTPMail test message sent" & _
                   "<table bgcolor='#8c8c8c' align='center'>" & _
                   "<tr><td bgcolor='#b4b4b4'>To</td><td bgcolor='#b4b4b4'>" & sTo & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>From</td><td bgcolor='#b4b4b4'>" & sFrom & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Subject</td><td bgcolor='#b4b4b4'>" & sSubject & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Body</td><td bgcolor='#b4b4b4'>" & replace(sGenericBody, vbcrlf,"<br>") & "</td></tr>" & _
                   "</table>"
  End Sub

  Private Sub runLazyJmail()
'*** the Jmail LazySend send routine ***
    Set JMail = Server.CreateObject("JMail.SMTPMail")
    JMail.LazySend = True
    JMail.Sender = sFrom
    JMail.Subject = sSubject
    JMail.AddRecipient sTo
    JMail.Body = "Test Jmail LazySend" & sGenericBody
    JMail.Priority = 3
    JMail.Execute
    Set JMail = Nothing
    response.write "Jmail Lazysend test message sent" & _
                   "<table bgcolor='#8c8c8c' align='center'>" & _
                   "<tr><td bgcolor='#b4b4b4'>To</td><td bgcolor='#b4b4b4'>" & sTo & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>From</td><td bgcolor='#b4b4b4'>" & sFrom & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Subject</td><td bgcolor='#b4b4b4'>" & sSubject & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Body</td><td bgcolor='#b4b4b4'>" & replace(sGenericBody, vbcrlf,"<br>") & "</td></tr>" & _
                   "</table>"
  End Sub

  Private Sub sJmailMessage()
    Set JMail = Server.CreateObject("Jmail.Message")
    Jmail.From = sFrom
    Jmail.AddRecipient sTo
    Jmail.Subject = sSubject
    Jmail.Body = "Jmail.Message Test" & sGenericBody
    Jmail.Send sServerSMTP
    Set Jmail = Nothing
    response.write "Jmail.Message test message sent" & _
                   "<table bgcolor='#8c8c8c' align='center'>" & _
                   "<tr><td bgcolor='#b4b4b4'>To</td><td bgcolor='#b4b4b4'>" & sTo & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>From</td><td bgcolor='#b4b4b4'>" & sFrom & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Subject</td><td bgcolor='#b4b4b4'>" & sSubject & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Body</td><td bgcolor='#b4b4b4'>" & replace(sGenericBody, vbcrlf,"<br>") & "</td></tr>" & _
                   "</table>"
  End Sub

  Private Sub runCDONTS()
'*** the CDONTS send routine ***
    Set iMsg = CreateObject("CDONTS.Newmail")
    iMsg.To = sTo
    iMsg.From = sFrom
    iMsg.Subject = sSubject
    iMsg.Body = "Test CDONTS" & sGenericBody
    iMsg.send
    Set iMsg = Nothing
    response.write "CDO-NTS Test" & _
                   "<table bgcolor='#8c8c8c' align='center'>" & _
                   "<tr><td bgcolor='#b4b4b4'>To</td><td bgcolor='#b4b4b4'>" & sTo & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>From</td><td bgcolor='#b4b4b4'>" & sFrom & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Subject</td><td bgcolor='#b4b4b4'>" & sSubject & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Body</td><td bgcolor='#b4b4b4'>" & replace(sGenericBody, vbcrlf,"<br>") & "</td></tr>" & _
                   "</table>"
  End Sub

  Private Sub runCDONTSATT()
'*** the CDONTS send routine with an attachment ***
    Set iMsg = CreateObject("CDONTS.Newmail")
    iMsg.To = sTo
    iMsg.From = sFrom
    iMsg.Subject = sSubject
    iMsg.Body = "Test CDONTS With Attachment" & sGenericBody
    iMsg.AttachFile Server.MapPath("testscript.asp"), "testscript.asp"
    iMsg.send
    Set iMsg = Nothing
    response.write "CDO-NTS Attachment Test" & _
                   "<table bgcolor='#8c8c8c' align='center'>" & _
                   "<tr><td bgcolor='#b4b4b4'>To</td><td bgcolor='#b4b4b4'>" & sTo & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>From</td><td bgcolor='#b4b4b4'>" & sFrom & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Subject</td><td bgcolor='#b4b4b4'>" & sSubject & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Body</td><td bgcolor='#b4b4b4'>" & replace(sGenericBody, vbcrlf,"<br>") & "</td></tr>" & _
                   "</table>"
  End Sub

  Private Sub runCDOSYS()
'*** the CDO send routine ***
    Set iMsg = CreateObject("CDO.Message")
    Set iConf = CreateObject("CDO.Configuration")
    Set Flds = iConf.Fields
    Flds(cdoSendUsingMethod) = 1        ' cdoSendUsingPort
    Flds(cdoSMTPServer) = sServerSMTP
    Flds(cdoSMTPServerPort) = 25
    Flds(cdoSMTPAuthenticate) = 0            'cdoAnonymous
    Flds.Update
    Set iMsg.Configuration = iConf
    iMsg.To = sTo
    iMsg.From = sFrom
    iMsg.Sender = sFrom
    iMsg.Subject = sSubject
    iMsg.TextBody = "Test CDOSYS" & sGenericBody
    iMsg.Send
    Set iMsg = Nothing
    response.write "CDOSYS test" & _
                   "<table bgcolor='#8c8c8c' align='center'>" & _
                   "<tr><td bgcolor='#b4b4b4'>To</td><td bgcolor='#b4b4b4'>" & sTo & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>From</td><td bgcolor='#b4b4b4'>" & sFrom & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Subject</td><td bgcolor='#b4b4b4'>" & sSubject & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Body</td><td bgcolor='#b4b4b4'>" & replace(sGenericBody, vbcrlf,"<br>") & "</td></tr>" & _
                   "</table>"
  End Sub

  Private Sub getCreateObject()
'*** the createobject get request ***
    response.write "<b>Create Object</b><br>Allows you to ''try'' creating objects on the fly"
    response.write "<form action='testscript.asp' method='get'>" & _
                   "<input type='hidden' name='action' value='creater'>" & _
                   "Server.CreateObject(''<input type='text' name='testing' class='style1'>'')" & _
                   "<input type='submit' value='Test it' class='style1'>" & _
                   "</form>"
  End Sub

  Private Sub runCreateObject()
'*** the createobject runner, lets see if it errors out :) ***
    response.write "Creating " & request.querystring("testing") & "<br>"
    On Error Resume Next
    Set oTestObj = Server.CreateObject(request.querystring("testing"))
    if Err then
      response.write "<br><b>error!</b>" & _
                     "<br>error number : " & err.number & _
                     "<br>error description : " & err.description
    else
      response.write "<br>Object created Successfully"
    End if
    On Error Goto 0
    Set oTestObj = Nothing
  End Sub

  Private Sub runNormal()
'*** the menu ***
    response.write "<table width='100%'><tr><td>&nbsp;<a href='?'>Home</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=jmail'>Jmail.SMTPMail</a> <a href='?action=lazymail'>.Lazysend</a></td></tr>"
    On Error Resume Next
    Set o = Server.CreateObject("Jmail.Message")
    If Err = 0 Then
      Response.Write "<tr><td>&nbsp;<a href='?action=jmailmessage'>Jmail.Message</a></td></tr>"
    End If
    Set o = Nothing
    On Error GoTo 0
    Response.Write "<tr><td>&nbsp;<a href='?action=cdonts'>CDONTS.NewMail</a> <a href='?action=cdontsatt'>.AttachFile</a></td></tr>" & _
                   sCDOSupport & _
                   sBLATScript & _
                   sIHTMLScript & _
                   sPerlSockScript & _
                   "<tr><td>&nbsp;<a href='?action=support'>CreateObject Support</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=servervars'>Server Variables</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=ses'>Session/Application Contents</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=hkeep'>Housekeeping</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=browse'>Directory Browser</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=dsnsetup'>Database Browser</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=info'>General Information</a></td></tr>" & _
                   "<tr><td>&nbsp;<a href='?action=adv'>Advanced Config</a></td></tr>" & _
                   "<tr><td>&nbsp;Date : " & date & "<br>" & _
                   "&nbsp;Time : " & time & "</td></tr></table>"
  End Sub

  Private Sub runEmailChange()
'*** the request an email change form ***
    response.write "<p>Enter your address in the box below and hit the button to specify a new address<br>" & _
                   "<form action='?' method='get'>" & _
                   "<input type='hidden' name='action' value='changeemail'>" & _
                   "<input type='text' name='email' class='style1' value='" & sTo & "' size='30'> " & _
                   "<input type='submit' class='style1' value='Change E-mail Address'>" & _
                   "</form></p>"
  End Sub

  Private Sub doEmailChange()
'*** the email address change maker routine ***
    Dim FSO, fsoFile
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
    Set fsoFile = FSO.CreateTextFile(Server.MapPath("testscriptconf.asp"))
    fsoFile.writeline request.querystring("email")
    fsoFile.writeline sFrom
    fsoFile.writeline sServerSMTP
    Set FSO = Nothing
    Set fsoFile = Nothing
    response.write "Email Address Changed to " & request.querystring("email")
  End Sub

  Private Sub hkeep()
    response.write "<b>Housekeeping</b><br>To remove any unwanted files created with this script just click the link below"
    response.write "<table bgcolor='#8c8c8c' align='center'><tr><th colspan='3'>Files</th></tr>"
    if sIHTMLScriptExists = "true" then
      response.write "<tr><td bgcolor='#b4b4b4'>iHTML Script</td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=view&file=testscript.ihtml'>View</a></td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=delete&file=testscript.ihtml'>Delete</a></td></tr>"
    else
      response.write "<tr><td bgcolor='#b4b4b4'>iHTML Script</td><td bgcolor='#b4b4b4'>View</td><td bgcolor='#b4b4b4'>Delete</td></tr>"
    end if
    if sBLATScriptExists = "true" then
      response.write "<tr><td bgcolor='#b4b4b4'>Blat Script</td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=view&file=testscript.pl'>View</a></td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=delete&file=testscript.pl'>Delete</a></td></tr>"
    else
      response.write "<tr><td bgcolor='#b4b4b4'>Blat Script</td><td bgcolor='#b4b4b4'>View</td><td bgcolor='#b4b4b4'>Delete</td></tr>"
    end if
    if sDumpExists = "true" then
      response.write "<tr><td bgcolor='#b4b4b4'>Blat Message</td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=view&file=dump.txt'>View</a></td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=delete&file=dump.txt'>Delete</a></td></tr>"
    else
      response.write "<tr><td bgcolor='#b4b4b4'>Blat Message</td><td bgcolor='#b4b4b4'>View</td><td bgcolor='#b4b4b4'>Delete</td></tr>"
    end if

    if sPerlSockScriptExists = "true" then
      response.write "<tr><td bgcolor='#b4b4b4'>PerlSock Script</td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=view&file=testscriptpsmtp.pl'>View</a></td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=delete&file=testscriptpsmtp.pl'>Delete</a></td></tr>"
    else
      response.write "<tr><td bgcolor='#b4b4b4'>PerlSock Script</td><td bgcolor='#b4b4b4'>View</td><td bgcolor='#b4b4b4'>Delete</td></tr>"
    end if


    if sConfigExists = "true" then
      response.write "<tr><td bgcolor='#b4b4b4'>Config File</td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=view&file=testscriptconf.asp'>View</a></td>" & _
                         "<td bgcolor='#b4b4b4'><a href='?action=delete&file=testscriptconf.asp'>Delete</a></td></tr></table>"
    else
      response.write "<tr><td bgcolor='#b4b4b4'>Config File</td><td bgcolor='#b4b4b4'>View</td><td bgcolor='#b4b4b4'>Delete</td></tr></table>"
    end if
  End Sub

  Private Sub view()
'*** allow people to view files created by this script ***
    Dim oTextObj, fTextFile, sBuffer
    set oTextObj = server.createobject("scripting.filesystemobject")
    Set fTextFile = oTextObj.OpenTextFile(Server.MapPath(".") & "\" & request.querystring("file"))
    if fTextFile.AtEndOfStream then
      sBuffer = "blank file - no content to display"
    else
      sBuffer = fTextFile.readAll
    end if
    fTextFile.close
    response.write "Viewing File : " & Server.MapPath(".") & "\" & request.querystring("file")
    response.write "<textarea cols='100' rows='20' class='style1'>" & sBuffer & "</textarea><br><a href='?action=hkeep'>back</a>"
  End Sub

  Private Sub delete()
'*** delete the files created with this script ***
    set oTextObj = server.createobject("scripting.filesystemobject")
    set ftextfile = oTextObj.getfile(Server.MapPath(".") & "/" & request.querystring("file"))
    fTextFile.delete True
    response.write "Deleting : " & request.querystring("file") & "<br><br>"
    response.write "<a href='?action=hkeep'>back</a>"
    response.redirect "?action=hkeep"
  End Sub

  Private Sub installBlat()
'*** install a blat test script in the domain ***
    Dim FSO, fsoFile
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
    Set fsoFile = FSO.CreateTextFile(Server.MapPath("testscript.pl"))
    fsoFile.writeline sBlatFile
    Set FSO = Nothing
    Set fsoFile = Nothing
    response.write "Blat Script installed, please go back to use"

    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
    Set fsoFile = FSO.CreateTextFile(Server.MapPath("dump.txt"))
    fsoFile.writeline "Test BLAT email" & sGenericBody
    Set FSO = Nothing
    Set fsoFile = Nothing
    response.redirect "?"
  End Sub

  Private Sub installIHTML()
'*** install the ihtml test script ***
    Dim FSO, fsoFile
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
    Set fsoFile = FSO.CreateTextFile(Server.MapPath("testscript.ihtml"))
    fsoFile.writeline sIHTMLFile
    Set FSO = Nothing
    Set fsoFile = Nothing
    response.write "iHTML Script installed, please go back to use"
    response.redirect "?"
  End Sub

    Private Sub installIPSMTP()
  '*** install the Perl SMTp test script ***
      Dim FSO, fsoFile
      Set FSO = Server.CreateObject("Scripting.FileSystemObject")
      Set fsoFile = FSO.CreateTextFile(Server.MapPath("testscriptpsmtp.pl"))
      fsoFile.writeline sPerlSockfile
      Set FSO = Nothing
      Set fsoFile = Nothing
      response.write "Perl SMTP Script installed, please go back to use"
      response.redirect "?"
  End Sub

  Private Sub showServerVariables()
'*** loop through the servervariables ***
    response.write "<b>Server Variables</b><br>All the server variables available to ASP scripts"
    response.write "<table bgcolor='#8c8c8c' align='center'>"
    response.write "<tr><th colspan='2'>ServerVariables</th></tr>"
    For Each x in Request.ServerVariables
      response.write "<tr><td bgcolor='#b4b4b4'>" & Request.ServerVariables.Key(x) & "</td>"
      response.write "<td bgcolor='#b4b4b4'>" & Request.ServerVariables.Item(x) & "</td></tr>"
    Next
    response.write "</table>"
  End Sub

  Private Sub showSessionContents()
'*** loop through the session and application contents ***
    'start with the session
    response.write "<b>Session/Application Contents</b><br>Contents [list] of the session and application objects"
    response.write "<table bgcolor='#8c8c8c' align='center'>"
    response.write "<tr><th colspan='2'>Session Contents " & session.contents.count() & " items</th></tr>"
    For x  = 1 to Session.Contents.Count
      response.write "<tr><td bgcolor='#b4b4b4'>" & Session.Contents.Key(x) & "</td>"
      response.write "<td bgcolor='#b4b4b4'>" & Session.Contents.Item(x) & "</td></tr>"
    Next
    response.write "</table><br>"
    'and the application contents
    response.write "<table bgcolor='#8c8c8c' align='center'>"
    response.write "<tr><th colspan='2'>Application Contents " & Application.contents.count() & " items</th></tr>"
    For Each x in Application.Contents
      response.write "<tr><td bgcolor='#b4b4b4'>" & Application.Contents.Key(x) & "</td>"
      response.write "<td bgcolor='#b4b4b4'>" & Application(x) & "</td></tr>"
    Next
    response.write "</table><br>"
    'for testing purposes add to the session/app vars
    if request.querystring("create") = "app" then
      response.write "creating the application variable"
      Application("ApplicationVar") = "works!"
      response.write "<br><a href='?action=ses&'>back</a>"
    else
      if request.querystring("create") = "ses" then
        response.write "creating the session variable"
        Session("SessionVar") = "works!"
        response.write "<br><a href='?action=ses&'>back</a>"
      else
      response.write "<a href='?action=ses&create=app'>create application variable</a> - " & _
                     "<a href='?action=ses&create=ses'>create session variable</a> - " & _
                     "<a href='?action=abandon'>abandon session</a>"
      end if
    end if
  End Sub

  Private Sub sAbandon()
'*** abandons the session ***
    Session.Abandon
    Response.Write "Session Abandoned"
  End Sub

  Private Sub sBrowse2()
'*** allow browsing of folders starting with the folder this file is located in ***
    On Error Resume Next 'ignore any errors we get
    Dim oFS
    Set oFS = Server.CreateObject("Scripting.FileSystemObject")
    if request.querystring("folder") = "" then
      Set oFolder = oFS.GetFolder(Server.MapPath("."))
    else
      Set oFolder = oFS.GetFolder(request.querystring("folder"))
    end if
    response.write "<b>Directory Browser</b>"
    response.write "<br>Jump to root : <a href='?action=browse2&folder=" & oFS.GetAbsolutePathName(Server.MapPath(".")) & _
                   "'>" & oFS.GetAbsolutePathName(Server.MapPath(".")) & "</a>"
    response.write "<table width='600' bgcolor='#8c8c8c' align='center'>"
    response.write "<tr><th colspan='5'>Directory Browser</th></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Name</td><td bgcolor='#b4b4b4'>Type</td><td bgcolor='#b4b4b4'>Attributes</td><td bgcolor='#b4b4b4'>Size</td><td bgcolor='#b4b4b4'>Actions</td></tr>"
    'allow to move up if not root folder, may error out if permissions incorrect
    if not oFolder.IsRootFolder then
      response.write "<tr><td bgcolor='#b4b4b4'><a href='?action=browse2&folder="& oFolder.ParentFolder & "'>..</a></td><td bgcolor='#b4b4b4'colspan='4'>[Parent Folder]</tr>"
    end if
    'list the folders
    For Each folder in oFolder.SubFolders
      response.write "<tr>" & _
                     "<td bgcolor='#b4b4b4'><a href='?action=browse2&folder=" & folder.Path & "'>" & folder.name & "</a></td>" & _
                     "<td bgcolor='#b4b4b4'>" & folder.Type & "</td>" & _
                     "<td bgcolor='#b4b4b4'>" & folder.Attributes & " " & fAttrib(folder.Attributes) & "</td>" & _
                     "<td bgcolor='#b4b4b4'>" & fSize(folder.Size) & "</td>" & _
                     "<td bgcolor='#b4b4b4'><a href='?action=deletor&i=folder&path=" & Folder.Path & "&dir=" & request.querystring("folder") & "'>delete</a></td>" & _
                     "</tr>"
    Next
    'list all files
    For Each file in oFolder.Files
      response.write "<tr>" & _
                     "<td bgcolor='#b4b4b4'>" & fDSNParse(file.Name,File.Path) & "</td>" & _
                     "<td bgcolor='#b4b4b4'>" & file.Type & "</td>" & _
                     "<td bgcolor='#b4b4b4'>" & file.Attributes & " " & fAttrib(file.Attributes) & "</td>" & _
                     "<td bgcolor='#b4b4b4'>" & fSize(file.Size) & "</td>" & _
                     "<td bgcolor='#b4b4b4'><a href='?action=editor&file=" & File.Path & "&dir=" & request.querystring("folder") & "'>edit</a> - <a href='?action=deletor&i=file&path=" & File.Path & "&dir=" & request.querystring("folder") & "'>delete</a></td>" & _
                     "</tr>"
    Next
    response.write "</table>"
    On Error GoTo 0
    response.write "<center><br><table bgcolor='#8c8c8c' align='center'>" & _
                     "<tr><td bgcolor='#b4b4b4'>Create Directory</td>" & _
                         "<td bgcolor='#b4b4b4'><form action='?action=creator&i=cfolder' method='post'>" & _
                                       "<input type='text' name='fname' class='style1'>" & _
                                       "<input type='hidden' name='path' value='" & request.querystring("folder") & "'>" & _
                                       "<input type='submit' class='style1'></form></td></tr>" & _
                     "<tr><td bgcolor='#b4b4b4'>Create Empty File</td>" & _
                         "<td bgcolor='#b4b4b4'><form action='?action=creator&i=cfile' method='post'>" & _
                                       "<input type='tex' name='fname' class='style1'>" & _
                                       "<input type='hidden' name='path' value='" & request.querystring("folder") & "'>" & _
                                       "<input type='submit' class='style1'></form></td></tr>" & _
                     "<tr><td bgcolor='#b4b4b4'>Upload File</td>" & _
                         "<td bgcolor='#b4b4b4'><form name='MyForm' action='?action=upload&path=" & Request.QueryString("folder") & "' method='post' ENCTYPE='multipart/form-data' OnSubmit=""return ShowProgress();"">" & _
                                       "<input type='file' name='fname' class='style1'>" & _
                                       "<input type='hidden' name='path' value='" & request.querystring("folder") & "'>" & _
                                       "<input type='submit' class='style1'></form></td></tr>"
    response.write "</table></center>"
  End Sub


  Private Sub sCreator()
'*** creates blank files and folders ***
    if request.querystring("i") = "cfile" then
      fPath = request.form("path") & "/" & request.form("fname")
      Set oFS = Server.CreateObject("Scripting.FileSystemObject")
      oFS.CreateTextFile(fPath)
      response.redirect "?action=browse2&folder=" & request.form("path")
      Set oFS = Nothing
    else
      if request.querystring("i") = "cfolder" then
        fPath = request.form("path") & "/" & request.form("fname")
        Set oFS = Server.CreateObject("Scripting.FileSystemObject")
        oFS.CreateFolder(fPath)
        response.redirect "?action=browse2&folder=" & request.form("path")
        Set oFS = Nothing
      else
        if request.querystring("i") = "upload" then
          response.write "uploading file not yet functional"
        else
          response.write "wtf!?"
        end if
      end if
    end if
  End Sub

  Private Sub sDeletor()
'*** deletes files obviously ***
    if request.querystring("i") = "folder" then
      Set oFS = Server.CreateObject("Scripting.FileSystemObject")
      oFS.DeleteFolder request.querystring("path")
      Set oFS = Nothing
      response.redirect "?action=browse2&folder=" & request.querystring("dir")
    end if
    if request.querystring("i") = "file" then
      Set oFS = Server.CreateObject("Scripting.FileSystemObject")
      oFS.DeleteFile request.querystring("path")
      Set oFS = Nothing
      response.redirect "?action=browse2&folder=" & request.querystring("dir")
    end if
  End Sub

  Private Sub sEditor()
'*** allow people to view files on the server ***
    Dim oTextObj, fTextFile, sBuffer, sPath
    if request.querystring("update") = "true" then
      sPath = request.form("file")
      set oTextObj = server.createobject("scripting.filesystemobject")
      Set fTextFile = oTextObj.CreateTextFile(sPath)                  'path,writing,creation
      fTextFile.Write request.form("stuff")
      fTextFile.close
      response.redirect "?action=browse2&folder=" & request.querystring("dir")
    else
      sPath = request.querystring("file")
      set oTextObj = server.createobject("scripting.filesystemobject")
      Set fTextFile = oTextObj.OpenTextFile(sPath)
      if fTextFile.AtEndOfStream then
	    sBuffer = "blank file - no content to display"
	  else
	    sBuffer = fTextFile.readAll
      end if
      fTextFile.close
      response.write "Back to : <a href='?action=browse2&folder=" & request.querystring("dir") & "'>" & request.querystring("dir") & "</a>"
      response.write "<form action='?action=editor&update=true' method='post'><textarea name='stuff' cols='130' rows='30' class='style1'>" & sBuffer & "</textarea>" & _
                     "<input type='hidden' name='file' value='" & sPath & "'>" & _
                     "<input type='hidden' name='dir' value='" & request.querystring("dir") & "'>" & _
                     "<br><input type='submit' value='Update' class='style1'></form>"
    end if
  End Sub

  Private Sub sBrowse()
'*** lists all possible drives and avail info ***
    Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
    Set oDrives = oFSO.Drives
    response.write "<b>Directory Browser [root]</b><br>Useful for exploring directories you have access to"
    response.write "<br>Jump to file root : <a href='?action=browse2&folder=" & oFSO.GetAbsolutePathName(Server.MapPath(".")) & _
                   "'>" & oFSO.GetAbsolutePathName(Server.MapPath(".")) & "</a>"
    response.write "<table width='600' bgcolor='#8c8c8c' align='center'>"
    For Each oDrive in oDrives
      response.write "<tr><td bgcolor='#b4b4b4'>Drive</td><td bgcolor='#b4b4b4'>" & oDrive.DriveLetter & "</td></tr>" & _
                     "<tr><td bgcolor='#b4b4b4'></td><td bgcolor='#b4b4b4'>Type : " & fDriveType(oDrive.DriveType) & "<br>"
      if oDrive.IsReady = "true" then
        response.write "Free Space " & oDrive.TotalSize & "<br>"
        response.write "Free Space " & oDrive.AvailableSpace & "<br>"
        response.write "File system " & oDrive.FileSystem & "<br>"
        response.write "Share Name " & oDrive.ShareName & "<br>"
        response.write "Vol Name " & oDrive.VolumeName & "<br>"
        response.write "Browse <a href='?action=browse2&dir=" & oDrive.Path & "'>" & oDrive.Path & "</a><br>"
      else
        response.write "Unacessable <br>" & _
                       "- <a href='?action=browse2&folder=" & oDrive.DriveLetter & "'>try anyway</a><br>" & _
                       "- <a href='?action=browse2&folder=" & oDrive.Path & "'>or here</a><br>"
      End If
       response.write "</td></tr>"
    Next
    response.write "</table>"
    Set oFSO = Nothing
  End Sub

  Private Sub sCreateDSN()
'*** form to connect to the database ***
    response.write "<b>Create dsn less connection</b>"
    response.write "<table><form action='?action=viewdb&dsntype=access' method='post'>" & _
                        "<tr><td colspan='2'>Access Database</td></tr>" & _
	                "<tr><td>Connection Path</td><td><input type='text' value='" & request.querystring("createdsn") & "' class='style1' size='40' name='fdsnpath'></td></tr>" & _
	                "<tr><td>Driver</td><td><select name='fdriver' class='style1'>" & _
                        "<option>Driver={Microsoft Access Driver (*.mdb)}" & _
                        "</td></tr>" & _
	                "<tr><td>DB Password</td><td><input type='password' value='' class='style1' size='40' name='fpwd'> [default none]</td></tr>" & _
	                "<tr><td colspan='2'><input type='submit' value='View Database' class='style1'></form>" & _
	               "<form action='?action=viewdb&dsntype=sql' method='post'>" & _
	                "<tr><td colspan='2'>SQL Server</td><tr>" & _
			"<tr><td>Server IP Address</td><td><input type='text' value='213.171.' class='style1' size='40' name='fip'></td></tr>" & _
			"<tr><td>Database</td><td><input type='text' class='style1' size='40' name='fdb'></td></tr>" & _
			"<tr><td>DB Username</td><td><input type='text' class='style1' size='40' name='fusr'></td></tr>" & _
			"<tr><td>DB Password</td><td><input type='password' class='style1' size='40' name='fpwd'></td></tr>" & _
			"<tr><td colspan='2'><input type='submit' value='View SQL Database' class='style1'></form>" & _
                       "<form action='?action=viewdb&dsntype=dsn' method='post'>" & _
			"<tr><td>ODBC DSN Name</td><td><input type='text' class='style1' size='40' name='dsnname'></td></tr>" & _
                        "<tr><td>DB Password</td><td><input type='password' class='style1' size='40' name='fpwd'></td><tr>" & _
                        "<tr><td colspan='2'><input type='submit' value='View DSN' class='style1'></form></td></tr>" & _
                       "<form action='?' method='get'><input type='hidden' name='action' value='mysql'>" & _
			"<tr><td>MySQL DSN Name</td><td><input type='text' class='style1' size='40' name='mysqldsnname'></td></tr>" & _
                        "<tr><td colspan='2'><input type='submit' value='View MySQL DSN' class='style1'></td></tr>" & _
                       "</form></table>"
  End Sub

  Private Sub sCheckInstall()
'*** installs the perl and ihtml scripts ***
    if request.querystring("s") = "ihtml" then
      installIHTML()
    else
      if request.querystring("s") = "blat" then
        installBlat()
      else
        if request.querystring("s") = "perlsmtp" then
          installIPSMTP()
        else
          response.write "error somewhere! nothing to install!"
        end if
      end if
    end if
  End Sub

  Private Sub sGeneralInfo()
'*** displays some general info - nothing much ***
    response.write "<b>General Information</b><br>Just some generally useless information you may find useful" & _
                   "<table bgcolor='#8c8c8c' align='center'>" & _
                   "<tr><td bgcolor='#b4b4b4'>Locale</td><td bgcolor='#b4b4b4'>" & CheckLocale(GetLocale()) & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Script Engine Build Version</td><td bgcolor='#b4b4b4'>" & ScriptEngineBuildVersion() & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Script Engine Version</td><td bgcolor='#b4b4b4'>" & ScriptEngineMajorVersion() & "." & ScriptEngineMinorVersion() & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Local Path</td><td bgcolor='#b4b4b4'>" & Server.MapPath(".") & "</td></tr>" & _
                   "<tr><td bgcolor='#b4b4b4'>Currency</td><td bgcolor='#b4b4b4'>" & FormatCurrency(0) & "</td></tr>"

    Set adoConn = Server.CreateObject("ADODB.Connection")
    Response.Write "<tr><td bgcolor='#b4b4b4'>ADO Version</td><td bgcolor='#b4b4b4'>" & adoConn.Version & "</td></tr>"
    Set adoConn = Nothing
    Response.Write "<tr><td bgcolor='#b4b4b4'>Size Site</td><td bgcolor='#b4b4b4'><a href='?action=explore'>size</a></td></tr>"
    Response.Write "</table>"
  End Sub

  Private Sub sDefault()
'*** the default action, nothing special ***

    Dim FSO, oFile, oComments, strStart, strEnd
    Set FSO   = Server.CreateObject("Scripting.FileSystemObject")
    Set oFile = FSO.OpenTextFile(Request.ServerVariables("PATH_TRANSLATED"))
    oComments = oFile.ReadAll
    strStart  = InStr(oComments, "File Name")
    strEnd    = InStr(oComments, "//-->")
    
    Response.Write Replace(Replace(Mid(oComments, strStart - 6, (strEnd + 5) - strStart), vbcrlf, "<br>"), " ", "&nbsp;")
  End Sub

  Private Sub sAdvConf()
'*** simple form for advanced options ***
    response.write "<b>Advanced Config Options</b><br><table>" & _
                   "<form action='?action=advcnfsetup' method='post'>" & _
                   "<tr><td>To Address</td><td><input type='text' value='" & sTo & "' class='style1' size='40' name='fto'></td></tr>" & _
                   "<tr><td>From Address</td><td><input type='text' value='" & sFrom & "' class='style1' size='40' name='ffrom'></td></tr>" & _
                   "<tr><td>SMTP Address</td><td><input type='text' value='" & sServerSMTP & "' class='style1' size='40' name='fsmtp'></td></tr>" & _
                   "<tr><td colspan='2'><input type='submit' value='Change config' class='style1'></table></form>"
  End Sub

  Private Sub sAdvCnfSetup()
'*** saves advanced info to the config file ***
    response.write "<b>Advanced Config Saved</b>"
    Dim FSO, fsoFile
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
    Set fsoFile = FSO.CreateTextFile(Server.MapPath("testscriptconf.asp"))
    fsoFile.writeline request.form("fto")
    fsoFile.writeline request.form("ffrom")
    fsoFile.writeline request.form("fsmtp")
    Set FSO = Nothing
    Set fsoFile = Nothing
  End Sub

  Private Sub sViewDB()
'*** opens up an access ot SQL database ***
    if request.querystring("dsntype") = "sql" then
      Session("sDynDSN") = "PROVIDER=MSDASQL;"& _
	            "DRIVER={SQL Server};"& _
			    "SERVER=" & request.form("fip") & ";"& _
			    "UID=" & request.form("fusr") & ";"& _
			    "PWD=" & request.form("fpwd") & ";"& _
			    "DATABASE=" & request.form("fdb") & ";"
	else
          if Request.QueryString("dsntype") = "access" then
             Session("sDynDSN") = request.form("fdriver") & ";" & _
	             "Dbq=" & request.form("fdsnpath") & ";" & _
        	     "Uid=;" & _
	             "Pwd=" & request.form("fpwd") & ";"
          else
             Session("sDynDSN") = "dsn=" & Request.Form("dsnname") & ";pwd=" & Request.Form("fpwd")
          end if
    end if
    Set oConn = Server.CreateObject("ADODB.Connection")
    oConn.Open Session("sDynDSN")
    Set rsSchema = oConn.OpenSchema(4)    'adSchemaColumns
    thistable=""
    response.write "<table bgcolor='#8c8c8c' align='center'>"
    DO UNTIL rsSchema.EOF
      prevtable=thistable
      thistable=rsSchema("Table_Name")
      thiscolumn=rsSchema("COLUMN_NAME")
      IF thistable<>prevtable THEN
        response.write "<tr><th colspan='3'>Table : " & thistable & " - <a href='?action=viewtable&table=" & thistable & "'>open</a></td></tr>"
      END IF
      response.write "<tr><td bgcolor='#b4b4b4'>" & thiscolumn & "</td>" & _
                         "<td bgcolor='#b4b4b4'>" & fFieldName(rsSchema("DATA_TYPE")) & "</td>" & _
                         "<td bgcolor='#b4b4b4'>" & rsSchema("DESCRIPTION") & "</td>" & _
                     "</tr>"
      response.flush
      rsSchema.MoveNext
    LOOP
    response.write "</table>"

    oConn.Close
    Set rsSchema = nothing
    Set oConn    = nothing
  End Sub

  Private Sub sViewTable()
'*** displays the contents of a table ***
      response.write "opening table " & request.querystring("table")

      Set oConn = Server.CreateObject("ADODB.Connection")
      oConn.Open Session("sDynDSN")
      Set oRS   = Server.CreateObject("ADODB.Recordset")
      sSQL      = "SELECT TOP 10 * FROM " & request.querystring("table")

      Set oRS = oConn.Execute(sSQL)

      response.write "<table bgcolor='#8c8c8c' align='center'>"
      response.write "<tr>"
      for each x in oRS.Fields
  	  response.write "<th>" & x.Name & "</th>"
      next
      response.write "</tr>"
      do while NOT oRS.EOF
        response.write "<tr>"
        for each x in oRS.Fields
  	    response.write "<td bgcolor='#b4b4b4'>" & x.Value & "</td>"
        next
        response.write "</tr>"
        oRS.MoveNext
      loop
      response.write "</table>"

    oRS.Close
  End Sub


  Private Sub sUpload()
'*** does an ASP Upload using Persits ASP Upload ***
    Set oUpload = Server.CreateObject("Persits.Upload.1")
    oUpload.OverwriteFiles = False
    oUpload.Save(Request.QueryString("path"))
    Response.Redirect "?action=browse2&folder=" & Request.QueryString("path")
  End Sub

  Private Sub sMySQL()
'*** connects to mysql databases ***
    Response.Write "<b>MySQL Database Browser</b>"
    Dim oConn
    Dim oRS
    Set oConn = Server.CreateObject("ADODB.Connection")
    Set oRS   = Server.CreateObject("ADODB.RecordSet")
    oConn.Open(Request.QueryString("mysqldsnname"))
    If Request.QueryString("table") <> "" then
      Response.Write "<br>Back to database <a href='?action=mysql&mysqldsnname=" & Request.QueryString("mysqldsnname") & "'>" & Request.QueryString("mysqldsnname") & "</a>"
      Set oRS = oConn.Execute("DESCRIBE " & Request.QueryString("table"))
      Response.Write "<div align='center'><table bgcolor='#8c8c8c' width='500'><tr><th colspan='10'>Table View</th></tr>"
      For Each x in oRS.Fields
        Response.Write "<td bgcolor='#b4b4b4'>" & x.Name & "</td>"
      Next
      Do While Not oRS.EOF
        Response.Write "<tr>"
        For Each x in oRS.Fields
          Response.Write "<td bgcolor='#b4b4b4'>" & x.Value & "</td>"
        Next
        Response.Write "</tr>"
        oRS.MoveNext
      Loop
      Response.Write "</table></div>"
    Else
      Set oRS = oConn.Execute("SHOW TABLES")
      Response.Write "<div align='center'><table bgcolor='#8c8c8c'><tr><th>Tables</th></tr>"
      Do While Not oRS.EOF
        Response.Write "<tr>"
        For Each x in oRS.Fields
          Response.Write "<td bgcolor='#b4b4b4'>" & x.Value & " - <a href='?action=mysql&mysqldsnname=" & Request.QueryString("mysqldsnname") & "&table=" & x.Value & "'>view</a></td>"
        Next
        Response.Write "</tr>"
        oRS.MoveNext
      Loop
      Response.Write "</table></div>"
    End If
    oConn.Close
    Set oConn = Nothing
    Set oRS   = Nothing 
  End Sub

  Function sExplore(folder)
    Set oFolder = oFS.GetFolder(folder)
    fldsz = 0
    For Each f in oFolder.Files
      totalSize = totalSize + f.Size
      fldsz = fldsz + f.Size
    Next
    Response.Write "<br>" & oFolder.Path & " (" & oFolder.Files.Count & " files " & fSize(fldsz) & ")"
    For Each d in oFolder.SubFolders
      totalSize = totalSize + sExplore(d.Path)
    Next
    sExplore = totalSize
  End Function

'*******************************************************************
'********* End Functions - Start main Script ***********************
'*******************************************************************
%>
<html>
	<head>
		<title>Daniels Test Script
			<%=sVersion%>
		</title>
		<link rel="stylesheet" href="http://scripting.tv/testscriptstyle.css">
	</head>
	<body bgcolor="#CCCCCC" topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<center>
						<table border='0' cellspacing='0' width='90%'>
							<tr>
								<th colspan='2' bgcolor='#6e6e6e' align='center' background="http://scripting.tv/headtop.gif">
									<font color="#FFFFFF">Daniels Test Script v
										<%=sVersion %>
									</font>
								</th>
							</tr>
							<tr>
								<td bgcolor='#8c8c8c' width='175' valign='top'><% runnormal() %></td>
								<td bgcolor='#b4b4b4' width='600' valign='top'>
									<%
'********** The Main Daddy-o sub picker ****************************

  Select Case request.querystring("action")
    Case "jmail"        : runJmail()                    'sends Jmail using normal SMTP server
    Case "lazymail"     : runLazyJmail()                'sends Jmail emails using the .LazySend option
    Case "cdonts"       : runCDONTS()                   'sends CDONTS emails
    Case "cdontsatt"    : runCDONTSATT()                'sends DEONTS email with this file attached
    Case "cdo"          : runCDOSYS()                   'sends CDO for Win2k emails if supported
    Case "support"      : getCreateObject()             'lets user specify an object to create
    Case "creater"      : runCreateObject()             'attempts to create user defines objects
    Case "install"      : sCheckInstall()               'installs some scripts for testing
    Case "hkeep"        : hkeep()                       'some housekeeping for files created by this script
    Case "view"         : view()                        'views files
    Case "delete"       : delete()                      'deletes files
    case "servervars"   : showServerVariables()         'shows all serverside variables
    Case "ses"          : showSessionContents()         'shows all session contents
    Case "browse"       : sBrowse()                     'starts at root and displays drives [should show none unlecc incorrectly configured!]
    Case "browse2"      : sBrowse2()                    'shows contents of folders
    Case "info"         : sGeneralInfo()                'some generic info
    Case "adv"          : sAdvConf()                    'form for input of smtp & from/to address
    Case "advcnfsetup"  : sAdvCnfSetup()                'sets smtp, from/to address etc
    Case "dsnsetup"     : sCreateDSN()                  'creates a dsn to a database
    Case "viewdb"       : sViewDB()                     'pulls all tables from a db
    Case "viewtable"    : sViewTable()                  'displays contents of a single table [max 10 items]
    Case "creator"      : sCreator()                    'create files/folders
    Case "deletor"      : sDeletor()                    'delete files/folders
    Case "editor"       : sEditor()                     'allows editing of files on the server
    Case "abandon"      : sAbandon()                    'abandons current session
    Case "upload"       : sUpload()                     'does an ASP Upload
    Case "mysql"        : sMySQL()                      'does some cool mysql stuff
    Case "jmailmessage" : sJmailMessage()               'Jmail.Message test
    Case "explore"      :                               'site sizing
	Response.Write "<b>Site Sizing</b>"
	Set oFS = Server.CreateObject("Scripting.FileSystemObject")               
	Response.Write "<br><br><b>Total Size = " & fSize(sExplore(Server.MapPath("."))) & "</b>"
	Set oFS = Nothing                    
    Case Else           : sDefault()                    'default action
   End Select

'*******************************************************************
%>
								</td>
							</tr>
							<tr>
								<th colspan='2' bgcolor='#6e6e6e' align='center'>
									<font color="#FFFFFF">Change Default Email Address</font></th></tr>
							<tr>
								<td bgcolor='#b4b4b4' align='center' colspan='2'>
									<%
  if request.querystring("action") = "changeemail" then
    doEmailChange()
  else
    runEmailChange()
  end if
%>
								</td>
							</tr>
							<tr>
								<td colspan='2' bgcolor='#6e6e6e' align='center' background="http://scripting.tv/headtop.gif"><font color="#FFFFFF">Script 
										Processing Time :
										<%
  sEndTime = Timer
  sDeltaTime = FormatNumber(sEndTime - sStartTime, 4)
  response.write sDeltaTime
%>
									</font>
								</td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
		</table>
	</body>
</html>