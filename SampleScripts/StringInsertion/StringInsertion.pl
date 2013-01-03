
# *******************************************************************************
# signature: 
#	insertXintoYatZ( X , Y , Z ) ;
sub insertXintoYatZ{
	my ( $X , $Y , $Z ) = @_;
	substr( $Y , $Z , -length($Y) ) = $X ;
	return $Y; 
}
# *******************************************************************************
$\ = "\n";
my $s;
print '';

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$s = "The black cat climbed the green tree";
print "s           = '$s'";
print '';
print 'color       = ' . substr( $s, 4, 5 );
print 'middle      = ' . substr( $s, 4, -11 );
print 'end         = ' . substr( $s, 14 );
print 'tail        = ' . substr( $s, -4 );
print '';

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
print "neg length, pos offset... \n            = " . substr( $s, -4, 2 );
print '';

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
print 'replace     = ' . substr( $s, 14, 7 , "jumped from" );
print "    (now, s =  '$s')";
print '';

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$s = "The black cat climbed the green tree";

print 'insert     = ' . (substr( $s , 26 , -length($s) ) = "tall ") ;
print "    (now, s =  '$s' )";

print 'insert     = ' . (substr( $s , 4 , -length($s) ) = "silly ") ;
print "    (now, s =  '$s' )";
print '';

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$s = "The black cat climbed the green tree";
print 'insert     = ' . ($s = insertXintoYatZ( "tall ", $s , 26 )) ;
print "    (now, s =  '$s' )";

print 'insert     = ' . ($s = insertXintoYatZ( "silly ", $s , 4 )) ;
print "    (now, s =  '$s' )";
print '';
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

$s = "The black cat climbed the green tree";
pos( $s ) = 1;
while( $s =~ /\ /g) {
	#print "  ++ MATCH: $+[0]" ;
	$s = insertXintoYatZ( "-" , $s , $+[0] );
	pos( $s ) = $+[0] + 1;
	#print " ++ $s";
}
print 'Looped insert...' ;
print "    (now, s =  '$s' )";
print '';


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=