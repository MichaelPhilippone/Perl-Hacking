#
#
use strict;
print "Hello World! \n";

my $foo = <STDIN>;

END { print join( $/ , values( %INC ) ) . $/; }