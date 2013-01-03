#!/usr/bin/perl

$priority = 9;

$priority = 'high';

$str = 'string1';
$strCount = 3;

$hello = 'hello';
$CRLF = "\n";

print "$hello $CRLF";


@arr = ('item1','item2','item3');

$count = 0;
foreach $item (@arr) 
{
	print "Arr[$count] = $item $CRLF";
	$count++;
}

print "Array size: $#arr";