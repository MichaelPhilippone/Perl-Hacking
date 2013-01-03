#
# scours a directory tree and all files (matching an optional filter)
# onto a target file (basically concatenates all files in a tree into one)
#
#

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-
if( ${^TAINT} ) { $ENV{'PATH'} = 'C:\\WINDOWS\\System32\\'; }

use strict; 
use Cwd qw( abs_path );
use Michael::Utils qw( IsWin time );

our $version      = 2.0;
our $author       = 'Michael Philippon <michael.philippone@gmail.com>';
our $verbose      = 0;
our $silent       = 0;
our $force        = 0;
our $OutputFile   = '';
our $AnchorPath   = '';
our $Filter       = '';

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

sub clearOutFile {
	my ( $file , @argv ) = @_;
	my $choice = 'y';
	
	if( !$force ) { 
		if (-e $file && defined($file) ) {
			print "REPLACE '$file'? \n  <y/n> \n";
			$choice = <STDIN>;
			chomp($choice);
		}
	}
	
	if( $choice =~ /(y|yes)/i ) {
		unlink( $file );
		truncate( $file , 0 );
	}
	else{ 
		print "Output file with the same name already exists. \n  EXITING. \n";
		exit(1);
	}
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

sub appendToFile {
	use FileHandle;
	my ( $file , $txt , @argv ) = @_;
	my $fh = new FileHandle;
	$fh->open(">>$file") or print "   !!! Could not open file: $file !!! \n"  if !$silent;
	print $fh $txt;
	print $fh "\n";
	$fh->close();
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

# reads from one file and appends onto another
sub appendFromToFile {
	use FileHandle;
	my ( $INfile , $OUTfile , @argv ) = @_;
	my ( $INfh , $OUTfh , $line );
	$INfh = new FileHandle;
	$INfh->open("<$INfile") or print "   !!! Could not open input file: $INfile !!! [$!] \n"  if !$silent;
	$OUTfh = new FileHandle;
	$OUTfh->open(">>$OUTfile") or print "   !!! Could not open output file: $OUTfile !!! [$!] \n"  if !$silent;
	while( <$INfh> ) {
		$line = $_;
		chomp($line);
		print $OUTfh $line."\n";
	}
	$INfh->close();
	$OUTfh->close();
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

sub readAndAppend {
	my( $dir , $pad , $outFile , $filter , @argv ) = @_;
	my $fullPath;
	
	$outFile =~ s/"//g;
	$dir =~ s/"//g;
	
	if( !(-e $dir && -d $dir && defined($dir)) ) {
		die "   Error opening directory \n     [DIR: $dir] \n     [ERROR: $!] \n"  if !$silent;
		return;
	}
	
	opendir(IMD, $dir) || die("Cannot open directory: $dir \n");
	my $dirHandle =\*IMD;
	my @thefiles=readdir($dirHandle);
	
	foreach my $file ( @thefiles ) {
		
		# test for '..' and '.' directories
		next if ($file =~ /^[\.]{1,2}$/ || !defined($file) );
		
		# test if item is a directory
		$fullPath = $dir.'\\'.$file;
		
		# recursive! (it's a directory)
		if (-d $fullPath ) {
			readAndAppend( $fullPath , $pad.'   ' , $outFile , $filter );
		}
		else {
			next if ( defined($filter) && $filter !~ /^$/ && $file !~ /$filter/) ;
			
			print "FILE: $file \n" if $verbose && !$silent;
			appendFromToFile( $fullPath , $outFile );
		}
	}
	closedir(IMD);
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

sub main {
	unless ($silent) { if( IsWin() ) { system('CLS'); } }
	
	my ($dir , $outFile , $filter , @argv ) = @_;
	
	if( $dir =~ /^$/ ) {
		$dir = '.';
	} 

	if($dir =~ /^\.$/ ){
		$dir = abs_path();
		$dir =~s/\//\\/g;
	}
	
	if( $outFile =~ /^$/ ) {
		$outFile = $dir.'\\CatFile_'.time().'.txt';
	}
	
	$dir = '"'.$dir.'"';
	
	unless ($silent) { print "\n\n"; }
	unless ($silent) { print "     Parsing all Files in: '$dir'     \n"; }
	unless ($silent) { print "     Concatenating all files into: '$outFile' \n"; }
	unless ($silent) { print "     Applying REGEX filter: '$filter' \n"; }
	unless ($silent) { print "\n\n"; }
		
	clearOutFile( $outFile );
	readAndAppend($dir , '   ' , $outFile , $filter);
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

sub parseOpts {
	my( @opts ) = @_;
	
	my $args = "|".join( " | " , @opts );		
	my $pad = "      ";
	
	if( $args =~ /\|(-v|--version)/i ) {
		print "\n$pad VERISON:  $version \n";
		exit(0);
	}
	if( $args =~ /\|(-a|--author)/i) {
		print "\n$pad AUTHOR:   $author \n" ;
		exit(0);
	} 
	elsif( $args =~ /\|-(\?|h|-help)/i ) {
		print "\n";
		print " USAGE: [perl] $0 [OPTIONS] [ <regex> ]\n";
		print "\n";
		print " OPTIONS: \n";
		print $pad."-v | --version    => Prints author and version info and quits \n";
		print $pad."-a | --author     => Prints authorinfo and quits \n";
		print $pad."-h | -? | --help  => Prints this usage prompt and quits \n";
		print "\n";
		print $pad."--verbose         => use verbose mode (now with an extra debugging flavor!) \n";
		print $pad."--silent          => suppress ALL OUTPUT (even error messages and warnings) \n";
		print $pad."--force           => try to overcome most errors (! could clobber existing output file !) \n";
		print "\n";
		print $pad."--path=\"path\"   => recursively scour directory anchored at <path> (enclose in double quotes) \n";
		print $pad."--file=\"output\" => concatenate all results into file <output> (enclose in double quotes) \n";	
		print "\n";
		print $pad." <regex>          => only look at FILES that match the supplied perl-style (d'uh) regular expression <regex> \n";
		exit(0);
	}
	
	$verbose = 1 if $args =~ /--verbose/i ;
	$silent  = 1 if $args =~ /--silent/i ;
	$force  = 1 if $args =~ /--force/i ;
	
	print $pad."!! WARN: you've selected silent mode AND verbose mode. (NOTE: silent mode overrules) \n" if $verbose && $silent ;
	
	if( $args =~ m!--file=([^\|]*)\ ?! ) { 
		$OutputFile = '"' . $1 . '"' ;
		$OutputFile =~ s/\s"$/"/;
	}
	if ($args =~ m!--path=([^\|]*)\ ?!) { 
		$AnchorPath = '"' . $1 . '"' ;
		$AnchorPath =~ s/\s"$/"/;
	}
	if ($opts[$#opts] !~ m!--!) { 
		$Filter = $opts[$#opts];
	}
	
	print "PATH:    $AnchorPath \n" if $verbose;
	print "FILE:    $OutputFile \n" if $verbose;
	print "FILTER:  $Filter \n" if $verbose;
	print "SILENT:  " . ($silent ? 'yes' : 'no') ."\n" if $verbose;
	print "VERBOSE: " . ($verbose ? 'yes' : 'no') . "\n" if $verbose;

} 

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

parseOpts( @ARGV );
main( $AnchorPath , $OutputFile , $Filter );




## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-