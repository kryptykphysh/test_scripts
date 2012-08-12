<?php

session_start();

if ($_GET[endsession]) 
   {
     print "<p>Session Destroyed - <a href=fhsesstest.php>continue</a></p>";
     session_destroy();
   }

else 
   { 
     $_SESSION["count"]++; 
     print "Session has been visited ".$_SESSION["count"]." times<br /><a href=fhsesstest.php?endsession=true>end session</a>";
   }

print "<img src=wine.jpg height=".(400-(10*$_SESSION["count"]))." width=400>";

?>