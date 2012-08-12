<%
Response.buffer = true
  
Dim conn, rs
set conn=Server.CreateObject("ADODB.Connection")

conn.Open "DSN=dsnSpotlight"

'Uncomment the following lines and modify them if you know a table name and an field you can query and sort by, etc.
'set rs = Server.CreateObject ("ADODB.RecordSet")
'rs.ActiveConnection = conn

'rs.Open "SELECT * FROM Table WHERE SearchField LIKE 'SearchItem' ORDER BY IDField", conn
'While Not rs.EOF
'  Response.Write rs("RequiredField") & "<br/>"
'  rs.MoveNext
'Wend
'rs.Close

conn.Close
Set rs = Nothing
Set conn = Nothing

%>