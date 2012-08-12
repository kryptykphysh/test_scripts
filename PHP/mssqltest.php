<?php 
mssql_connect("213.171.218.238", "sysquser", "oaksuser"); 
mssql_select_db("sysqdb"); 
echo mssql_error(); 
echo "</p>If you do not see any errors then connection was sucessfull!"; 
?> 