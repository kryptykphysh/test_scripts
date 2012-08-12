#!/usr/bin/perl
# Written by C James (2002-2004)

#################################################################################
# This script written by Angelstorm Innovations ( http://angelstorm.co.uk )     #
# Comments and bugs can be sent to scripts@angelstorm.co.uk                     #
# Donations for its use can be sent to any UK registered charity.               #
#                                                                               #
# This program is free software; you can redistribute it and/or modify          #
# it under the terms of the GNU General Public License as published by          #
# the Free Software Foundation; either version 2 of the License, or             #
# (at your option) any later version.                                           #
#                                                                               #
# This program is distributed in the hope that it will be useful,               #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 #
# GNU General Public License for more details.                                  #
#                                                                               #
# You should have received a copy of the GNU General Public License             #
# along with this program; if not, write to the Free Software                   #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA     #
#################################################################################

# Please note !!!
# Willow will ( with the exception of strict and cgi ) always "require" and then
# "import" rather than "use" a module.
# This is because the former is only initiated when the script is run and that
# particular line is encountered. "use" will call the module on initial load.
# The difference may seem small but, importantly, this means that willow will
# initially load with just CGI and will only fail on sub-routines that call
# an external module that isn't present.

use strict;
use CGI;

# Hook errors to browser. This will catch errors that our die handler misses.
use CGI::Carp qw(fatalsToBrowser);
my $cgi = new CGI;

$SIG{__DIE__} = \&error;
my $release = "4.0.1";
my $reldate = "8th May 2004";

my $cmd = $cgi->param("cmd");
$cmd =~ s/[^a-z]//g;
if(($cgi->param("com") eq "version") or $cmd eq "version")
{
        output( "text/plain", "Willow\nVersion : $release\nRelease date : $reldate\n" );
        exit(1);
}

# Initialise Globals
my($rootpath, $slash, $scriptname, $cgipath, $domain);
init_globs();

# Now we authenticate our user. Unlike previous versions of willow,
# you must have entered a valid password for all actions (except version).
# This will assist in protecting against any exploits that I haven't spotted.
# Please note, the first edition of Willow had NO KNOW VULNERABILITES.
# However, I wasn't happy that so much information was available to the general public.

# The added bonus of this is that once we have verified the user, we no longer have to parse
# all parameters for content.
# This means we can allow ALL characters in passed paramaters since the only people who should
# have access to willow are people with ftp access and so forth anyway.
#
# You cannot cross-site attack willow as no paramaters are parsed until the user is verified.
#
# NOTE : The session key has 218,340,105,584,896 variations. This is effectively a stronger
# security measure than the users password.

my $key = $cgi->param("key");
$key =~ s/[^0-9a-zA-Z]//g;
my $scripturl= $scriptname."?key=".$key;

if(verify())
{
	
	# Lets call the command sub-routine
	my @lines;
	   if($cmd eq "env") { environment(); 	}
	elsif($cmd eq "mod") { modules(); 	}
	elsif($cmd eq "nfo") { server_info(); 	}
	elsif($cmd eq "doc") { documentation(); }
	elsif($cmd eq "upd") { update(); 	}
	elsif($cmd eq "src") { view_source(); 	}
	elsif($cmd eq "sql") { mysql_test(); 	}
	elsif($cmd eq "eml") { email_test(); 	}
	elsif($cmd eq "brw") { browser(); 	}
	elsif($cmd eq "pwd") { password(); 	}
	elsif($cmd eq "log") { logout(); 	}
	elsif($cmd eq "edt") { edit_file(); 	}
			else { no_command(); 	}
}

else
{
 	login();
}

#################################################################################
# Main Program Sub-Routines
#
#################################################################################

sub update
{
	# Try and update willow to the latest version.
	print "Content-type: text/html\n\n";
	print "<HTML><BODY>\n";
	print "Trying to import LWP::Simple module<BR>\n";
	require LWP::Simple;
	import LWP::Simple;
	print "Contacting master server<BR>\n";
	my $version = get('http://angelstorm.co.uk/cgi-bin/willow.pl?com=version');
	$version =~ /.*Version : (.*)\n.*/s;
	$version = $1;
	if($version > $release)
	{
		print "Latest version : $version<BR>Your version $release<BR>\n";
		print "Downloading new version<BR>\n";
		my $lines = get('http://angelstorm.co.uk/cgi-bin/source.pl?file=willow.pl');
		open(FH, "> willow.new") or print "Cannot open new file for writing! This is fatal!<BR>\n";
		print FH $lines;
		close(FH);
		(-e "willow.new") and system("mv willow.new willow.pl");
		print "<B>Update completed</B><BR>\n";
		print "<BR>Please click <A HREF=\"$scripturl\">Here</A> to return to Willow</A>";
	}
	else
	{
		print "You already have the most current version of Willow.<BR><B>Update aborted</B>\n<BR>\n";
		print "<BR>Please click <A HREF=\"$scripturl\">Here</A> to return to Willow</A>";
	}
	print "</BODY></HTML>";
}

#################################################################################

sub password
{
	(unlink $cgipath."willow.pwd") or die "Couldn't unlink password file";
	redirect($scriptname,"Resetting password", 1);
}

#################################################################################

sub view_source
{
	my $lines = join('\n', read_text($rootpath.$scriptname));
	my $type = $cgi->param("type");
	if($type eq "txt")
	{
		output ("text/plain", $lines);
	}
	else
	{
		$lines =~ s/\</\&lt\;/g;
		$lines =~ s/\>/\&gt\;/g;
		$lines = "Please click <A HREF=\"$scripturl\">Here</A> to return to Willow</A><BR><BR><A HREF=\"$scripturl&amp;cmd=src&amp;type=txt\">Click here to download the source code directly ( no HTML )</A><BR><BR><PRE>$lines</PRE>";
		output ("text/html", "<HTML><BODY>$lines</BODY></HTML>");
	}
}

