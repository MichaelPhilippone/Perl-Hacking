package Michael::Utils;

use strict;
use warnings;
#use Cwd qw(abs_path);

BEGIN {
	use Exporter   ();
	use vars       qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
	# set the version for version checking
	$VERSION     = 0.01;
	# if using RCS/CVS, this may be preferred
	# $VERSION = do { my @r = (q$Revision: 0.01 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r }; # must be all one line, for MakeMaker
	@ISA         = qw(Exporter);
	@EXPORT      = qw( &IsWindows &getTime &parseArgs &printMe &listDirectory );
	%EXPORT_TAGS = ( );     # eg: TAG => [ qw!name1 name2! ],
	# your exported package globals go here,
	# as well as any optionally exported functions
	@EXPORT_OK = qw( IsWin time getArgs hashArgs listDir ls );
}

# -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- 

*IsWin = \&IsWindows ;
sub IsWindows { 
	if( $ENV{'OS'} =~ /win/i)  { return 1; }   
	else  { print " ** Unable to Determine OS when using Taint Mode ** \n"; }
	return 0;
}

# -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- 
# given a string, execute a perl one-liner process to print the result
#	?? 	- 	Allows for constant, non-blocking reidrection IO (ie: file output) 
#			on WIN systems
sub printMe { 
	my ($str , @argv) = @_;
	system( "perl -eT \"print '$str' ;\"" ); 
}

# -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- 
# date / time
# optionally formatted as:
#	
*time = \&getTime ;
sub getTime {
	my ( $format , @argv ) = @_;
	my ( 	$second
			, $minute
			, $hour
			, $dayOfMonth
			, $month
			, $yearOffset
			, $dayOfWeek
			, $dayOfYear
			, $daylightSavings
	) = localtime();
	my $dt = '';
	my $year = 1900 + $yearOffset;
	my $AmPm = '';
	# make the month 1-12 (not 0-11)
	$month++;	
	# make the following nums 0 padded if < 9
	$hour=~s/(^[\d]{1})$/0$1/;
	$minute=~s/(^[\d]{1})$/0$1/;
	$second=~s/(^[\d]{1})$/0$1/;
	$month=~s/(^[\d]{1})$/0$1/;
	$dayOfMonth=~s/(^[\d]{1})$/0$1/;
	
	# just return default format date string : yyyy-mm-dd
	if( !defined($format) || $format =~ /^[\s]+$/ ) { 
		$format = "yyyy-MM-dd";
	}
	$dt = $format;
	my @monthsFull = qw(January February March April May June July August September October November December);
	my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	my @weekDaysFull = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday Sunday);
	my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

	# date:
	$dt =~ s/[y]{4}/$year/;										# 4 digit year (with century)
	$dt =~ s/[y]{2}/substr( $year, length($year)-2 , 2 )/e;		# two digit year (no century)
	$dt =~ s/[M]{4}/$monthsFull[$month-1]/;						# long month name
	$dt =~ s/[M]{3}/$months[$month-1]/;							# short month name
	$dt =~ s/[M]{2}/$month/;									# month number
	$dt =~ s/[d]{2}/$dayOfMonth/;								# day of month (digit)
	$dt =~ s/[D]{4}/$weekDaysFull[$dayOfWeek]/;					# long weekday name
	$dt =~ s/[D]{3}/$weekDays[$dayOfWeek]/;						# short weekday name
	# time:
	$dt =~ s/[h]{2}/$hour % 12/e;			# 12 hr time
	$dt =~ s/[H]{2}/$hour/;			# 24 hr time
	$dt =~ s/[m]{2}/$minute/;		# 
	$dt =~ s/[s]{2}/$second/;		# 
	$AmPm = 'AM';
	if( $hour > 12 ) { $AmPm = 'PM'; }
	$dt =~ s/[t]{2}/$AmPm/;			# print AM or PM signifier
	
	return $dt;
}

# -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- 

