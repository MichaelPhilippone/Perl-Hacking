#
#
#

$\ = "\n" ;

@args = `dir /B`;

print '';
#print " ARG: " . join( "\n ARG: " , @ARGV );
print " ARG: " . join( "\n ARG: " , @args );
print '';