#################################################################################
sub email_test
{
	my $lines = <<HTMLCODE;
	<H1>[Email Test]</H1>
	<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
	<TR>
	<TD VALIGN="TOP" BGCOLOR="#EEEEEE" COLSPAN=2>
	<B>Formmail send test</B><BR><BR>
HTMLCODE
	my $action = $cgi->param("action");
	if( $action eq "send" )
	{
		my $mta = $cgi->param("mta");
		my $rcpt = $cgi->param("rcpt");
		my $from = $cgi->param("from");
		my $smtpserver = $cgi->param("smtpserver");
		($smtpserver) or $smtpserver = "smtp.$domain";
		($smtpserver =~ /.*:\d*$/) or $smtpserver = $smtpserver .= ":25";
		
		$lines .= "Sending a test mail using the <B>$mta</B> component<BR><BR>\n";
		my $sent = "Sent from : $from\n<BR>Sent to : $rcpt\n<BR>smtp server is : $smtpserver\n<BR><BR>\n<B>Send appeared to be sucessfull<BR><BR>\n";
		
		my $subject = "Test mail from $domain using $mta";
		$scripturl =~ /(.*)\?.*/;
		my $body = "This is a test mail sent using the $mta component.\nServer time is ".localtime()."\n\nThis was sent using Willow from the URL http://$domain$1\n";
		
		if($mta eq "sendmail")
		{
			open(MAIL,"|/usr/sbin/sendmail -i -t -f $from") or die "Cannot send mail using the Sendmail component";
			print MAIL "From: $from\n";
			print MAIL "To: $rcpt\n";
			print MAIL "Subject: $subject\n\n";
			print MAIL $body;
			close( MAIL );
			$lines .= $sent;
		}

		elsif($mta eq "jmail")
		{
			require OLE;
			import OLE;
			my $jmail = CreateObject OLE "JMail.SMTPMail" or die "Cannot use the OLE::Jmail Module";
			$jmail->{ServerAddress} = $smtpserver;
			$jmail->{Sender} = $from;
			$jmail->{Subject} = $subject;
			$jmail->AddRecipient ($rcpt);
			$jmail->{Body} = $body;
			$jmail->Execute;
			$lines .= $sent;
		}

		elsif($mta eq "netsmtp")
		{
			require Net::SMTP;
			import Net::SMTP;
			my $smtp = Net::SMTP->new($smtpserver) or die "Cannot connect to $smtpserver.";
			$smtp->mail($from);
			$smtp->to($rcpt);
			$smtp->data();
			$smtp->datasend("To: $rcpt\n");
			$smtp->datasend("From: $from\n");
			$smtp->datasend("Subject: $subject\n\n");
			$smtp->datasend("$body");
			$smtp->dataend();
			$smtp->quit;
			$lines .= $sent;
		}
		
		elsif($mta eq "socket")
		{
			require Socket;
			import Socket;
			my $x;
			my $here;
			my $null;
			($x,$x,$x,$x, $here) = gethostbyname($null);

			my $thisserver = pack('S n a4 x8',2,0,$here);

			$smtpserver =~ /(.*)\:(.*)/;
			my $smtpserver = $1;
			my $port = $2;

			my $iaddr = inet_aton($smtpserver); 
			my $paddr = sockaddr_in($port, $iaddr); 

			((socket(S,2,1,6))) or die "Connect error when trying to create socket.";
			((bind(S,$thisserver))) or die "Connect error when trying to bind to socket";
			((connect(S,$paddr))) or die "Connection to $smtpserver on port $port has failed!";
			select(S);
			$| = 1;
			select(STDOUT);
			my $DATA = <S>;
			($DATA !~ /^220/) and die "Data in Connect error to $smtpserver Port $port";

			print S "HELO $domain\r\n";
			$DATA = <S>;
			($DATA !~ /^250.*/) and die "$DATA\nConnect error ( HELO )";

			print S "MAIL FROM:<$from>\r\n";
			$DATA = <S>;
			($DATA !~ /^250.*/) and die "From address rejected ( MAIL FROM: )";

			print S "RCPT TO:<$rcpt>\r\n";
			$DATA = <S>;
			($DATA !~ /^250.*/) and die "Recipient address rejected ( RCPT TO: )";

			print S "DATA\r\n";
			$DATA = <S>;
			($DATA !~ /^354.*/) and die "Message send failed when trying to initialise DATA";

			print S "From: $from\r\nTo: $rcpt\r\nSubject: $subject\r\n\r\n$body\r\n.\r\n";
			$DATA = <S>;
			($DATA !~ /^250/) and die "Message send failed when trying to send DATA";

			print S "QUIT\n";
			$lines .= $sent;
		}
		
		else
		{
			$lines .= "<STRONG>$mta is not a valid Mail Transport Agent</STRONG>";
		}
	}
	else
	{
		$lines .= <<HTMLCODE;
		Use this utility to send a test mail using one of the components listed below<BR>
		<BR>
		<form method="post" action="$scriptname">
		<input type="hidden" name="key" value="$key">
		<input type="hidden" name="cmd" value="eml">
		<input type="hidden" name="action" value="send">
		<input type="radio" name="mta" value="sendmail"> : Sendmail (Linux)<BR>
		<input type="radio" name="mta" value="jmail"> : Jmail (Windows)<BR>
		<input type="radio" name="mta" value="netsmtp"> : Net::SMTP Module (Linux / Windows)<BR>
		<input type="radio" name="mta" value="socket" checked> : Socket Mail (Linux / Windows)<BR>
		<BR>
		Send email to : <BR><input type="text" name="rcpt" value="" size="40" maxlength="200"><BR><BR>
		Send email from : <BR><input type="text" name="from" value="" size="40" maxlength="200"><BR><BR>
		SMTP Server : <BR><input type="text" name="smtpserver" value="smtp.$domain" size="40" maxlength="200"><BR><BR>
		<input type="submit" value="Send test mail" name="submit"></form>
HTMLCODE
	}
	$lines .= <<HTMLCODE;
	</TD></TR></TABLE>
HTMLCODE
	my $html = html_source();
	$html =~ s/##content##/$lines/g;
	output ("text/html", $html); 
}

#################################################################################

sub mysql_test
{
	my $lines = "
	<H1>[MySQL DBI module Connection Test]</H1>
	<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
	<TR>
	<TD VALIGN=\"TOP\" BGCOLOR=\"#EEEEEE\">
	<B>Test connection to a MySQL Database</B><BR>
	";
	my $DBHOST = $cgi->param("dbhost");
	my $DBNAME = $cgi->param("dbname");
	my $DBUSER = $cgi->param("dbuser");
	my $DBPASS = $cgi->param("dbpass");
	my $DBCOMM = $cgi->param("dbcomm");			
	
	if($DBPASS)
	{
		$DBCOMM =~ s/%20/\\ /g;
		require DBI;
		import DBI;
		my $dbh = DBI->connect("dbi:mysql:$DBNAME:$DBHOST:3306", $DBUSER, $DBPASS);

		if(! $dbh){ $lines .= "<STRONG>Failed to connect to database</STRONG><BR>Reason : ".$DBI::errstr."<BR><BR>\n"; }
		else
		{
			# prepare the query
			my $sth = $dbh->prepare("$DBCOMM");

			# execute the query
			$sth->execute();

			$lines .= "<B>Connection OK</B><BR><BR>\n";
			$lines .= "<B>Information received from</B><BR>$DBHOST :: $DBNAME<BR><BR>\n";
			$lines .= "<B>* Begin data block<BR></B>";
			while(my (@info) = $sth->fetchrow_array())
			{
				foreach(@info)
				{
					my $line = $_;
					$line =~ s/\</&lt/g;
					$line =~ s/\>/&gt/g;
					$lines .= "<B>*</B> $line<BR>\n";
				}
			}
			$lines .= "<B>* End data block<BR></B>\n";
		}
	}
	$lines .= <<HTMLCODE;
	<form method="post" action="$scriptname">
	<input type="hidden" name="cmd" value="sql">
	<input type="hidden" name="key" value="$key">
	<input type="text" name="dbhost" value="$DBHOST" size="40" maxlength="200"> : Hostname or IP address<BR>
	<input type="text" name="dbname" value="$DBNAME" size="40" maxlength="200"> : Database Name<BR>
	<input type="text" name="dbuser" value="$DBUSER" size="40" maxlength="200"> : Username<BR>
	<input type="password" name="dbpass" value="$DBPASS" size="40" maxlength="200"> : Password<BR>
	<input type="text" name="dbcomm" value="" size="40" maxlength="200"> : SQL Commanand<BR><BR>
	<input type="submit" value="Test Connection" name="submit"></form>
	</TD></TR></TABLE>
HTMLCODE
	 my $html = html_source();
	 $html =~ s/##content##/$lines/g;
	 output ("text/html", $html);	
}
	