*getArgs = \&parseArgs ;
*hashArgs = \&parseArgs ;
# USAGE: my %args = parseArgs( @_ );
sub parseArgs {
	my( %retHash );
	# nab the SPLIT, STRIP and REF key'd elements from @_ list.
	#	if none are provided in the @_ list, use the defaults
	my %args = ( SPLIT => '' , STRIP => '' , REF => '' , @_ );

	my $strip = $args{'STRIP'};
	my $split = $args{'SPLIT'};
	my $arrRef = $args{'REF'};
	my @argv = @$arrRef;
	my ( $key , $val );
	
	foreach my $arg ( @argv ) {
		$key = $arg;
		$val = '';		
		# remove the 'strip' sequence from the arguments
		if( $strip !~ /^[\s]+$/ ) {
			$key =~ s/$strip//;
		}
		# split the argument into a key/val pair (if necessary)
		if( $split !~ /^[\s]+$/ && $key =~ /$split/ ) {
			( $key , $val ) = split( /$split/ , $key );
		}
		$retHash{ lc($key) } = $val;
	}
	return %retHash;
}
# -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- 
*listDir = \&listDirectory;
*ls = \&listDirectory;
sub listDirectory {
	my %args = ( 
		PADDING => 0 
		, DIR => '.' 
		, FILE => ''
		, FILTER => '//'
		, @_ 	);
		
	my ( $fullPath
		, $dirHandle
		, @thefiles 
		, $pad 
		, $padNum 
		, $path );
	
	$padNum = int($args{'PADDING'});
	$pad = (" " x $padNum );
	
	$path = $args{'DIR'};
	$path =~ s!\\$!!;
	
	if( $path =~ m!^\.$! ) { 
		use Cwd qw( abs_path );
		$path = abs_path();
		$path =~ s!\/!\\!g;
	}
	
	opendir( $dirHandle , $path ) || die("Cannot open directory: $path \n");
	@thefiles=readdir($dirHandle);
	
	foreach ( @thefiles ) {
	
		# test for '..' and '.' directories
		next if ( $_ =~ /^[\s]*\.[\s]*$/ || $_ =~ /^[\s]*\.\.[\s]*$/ );
		
		# test if item is a directory
		if (-d $path."\\".$_ ) {
			$fullPath = $path.'\\'.$_;
			print $pad.$fullPath.'\\'."\n";
			# recurse into the directory
			listDirectory( DIR => $fullPath , PADDING => ( $padNum+$padNum ) );
		}
		else {		
			# print full file path:
			print $pad.'"'.$path.'\\'.$_.'"'."\n";
		}
	}

	closedir( $dirHandle );
}

# -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- 
1;
# -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- 

END {}

__END__

=head1 NAME
	Michael::Utils

---------------------------

=head1 SYNOPSIS 

---------------------------

=head1 SAMPLES 
	use Michael::Utils;

	my $dateTime = getTime() ;
	my $isThisWindows = IsWindows();
	my %argsHash = parseArgs();
	

	use Michael::Utils qw( IsWin time getArgs hashArgs printMe ) ;

	my $dateTime = time() ;
	OR
	my $time = time( 'hh:mm:ss' );
	
	my isThisWindows = IsWin();

	my %argsHash = getArgs( REF => \@_ );
	# OR
	my %argsHash = hashArgs( REF => \@_ );
	
	printMe( "Hello World!" );	# prints 'Hello World!' (no quotes)

---------------------------

=head1 DESCRIPTION
	Commonly used / included functions (most are relatively stateless)

---------------------------

=head2 B<IsWindows> -
	Usage:
		if( IsWindows() ) { print "WINDOWS"; };
		OR
		if( IsWin() ) { print "WINDOWS"; };
	
	Returns 1 if the user is using a windows system, 0 if not.

---------------------------

=head2 B<printMe> -
	Print a string using a perl one-liner in a new process
	(using system() call, so I believe it's ultimately a fork() call)
	
	Allows for constant file output during program execution, instead
	of just waiting until the program ends
	
---------------------------

=head2 B<getTime> -

	Usage:
		getTime( ["FORMAT"] );
		OR
		time( ["FORMAT"] );
	
	Date Format Place Holders:
		dd    - numeric day of month
		DDD   -	shorthand day of month
		DDDD  -	longhand day of month
		MM    - numeric month (1-12)
		MMM   -	shorthand month (3 characters, Jan, Sep, etc)
		MMMM  -	longhand month (full name)
		yy    -	year without century
		yyyy  -	year with century
		hh    -	hour of day (12-hour style)
		HH    -	hour of day (24-hour / 'military' style)
		mm    -	minute of hour
		ss    -	second of minute
		tt    -	AM or PM
	
	Default style is "yyyy-MM-dd"

---------------------------

=head2 B<parseArgs> -
	Parse command line arguments into a perl hash.
	Optionally splits arguments into key/val pairs.

	Usage: 
		parseArgs( [STRIP => '--' ,] [SPLIT => '=' ,] REF => \@args );
		
	Options:
		STRIP 
			character sequence to remove from the front of the hash keys (default: '--', optional) 
		SPLIT
			character sequence used to split the incoming args into key/val pairs (default: '=', optional)
		REF 
			reference to the array of command line arguments to parse (required)

	Default SPLIT and STRIP sequences given in 'Usage' example

---------------------------

=head2 B<listDirectory> -
	Given a directory, list the contents
	(optional: pad the output to represent recursive folders' depths)

	Usage: 
		parseArgs( [PADDING => 0 ,] DIR => '.' );
		
	Options:
		PADDING 
			some number of spaces to recursively pad the output results based on folder depth
			[just try it to get what it means... :) ]
		DIR 
			name of the directory to list, default is current directory ('.' on *nix systems)

	Note: 
		Default PADDING and DIR values given in 'Usage' example

---------------------------
=head1 EXPORT
  * getTime         [time]
  * IsWindows	    [isWin]
  * parseArgs       [getArgs, hashArgs]
  * printMe      
  * listDirectory   [listDir, ls]

---------------------------
=head1 SEE ALSO
---------------------------
=head1 BUGS
---------------------------
=head1 AUTHOR
	Michael Philippone, E<lt>michael.philippone@gmail.comE<gt>
---------------------------
=cut