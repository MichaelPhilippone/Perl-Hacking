#
#	using the Tk lib, pick a file, then decrypt it using GPG via OS command line call
#

package PickFile_DecryptFile;

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

use strict;
use warnings;

use Tk;

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

$\="\n";                       # let every print end with a newline
$| = 1;                        # keeps the pipes piping hot!

# where are we keeping the password for the GPG decryption?
our $GPGPassWordFile = '"\\austin\healthr2\mphilippone\BACKUP\Adam_GPG_KEY_Passphrase.txt"';

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

sub GUI { 
	my ( @argv) = @_;
	
	my $winTitle = "Decrypt PGP File";
	
	my ( $x , $y ) = ( 200 , 200 );
	my( $winHeight , $winWidth ) = ( 350 , 650 );
	
	my $mw = MainWindow->new( -title => $winTitle );

	my $frame = 
			$mw->Frame()
					->pack( 
						-expand => 1 
						, -fill => 'x' 
						, -padx => 10 
						, -pady => 5 );
	
	my $getFilesBtnClick = sub{ 
				
		my @types = ( ["PGP Encrypted Files",'.pgp'] , ["All files",'*'] );
		my $fileName = $mw->getOpenFile(-filetypes => \@types , -initialdir => '.' , -title => "Select File" );
		my $decryptedFileName = '';
		
		if( !( defined($fileName) && $fileName !~ /^[\s]*$/ ) ) {
			$frame->Label( 
					-text => "Please choose a file." )
						->pack( 
							-expand => 1 
							, -fill => 'x' 
							, -padx => 5 
							, -pady => 10 );
			
		}
		else {
			$fileName =~ s!\/!\\!g ;
			$decryptedFileName = $fileName;
			$decryptedFileName =~ s/\.gpg$//  if( $decryptedFileName =~ /\.gpg$/  );
			$decryptedFileName =~ s/\.pgp$//  if( $decryptedFileName =~ /\.pgp$/  );
			
			print "fileName:       $fileName";
			print "OUTPUT:         $decryptedFileName\n\n";
						
			# make a system call to decrypt the test file:
			if( system(
					'gpg'
					, '--output' => $decryptedFileName
					, '--batch'
					, '--quiet'
					, '--passphrase-file' => $GPGPassWordFile
					, '--yes'
					, '--decrypt' => $fileName) ) 
			{	
				# either remove the old label (if it exists) or create one
				$frame->Label( 
						-text => "$fileName has been decrypted to \n $decryptedFileName" )
							->pack( 
								-expand => 1 
								, -fill => 'x' 
								, -padx => 5 
								, -pady => 10 );
				
				# now resize the window to show the full response text
				$mw->geometry( $winWidth+(length($fileName)*2) . "x" . $winHeight . "+" . $x . "+" . $y );						
			}
			else {
				$frame->Label( 
					-text => "$fileName\n" . "was unable to be decrypted" )
						->pack( 
							-expand => 1 
							, -fill => 'x' 
							, -padx => 5 
							, -pady => 10 ) ;
			}
		}
	};
	
	$frame->Button( -text => "Select Encrypted File"
				, -command => \$getFilesBtnClick
				)->pack( -expand => 1
						#, -fill => 'x' 
						, -padx => 5 , -pady => 20 );
				
	$frame->Button( -text => "Exit"
				, -command => sub{ exit(0); } 
			)->pack( -expand => 1
					#, -fill => 'x' 
					, -padx => 5 , -pady => 20 );
			
	MainLoop;
}
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
GUI( @ARGV );