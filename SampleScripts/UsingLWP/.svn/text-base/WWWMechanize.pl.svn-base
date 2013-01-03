#
#
#
use strict;
use warnings;
use WWW::Mechanize;

our $LoginURL = 'http://edionline.acs-inc.com/html/login.html';
our $PostURL = 'https://edionline.acs-inc.com/cgi-bin/auth.exe';
our $TestFileFilesURL = 	'https://edionline.acs-inc.com/' . 
						'cgi-bin/download.exe?' . 
						'page=edionline&area=D%2eC%2e%20Medicaid%20Daily%20Enrollments%20and%20Disenrollments%5cReports%5c100510DB%2e001' ;
our %LoginFields = (
		'page' => 'edionline'
		, 'username' => 'hlth righ'
		, 'password' => '770330346'
		, 'Log In' => 'Log In' );

our $outFH;
our $outFile = '100510DB.001' ;
		
		
		
my $a = WWW::Mechanize->new;
$a->get( $LoginURL );
$a->submit_form(
	with_fields  => \%LoginFields
);

$a->get( $TestFileFilesURL );

open ( $outFH , '>' , $outFile ) 
	|| die( "Error opening outfile \n    [ERR: $!] \n    [FILE: $outFile] \n" );
	
print $outFH $a->response()->content();

close( $outFH );

print "   DONE. \n";