<%

If Request("command") = "send" Then

	Dim oCdoMsg, oCdoConfg, strReferer, strServer, strClientIP, strServerIP, blnSpam

	Dim SMTPServer, SMTPUsername, SMTPPassword, mailInfo
	  
' Next set up the CDO object.

	Set oCdoMsg = server.createobject("CDO.Message")
	  
' After that obtain some information about the site using the request.servervariables object. 
' Note that we get the referrer page here. This is the page that carried out the page post operation. 

	strReferer = request.servervariables("HTTP_REFERER")
	strServer = Replace(request.servervariables("SERVER_NAME"), "www.", "")
	strClientIP = request.servervariables("REMOTE_ADDR")
	strServerIP = request.servervariables("LOCAL_ADDR")
'	strFrom = "noreply@"  & strServer
      
	Select Case strServer
		Case "advent"
			SMTPServer = "localhost"
			SMTPUsername = Request("username")
			SMTPPassword = Request("password")
		Case Else
'			SMTPServer = "smtp." & strServer
			SMTPServer = "localhost"
			SMTPUsername = Request("username")
			SMTPPassword = Request("password")
	End Select


' Now use this information to check that the posting page is on the same site as the script. 
' This prevents others using your script for bulk emailing activities - see the note at the bottom of this page.

	intComp = inStr(strReferer, strServer)
	If intComp > 0 Then
		blnSpam = False
	Else
' Spam Attempt Block
		blnSpam = True
	End If
      
	Response.Write "Client IP: " & strClientIP & "<br>"
	Response.Write "Server IP: " & strServerIP & "<br>"
	Response.Write "Referer: " & strReferer & "<br>"
	Response.Write "Server: " & strServer & "<br>"
	Response.Write "Spam: " & blnSpam & "<br>"
	Response.Write "SMTP Server: " & SMTPServer & "<br>"
	Response.Write "SMTP Username: " & SMTPUsername & "<br>"
	Response.Write "SMTP Password: " & SMTPPassword & "<br>"

	mailInfo =	"Client IP: " & strClientIP & vbCrLf & _
				"Server IP: " & strServerIP & vbCrLf & _
				"Referer: " & strReferer & vbCrLf & _
				"Server: " & strServer & vbCrLf & _
				"Spam: " & blnSpam & vbCrLf & _
				"SMTP Server: " & SMTPServer & vbCrLf & _
				"Time: " & Now()

' Next populate the CDO object with the correct data. 
' Note that we use the server information to set up the sender and the smtp server. The recipient is obtained from the request object.

	oCdoMsg.to = request.form("to")
	oCdoMsg.from = request.form("from")
	oCdoMsg.Subject = request.form("subject")
	oCdoMsg.Textbody = request.form("body") & vbCrLf & mailInfo
		
' The next section sets CDO to use our main SMTP server cluster rather than the local MS SMTP Service.  We recommend using our main SMTP servers.

	strMSSchema = "http://schemas.microsoft.com/cdo/configuration/"
	Set oCdoConfg = Server.CreateObject("CDO.Configuration")
	oCdoConfg.Fields.Item(strMSSchema & "sendusing") = 2 ' cdoSendUsingPort
	oCdoConfg.Fields.Item(strMSSchema & "smtpserver") = SMTPServer
	oCdoConfg.Fields.Item(strMSSchema & "smtpauthenticate") = 0 ' cdoAnonymous
'	oCdoConfg.Fields.Item(strMSSchema & "sendusername") = SMTPUsername
'	oCdoConfg.Fields.Item(strMSSchema & "sendpassword") = SMTPPassword
	oCdoConfg.Fields.Item(strMSSchema & "smtpserverport") = 25
	oCdoConfg.Fields.Item(strMSSchema & "smtpusessl") = False
	oCdoConfg.Fields.Item(strMSSchema & "smtpconnectiontimeout") = 60
	oCdoConfg.Fields.Update 
	Set oCdoMsg.Configuration = oCdoConfg
	  
' This bit of code checks the referrer is correct, and if so sends the mail through CDO to the local SMTP server queue.

	Response.Flush
	If NOT blnSpam Then
		On Error Resume Next
		oCdoMsg.send
		If Err Then
			Response.Write Err.Number & ": " & Err.Description & "<br>"
' The server rejected one or more recipient addresses. 
' -2147220977 
' The server response was: 554 : Client host rejected: Access denied
' The server response was: 551 : Bad Recipient
			Response.Flush
			strResult = "Mail sending failed."
		Else
			strResult = "Mail Sent."
		End If
		On Error Goto 0
	 Else
		strResult = "Mail Not Sent."
	End If
	Response.write strResult 
   
' After outputting whatever text you want to tell the client that the job is done, clean up the objects we have used.

	 Set oCdoMsg = nothing
	 Set oCdoConfg = nothing

End If
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<title>Type Here</title>
</head>
<body>
<form method=POST action="cdo_mail.asp">
	<input type=hidden name="command" value="send" />
	<table>
		<tr>
			<td valign="top"><b>username:&nbsp;</b></td>
			<td valign="top">
				<input type=text name="username" size="20" value="<%=Request("username")%>">
			</td>
		</tr>
		<tr>
			<td valign="top"><b>password:&nbsp;</b></td>
			<td valign="top">
				<input type=text name="password" size="20" value="<%=Request("password")%>">
			</td>
		</tr>
		<tr>
			<td valign="top"><b>from:&nbsp;</b></td>
			<td valign="top">
				<input type=text name="from" size="30" value="<%=Request("from")%>">
			</td>
		</tr>
		<tr>
			<td valign="top"><b>to:&nbsp;</b></td>
			<td valign="top">
				<input type=text name="to" size="30" value="<%=Request("to")%>">
			</td>
		</tr>
		<tr>
			<td valign="top"><b>subject:&nbsp;</b></td>
			<td valign="top">
				<input type=text name="subject" size="35" value="<%=Request("subject")%>">	
			</td>
		</tr>
		<tr>
			<td valign="top"><b>body text:&nbsp;</b></td>
			<td valign="top">
				<textarea name="body" cols="40" rows="6"><%=Request("body")%></textarea>
			</td>
		</tr>
		<tr>
			<td valign="top">
			</td>
			<td align=right valign="top">
				<input type=submit value="Submit" name="send" style="font-weight: bold">
			</td>
		</tr>
	</table>
</form>
</body>
</html>