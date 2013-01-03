#!/usr/bin/perl -w

# This program gets sequences for a specified taxonomic group from the “class” database and prints them out in fasta format
 
# usage: get_sequences_for_specified_taxon.pl taxon_name swissprot_release output_filename database_username database_password

#The username and password for the “class” database are “biol511” and “student”, respectively

# The taxon name must be a scientific name. If it has a space, such as Drosophila melanogaster, you must replace the space with an underscore, like Drosophila_melanogaster. You can look in the taxon_name table to find out scientific names.

# Possible values of swissprot_release for the class database are 42.8 and 44.3. 


use strict;

use DBI;   # You must use DBI to interact with a database

#use Data::Dumper;  # I used this for debugging.

my $taxon = shift @ARGV or die $!;               # If genus and species, it needs to be in quotes (because of the space)
my $swissprot_release = shift @ARGV or die $!;
my $output_filename = shift @ARGV or die $!;
my $username = shift @ARGV or die $!;
my $password = shift @ARGV or die $!;


if ($swissprot_release != 42.8 && $swissprot_release != 44.3) {          # Exit if a valid release wasn't entered
    print "The class database does not have swissprot release $swissprot_release. Use 42.8 or 44.3\n"; exit;
}

#Next set up your database handle and open the connect.



my $dbh = DBI->connect("dbi:mysql:class:localhost",        # The database name (class) could have been a variable to make this more flexible.
                       "$username",                        # Double quotes allow you to use variable names. Single quotes don't.
                       "$password",
                       {RaiseError => 1}                   # This line says to exit if there is a mysql error and print the error to the screen 
                      );




my %sth;   # I will put mysql statement handles in this hash.


# First get the left and right id for the specified taxonomic group

# This sets up the statement handle:

$sth{get_taxon_bounds}=$dbh->prepare(qq{select left_id, right_id from taxon_name, taxon where taxon_name.name='$taxon' and taxon_name.class='scientific name' and taxon.taxon_id=taxon_n
ame.taxon_id});     

$sth{get_taxon_bounds}->execute ();  # If there is a syntax error in the statement handle (above), this line number is given in the error message.

my @left_right = $sth{get_taxon_bounds}->fetchrow_array ();    # Get the results from the query. This query gives only one row of output.

$sth{get_taxon_bounds}->finish ();  

#print Dumper (@left_right); exit;    # I used this for debugging - to make sure my query was doing what I thought it should do.

my $left_id = $left_right[0];     
my $right_id = $left_right[1];



open (OUT, ">$output_filename") or die $!;

#the next query uses the left_id and right_id from above to get the correct sequences

$sth{get_seq} = $dbh->prepare(qq{select acc, swissprot.id, swissprot.taxon_id, seq, descr, name from swissprot, taxon, taxon_name where release=$swissprot_release and swissprot.taxon_i
d = taxon.taxon_id and taxon.left_id >= $left_id and taxon.right_id <= $right_id and taxon_name.taxon_id = taxon.taxon_id and taxon_name.class = 'scientific name'}); 

$sth{get_seq}->execute ();

my @ary;
while (@ary=$sth{get_seq}->fetchrow_array ()) {    # Since the query results in many rows, we collect the results using a while loop
    my $acc = $ary[0];                             # every time we go through the loop, @ary gets a NEW set of values. The previous row is lost.
    my $id = $ary[1];                              # Therefore, we need either do something with these value INSIDE the while loop, or we need to
    my $sequence = $ary[3];                        # save the elements of the array (like in hashes) to be used later.
    my $descr = $ary[4];                           # Notice that the order of the things in the array are exactly how we specified the select statement.    
    my $taxon_name = $ary[5];
    
#    print Dumper (@ary); exit;        # I used this for debugging to make sure the select statement was doing what I thought it should do.

# The next section prints the seqeunces out in fasta format, with 60 amino acids per line.

    print OUT ">" . $id . "(" . $acc . ") ". $descr . " sp: " . $taxon_name . "\n";
    my $line_start = 0;
    my $total_length = length ($sequence);
    
    while ($line_start < $total_length) {
        if ($total_length - $line_start >= 60) {
            
            print OUT substr($sequence, $line_start, 60);
        }
        else {
            print OUT substr($sequence, $line_start, $total_length - $line_start + 1);
        }

        print OUT "\n";
        $line_start += 60;
    }
}


$sth{get_seq}->finish (); # We must finish reading data from the select statement before closing the statement handle. (Outside the while loop).


close OUT;

$dbh->disconnect ();    # Its good to close the database connection when you are finished.
exit;