#################################################################################
sub no_command
{
	my $lines = <<HTMLCODE;
	<H1>[Welcome to Willow]</H1>
	<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
	<TR>
	<TD VALIGN="TOP" BGCOLOR="#EEEEEE">
	<B>Introduction</B><BR>
	Willow is a script written with the intent of providing a simple and stable method of diagnosing, testing and gathering information on a webserver.<BR><BR>
	It was written because there did not seem to be a utility script on general release that covered enough aspects of site administration and component testing.<BR><BR>
	The aim of Willow is to provide a comprehensive toolset that can be used to test, diagnose and administer your server or domain.<BR><BR>
	<B>Testing</B><BR>
	Willow has been tested extensively on the following platforms.<BR>
	<UL>
	<LI>RedHat Linux 6.2 -> 9.0 (Apache 1.3.23 -> Apache 2.0.48)
	<LI>Microsoft Windows 2000 ( IIS5 )
	<LI>Microsoft Windows 2003 ( IIS6 )
	</UL>
	As more platforms are verified as working correctly, they will be added to the list above.<BR>
	<BR>
	<B>Contact</B><BR>
	Any queries regarding development issues for Willow can be forwarded to willow\@angelstorm.co.uk<BR>
	</TD>
        </TR>
        </TABLE>
HTMLCODE
	 my $html = html_source();
	 $html =~ s/##content##/$lines/g;
	 output ("text/html", $html);
}

#################################################################################
sub edit_file
{	
	my $lines = <<HTMLCODE;
	<H1>[File Editor]</H1>
	<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
	<TR>
	<TD VALIGN="TOP">
HTMLCODE
	my $path = $cgi->param("file");
	($path) or die "No file specified for editing";
	my $action = $cgi->param("action");
	if($action eq "Save")
	{
		my $text = $cgi->param("text");
		write_text($path, $text);
		$lines .= <<HTMLCODE;
		<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH="100%">
		<TR><TD BGCOLOR="#EEEEEE">
		<P ALIGN="CENTER"><B>Saved!</B><BR><BR>The File<BR>
		<B>$path</B><BR><BR>Has been saved.<BR>
		Please click <A HREF="$scripturl&cmd=brw&path=$1">here</A> to return.
HTMLCODE
	}
	elsif($action eq "Cancel")
	{
		$path =~ /(.*)[\\|\/].*/;
		$lines .= <<HTMLCODE;
		<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH="100%">
		<TR><TD BGCOLOR="#EEEEEE">
		<P ALIGN="CENTER"><B>Cancelled!</B><BR><BR>
		You have cancelled the edit of the file:<BR><B>$path</B><BR><BR>
		Please click <A HREF="$scripturl&cmd=brw&path=$1">here</A> to return.
HTMLCODE
	}
	elsif(-T $path)
	{
		$path =~ /(.*)[\\|\/].*/;
		my $uplevel = $1;
		my $text = read_text($path);
		$text =~ s/\</\&lt;/g;
		$text =~ s/\>/\&gt;/g;
		$lines .= <<HTMLCODE;
		<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH="100%">
		<FORM METHOD="POST" ACTION="$scripturl">
		<INPUT TYPE="HIDDEN" NAME="file" VALUE="$path">
		<INPUT TYPE="HIDDEN" NAME="key" VALUE="$key">
		<INPUT TYPE="HIDDEN" NAME="cmd" VALUE="edt">
		<TR><TD BGCOLOR="#EEEEEE">
		<B>[$path]</B>
		<HR>
		<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH="100%" class=noborder>
		<TR><TD ALIGN="LEFT" WIDTH="50%">
		<INPUT TYPE="submit" NAME="action" VALUE="Cancel">
		</TD><TD ALIGN="RIGHT" WIDTH="50%">
		<INPUT TYPE="submit" NAME="action" VALUE="Save">
		</TD></TR>
		</TABLE>
		<HR>
		<TEXTAREA NAME="text" ROWS="20" COLS="80" WRAP="virtual">$text</TEXTAREA>
		</TD></TR></FORM></TABLE>
		
HTMLCODE
	}
	
        $lines .= "</TD></TR></TABLE>";
	my $html = html_source();
	$html =~ s/##content##/$lines/g;
	output ("text/html", $html);
	return;
}

#################################################################################

