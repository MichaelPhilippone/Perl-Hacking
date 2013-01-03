#!/usr/bin/perl
# Script to emulate a browser for posting to a 
#   CGI program with method="POST".

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request::Common;

our $URL = 'https://edionline.acs-inc.com/cgi-bin/auth.exe';
our %LoginFields = (
		'page' => 'edionline'
		, 'username' => 'hlth righ'
		, 'password' => '770330346'
		, 'Log In' => 'Log In' );

sub PostToURL {
	my( $url , $fieldRef , @argv ) = @_;
	my $ret = '';
	my $brsr = new LWP::UserAgent;
	my $pg = $brsr->request(POST $url , $fieldsRef);
	
	if ($pg->is_success) { 
		$ret = $pg->content;
	} else { 
		$ret = $pg->message; 
	}
	return $ret;
}

print PostToURL( $URL , \%LoginFields );