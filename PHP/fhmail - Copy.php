<?php 

$from = 'root@kirkintillochinsuranceservices.co.uk'; 
$to = 'insure@kirkintillochinsuranceservices.co.uk';


if ( mail("$to", "Test mail from phpmail","This is a test PHP Email", "From: $from", "-f$from" ))
   { 
     print "Mail sent"; 
   }
else
   {
     print "failed";
   } 

?>