#
#	Demonstrate usage(s) of pareArgs method of Michael::Utils package
#

use strict;
use warnings;
use diagnostics;

use Michael::Utils qw( IsWin time hashArgs );

sub main {
	my( @argv ) = @_;
	
	my %argHash = hashArgs( SPLIT => '=' , STRIP => '--' , REF => \@argv );
	
	print "\n   PARSING ARGS: \n" ;
	foreach my $key ( keys(%argHash) ) {
		print '    KEY: ' . $key ."\n";
		print '    VAL: ' . $argHash{$key} . "\n\n";
	}
	print "\n\n";
}

#if(IsWin()) { system( CLS ); }
main( @ARGV );