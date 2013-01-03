use strict;
use warnings;

my $verbose = shift;
my $pad = 4;

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

print ("*" x 95);
print "\n\n                NUMBERS: \n\n";
print ("*" x 95);
my @unsorted_array = (100,5,8,92,-7,34,29,58,8,10,24);

print "\nUNSORTED: \n    " . join(",", @unsorted_array), "\n";

print "\nCOMPARISON STEPS:  \n" if $verbose;
#my @sorted_array = (sort { $b <=> $a; } @unsorted_array);
my @sorted_array = 
	( sort  
		{ 
			printf( "    [a=%".$pad."s] [b=%".$pad."s ] [cmp=%".$pad."s] \n" , $a , $b , ($a <=> $b) ) if $verbose ; 
			($a <=> $b ) ; 
		} 
		@unsorted_array 
	);
print "\n" if $verbose;

print "\nSORTED: \n    " . join(",", @sorted_array), "\n";
print "\n\n";

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
print ("*" x 95);
print "\n\n                STRINGS: \n\n";
print ("*" x 95);

my @unsorted_array = (
    "Hello World!",
    "You is all I need.",
    "To be or not to be",
    "There's more than one way to do it.",
    "Absolutely Fabulous",
    "Ci vis pacem, para belum",
    "Give me liberty or give me death.",
    "Linux - Because software problems should not cost money",
);

print "\nUNSORTED: \n    " . join("\n    ", @unsorted_array), "\n";

# Do a case-insensitive sort

print "\nCOMPARISON STEPS:  \n" if $verbose;
#my @sorted_array = (sort { lc($b) cmp lc($a); } @unsorted_array);
my @sorted_array = 
	( sort  
		{ 
			printf( "    [a=%".$pad."s] [b=%".$pad."s ] [cmp=%".$pad."s] \n" , $a , $b , ( lc($a) cmp lc($b) ) ) if $verbose ; 
			( lc($a) cmp lc($b) ) ; 
		} 
		@unsorted_array 
	);
print "\n" if $verbose;


print "\nSORTED: \n    " . join("\n    ", @sorted_array), "\n";