#####################################################################
#	WHO: 	Michael Philippone
#	WHAT:	tutorial script for file I/O
#	WHEN:	2010-04-22
#####################################################################
#
#	Notes on file I/O modifiers:
#		pre/suffixed to the filename in the "open" function call: 
#			open( FH , ">>file.txt");
#
# 	mode		operand		create		truncate
# 	read		<		
# 	write		>			?			?
# 	append		>>			?	
# Each of the above modes can also be prefixed with the + character to allow for simultaneous reading and writing.
#
# 	mode			operand		create		truncate
# 	read/write		+<		
# 	read/write		+>			?			?
# 	read/append		+>>			?	
#
# Notice, how both +< and +> open the file in read/write mode but 
#	the latter also creates the file if it doesn't exist or 
#	truncates (deletes) an existing file.
#
##########################################################################################################
#	sub routines:
#		oldFashionedOutput	-	opens a given file and dumps its contents (via WHILE loop)
#		oldFashionedInput	-	opens a given file (in append mode) and appends current date/time
#		fileGlobbing		-	opens a file by its GLOB and writes each line (via WHILE loop)
#		fileHandles			-	opens a file by its FileHandle reference (uses package: FileHandle)
#		fileVars			-	opens a file by a variable referring to the file
#		fileSorting			-	opens a file (old fashioned way), 
#								sorts the lines (in an array) and then prints each line
#		main 				-	driver function, used in calling the above sub routines
##########################################################################################################

use strict;
use Michael::Utils qw ( time );


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Old Fashioned File I/O
sub oldFashionedOutput {
	my ( $fileName , @argv ) = @_;
	
	print "\n*************************************************************\n\n";
	print "   Old Fashioned File Output \n\n";

	#input
	open (MYFILE, "<$fileName") || die("Could Not Open File: $fileName \n");
	while( <MYFILE>) {
		print $_;
	}
	close (MYFILE);
}

sub oldFashionedInput {
	my ( $fileName , @argv ) = @_;
	
	print "\n*************************************************************\n\n";
	print "   Old Fashioned File Input \n\n";
	# output
	open (MYFILE, ">>$fileName") || die("Could Not Open File: $fileName \n");
	print MYFILE "\nOld Fashioned FILE I/O -- ".time();
	print "( wrote a line to file: $fileName )\n";
	close (MYFILE);
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# File GLOBBING
sub fileGlobbing {
	my ( $fileName , @argv ) = @_;
	
	print "\n*************************************************************\n\n";
	print "   File Globbing \n\n";
	
	open(MYINPUTFILE, "<$fileName") || die("Could Not Open File: $fileName \n");
	my $fileGLOB = \*MYINPUTFILE;
	while (<$fileGLOB>) {
		my $line = $_;
		chomp($line);
		print "$line\n";
	}
	close(MYINPUTFILE);
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# File Handles
sub fileHandles {
	use FileHandle;
	my ( $fileName , @argv ) = @_;
	
	print "\n*************************************************************\n\n";
	print "   File Handles \n\n";

	my $fh = new FileHandle;
	$fh->open("<$fileName") or die "Could not open file: $fileName\n";
	while (<$fh>) {
		my $line = $_;
		chomp($line);
		print "$line\n";
	}
	$fh->close(); # automatically closes file
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# File variables
sub fileVars {
	my ( $fileName , @argv ) = @_;
	
	print "\n*************************************************************\n\n";
	print "   File Variables \n\n";
	
	my $fh ;
	open($fh , "<$fileName") or die "Could not open file: $fileName\n";
	while (<$fh>) {
		my $line = $_;
		chomp($line);
		print "$line\n";
	}
	close($fh); 
}
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# File sorting
sub fileSorting {
	my ( $fileName , @argv ) = @_;

	print "\n*************************************************************\n\n";
	print "   File Sorting \n\n";

	open(MYINPUTFILE, "<$fileName") or die "Could not open file: $fileName \n";
	my( @lines ) = <MYINPUTFILE>;
	@lines = sort(@lines);
	my($line);
	foreach $line (@lines) {
		print "$line"; 
	}
	close(MYINPUTFILE);
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MAIN DRIVER:

sub main {
	system(cls);
	
	my $fn = '\\\\austin\\healthr2\\mphilippone\\Code\\scripts\\perl\\data.txt';
	
	print "\n\n";
	print "     TESTING FILE MANIPULATION      \n";
	print "     FILE: $fn \n";
	print "     started at: ".time();
	print "\n\n";
	
	#oldFashionedInput($fn);
	#oldFashionedOutput($fn);
	#fileGlobbing($fn);
	fileHandles($fn);
	#fileVars($fn);
	#fileSorting($fn);
}

#########################################################
# call the driver
#	- kicks off the program :-)
main();
#########################################################