sub browser
{
	my $lines = <<HTMLCODE;
	<H1>[Directory Browser]</H1>
	<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
	<TR>
	<TD VALIGN="TOP">
HTMLCODE

	my $path = $cgi->param("path");
	($path) or $path = $rootpath;
	my %files;
	if(-d $path)
	{
		$path =~ /.*[\\|\/]$/ or $path .= $slash;
		$path =~ /(.*)[\\|\/](.*)[\\|\/]/;
		my $uplevel = $1;
		$lines .= <<HTMLCODE;
		<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH="100%">
		<form method="post" action="$scriptname">
		<TR><TD BGCOLOR="#EEEEEE">
		<B>Current Path = $path</B><HR>
		<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH="100%" class=noborder>
		<TR><TD ALIGN="LEFT">
		<A HREF="$scripturl&amp;cmd=brw&amp;path=$uplevel">^ Up ^</A>
		</TD><TD ALIGN="RIGHT">
		<input type="hidden" name="key" value="$key">
		<input type="hidden" name="cmd" value="brw">
		<input type="text" name="path" value="" size="30" maxlength="100">
		<input type="submit" name="submit" value="Goto">
		</TD></TR></TABLE>
		<HR>
		</TD>
		</TR>
		</form>
		</TABLE><BR>
HTMLCODE
		my @list;
		my @newlist;
		opendir(DIR, $path);
		my @dirlist = readdir(DIR);
		closedir DIR;  

		foreach(@dirlist)
		{
			unless( ($_ =~ /^\.\.$/) or ($_ =~ /^\.$/))
			{
				push @list, $path.$_;
			}
		}
		if(@list)
		{
			foreach(@list)
			{
				my $fn = $_;
				$fn =~ /.*[\/|\\](.*?)$/;
				my $file = $1;
				$fn =~ s/\/\//\//g;
				-d $fn and $file = $slash.$file;
				my $size = -s $fn;
				$files{$fn."##".$size} = $file;
			}
		}
		else
		{
			$lines .= "<STRONG>No files found or server permissions prevent listing!</STRONG>\n";
		}
	}
	else
	{
		if($path =~ /.*\.(jpg|gif|png|jpeg)$/i)
		{
			my $ext = $1;
			($ext eq "jpg") and $ext = "jpeg";
			show_image($path,$ext);
			return;
		}
		elsif( -T $path )
		{
			$path =~ /(.*)[\\|\/].*/;
			my $uplevel = $1;
			my $text = read_text($path);
			$text =~ s/\</\&lt;/g;
			$text =~ s/\>/\&gt;/g;
			$lines .= <<HTMLCODE;
			<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH="100%">
			<TR><TD BGCOLOR="#EEEEEE">
			<B>[$path]</B>
			<HR>
			<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH="100%" class=noborder>
			<TR><TD ALIGN="LEFT" WIDTH="50%">
			<A HREF="$scripturl&amp;cmd=brw&amp;path=$uplevel">&lt;&lt; Back</A>
			</TD><TD ALIGN="RIGHT" WIDTH="50%">
			<A HREF="$scripturl&amp;cmd=edt&file=$path">[Edit this File]</A>
			</TD></TR>
			</TABLE>
			<HR>
			<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH="100%">
			<TR><TD WIDTH="100%" BGCOLOR="#FFFFFF">
			<PRE>$text</PRE>
			</TD></TR></TABLE>
			</TD></TR></TABLE>
HTMLCODE
		}
		else
		{
			$lines .= <<HTMLCODE;
			<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
			<TR>
			<TD VALIGN="TOP" BGCOLOR="#EEEEEE" ALIGN="MIDDLE">
			<BR><B>[ERROR]</B><BR><BR>
			<B>Unable to open</B><BR>$path<BR><B>for reading</B><BR><BR>Possibly due to [$!]<BR><BR>
			</TD></TR></TABLE>
HTMLCODE
		}

	}
	if(%files)
	{
		my $bg =1;
		$lines .= "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=\"100%\">\n";
		foreach( sort( keys %files ))
		{
			$bg = 1-$bg;
			$_ =~ /(.*)##(.*)/;
			$lines .= "<TR><TD CLASS=bgcolor$bg WIDTH=\"80%\">&nbsp;<A HREF=\"$scripturl&amp;cmd=brw&amp;path=$1\">";
			my $color = "#FF0000";
			(-T $1) and $color = "#007777";
			(-B $1) and $color = "#AA2222";
			(-d $1) and $color = "#2222BB";
			$lines .= "<FONT COLOR=\"$color\">$files{$_}\n";
			$lines .= "</FONT></A></TD><TD CLASS=bgcolor$bg ALIGN=\"RIGHT\">&nbsp;";
			(-d $1) or $lines .= bytes_in_english($2);
			$lines .="&nbsp;</TD></TR>\n";
		}
		$lines .= "</TABLE>";
	}
        $lines .= "</TD></TR></TABLE>";
	my $html = html_source();
	$html =~ s/##content##/$lines/g;
	output ("text/html", $html);
	return;
}
		
			
#################################################################################
sub documentation
{
        my $lines = <<HTMLCODE;
        <H1>[Willow Copyright Notice]</H1>
		<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
		<TR>
		<TD VALIGN="TOP" BGCOLOR="#EEEEEE">
                <B>Willow was written by Angelstorm Innovations ( http://angelstorm.co.uk/willow.html )</B><BR><BR>
                <I>
                <HR><BR>
                This program is free software; you can redistribute it and/or modify 
                it under the terms of the GNU General Public License as published by
                the Free Software Foundation; either version 2 of the License, or 
                (at your option) any later version.<BR><BR>
                This program is distributed in the hope that it will be useful,
                but WITHOUT ANY WARRANTY; without even the implied warranty of
                MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                GNU General Public License for more details.<BR><BR>
                You should have received a copy of the GNU General Public License
                along with this program; if not, write to : <BR>
                The Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA<BR><BR>
                <HR>
                </I><BR>
                Comments and bugs can be sent to scripts\@angelstorm.co.uk<BR>
                Donations for its use can be sent to any UK registered charity.</B><BR><BR>
                <B>Full documentation will be available in the next release of Willow.</B><BR><BR>
                </TD></TR></TABLE>
HTMLCODE
        my $html = html_source();
        $html =~ s/##content##/$lines/g;
        output ("text/html", $html);
        return;
}

#################################################################################
sub environment
{
        my @envs;
        my $lines = "<H1>[Environment Variables]</H1><TABLE CELLSPACING=2 CELLPADDING=2 BORDER=0>\n";

        # This alternates bgcolors for alternate lines.
        my $bg=1;
        foreach (keys %ENV)
        {
        	$bg = 1-$bg;
                $lines .= "<TR><TD CLASS=bgcolor$bg><B>$_</B></TD><TD CLASS=bgcolor$bg>$ENV{$_}</TD></TR>\n";
        }
        $bg = 1-$bg;
        $lines .= "<TR><TD CLASS=bgcolor$bg VALIGN=\"TOP\"><B>\@INC includes</B></TD><TD CLASS=bgcolor$bg>".join("<BR>", @INC)."</TD></TR>\n";
        $lines .= "</TABLE>\n";
        my $html = html_source();
        $html =~ s/##content##/$lines/g;
        output ("text/html", $html);
        return;
}

#################################################################################
sub server_info
{
        my $lines = "<H1>[Package Information]</H1>";
        $lines .= "<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>\n";
        my $bgcol=1;
        my $perlv = $];
	$perlv =~ s/000//g;
	$perlv =~ s/00//g;
        $lines .= "<TR><TD CLASS=bgcolor$bgcol WIDTH=150><B>Perl Version</B></TD><TD CLASS=bgcolor$bgcol>$perlv</TD></TR>\n";
        $bgcol = 1-$bgcol;
        $lines .= "<TR><TD CLASS=bgcolor$bgcol><B>Perl Location</B></TD><TD CLASS=bgcolor$bgcol>$^X</TD></TR>\n";
        $bgcol = 1-$bgcol;
        $lines .= "<TR><TD CLASS=bgcolor$bgcol><B>Operating System</B></TD><TD CLASS=bgcolor$bgcol>$^O</TD></TR>\n";
        if($^O =~ /linux/i)
        {
		$bgcol = 1-$bgcol;
		$lines .= "<TR><TD CLASS=bgcolor$bgcol valign=\"TOP\"><B>Software Package</B></TD><TD CLASS=bgcolor$bgcol><B>Version</B></TD></TR>\n";
		my @packages =  (
			"sendmail",
			"php",
			"python",
			"mysql",
			"mysql-client",
			"openssl",
			"openssh",
			"named",
			"samba",
			"httpd",
			"tar",
			"gcc",
			"gzip",
			"bzip2",
			"lynx",
			"gpg",
			"rsync"
			);
		foreach my $package ( sort @packages )
		{
			# RedHat Package manager seems to be a common way forward
			my $result;
			$result = `rpm -q $package`;
			if ( $result =~ /$package-(.*)-(.*)$/ )
			{
				$result = $1;
			}
			else
			{
				# TIf RPM returns nothing, it might have been compiled
				# the good old fashioned way. Let's query it :)
				my $binary = find_binary($package);
				if($binary)
				{
					my @bins = split(/,\ /, $binary);
					foreach(@bins)
					{
						$result = `$_ -v`;
						($result) or $result = `$_ -V`;
						($result) or $result = `$_ --version`;
						($result) or $result = `$_ -version`;
						($result) or $result = "<STRONG>Installed, but unable to determine version</STRONG>";
						$result =~ s/  / /g;
						($result =~ /(.*?)\n.*/s) and $result = $1;
						($result =~ /$package (.*)/) and $result = $1;
					}
				}
				else
				{
					$result = "<STRONG>Not installed or no information available</STRONG>";
				}
			}
			$bgcol = 1-$bgcol;
			$lines .= "<TR><TD CLASS=bgcolor$bgcol>&nbsp;&nbsp;".ucfirst($package)."</TD><TD CLASS=bgcolor$bgcol>&nbsp;&nbsp;$result</TD></TR>\n";
		}
		my $line = find_binary("sendmail");
		if ($line)
		{ 
			$bgcol = 1-$bgcol;
			$lines .= "<TR><TD CLASS=bgcolor$bgcol><B>Sendmail Locations</B></TD><TD CLASS=bgcolor$bgcol>$line</TD></TR>\n";
		}
        }
        $lines .= "</TABLE>";
        my $html = html_source();
        $html =~ s/##content##/$lines/g;
        output ("text/html", $html);
        return;
}

