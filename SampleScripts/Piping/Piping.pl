#	#	#	#	#	#	#	#	#	#	#	#	#	#
# Running another process on a pipe
#	If you use backquotes, a command is run on your
#	computer as a separate process and WHEN IT IS
#	COMPLETED, you'll get the results back.  If you
#	want to read fromthe other process as it runs,
#	you can open a piped process instead - that's
#	using open with a pipe character at the end of
#	what would normally be the file name, but is now
#	the command to run your extra process in turn.
#	#	#	#	#	#	#	#	#	#	#	#	#	#
# Run a ping command to contact a local machine
open (STUFF,"ping -c3 192.168.200.215|");

# Analyse the result as it's generated
while ($lyne = <STUFF>) {
	if ($lyne =~ /time=(\S+)/) {
		$elt = $1;
		if ($elt > 300) {
			print "slow";
		} elsif ($elt > 100) {
			print "ok";
		} else {
			print "wow!";
		}
		print " - took $elt ms\n";
	}
}

__END__

Sample output:

linux#$ perl Piping.pl
wow! - took 2.317 ms
wow! - took 1.009 ms
wow! - took 1.017 ms
linux#$