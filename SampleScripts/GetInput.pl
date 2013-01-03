#
# Read input from User:
#
## =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
use Term::ReadKey;

sub ReadFromUser {
	my( $prompt , @argv ) = @_;
	
	local $| = 1;
	
	print "Enter Username \n";
	print $prompt;
	chomp(my $uname = <STDIN>);
	print "\n";
	
	die ("!! ERROR !! \n unexpected end of input")
		unless defined ($uname) ;
	
	print "Enter Password \n";
	print $prompt;

	ReadMode "noecho";
	chomp(my $pass = <STDIN>);
	ReadMode "restore";
	print "\n";
	
	die ("!! ERROR !! \n unexpected end of input")
		unless defined ($pass) ;

	return $uname." -- ".$pass;
}

sub main {
	my( @argv ) = @_;
	
	my $input = ReadFromUser( ' >>> ' );
	
	print "You entered: $input \n"
}	

main( @ARGV );