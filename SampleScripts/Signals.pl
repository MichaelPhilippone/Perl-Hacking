system(CLS);

use Config;

sub handler {
	my($sig) = @_;
	print "Caught $sig signal \n";
	
	exit(0);
}

defined $Config{sig_name} || die "No sigs?";
foreach $name (split(' ', $Config{sig_name})) {
	$signo{$name} = $i;
	$signame[$i] = $name;
	$i++;
	
	print "SIG:   $name \n";
	print "SIGNO: $i \n";
	
	#$SIG{$name} = \&handler;
}

# catch end of properly exiting script:
END{ print "closing..."; }


__END__
Expected output (or something similar, on Win32 [XP])

SIG:   ZERO
SIGNO: 1
SIG:   HUP
SIGNO: 2
SIG:   INT
SIGNO: 3
SIG:   QUIT
SIGNO: 4
SIG:   ILL
SIGNO: 5
SIG:   NUM0
SIGNO: 6
SIG:   NUM0
SIGNO: 7
SIG:   NUM0
SIGNO: 8
SIG:   FPE
SIGNO: 9
SIG:   KILL
SIGNO: 10
SIG:   NUM1
SIGNO: 11
SIG:   SEGV
SIGNO: 12
SIG:   NUM1
SIGNO: 13
SIG:   PIPE
SIGNO: 14
SIG:   ALRM
SIGNO: 15
SIG:   TERM
SIGNO: 16
SIG:   NUM1
SIGNO: 17
SIG:   NUM1
SIGNO: 18
SIG:   NUM1
SIGNO: 19
SIG:   NUM1
SIGNO: 20
SIG:   CHLD
SIGNO: 21
SIG:   BREA
SIGNO: 22
SIG:   ABRT
SIGNO: 23
SIG:   STOP
SIGNO: 24
SIG:   NUM2
SIGNO: 25
SIG:   CONT
SIGNO: 26
SIG:   CLD
SIGNO: 27