#
#
#
use strict;
use warnings;

our @Header;
our $SingleFileOutput = 1;

# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- readFileSpec
#
# ARG: 		$specFile	-	the location of a file to parse for the file spec
# PURPOSE:	given a file specification location: parse it for the (field name, start index, length) tuples
#
# RETURN:	pointer to file-spec structure (array of {field, start-index, length}-hashes)
#
sub readFileSpec {
	my( $specFile , @argv ) = @_;
	my $pad = '   ';
	my $specFH;
	open( $specFH , '<' , $specFile )
		|| die( "ERROR: could not open file spec file \n    [ERR: $!] \n    [FILE: $specFile] \n" );
	
	my @specs;
	my $index=0;
	
	foreach my $ln (<$specFH>) {
		chomp( $ln );
		next if $ln =~ /^[\s]*$/ ;
		next if $ln =~ /^[\s]*#/ ;
				
		# keep track of the current spec
		my @cols = split( /\,/ , $ln ) ;
		
		# store spec data in an array of hashes
		$specs[$index]{'NAME'} =  $cols[0];
		$specs[$index]{'START'} =  $cols[1];
		$specs[$index]{'LENGTH'} =  $cols[2];
		
		push( @Header , $specs[$index]{'NAME'} );
		
		$index++;
	}
	return \@specs;
}
# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- files2Hash
#
# ARG:		$dir		-	directory of files for parsing
#			$specRef	-	reference to file spec structure (array of {field, start-index, length}-hashes)
# RETURN:	reference to hash of parsed file-data hashes
#
sub applySpec2File {
	my( $file , $specRef , @argv ) = @_;
	my $pad = '   ';
	my @spec = @{ $specRef };
	my $fileFH;
	my %lines;	# keep a listing of lines for this file
	my $count=0;
	open( $fileFH , '<' , $file )
		|| die("ERROR: cannot open file for parsing. \n    [FILE: $file] \n    [ERR: $!] \n");
	print "IN-FILE : $file \n";
	foreach my $ln (<$fileFH>) {
		$ln =~ s/[\r\n\f]+$// ; 	# carefully chomp :)
		next if( $ln =~ /^[\s]*$/ );
		chomp( $ln );
		
		my %line; 	# keep a listing of columns for this line		
		for my $ix (0..$#spec) {
			my $data = substr( $ln , ($spec[$ix]{'START'}-1) , $spec[$ix]{'LENGTH'} );
			$data =~ s/^[\s]*//;
			$data =~ s/[\s]*$//;
			chomp($data);
			
			if(!exists($line{$ix})) { 
				$line{$ix} = $data;
			}
		}
		
		# save the listing of columns (line) to the listing of lines
		if(!exists($lines{$count})) { 
			$lines{$count} = \%line;
		}
		$count++;
	}
	return \%lines;
}
# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- files2Hash
#
# ARG:		$dir		-	directory of files for parsing
#			$specRef	-	reference to file spec structure (array of {field, start-index, length}-hashes)
# RETURN:	reference to hash of parsed file-data hashes
#
sub files2Hash {
	my( $dir , $specRef , @argv ) = @_;
	my %files;
	my $pad = '   ';
	my @specs = @{ $specRef };
	my $dirFH ;	
	
	opendir( $dirFH , $dir )
		|| die( "ERROR: unable to list parse directory \n    [ERR: $!] \n    [DIR: $dir] \n" );
	my @filelist=readdir($dirFH);
	
	print $pad."> Moving to [$dir] \n" ;
	chdir($dir);
	
	foreach my $file ( @filelist ){
		chomp( $file );
		# trim leadin/trailing whitespace
		$file =~s/^[\s]//;
		$file =~s/[\s]$//;
		next if $file =~ /^[\s]*$/ ;
		next if $file =~ /^[\.]{1,2}$/ ;
		next if( !( (-e $file) && (-f $file) ) ) ;	
		
		if( !exists( $files{$file} ) ) { 
			$files{$file} = ();
		}
		$files{$file} = applySpec2File( $file , $specRef );
	}
	
	return \%files ;
}
# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- hash2CSV
sub hash2CSV {
	my ( $destDir , $filesHashRef , $specsRef , @argv ) = @_;
	my %files = %{ $filesHashRef };
	
	# make and cd to the output directory
	mkdir( $destDir ) if( !((-e $destDir) && (-d $destDir)) ) ;
	chdir( $destDir );
	
	foreach my $file ( sort(keys(%files)) ) {
		my $outFH=undef;
		my $outFile = $file;
		$outFile =~ s/\.[\d]{1,3}/.csv/ ;
		if( $file =~ /^(?<YEAR>[\d]{2})(?<MONTH>[\d]{2})(?<DAY>[\d]{2})(?<TYPE>[A-Z]{2})\.[\d]{1,3}$/ ) {
			my ($yr,$mo,$day,$type) = ($+{YEAR},$+{MONTH},$+{DAY},$+{TYPE});
			$type = 'Medicaid-Dataset' if $type =~ /DD/ ;
			$type = 'Medicaid-Report'  if $type =~ /DB/ ;
			$type = 'Alliance-Dataset' if $type =~ /DG/ ;
			$type = 'Alliance-Report'  if $type =~ /DF/ ;
			$outFile = "20${yr}-${mo}-${day}_${type}.csv" ;
		}
		truncate($outFile , 0);
		open ( $outFH , '>' , $outFile )
			|| die( "ERROR: unable to open output file. \n   [ERR: $!] \n    [FILE: $outFile] \n" );
		print $outFH join(',',@Header) . "\n";
		print "OUT-FILE: $outFile \n";		
		
		foreach my $line (sort {$a<=>$b} keys( %{$files{$file}} ) ) {
			my @lines;
			foreach my $element ( sort {$a<=>$b} keys(%{$files{$file}{$line}}) ) {
				push( @lines , $files{$file}{$line}{$element} );	
			}
			print $outFH join(',',@lines) . "\n";
		}
		close( $outFH );
	}
}
# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- main
sub main {
	my( $dir, $spec , @argv) = @_;
	if( !defined($dir) || !(-e $dir) || !(-d $dir) ) {
		print " ** Please supply a directory of files to parse ** \n\n";
		exit(2);
	}
	if( !defined($spec) || !(-e $spec) || !(-f $spec) ) {
		print " ** Please supply a file spec for the files to parse ** \n\n";
		exit(2);
	}
	hash2CSV( 
		$dir.'\\OUTPUT'
		, files2Hash( 
			$dir 
			, readFileSpec( $spec ) ) );
}

# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=-
# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- START RUNNING HERE
print "\n";
main(@ARGV);
print "\n";
# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=-
# -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=- -=-=-



__DATA__
### -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
File Structure collection looks like:
	"hash of hashed hashes" :)
{ 	"filename01" => 
		{	"0" => {"0" => field , "1" => field , "2" => field , ...}
			, "1" => {"0" => field , "1" => field , "2" => field , ...}
			, "2" => {"0" => field , "1" => field , "2" => field , ...}		}
	, "filename02" => 
		{	"0" => {"0" => field , "1" => field , "2" => field , ...}
			, "1" => {"0" => field , "1" => field , "2" => field , ...}
			, "2" => {"0" => field , "1" => field , "2" => field , ...} 	}		}
### -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=