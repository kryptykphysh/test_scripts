<?
mail( "info@ratcliffes.co.uk; $_POST[email]", "Feedback Form
results",$_POST[message], "From: $_POST[email]", "-finfo@ratcliffes.co.uk" );

header( "Location: feedback.htm" );
?>