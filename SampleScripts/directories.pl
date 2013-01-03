#####################################################################
#	WHO: 	Michael Philippone
#	WHAT:	tutorial script for file I/O
#	WHEN:	2010-04-22
#####################################################################
#
#	Notes on file I/O modifiers:
#		(pre/suffixed to the filename in the "open" function call)
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
#		main 				-	driver function, used in calling the above sub routines
##########################################################################################################

use strict;
use Michael::Utils qw( time IsWin );
## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
sub listDir {
	my( $dir , $pad , @argv ) = @_;
	my $fullPath;
	
	opendir(IMD, $dir) || die("Cannot open directory: $dir \n");
	my $dirHandle =\*IMD;
	my @thefiles=readdir($dirHandle);
	
	foreach ( @thefiles ) {
	
		# test for '..' and '.' directories
		unless ( $_ =~ /^[\.]{1,2}$/ ) { 
		
			# test if item is a directory
			if (-d $dir."\\".$_ ) {
				$fullPath = $dir.'\\'.$_;
				print $pad.$fullPath.'\\';				
				# recurse into the directory
				listDir( $fullPath , $pad.'   ' );
			}
			else {
				# print full file path:
				print $pad.'"'.$dir.'\\'.$_.'"';
			}
		}	
	}
	closedir(IMD);
}
## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
sub main {
	if( IsWin() ) { system(cls); }
	
	my $dir = 'ExtractDOCTransfers';
	my $padding = '    ';
	$\ = "\n";
	
	print "\n".$padding."TESTING Directory MANIPULATION";
	print $padding."started at: ".time( "yyyy-MM-dd HH:mm:ss" )."\n";
	
	listDir($dir , $padding );
}
## -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
main();