#################################################################################
sub modules
{
        # Returns a list of all modules installed on the server
        my @dirs;
        foreach(@INC)
        {
        	($_ eq ".") or push @dirs, $_;
        }
        my @modules;
        my %check;

        my @files = ls_recursive(@dirs);

        foreach(@files)
        {
        	$_ =~ /(.*)##(.*)##(.*)/;
                my $flags = $1;
                my $size = $2;
                my $file = $3;
                foreach(@INC)
        	{
        		if( $file =~ /.*($_)(.*)/ && $_ ne ".")
        		{
        			$file = $2;
        		}
        	}
        	$file or next;
                if( $flags =~ /d/ )
                {
                        $file =~ /.*(\/|\\)(.*?)$/;
                        my $mod = lc($2);
                        unless(exists($check{$mod}))
                        {
                                $check{$mod} = $2;
                                push @modules, $2;
                        }
                }
                elsif( $file =~ /.*(\\|\/)(.*?)(\\|\/)(.*?)\.pm$/ )
                {
                	my $mod = lc($2.$4);
                        unless(exists($check{$mod}))
                        {
                                $check{$mod} = $2;
                                push @modules, $2."::".$4;
                        }
                }
        }
        @modules = (sort{uc($a) cmp uc($b)} @modules);
        my @mods;
        my $mod;
        foreach $mod (@modules)
        {
        	my $link = $mod;
        	if($mod =~ /::/){ $mod = "<SMALL>+&nbsp;$mod</SMALL>"; }
        	else{ $mod = "<B>$mod</B>"; }
        	push @mods, "<A HREF=\"http://search.cpan.org/search?query=$link&amp;mode=module\" TARGET=\"_blank\">$mod</A>\n";
        }
        my $lines = tablify(4,@mods);
        $lines = "<H1>[Currently Installed Perl Modules]</H1>\n$lines\n<BR><B>Click on a module to search CPAN for further information</B>\n";
        my $html = html_source();
        $html =~ s/##content##/$lines/g;
        output ("text/html", $html);
        return;
}

#################################################################################
# HTML Construction Sub-Routines

#################################################################################
sub html_source
{
        my $style = style_sheet();
        my $lines = <<HTMLCODE;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HEAD>
<TITLE>Willow :: The Definitive Perl Web Utility :: Version $release</TITLE>

<STYLE TYPE="text/css">
<!--
$style;
-->
</STYLE>
</HEAD>
<BODY BGCOLOR="#BBBBBB" TEXT="#222222">
<CENTER>
<H1>[Willow : Version $release]</H1>
<TABLE CELLSPACING=2 CELLPADDING=2 BORDER=0 WIDTH=500>
<TR>
	<TD ALIGN="CENTER" BGCOLOR="#DDDDDD"><B>&nbsp;[Information]&nbsp;</B></TD>
	<TD ALIGN="CENTER" BGCOLOR="#DDDDDD"><B>&nbsp;[Server Tools]&nbsp;</B></TD>
	<TD ALIGN="CENTER" BGCOLOR="#DDDDDD"><B>&nbsp;[Willow Admin]&nbsp;</B></TD>
</TR>
<TR>
	<TD VALIGN="TOP" ALIGN="CENTER" BGCOLOR="#EEEEEE">
	<A HREF="$scripturl&amp;cmd=env">-Environment Variables-</A><BR>
	<A HREF="$scripturl&amp;cmd=mod">-Installed Modules-</A><BR>
	<A HREF="$scripturl&amp;cmd=nfo">-Package Information-</A><BR>
	</TD>
	<TD VALIGN="TOP" ALIGN="CENTER" BGCOLOR="#EEEEEE">
	<A HREF="$scripturl&amp;cmd=sql">-MySQL Interface-</A><BR>
	<A HREF="$scripturl&amp;cmd=eml">-Email Component Test-</A><BR>
	<A HREF="$scripturl&amp;cmd=brw">-Directory Browser-</A><BR>
	</TD>
	<TD VALIGN="TOP" ALIGN="CENTER" BGCOLOR="#EEEEEE">
	<A HREF="$scripturl&amp;cmd=doc">-Copyright-</A><BR>
	<A HREF="$scripturl&amp;cmd=upd">-Update Willow-</A><BR>
	<A HREF="$scripturl&amp;cmd=src">-View Source Code-</A><BR>
	<A HREF="$scripturl&amp;cmd=pwd">-Change Password-</A><BR>
	<A HREF="$scripturl&amp;cmd=log">-Logout-</A><BR>
	</TD>
</TR>
</TABLE>
<BR>
##content##
</CENTER>
</BODY>
</HTML>
HTMLCODE
        return $lines;
}

