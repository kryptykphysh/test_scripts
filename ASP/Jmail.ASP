<html>

<head>
<title>w3 JMail rocks</title>
</head>

<body>
<p align="center"><font face="Arial, geneva" size="5"> Email Form</font></p>
<%

Set JMail = Server.CreateObject("JMail.SMTPMail") 

' Below you should enter your own SMTP-server 
JMail.ServerAddress = "smtp-out.promailbox.net" 
JMail.Sender = "blogger@bloggerthanyou.com"
JMail.Subject = "Testing"
JMail.AddRecipient "2ndline@fasthosts.co.uk"
JMail.AddHeader "Originating-IP", Request.ServerVariables("REMOTE_ADDR") 
JMail.Logging = True
JMail.Execute

%>
<center>
<font face="Arial, geneva" size="3">
Your email has been sent to <%= Recipient %><br>
</font>

</center>
</body>
</html> 