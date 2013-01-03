
use warnings;
use strict;

my( 
	$string 
	, $regex
	, $replace
);

print "\n\n TESTING REGEX \n\n";

$string='hello world! worldwide greetings';
print "string = $string \n";
$regex='world';
$replace='everyone';
$string=~s/$regex/$replace/g;
print "string = $string \n";