#!/usr/bin/perl


use English;
use strict;
use CGI ();
use LWP::UserAgent ();
use HTTP::Request::Common qw(POST);
#use LWP::Debug qw( + );

my $Webjump = 'https://blah.com/siteminderagent/forms/login.fcc?TYPE=33554433&REALMOID=06-00034bb7-e037-116f-8241-808d67a50008&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGE NTNAME=$SM$6u%2by8Xv45zujpG8vqd8c%2fvGZPwkzRg6Ka38 kNya45FRtmGxbt4%2fdZsHY6%2ftkVw44&TARGET=$SM$%2fcgi-bin%2fTISLogReview%2findex%2ecgi';
my $AuthURL = 'https://edionline.acs-inc.com/cgi-bin/auth.exe';
my %postParams = (
	'page' => 'edionline'
	, 'username' => 'hlth righ'
	, 'password' => '770330346'
	, 'Log In' => 'Log In' );
my $red = 'https://edionline.acs-inc.com/html/login.html';

sub main () {

	my $cgi = new CGI();
	my $session;
	my $id = undef;
	my $redirect = "$Webjump";
	
	tie %session
		, 'Apache::Session::File'
		, $id
		, { Directory => "/tmp/" 
			, LockDirectory => "/tmp/" };

	if ($id == undef) {
		$cookie = $query->cookie( 	-name=>'SID01',
									-value=>$session{_session_id},
									-expires=>'+1y',
									-path=>'/session');
		print $query->header(-cookie=>$cookie);
		print "Assigned session ID<br>n";
	} else {
		print $query->header();
		print "Not assigned session ID<br>n";
	}

	$id = $session{_session_id};

	print "<html>n";
	print " <head><title>Session ID</title></head>n";
	print " <body bgcolor=#ffffff>n";
	print " Your session ID is $idn";
	print " </body>n";
	print "</html>n";		
			
			
	return;
	
	
			
	my @parameterNames = $cgi->param();
	foreach my $parameterName (@parameterNames) {
		my $parameterValue = $cgi->param($parameterName);
		if ($parameterName eq "USER"){
			my $USER = $parameterValue;
		}
		elsif ($parameterName eq "PASSWORD") {
			my $secretname = $parameterValue;
		}
		else {
			printError($cgi,
			"Illegal parameter $parameterName passed to sso.pl");
			return();
		}
		$redirect .= "$parameterName=$parameterValue&";
	}

	print($cgi->redirect($redirect)); #=> This works!!

	# => BELOW ARE SOME OF THE POST METHODS I TRIED

	my $userAgent = new LWP::UserAgent();
	push @{ $userAgent->requests_redirectable }, 'POST';

	#METHOD 1
	my $req = new HTTP::Request POST => $Webjump;
	my $req = 
		POST $Webjump,
		['USER' => 'username',
		'PASSWORD' => 'password'];
	my $res = $userAgent->request($req);
	my $contentString = $res->as_string;

	my $response =new HTTP::Request GET => $red;
	print $response->content;

}

# Kick off the script
main();