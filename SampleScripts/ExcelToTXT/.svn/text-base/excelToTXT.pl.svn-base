#!/usr/local/bin/perl

############################################
#    AUTHOR:    Alan Hamlett
#    MODIFIED:  Michael Philippone (2010-05-04)
#    CREATED:   03/18/2009
############################################

use strict;
use Spreadsheet::ParseExcel;

# the following pulls args from the command 
#	line options given to the script
my $inputFile   	= shift;
my $outputFile    	= shift;
$" 					= shift;
if( $" =~ /^[\s]$/ ) { $" = ","; }

if(!-e $inputFile || !$outputFile) {
    print qq~
   Usage: perl $0 inputFile outputFile delimiter (escaped)
       Parses an excel input file into a text file
~;
    exit 1;
}

if(open(OUT, "> $outputFile")) {
    my $workbook = Spreadsheet::ParseExcel::Workbook->Parse($inputFile);
    foreach my $worksheet (@{$workbook->{Worksheet}}) { # looping through worksheets
        for(my $row = $worksheet->{MinRow}; defined $worksheet->{MaxRow} && $row <= $worksheet->{MaxRow}; $row++) { # loop through rows
            my @line;
            for(my $column = $worksheet->{MinCol}; defined $worksheet->{MaxCol} && $column <= $worksheet->{MaxCol}; $column++) { # loop through columns
                my $value = $worksheet->{Cells}[$row][$column] ? $worksheet->{Cells}[$row][$column]->Value : "";
                $value =~ s/^\s+//;
                $value =~ s/\s+$//;
                $value =~ s/[\r\n]+//g;
                $value = " " if $value ne "0" && !$value;
                push(@line, $value);
            }
            print OUT "@line\n";
        }
    }
    close(OUT);
}
else {
    print "Error: Could not write to output file '$outputFile'\n";
}