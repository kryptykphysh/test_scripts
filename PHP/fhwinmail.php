<? 

ini_set("sendmail_from", "root@customersdomain.com");

$from = 'root@customersdomain.com'; 

if ( mail("external.test@gmail.com", "Test mail from phpmail","This is a test PHP Email", "From: $from" ))
   { 
     print "Mail sent"; 
   }
else
   {
     print "failed";
   } 

?>