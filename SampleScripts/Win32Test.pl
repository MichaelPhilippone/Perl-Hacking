#!/usr/bin/perl -w
#
#
use strict;
use Win32;

sub main {
	my (@argv ) = @_;
	
	# button flags:
	#	0 - OK
	#	1 - OK / Cancel
	#	2 - Abort, Retry , Ignore
	#	3 - Yes, No, cancel
	#	4 - Yes / No
	#	5 - Retry / Cancel
	# return flags:
	#	0 - Error
	#	1 - Ok
	#	2 - Cancel
	#	3 - Abort
	#	4 - Retry
	#	5 - Ignore
	#	6 - Yes
	#	7 - No	
	my $buttonFlag = 1;
	my $returnFlag = Win32::MsgBox( "Hello World!" , $buttonFlag , "TITLE" );
	print "SELECTED: ".$returnFlag."\n\n";
}

main( @ARGV );