genomes: /var/www/cgi-class > more class_example.cgi
#! /usr/bin/perl -w

#This script provides a form to submit an sptrembl accession. 
#It connects to dbee database and queries for description given the sptrembl accession.
#It then prints the results to a new page. 
#This one script does the equivalent of class_example_form.cgi and class_example_output.cgi


use warnings;
use strict;
use DBI;
use CGI qw( :standard );
use CGI::Carp qw(fatalsToBrowser carpout);

print header;
	
### The Main Part

my $acc;  

#First we check if someone has already submitted an accession. If not, then param is undefined,
#and we need to supply the form to allow someone to submit the accession.
#If param is defined, it means an accession has been submitted, and we need to do the query.

if (! param()) {       
    print start_html( { title => "Sptrembl Description Query" } );     
    Print_Form();        #calling a subroutine (see below)
    print end_html();
}

else {

    Initialize_Values();           # calling a subroutine (see below)
    my $description = Do_Query();
    print start_html( { title => "Query Results" } );   #print the following in html

    Print_Results($description);   #calling a subroutine (see below)

    print end_html();                                   #end of html
    exit;
    
}


### Subroutines

sub Print_Form {      #this subroutine prints the html form


    print h3("Query the dbee database." ), br();
    print startform(),
    "SPTrembl accession", br(),
    textfield('accession'), br(),
    br(), br(), submit( -value => "Submit Accession" ),
    end_form(), br(), br();


}

sub Initialize_Values {     #this subroutine puts the param value into the $acc scalar.

    $acc = param ('accession');      #The value that was submitted is in param. Now we set $acc to be that value.

}


sub Do_Query {              #this subroutine does the query using $acc

        my $dbh = DBI->connect("DBI:mysql:dbee:localhost",
                                "dbuser",    #dbuser is a user that has only select privileges
                                "dbuser",    #dbuser is also the password
                                {RaiseError => 1}
                                );


        my $sth = $dbh->prepare(qq{Select descr from sptrembl where acc='$acc' and sprot_release= 56.5});
        $sth->execute();
        my $description = $sth->fetchrow_array(); 
        $sth->finish();
        if (! defined $description) {
            $description = "$acc was not found in the dbee database.";
        }
        return($description);
        $dbh->disconnect();
}


sub Print_Results {    #this subroutine printe the results to a web page
    
    my $desc = shift @_;
    print h2("Results of Sptrembl Query for $acc"), br(),
    hr;
    print $desc; 
}       
