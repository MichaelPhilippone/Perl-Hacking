

# one-liners
#	perl -MLWP::Simple -e 'getprint("http://www.google.com")'
#	perl -MLWP::Simple -e 'getstore("http://www.google.com" , "google.html")'

use strict;
use warnings;
use LWP::Simple;

my $url = 'http://www.google.com' ;
my $file = 'google.html' ;

my $content = get( $url ) ;
	
if( defined( $content ) ) {
	print "Content retrieved successfully from '$url' \n";
}
else {
	die "Couldn't get $url! \n" 
}
	
# print "CONTENT: \n";
# print "$content \n" ;


# if( mirror("http://www.sn.no/", "foo") == RC_NOT_MODIFIED ) { }
# if( is_success(getprint("http://www.sn.no/")) ) { }

if( is_success( getstore( $url , $file ) ) ) {
	print "File stored to: $file \n";
}