#
#
#
use strict;
use warnings;
use Michael::Utils qw( hashArgs );

$| = 1;
$\ = "\n";


## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
sub printUsage{
	my( @argv ) = @_;
	while( <DATA> ) {
		chomp($_);
		print;
	}
}
## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
sub main{
	my( @argv ) = @_;
	my %args = hashArgs( 
					REF => \@argv 
					, SPLIT => '='
					, STRIP => '--' );
	my $pad = 10;
	
	# print '';
	# print sprintf( "  >> %-".$pad."s  =  %s" , "ARGUMENT" , "VALUE" );		
	# print ('-' x ($pad*3) );
	# while( my ($arg, $val) = each( %args ) ) {
	#	print sprintf( "  >> %-".$pad."s  =  %s" , $arg , $val );
	# }
	printUsage();
}
## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
main( @ARGV );
## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=s


__DATA__
Testing usage:
	This is a test
	This is also a test
	This is how you use the program!
	:-)	
The end.