#################################################################################
sub style_sheet
{
        my $lines = <<HTMLCODE;
      P {color: #000000; font-family: Arial; font-size: 12px; font-weight: normal; line-height: 14pt;}
     TD {color: #000000; font-family: Arial; font-size: 12px; font-weight: normal; line-height: 14pt;}
      B {color: #551500; font-family: Arial; font-size: 12px; font-weight: bold; line-height: 14pt;}
 STRONG {color: #FF0000; font-family: Arial; font-size: 12px; font-weight: normal; line-height: 14pt;}
     H1 {color: #551500; font-family: Arial; font-size: 14px; font-weight: bold; line-height: 16pt;}
  SMALL {color: #000000; font-family: Arial; font-size: 10px; font-weight: normal; line-height: 14pt;}
    PRE {background: #FFFFFF;}

  A             {font-family: Arial; font-size:12px; color: #0000FF; font-weight: normal; line-height:14px;}
  A:active      {font-family: Arial; font-size:12px; color: #FF0000; font-weight: normal; line-height:14px;}
  A:hover       {font-family: Arial; font-size:12px; color: #FF0066; font-weight: normal; line-height:14px;}
  A:link        {text-decoration: none;}
  A:visited     {text-decoration: none;}

  INPUT         {
                 font-family: Arial;
                 font-size:12px;
                 color: #000000;
                 font-weight: normal;
                 line-height:16px;
                 background:#FFFFFF;
                 border: #551500 1px solid;
                }

  SELECT        {
                 font-family: Arial;
                 font-size:12px;
                 color: #000000;
                 font-weight: normal;
                 line-height:14px;
                 background:#FFFFFF;
                 border: #551500 1px solid;
                }

 TABLE          {
                 border: #551500 1px solid;
                 background: #CCCCCC;
                }

 .bgcolor0 { background: #EEEEEE; }
 .bgcolor1 { background: #DDDDDD; }
 .sliderbg { background: #CCCCCC; }
 .sliderfg { background: #888888; }
 .noborder { border: #000000 0px solid; background: #EEEEEE;}

HTMLCODE
        return $lines;
}

#################################################################################
sub redirect
{
     my $page = shift;
     my $message = shift;
     my $noprm = shift;
     ($message) or $message = "Please wait one moment";
     my $params;
     unless( $noprm )
     {
     	my $cgi = new CGI;
     	foreach($cgi->param)
     	{
     		 (($_ =~ /^pass.$/) or ($_ =~ /^pass$/) )and next;
     		 $params .= "&".$_."=".$cgi->param($_);
     	}
     }
     print $cgi->header(-expires=>'-1d', -type=>"text/html");
     print "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n";
     print "<HEAD><TITLE>Redirect</TITLE>\n";
     print "<META HTTP-EQUIV=Refresh CONTENT=\"1; URL=".$page.$params."\">\n";
     print "</HEAD><BODY>$message</BODY></HTML>\n";

     exit(1);
}

#################################################################################
sub tablify
{
        # constructs an HTML table from @list data
        # takes two args. First is number of columns, second is list array
        my $cols = shift;
        my @input = @_;
        my $count = 0;
        my $split = @input;
        my $bgcol=1;
        $split = $split/$cols;
        my $lines = "<TD VALIGN=\"TOP\" CLASS=bgcolor$bgcol>";
        while(@input)
        {
                $count++;
                my $mod = shift @input;
                $lines .= "$mod<BR>\n";
                if($count >= $split)
                {
                        $count = 0;
                        $bgcol = 1-$bgcol;
                        $lines .= "</TD>\n<TD VALIGN=\"TOP\" CLASS=bgcolor$bgcol>"
                }
        }
        $lines .= "</TD>";
        ($lines =~ /(.*)\<TD.*?\>\<\/TD\>$/s) and $lines = $1;
        $lines = "<TABLE CELLSPACING=2 CELLPADDING=2 BORDER=0><TR>\n$lines\n</TR></TABLE>\n";
        return $lines;
}

#################################################################################

sub bargraph
{
	my $width = shift;
	my $amount = shift;
	my $total = shift;
	my $fg = int(($width/$total)*$amount);
	my $bg = $width - $fg; 
        return "<table cellspacing=0 width=$width class=sliderbg><tr><td height=10 class=sliderfg width=$fg></td><td class=sliderbg width=$bg></td></tr></table>\n";
}

#################################################################################
# Generic "Toolset" Sub-Routines

#################################################################################
sub ls_recursive
{
        # Returns a recursive list of files in a directory
        my @dirs = @_;

        my @files;

        while(@dirs)
        {
                my @list;
                my $file;
                my $dir = shift @dirs;

                # Readdir is better than Glob for Win32 systems
                opendir(DIR, $dir) or next;
                my @dirlist = readdir(DIR);
                closedir DIR;

                # Unfortunately, READDIR doesn't include the full path
                # of the file, so we need to prepend it with the full dir path
                foreach( @dirlist )
                {
                        # Not interested in "." or ".."
                        (($_ =~ /^\.\.$/) or ( $_ =~ /^\.$/ )) and next;
                        $file = $dir;
                        ($file =~ /.*[\\|\/]$/) or $file .= $slash;
                        $file .= $_;
                        push @list, $file;
                }

                # Now we check these files and add them to our listing
                foreach $file ( @list)
                {
                        if( -d $file )
                        {
                                push @dirs, $file;
                        }
                        my $flags;
                        my $size = "0";
                        ( -z $file ) or $size = (-s $file);
                        ( -d $file ) and $flags .= "d";
                        ( -l $file ) and $flags .= "l";
                        ( -T $file ) and $flags .= "t";
                        ( -B $file ) and $flags .= "b";
                        push @files, $flags."##$size##".$file;
                }
        }
        return @files;
}

#################################################################################
sub find_binary
{
	# Takes one argument. Finds all binary executable instances of that argument.
	my $file = shift;
	my @loc;
 	open(FH,"locate $file |");
	while(<FH>)
	{
		push @loc, $_;
	}
	close(FH);
	my $result;
	foreach(@loc)
	{
		chomp;
		if( $_ =~ /.*(\\|\/)$file$/ && -x $_ && -B $_ && $_ !~ /.*([\/|\\]doc[\\|\/]).*/)
		{
			( -d $_) or $result .= $_.", ";
		}
	}
	($result =~ /(.*)(\, )$/ ) and $result = $1;
	return $result;
}

#################################################################################
sub error
{
        my $error = "@_";
        my $fall = $!;

	my $lines = <<HTMLCODE;
		<H1>[Error Report]</H1>
		<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
		<TR><TD BGCOLOR="#EEEEEE">
HTMLCODE
        $lines .= "<P ALIGN=\"CENTER\"><B>Whoops! Theres been a problem</B><BR><BR>\n";
        $lines .= "You can report this to the author if you wish. Please ensure that you copy all text listed below in your report.<BR><BR>\n";
        my @params=$cgi->param;
        my $content ="<PRE>\n--------------------------------------------------------".
                                     "--------------------------------------\n";
        $content .="Date / Time        : ".localtime()."\n";
        $content .="Error              : $error";
        $content .="Possible reason is : $fall\n";
        $content .="Referring page     : ".$ENV{'HTTP_REFERER'}."\n";
        $content .="Current page       : ".$ENV{'REQUEST_URI'}."\n";
        $content .="Visitor IP         : ".get_ip()."\n\n";
	$content .="Internal Variables\n";
	$content .="           cgipath : ".$cgipath."\n";
	$content .="          rootpath : ".$rootpath."\n";
	$content .="        scriptname : ".$scriptname."\n";
	$content .="            domain : ".$domain."\n";
	$content .="             slash : ".$slash."\n\n";
        $content .="Paramaters passed\n";
        foreach(@params)
        {
         	$content .= sprintf('%18s', $_);
	        $content .= " : ".$cgi->param($_)."\n";
        }
        $content .="--------------------------------------------------------".
                                     "--------------------------------------\n";
        $lines .= "$content</PRE>\n";
        my $html = html_source();
        $html =~ s/##content##/$lines/g;
        output ("text/html", $html);
        exit(1);
}

#################################################################################
sub read_text
{
        my $file = shift or die "Must supply argument to read_text";
        my $lines;
        open(FH, "< ".$file);
        while(<FH>)
        {
                $lines .= $_;
        }
        close(FH);
        return $lines;
}

#################################################################################
sub show_image
{
        my $file = shift or die "Must supply argument to show_image";
        my $ext = shift;
		
	print "Content-type: image/$ext\n\n";
		
	my $line;
	my $buff;
	open( IMAGE, "< ".$file) or die "Cannot open file $file";
	binmode IMAGE;
	while(read IMAGE, $buff, 1024)
	{
	       $line .= $buff;
	}
	close IMAGE;
	print "$line";
}

#################################################################################
sub write_text
{
        my $file = shift or die "Must supply argument to write";
        my @lines = @_;
        open(FH, "> $file") or die "Cannot open $file for writing";
        foreach(@lines)
        {
                print FH $_;
        }
        close(FH);
        (-e $file) and return 0;
        return 1;        
}

#################################################################################
sub append_text
{
        my $file = shift or die "Must supply argument to append";
        my @lines = @_;
        open(FH, ">> $file") or die "Cannot open $file for appending";
        foreach(@lines)
        {
                print FH $_;
        }
        close(FH);
}

#################################################################################
sub output
{
        my $type = shift;
        my $lines = shift;
        print "Content-Type: $type\n";
        print "Expires: -1d\n";
        print "Pragma: no-cache\n\n";
        print "$lines";
}


#################################################################################
sub bytes_in_english
{
	my $size = shift;
	($size <= 1024) and return $size." Bytes";
	($size > 1073741824) and return int($size/1073741824)." GB";
	($size > 1048576) and return (int($size/104857.6)/10)." MB";
	return (int($size/102.4)/10)." KB";
}
		
#################################################################################
sub get_ip()
{
        my $host = $ENV{REMOTE_ADDR};
        my $ip = $ENV{HTTP_X_FORWARDED_FOR};
   	($ip) or ($ip = $host);
        return $ip;
}

#################################################################################
# Encryption routines

#################################################################################
sub generate_key
{
	# Generates a session key
	my $i;
	my $key;
	my @chars = (0..9, 'A'..'Z', 'a'..'z');
	for($i=0;$i<8;$i++)
	{
		$key .= $chars[rand 62];
	}
	return $key;
}

#################################################################################
sub encrypt_string
{
	my $pass = shift;
	# Randomly Generate Salt
	my $salt = join '', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64];
	$pass = crypt($pass, $salt);
	return $pass;
}

#################################################################################
sub verify_encrypted_string
{
	my $pass = shift;
	my $encpass = shift;
	(crypt($pass, $encpass) eq $encpass) and return 1;
	return 0;
}

#################################################################################
# Login Sub-Routines

#################################################################################
sub verify
{
	($key) or return 0;
	my $ip = get_ip();
	$ip =~ s/\./\-/g;
	my $keyfile = $cgipath."willow-".$ip.".key";
	(-e $keyfile) or return 0;
	my $storkey=read_text($keyfile);
	chomp($storkey);
	$storkey =~ /(.*)##(.*)/;
	my $time = $1;
	my $storkey = $2;
	if(time()>($time+600))
	{
		# Session keys last for ten minutes
		unlink($keyfile);
		return 0;
	}
	verify_encrypted_string($key, $storkey) or return 0;
	my $ip = get_ip();
	$ip =~ s/\./\-/g;
	my $time = time();
	my $cryptkey = encrypt_string($key);
	write_text($cgipath."willow-".$ip.".key", $time."##".$cryptkey);
	return 1;
}

sub login
{
	my $lines;
	if( -e $cgipath."willow.pwd")
	{
		my $pass = $cgi->param("pass");
		$pass =~ s/[^a-zA-Z0-9]//g;
		my $cryptpass = read_text($cgipath."willow.pwd");
		chomp($cryptpass);
		my $params;
		foreach($cgi->param)
		{
			( $_ eq "pass" ) or
		        $params .= "<INPUT TYPE=\"HIDDEN\" NAME=\"$_\" VALUE=\"".$cgi->param($_)."\">\n";
        	}
		if($pass && verify_encrypted_string($pass, $cryptpass))
		{
			my $key = generate_key();
			my $ip = get_ip();
			my $time = time();
			$ip =~ s/\./\-/g;
			my $cryptkey = encrypt_string($key);
			write_text($cgipath."willow-".$ip.".key", $time."##".$cryptkey);
			redirect($scriptname."?key=$key","Logging you in, one moment please");
		}
		else
		{
			$lines .= <<HTMLCODE;
			<H1>[Enter Password]</H1>
			<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
			<TR>
			<TD VALIGN="TOP" BGCOLOR="#EEEEEE">
			<P ALIGN="CENTER">
			
			<B>Log in to Willow</B>
			<FORM METHOD="post" ACTION="$scriptname">
			$params
			<INPUT TYPE="PASSWORD" NAME="pass" SIZE=30 VALUE=""><BR><BR>
			<INPUT TYPE="SUBMIT" VALUE="Login">
			</FORM>
			<B>Seeing this screen again?</B><BR>
			
			<SMALL>
			If you are having problems logging in, please check the following<BR>
			</SMALL>
			
			</P>
			
			<SMALL>
			<UL>
			<LI>That you have typed your password correctly
			<LI>That the caps lock key is not on
			<LI>Willow has a session timeout. After 10 minutes of inactivity, you will need to login again.
			<LI>That you are not connecting from a different computer. Willow stores your IP address when it logs you in.
			</UL>
			</SMALL>
			
			<P ALIGN="CENTER">
			
			<SMALL>
			If the above are all verified as ok, please remove the willow.pwd file from the directory Willow resides in, and reset your password using the prompt provided.
			</SMALL>
			
			</P>
			</TD></TR>
			</TABLE>
HTMLCODE
			my $html = html_source();
		        $html =~ s/##content##/$lines/g;
	        	output ("text/html", $html);
		}
	}
	else
	{
		my $pass1 = $cgi->param("pass1");
		my $pass2 = $cgi->param("pass2");
		if( $pass1 and $pass2)
		{
			if($pass1 =~ /[^a-zA-Z0-9]/ or $pass2 =~ /[^a-zA-Z0-9]/) 
			{
				$lines .= pass_error("Your password can only contain the letters a through z, uppercase or lowercase, and the numbers 0 to 9.<BR><BR>\n");
			}
			elsif( ($pass1 ne $pass2) or ($pass1 eq "") )
			{
				$lines .= pass_error("New password fields do not match or are empty.<BR><BR>You must type the same password twice for verification.<BR><BR>\n");
			}
			else
			{
				if(bad_password($pass1))
				{
					$lines .= pass_error("Your password is too simple and/or contains a commonly used word. Please choose a more secure password<BR><BR>\n");
				}
				else
				{
					my $cryptpass = encrypt_string($pass1);
					write_text($cgipath."willow.pwd", $cryptpass);
					my $key = generate_key();
					my $ip = get_ip();
					my $time = time();
					$ip =~ s/\./\-/g;
					my $cryptkey = encrypt_string($key);
					write_text($cgipath."willow-".$ip.".key", $time."##".$cryptkey);
					redirect($scriptname."?key=$key","Password set, one moment please ...");
				}
			}
		}
		else
		{
			$lines .= <<HTMLCODE;
			<H1>[Choose a Password]</H1>
			<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500>
			<TR><TD VALIGN="TOP" BGCOLOR="#EEEEEE">
	                <P ALIGN="CENTER"><B>Choose an administration Password</B>
	                <FORM METHOD="post" ACTION="$scriptname">
	                <INPUT TYPE="PASSWORD" NAME="pass1" SIZE=30><BR>
	                <INPUT TYPE="PASSWORD" NAME="pass2" SIZE=30><BR><BR>
                 	<INPUT TYPE="SUBMIT" VALUE="Login">
                 	</FORM>
                 	<B>Why am I seeing this screen?</B><BR>
                 	Willow is a very powerfull testing utility and, as such, requires a password to be set to avoid an
                 	un-authorised person gaining access to your website and the files stored within.<BR><BR>
                 	</TD></TR></TABLE>
                 	
HTMLCODE
		}
                 my $html = html_source();
                 $html =~ s/##content##/$lines/g;
                 output ("text/html", $html);
	}
}

sub pass_error
{
	my $error = shift;
	my $lines = "<H1>[ERROR]</H1>\n";
	$lines .= "<TABLE CELLSPACING=2 CELLPADDING=2 WIDTH=500><TR><TD VALIGN=\"TOP\" BGCOLOR=\"#EEEEEE\">\n";
	$lines .= "<BR><P ALIGN=\"CENTER\"><B>Password Set Error</B><BR>$error\n";
	$lines .= "<BR><BR><B>Please click the back button on your browser to return</B><BR><BR>\n\n";
	$lines .= "</TD></TR></TABLE>\n";
	return $lines;
}

sub bad_password
{
	my $password = shift;
	# Can add as many as we like here, could add regexp if required";
	my @badpass = ("password", "qwerty", "letmein", "willow", "test", "secure", "pass");
	foreach(@badpass)
	{
		($password =~ /$_/) and return 1;
	}
}

sub logout
{
	my $ip = get_ip();
	$ip =~ s/\./\-/g;
	unlink($cgipath."willow-".$ip.".key");
 	print $cgi->header(-expires=>'-1d', -type=>"text/html");
	print "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n";
	print "<HEAD><TITLE>Redirect</TITLE>\n";
	print "<META HTTP-EQUIV=Refresh CONTENT=\"1; URL=".$scriptname."\">\n";
	print "</HEAD><BODY>Logging out ... one moment please</BODY></HTML>\n";
}

sub init_globs
{
	# Obtain details on the path to this script for future reference.
	# We need to do it this way as IIS has no 'document_root' environment variable.
	# We also need some additional information.
	$rootpath = $ENV{'PATH_TRANSLATED'};                                  # IIS
	unless( $rootpath ){$rootpath = $ENV{'SCRIPT_FILENAME'};}             # Apache
	($rootpath) or die "Fatal! Willow cannot determine the server path to this script!";
	$rootpath =~ /.*(\/|\\).*/;
	$slash = $1;

	# We use the 'script name' ENV variable to work out the web-root now. Also, we use this
	# To reference willow via a href link.
	$scriptname = $ENV{'SCRIPT_NAME'};
	($scriptname) or die "Cannot determine script name";
	my $scriptnamepath = $scriptname;
	if($rootpath =~ /.*\\.*/ and $scriptnamepath =~ /.*\/.*/)
	{
		$scriptnamepath =~ s/\//\\\\/g;
	}
	$scriptname =~ /(.*)[\\|\/](.*?)$/;
	my $filename = $2;

	# Get the full path of the directory willow resides in
	$rootpath =~ /(.*[\\|\/])$filename$/;
	$cgipath = $1;

	if($rootpath =~ /(.*)$scriptnamepath/)
	{
		$rootpath = $1;
	}

	else
	{
		die "Couldn't determine webroot path.\n#Path=$rootpath#\n#Scriptnamepath=$scriptnamepath#\n";
	}

	($rootpath =~ /.*[\\|\/]$/ ) or $rootpath = $rootpath.$slash;
	$domain = $ENV{'HTTP_HOST'};
	$domain =~ s/www\.//g;
	# So, now we have $domain, $rootpath, $cgipath, $scriptname and $slash set correctly (we hope!)
}