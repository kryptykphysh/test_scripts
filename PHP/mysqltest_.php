<?php
$dblink = mysql_connect("213.171.219.94", "sdfsdfsdf", "sdfsdfsdf") or  die("Could not connect to MySQL server"); 

$db = mysql_select_db("sdfsdfsdf") or die("Could not connect to Database"); 

$res = mysql_query("SHOW TABLES ") or die("Could not run query"); 

$row = mysql_fetch_array($res); 

if($row == "")
{ echo "No tables found, connection works.";}
else
{ echo "Tables found and connections work.<br />Tables found:<br />"; 
 foreach($row as $key => $value){ if(is_numeric($key)){ echo $value."<br />"; } } }?><br />Script created at: 18/07/2008 01:43:35<br />Current time/date: <? echo date("d\/m\/Y h:i:s"); ?>
