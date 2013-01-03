#!usr/bin/perl
use strict;
use warnings;
use Crypt::CBC;
use Crypt::Twofish2 qw(MODE_CBC);
use Crypt::Rijndael;
use Digest::MD5;
use threads;
use threads::shared;
use File::Basename;

#Optional Modules#
if ($^O eq 'MSWin32') {
  eval    { require Win32::Console; Win32::Console::Free() };
  if ($@) { print "Win32::Console is not installed.\n$@";   }
}

#Declarations#
my $VERSION = 1.01;                     #major rel.version rel.patch rel
my (%threads, %shash,);

#Threads#
#all threads have access to all shared data structures
share ($shash{1}{'go'});         $shash{1}{'go'}        = 0;
share ($shash{1}{'die'});        $shash{1}{'die'}       = 0;
share ($shash{1}{'key1'});       $shash{1}{'key1'}      = 0;
share ($shash{1}{'key2'});       $shash{1}{'key2'}      = 0;
share ($shash{1}{'fileIN'});     $shash{1}{'fileIN'}    = 0;
share ($shash{1}{'fileOUT'});    $shash{1}{'fileOUT'}   = 0;
share ($shash{1}{'keysize'});    $shash{1}{'keysize'}   = 0;
share ($shash{1}{'blocksize'});  $shash{1}{'blocksize'} = 0;
share ($shash{1}{'integrity'});  $shash{1}{'integrity'} = 0;
share ($shash{1}{'encryption'}); $shash{1}{'encryption'}= 0;
share ($shash{1}{'operation'});  $shash{1}{'operation'} = 0;
share ($shash{1}{'progress'});   $shash{1}{'progress'}  = 101;
$threads{1} = threads->new(\&worker, 1);

#Main#
use Tk;
use Tk::LabFrame;
use Tk::ROText;

my  $mw = MainWindow->new(-title    => 'Shapeshifter',
                          -relief   => 'groove',
                          -bd       => 2,);
                          $mw->resizable(0, 0);
&gui();
&Tk::MainLoop();

#Exit#
for my $gc (1..1) {
  warn "Destroying Thread [$gc]\n";
  $shash{$gc}{'die'} = 1;
  unless ($threads{$gc}->join) {
    warn "Error joining thread:  [$gc]\n$!";
  }
}
warn "Exiting normally..\n";
exit;

