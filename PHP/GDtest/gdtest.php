<?php
header("Content-type: image/png");
$string = $_GET['text'];
$im     = imagecreatefrompng("test.png");
$orange = imagecolorallocate($im, 220, 210, 60);
$px     = (imagesx($im) - 7.5 * strlen($string)) / 2;
imagestring($im, 3, $px, 9, $string, $orange);
imagepng($im);
imagedestroy($im);
//This example would be called from a page with a tag like: <img src="button.php?text=text">. The above button.php script then takes this "text" string and overlays it on top of a base image which in this case is "test.png" and outputs the resulting image. This is a very convenient way to avoid having to draw new button images every time you want to change the text of a button. With this method they are dynamically generated. 
?> 