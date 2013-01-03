#
#	Get emails from an IMAP mailbox
#

use strict;
use warnings;    
use Net::IMAP::Simple;
use Carp;
use Email::Simple;

my $host = '';
my $user = '';
my $pass = '';
	
# Create the object
my $imap = Net::IMAP::Simple->new( $host ) ;
  
# Log on
$imap->login( $user , $pass ) || croak( "Login failed: Unable to login. \n");

# Print the subject's of all the messages in the INBOX

my $folder = 'INBOX';
my $unseenMsgs = $imap->unseen( $folder );
my( $unseen , $recent , $num ) = $imap->status( $folder );

print "There are: \n";
print "    $unseen   UNREAD messages \n";
print "    $recent   RECENT messages \n";
print "    $num      TOTAL messages \n";


my @folders = $imap->mailboxes;
print join("\n -> " , @folders);

#for(my $i = 1; $i <= $unseenMsgs; $i++) {           
#	my $es = Email::Simple->new(join '', @{ $imap->top($i) } );    
#	my $messages = $es->header('Subject')."\n";
#	my $date = $es->header('Date');
#	chomp $messages;
#	chomp $date;
	#print "$messages :: $date\n";
#}




$imap->quit;