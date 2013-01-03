#
# scours a directory tree and all files (matching an optional filter)
# onto a target file (basically concatenates all files in a tree into one)
#
#

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-
use strict; 
use Cwd qw( abs_path );
use Michael::Utils qw( IsWin time );
## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

our $VERSION=0.01;
our $FILTER='';

sub clearOutFile {
	my ( $file , @argv ) = @_;
	if (-e $file && defined($file)) {
		truncate( $file , 0 );
	}
	else {
		my $fh = new FileHandle;
		$fh->open(">$file") or die "   !!! Could not create/truncate file: $file [$!] !!! \n";
		print $fh "";
		$fh->close();
	}
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

sub appendToFile {
	use FileHandle;
	my ( $file , $txt , @argv ) = @_;
	my $fh = new FileHandle;
	$fh->open(">>$file") or print "   !!! Could not open file: $file !!! \n";
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
	$INfh->open("<$INfile") or print "   !!! Could not open input file: $INfile !!! [$!] \n";
	$OUTfh = new FileHandle;
	$OUTfh->open(">>$OUTfile") or print "   !!! Could not open output file: $OUTfile !!! [$!] \n";
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
	
	if( !(-e $dir && -d $dir && defined($dir)) ) {
		die "   !!! Could not use DIR: $dir [$!] !!! \n";
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
			readAndAppend( $fullPath , $pad.$pad , $outFile );
		}
		else {
			if( $FILTER !~ /^$/ ) {
				if(	$file =~ /$FILTER/i) {					
					appendToFile( $outFile , $pad.$fullPath );
				}
			}
		}
	}
	closedir(IMD);
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

sub main {
	
	if( IsWin() == 1 ) {
		system(cls);
	}	
	
	my ($dir , $outFile , $filter , $usePadding , @argv ) = @_;
	my ( $pad );
	
	# if no path was supplied, use the "."
	if( $dir =~ /^$/ ) {
		$dir = '.';
	} 
	
	# if the "." path was supplied (even if from line above)
	# use the abs_path function to get our current directory
	if($dir =~ /^\.$/ ){
		$dir = abs_path();
		$dir =~s/\//\\/g;
	}

	if( $outFile =~ /^$/ ) {
		$outFile = 'FileList'.time().'.txt';
	}
	
	# if we are told to indent output lines corresponding to dir depth:
	$pad = '';
	if ( $usePadding !~ /^$/ ) {
		$pad = '   ';
	}
	
	$FILTER = '';
	if( $filter !~ /^$/ ) {
		$FILTER = $filter;
	}
	
	print "\n\n";
	print "     ListAllFiles.pl [v$VERSION]     \n";
	print "     --------------------------------------------\n";
	print "     Listing all Files in: '$dir'     \n";
	print "     Logging files into: '$outFile' \n";
	if( $FILTER !~ /^$/ ) {
		print "     Only logging files satisfying REGEX filter: '$filter' \n";
	}
	print "\n\n";
		
	# bomb out the output file before we continue:
	clearOutFile( $outFile );
	
	# now, recurse thru the given dir tree and log each file into the output file
	readAndAppend($dir , $pad , $outFile , $filter);
}

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-

main(@ARGV);

## -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=- -=-
