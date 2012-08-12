<!DOCTYPE html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<TITLE>PHP Upload Test</TITLE>
<style>
body {
	background-color : #f2f2f2;
	color : #000000;
	font-family : verdana, geneva;
	font-size:11px;
	line-height:15px;
}


TD, P, PRE {
	color : #000000;
	font-family : verdana, geneva;
	font-size:11px;
	line-height:15px;
}

</style>
</HEAD>
<BODY>
<DIV align="center" style="margin-top:60px">
		<table style="background-color:#ffffff; width:500px; border width:1px solid #666666;" cellpadding="8">
			<tr>
				<td style="font-family: arial; font-size: 17px; font-weight: bold; color: #000000;">
					PHP Upload Test
				</td>
			</tr>
		</table>
		<br><br>
		<table style="background-color: #ffffff; width: 500px; border width: 1px solid #666666;" cellpadding="8">
			<tr>
				<td style="line-height:18px">
					This form will attempt to upload a file using php, renamed to a 'safe' extension for security <hr noshade width='90%' size='1px'>


<?

	if(isset($_POST['submitted']))
	{
		if(!is_dir('fh_test'))
		{
			mkdir('fh_test', 0777); 
		}
		$path = realpath("fh_test");
		$uploadfile = $path . "/" . $_FILES['userfile']['name'] . ".txt";
		print "<pre>";

		if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) 
		{
  			print "File is valid, and was successfully uploaded.<br><br>";
			print_r($_FILES);
		} 
		else 
		{
			print "<b>Possible file upload attack!</b>  Here's some debugging info:<br>";
			print_r($_FILES);
		}
		print "</pre>";
	}
	else
	{
?>
<form enctype="multipart/form-data" action="?" method="post">
 <input type="hidden" name="MAX_FILE_SIZE" value="2000000" />
 <input type="hidden" name="submitted" value="true" />
 Send this file: <input name="userfile" type="file" />
 <input type="submit" value="Send File" />
</form>
<?
	}


?> 


				</td>
			</tr>
		</table>
</div>
</BODY>
</HTML>
