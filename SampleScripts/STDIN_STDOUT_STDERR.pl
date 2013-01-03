#
#
#
use strict;
use warnings;

use Michael::Utils qw(IsWin);
if(IsWin()){ system(CLS); }

# set up a few variables to mask the STD I/O streams
#	we can use these variables to reassign the I/O 
#	streams at runtime (into/out of files, etc)
my $inputFH = \*STDIN;
my $errFH = \*STDERR;
my $outFH = \*STDOUT;

# the <STDIN> filehandle reads from the input stream
print "What is your name? \n";
chomp(my $name = <$inputFH>);
print $outFH "Hello $name \n";

# the <STDERR> filehandle defaults output to the 
#	screen, but is separate from STDOUT
if( $name =~ /[\d]+/ ) {
	print $errFH "?! You can't have numbers in a name ?! \n";
}
print "\n";

# the <DATA> filehandle reads what comes
#	after the __END__ signifier in 
#	a perl script
while( <DATA> ) {
	chomp($_);
	print $outFH "DATA: $_ \n";
}

__END__
Jan
Feb
Mar
Apr
May
Jun
Jul
Aug
Sep
Oct
Nov
Dec