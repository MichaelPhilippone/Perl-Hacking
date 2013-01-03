use strict;
use Michael::Utils qw( time IsWin );
if( IsWin() ) { system(CLS); }

print "\n     TESTING DATE/TIME MANIPULATION      \n\n";

print &getTime."\n\n";

sub getTime {
	my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	my (
		$second
		, $minute
		, $hour
		, $dayOfMonth
		, $month
		, $yearOffset
		, $dayOfWeek
		, $dayOfYear
		, $daylightSavings
	) = localtime();

	my $year = 1900 + $yearOffset;
	my $theTime = "$hour:$minute:$second, $weekDays[$dayOfWeek] $months[$month] $dayOfMonth, $year";
	return 'Friendly Readable Time: '.$theTime;
}

