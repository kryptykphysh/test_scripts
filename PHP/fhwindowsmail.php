<? 

ini_set("sendmail_from", "external.test@gmail.com");

$from = 'external.test@gmail.com'; 

if ( mail("root@whiteeagledistribution.co.uk", "Test mail from phpmail","This is a test PHP Email", "From: $from" ))
   { 
     print "Mail sent"; 
   }
else
   {
     print "failed";
   } 

?>