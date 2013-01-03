#
#
#

use strict;
use warnings;


sub check_context {
    # True
    if ( wantarray ) {
        print "List context\n";
		return ();
    }
    # False, but defined
    elsif ( defined wantarray ) {
        print "Scalar context\n";
		return '';
    }
    # False and undefined
    else {
        print "Void context\n";
		return ;
    }
}

my @x1       = check_context();  # prints 'List context'
my %x2       = check_context();  # prints 'List context'
my ($x3, $y) = check_context();  # prints 'List context'

my $x4       = check_context();  # prints 'Scalar context'

check_context();                # prints 'Void context'