#Subroutines#
sub gui #---------------------------------------------------------------GUI
{
  #Widgets#
  our $f00 = $mw ->Frame(-relief => 'groove', -bd => 2,);
  our $f01 = $f00->Frame(-relief => 'raised', -bd => 2,);
  our $f02 = $f00->Frame(-relief => 'raised', -bd => 2,);
  my  $f03 = $f00->Frame(-relief => 'flat',   -bd => 0,);
  our $f04 = $mw ->Frame(-relief => 'sunken', -bd => 2,);
  our $f05 = $f00->Frame(-relief => 'raised', -bd => 2,);
  our $f06 = $f00->Frame(-relief => 'raised', -bd => 2,);
  our $f07 = $mw ->Frame(-relief => 'groove', -bd => 2,);
  our $f08 = $f03->Frame(-relief => 'flat',   -bd => 0,);
  
  our $o01 = $f06->Optionmenu(
    -options  => ['Rijndael','Twofish2',],
    -variable => \$shash{1}{'encryption'},
    -fg       => '#000000',
    -relief   => 'ridge',
    -bd       => 2,
  );
  our $o02 = $f06->Optionmenu(
    -options  => ['256 bits', '192 bits', '128 bits',],
    -variable => \$shash{1}{'keysize'},
    -fg       => '#000000',
    -relief   => 'ridge',
    -bd       => 2,
  );
  
  our $l01 = $f05->Label(-text    => 'Shapeshifter',
                         -anchor  => 'center',
                         -font    => '{Verdana} 20',
                         -bg      => '#000000',
                         -fg      => '#00ff00',
                         -relief  => 'flat',
                         -width   => 12,);
  our $l02 = $f04->Label(-text    => '',
                         -anchor  => 'center',
                         -font    => '{Courier New} 10',
                         -relief  => 'raised',
                         -bg      => '#000000',
                         -fg      => '#00FF00',
                         -bd      => 4,);
  my  $l03 = $f02->Label(-text    => 'Key:',
                         -anchor  => 'center',
                         -width   => 6,);
  my  $l04 = $f01->Label(-text    => 'Encrypt',
                         -anchor  => 'w',);
  my  $l05 = $f01->Label(-text    => 'Decrypt',
                         -anchor  => 'w',);
  my  $l06 = $f06->Label(-text    => 'AES Cipher:',
                         -anchor  => 'w',);
  my  $l07 = $f06->Label(-text    => 'AES Key:',
                         -anchor  => 'w',);
  my  $l08 = $f00->Label(-text    => '',
                         -relief  => 'raised',
                         -bd      => 2,);
  
  our $b01 = $f08->Button(-text             => 'File:',
                          -activeforeground => '#0000ff',
                          -width            => 6,
                          -command          => sub {
    &openfile();
  });
  our $b02 = $f03->Button(-text             => 'Start',
                          -activeforeground => '#0000ff',
                          -command          => sub {
    &go();
  });
  my  $b03 = $f03->Button(-text             => 'Cancel',
                          -activeforeground => '#ff0000',
                          -command          => sub {
    &cancel();
  });
  
  our $e01 = $f02->Entry(#key
                         -width => 24,     #also used to adjust geometry
                         -bg    => '#ffffff',
                         -fg    => '#000000');
  our $e02 = $f08->Entry(#path
                         -bg    => '#ffffff',
                         -fg    => '#000000',);
  
  our $r1v = our $r2v = 0;
  our $r01 = $f01->Radiobutton(-variable => \$r1v,
                               -command  => sub {
      $shash{1}{'operation'} = 'E';
      $r2v = 0;
  });
  our $r02 = $f01->Radiobutton(-variable => \$r2v,
                               -command  => sub {
      $shash{1}{'operation'} = 'D';
      $r1v = 0;
  });
  
  my  $sb1 = $f07->Scrollbar(-orient => 'horizontal',);
  our $t01 = $f07->ROText(-xscrollcommand => ['set' => $sb1],
                          -fg             => '#ffffff',
                          -bg             => '#000000',
                          -relief         => 'sunken',
                          -wrap           => 'none',
                          -bd             => 2,
                          -height         => 16,
                          -width          => 58,);
      tie (*STDOUT, ref $t01, $t01);
      $sb1->configure(-command => ['xview' => $t01]);
  
  #Geometry#
  $f00->grid(-in     => $mw,       -columnspan => '2',
             -column => '1',       -rowspan    => '4',
             -row    => '1',       -sticky     => 'news');
  $f01->grid(-in     => $f00,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '2',       -sticky     => 'news');
  $f02->grid(-in     => $f00,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '3',       -sticky     => 'news');
  $f03->grid(-in     => $f00,      -columnspan => '3',
             -column => '1',       -rowspan    => '2',
             -row    => '5',       -sticky     => 'news');
  $f04->grid(-in     => $mw,       -columnspan => '2',
             -column => '1',       -rowspan    => '1',
             -row    => '7',       -sticky     => 'news');
  $f05->grid(-in     => $f00,      -columnspan => '1',
             -column => '3',       -rowspan    => '3',
             -row    => '1',       -sticky     => 'news');
  $f06->grid(-in     => $f00,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $f07->grid(-in     => $mw,       -columnspan => '2',
             -column => '1',       -rowspan    => '1',
             -row    => '6',       -sticky     => 'news');
  $f08->grid(-in     => $f03,      -columnspan => '2',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news',);
  
  $l01->grid(-in     => $f05,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $l02->grid(-in     => $f04,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $l03->grid(-in     => $f02,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $l04->grid(-in     => $f01,      -columnspan => '1',
             -column => '2',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $l05->grid(-in     => $f01,      -columnspan => '1',
             -column => '5',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $l06->grid(-in     => $f06,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $l07->grid(-in     => $f06,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '2',       -sticky     => 'news');
  $l08->grid(-in     => $f00,      -columnspan => '1',
             -column => '2',       -rowspan    => '3',
             -row    => '1',       -sticky     => 'news');
  $r01->grid(-in     => $f01,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $r02->grid(-in     => $f01,      -columnspan => '1',
             -column => '4',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $b01->grid(-in     => $f08,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $b02->grid(-in     => $f03,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '2',       -sticky     => 'news');
  $b03->grid(-in     => $f03,      -columnspan => '1',
             -column => '2',       -rowspan    => '1',
             -row    => '2',       -sticky     => 'news');
  $e01->grid(-in     => $f02,      -columnspan => '1',
             -column => '2',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $e02->grid(-in     => $f08,      -columnspan => '1',
             -column => '2',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $o01->grid(-in     => $f06,      -columnspan => '1',
             -column => '2',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $o02->grid(-in     => $f06,      -columnspan => '1',
             -column => '2',       -rowspan    => '1',
             -row    => '2',       -sticky     => 'news');
  
  $t01->grid(-in     => $f07,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '1',       -sticky     => 'news');
  $sb1->grid(-in     => $f07,      -columnspan => '1',
             -column => '1',       -rowspan    => '1',
             -row    => '2',       -sticky     => 'news');
  
  $mw->gridRowconfigure(1,         -minsize => 1,);
  $mw->gridRowconfigure(2,         -minsize => 1,);
  $mw->gridRowconfigure(3,         -minsize => 1,);
  $mw->gridRowconfigure(4,         -minsize => 1,);
  $mw->gridRowconfigure(5,         -minsize => 1,);
  $mw->gridRowconfigure(6,         -minsize => 1,);
  $mw->gridRowconfigure(7,         -minsize => 1,);
  $mw->gridColumnconfigure(1,      -minsize => 1,);
  $mw->gridColumnconfigure(2,      -minsize => 1,);
  
  $f00->gridRowconfigure(1,        -minsize => 1,);
  $f00->gridRowconfigure(2,        -minsize => 1,);
  $f00->gridRowconfigure(3,        -minsize => 1,);
  $f00->gridRowconfigure(4,        -minsize => 1,);
  $f00->gridRowconfigure(5,        -minsize => 1,);
  $f00->gridColumnconfigure(1,     -minsize => 1,);
  $f00->gridColumnconfigure(2,     -minsize => 1,);
  $f00->gridColumnconfigure(3,     -minsize => 1, -weight => 1);
  
  $f01->gridRowconfigure(1,        -minsize => 1,);
  $f01->gridColumnconfigure(1,     -minsize => 1,);
  $f01->gridColumnconfigure(2,     -minsize => 1,);
  $f01->gridColumnconfigure(3,     -minsize => 1, -weight => 1);
  $f01->gridColumnconfigure(4,     -minsize => 1,);
  $f01->gridColumnconfigure(5,     -minsize => 1,);
  $f01->gridColumnconfigure(6,     -minsize => 1, -weight => 1);
  
  $f02->gridRowconfigure(1,        -minsize => 1,);
  $f02->gridColumnconfigure(1,     -minsize => 1,);
  $f02->gridColumnconfigure(2,     -minsize => 1, -weight => 1);
  
  $f03->gridRowconfigure(1,        -minsize => 1, -weight => 1);
  $f03->gridRowconfigure(2,        -minsize => 1, -weight => 1);
  $f03->gridColumnconfigure(1,     -minsize => 1, -weight => 1);
  $f03->gridColumnconfigure(2,     -minsize => 1, -weight => 1);
  
  $f04->gridRowconfigure(1,        -minsize => 1,);
  $f04->gridColumnconfigure(1,     -minsize => 1, -weight => 1);
  
  $f05->gridRowconfigure(1,        -minsize => 1, -weight => 1);
  $f05->gridColumnconfigure(1,     -minsize => 1, -weight => 1);
  
  $f06->gridRowconfigure(1,        -minsize => 1,);
  $f06->gridRowconfigure(2,        -minsize => 1,);
  $f06->gridColumnconfigure(1,     -minsize => 1,);
  $f06->gridColumnconfigure(2,     -minsize => 1, -weight => 1);
  
  $f07->gridRowconfigure(1,        -minsize => 1,);
  $f07->gridRowconfigure(2,        -minsize => 1,);
  $f07->gridColumnconfigure(1,     -minsize => 1,);
  
  $f08->gridRowconfigure(1,        -minsize => 1, -weight => 1);
  $f08->gridColumnconfigure(1,     -minsize => 1,);
  $f08->gridColumnconfigure(2,     -minsize => 1, -weight => 1);
  
  #Bindings#
  $l01->bind('<ButtonPress-1>' => sub {
    &ss_fade();
  });
  &button_lights($o01);
  &button_lights($o02);
  
  #Defaults#
  $r01->invoke;
  $l02->configure(-text => 'Ready');
  
  #Callbacks
  sub go #--------------------------------------------------------------GO
  {
    $mw->Busy(-recurse => 1);
    $t01->delete("1.0", 'end');
    $mw->update;
    
    #gather, verify, and share values for the work thread
    if ($shash{1}{'key1'} = $e01->get()) {
      #get and create user key
      $shash{1}{'key2'} = 'aAbBcC'.$shash{1}{'key1'}.'1!2@3#';
    }
    else {
      print "Error - Invalid Key.\n";
      $mw->Unbusy;
      return(0);
    }
    if (-e $shash{1}{'fileIN'}) {                                         #test
      #launch thread
      print "Processing file..\n\n";
      $shash{1}{'go'} = 1;
      
      #indicate activity
      &activity(1);
      
      #create a report
      print "Operation completed.\n\n";
      print "Summary\n";
      print "  cipher:     ".$shash{1}{'encryption'}."\n";
      print "  keysize:    ".$shash{1}{'keysize'}."\n";
      print "  blocksize:  ".$shash{1}{'blocksize'}."\n";
      print "  integrity:  ".$shash{1}{'integrity'}."\n";
      print "  input:      ".$shash{1}{'fileIN'}."\n";
      print "  output:     ".$shash{1}{'fileOUT'}."\n\n";
      print "Done.\n\n";
    }
    else {
      print "Error - Invalid File.\n";
      $mw->Unbusy;
      return(0);
    }
    goEND:
    $mw->Unbusy;
    $mw->update;
  }
  sub cancel #----------------------------------------------------------CANCEL OPERATION
  {
    $mw->Busy(-recurse => 1);
    $shash{1}{'go'} = 0;
    $mw->after(1000);
    $mw->Unbusy;
  }
  sub openfile #--------------------------------------------------------OPEN FILE
  {
    $mw->Busy(-recurse => 1);
    $e02->delete(0, 'end');
    $mw->update;
    
    my $ofile = $mw->getOpenFile(
      -title      => 'Select File',
      -initialdir => '.',
    );
    if ($ofile) {
      $shash{1}{'fileIN'} = $ofile;
      $e02->insert('end', "$ofile");
      $e02->icursor('end');
      $e02->xview('end');
      $mw->update;
    }
    $mw->Unbusy;
  }
  sub activity #--------------------------------------------------------ACTIVITY
  {
    my $opt = $_[0];
    
    $e02->configure(-state => 'disabled',);
    $mw->update;
    
    $mw->after(2000);
    while($shash{$opt}{'progress'} != 101) {
      $l02->configure(-text => ($shash{$opt}{'progress'} - 1).'%');
      $mw->after(500);
      $mw->update;
    }
    
    $l02->configure(-text  => 'Ready');
    $e02->configure(-state => 'normal',);
    $mw->update;
  }
  sub ss_fade #---------------------------------------------------------FADE
  {
    $l01->Busy;
    
    my $c2 = 254;
    while ($c2 >= 16) {
      my $c2_hex = sprintf "%x", $c2;
      my $fg = '#00'.$c2_hex.'00';
      $l01->configure(-fg => $fg);
      if ($c2 % 2) {
        $c2--;
      }
      $c2--;
      $mw->update;
      
      my $x = 20 + int(rand(10));
      $mw->after($x);
    }
    $c2++;
    while ($c2 <= 255) {
      my $c2_hex = sprintf "%x", $c2;
      my $fg = '#00'.$c2_hex.'00';
      $l01->configure(-fg => $fg);
      if ($c2 % 2) {
        $c2 += 4;
      }
      $c2 += 4;
      $mw->update;
      
      my $x = 20 + int(rand(10));
      $mw->after($x);
    }
    $l01->configure(-fg => '#00ff00');
    $l01->Unbusy;
    $mw->update;
  }
  sub button_lights #---------------------------------------------------BUTTON LIGHTS
  {
    my $w = $_[0];
    
    $w->bind('<Enter>' => sub {
      $w->configure(-activeforeground => '#0000ff');
    });
    $w->bind('<Leave>' => sub {
      $w->configure(-activeforeground => '#000000');
    });
  }
}
########################################################################THREAD SECTION
sub worker #------------------------------------------------------------Crypto work
{
  my $TID = shift;
  $| = 1;
  
  while(1) {
    if ($shash{$TID}{'die'} == 1) { goto workerEND };
    if ($shash{$TID}{'go' } == 1) {
      my($md5, $cipher, $key, $output, $buffer,);
      $shash{1}{'keysize'} =~ s/\sbits//;
      
      #Key1 is entered by the user, key2 is generated by hardening key1.
      #The first and second passphrases (key1 & key2) are hashed, and
      #then combined in various ways to make a 1024 bit key.
      #This key is then passed to Crypt-CBC which will derive a new key
      #of specified size by performing a series of md5 operations on it.
      $md5 = Digest::MD5->new;
      $md5->add($shash{$TID}{'key1'}); $key  = $md5->digest;   #128 bits
      $md5->add($shash{$TID}{'key2'}); $key .= $md5->digest;   #256 bits
      $key .= reverse($key);                                   #512 bits
      $key .= reverse($key);                                  #1024 bits
      $cipher = Crypt::CBC->new (-cipher  => $shash{1}{'encryption'},
                                 -keysize => $shash{1}{'keysize'} / 8,
                                 -key     => $key,);
      $shash{$TID}{'blocksize'} = $cipher->blocksize;
      
      #perform the integrity checking function
      if (open(IN, "< :raw", $shash{$TID}{'fileIN'})) {
        $shash{$TID}{'integrity'} = $md5->addfile(*IN)->hexdigest;
        close IN;
      }
      else {
        print 'Can not open'.$shash{$TID}{'fileIN'}."\n$!";
        goto goEND;
      }
      
      #determine the mode of operation
      if ($shash{$TID}{'operation'} eq 'E') {
        $cipher->start('encrypting');
      }
      elsif ($shash{$TID}{'operation'} eq 'D') {
        $cipher->start('decrypting');
      }
      
      #open files
      unless(open(IN, '< :raw', $shash{$TID}{'fileIN'})) {
        print 'Can not open '.$shash{$TID}{'fileIN'}."\n$!";
        goto goEND;
      }
      $shash{$TID}{'fileOUT'} = dirname($shash{$TID}{'fileIN'}).'/'.
                                        $shash{$TID}{'operation'}.'_'.
                                        basename($shash{$TID}{'fileIN'});
      unless(open(OUT, '> :raw', $shash{$TID}{'fileOUT'})) {
        print 'Can not create '.$shash{$TID}{'fileOUT'}."\n$!";
        goto goEND;
      }
      
      #perform the encryption or decryption operation
      while (read(IN,$buffer,1024)) {
        if ($shash{$TID}{'go' } == 0 or $shash{$TID}{'die'} == 1) {
          close IN;
          close OUT;
          undef $buffer;
          unlink $shash{$TID}{'fileIN'};
          if ($shash{$TID}{'go'}  == 0) { goto goEND;   }
          if ($shash{$TID}{'die'} == 1) { goto workEND; }
        }
        else {
          print OUT $cipher->crypt($buffer);
          my $endsize = -s $shash{$TID}{'fileIN'};
          my $nowsize = -s $shash{$TID}{'fileOUT'};
          my $percent = int(($nowsize * 100) / $endsize);
          $shash{$TID}{'progress'} = $percent;
        }
      }
      print OUT $cipher->finish; #very important
      
      #finish up
      close IN;
      close OUT;
      $shash{$TID}{'progress'} = 101;
      $shash{$TID}{'go'}       = 0;
    }
    else {
      sleep(1);
    }
    goEND:
  }
  workerEND:
  return(1);
}
#POD Section#
=head1 NAME

Shapeshifter

=head1 DESCRIPTION

Encrypt/Decrypt your files.

=head1 README

Shapeshifter 1.01

A pTk GUI based file encrypter and decrypter.
This is a stripped-down version of a VPN system which allows for
secure data streams, chat, and file transfer.

=head1 PREREQUISITES

Crypt::CBC

Tk

=head1 COREQUISITES

Win32::Console (Optional)

=head1 Copyright

Shapeshifter

Copyright (C) 2007 Jason David McManus

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

=head1 History

v1_01 - Initial release. (Apr. 2007)

=head1 Contact

Please send comments/suggestions/bugs to: QoS.nospam@cpan.org
(remove dot nospam to send email)
Or post a message on the comp.lang.perl.tk newsgroup

Thank you.

=pod OSNAMES

MSWin32, any others?

=pod SCRIPT CATEGORIES

Networking

=cut