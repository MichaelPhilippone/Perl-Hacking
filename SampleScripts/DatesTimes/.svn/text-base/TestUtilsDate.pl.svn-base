#
#
#

use strict;
use warnings;
use Michael::Utils qw(time IsWin);

if(IsWin()) { system(CLS); }

our $pad = "   ";
our $formatTitle = "FORMAT                                ";
our $timeTitle = 'Michael::Utils::time( [\'FORMAT\'] )';
our $header = $pad.$formatTitle.$pad.$timeTitle." \n";
$header .= "-" x (length($header)+1)."\n\n";

sub PrintFormatTime {
	my( $time , $fmt , @argv ) = @_;
	$fmt = (!length($fmt)?'(none)':$fmt);
	print $pad.$fmt.( " " x (length($formatTitle)-length($fmt)) ).$pad.$time."\n\n";
}

print "\n\n".$header;

my $fmt;
$fmt = '';
PrintFormatTime ( Michael::Utils::time() , $fmt );

$fmt = "dd/MM/yyyy";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );

$fmt = "dd/MM/yy";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );

$fmt = "DDD, MMM dd, yyyy";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );

$fmt = "DDDD, MMMM dd, yyyy";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );

$fmt = "hh:mm:ss";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );

$fmt = "hh:mm:ss tt";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );

$fmt = "HH:mm:ss";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );

$fmt = "dd/MM/yy hh:mm:ss [tt]";
PrintFormatTime ( Michael::Utils::time( $fmt ) , $fmt );