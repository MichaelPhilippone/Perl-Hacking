#!/usr/bin/perl -W

use strict;
use warnings;
use XML::Twig;
use DBI;
# ================================================================================ GLOBALS
my $DIR = shift; 
die "No File Supplied!" ."\n\t>>[ERR: $!]\n" if (!$DIR || $DIR =~ m/^[\w]*$/);
my $DBH = DBI->connect("dbi:mysql:class:localhost","mp656","password",{RaiseError => 1});
# ===================================================================== &parse_page_entity
# extract the data from a 'page' record 
#  and push into MySQL DB w/ DBI
sub parse_page_entity {
	my ($elt,$file)=@_;
	my %fields;
	if( $elt->has_child('title') ) {
		$fields{'title'} = $elt->has_child('title')->text_only;
	} else { print " !!!!!! No title for element. \n"; }
	if( $elt->has_child('id') ) {
		$fields{'id'} = $elt->has_child('id')->text_only;
	} else { print " !!!!!! No id for element. \n"; }
	if( $elt->has_child('ns') ) {
		$fields{'namespace'} = $elt->has_child('ns')->text_only;
	} else { print " !!!!!! No namespace for element. \n"; }
	
	if( $elt->has_child('revision') ) {
		$fields{'revision'} = $elt->has_child('revision');
		
		if( $fields{'revision'}->has_child('id') ) {
			$fields{'rev_id'} = $fields{'revision'}->has_child('id')->text_only;	
		}
		if( $fields{'revision'}->has_child('timestamp') ) {
			$fields{'rev_timestamp'} = $fields{'revision'}->has_child('timestamp')->text_only;	
		}
		if( $fields{'revision'}->has_child('minor') ) {
			$fields{'rev_minor'} = $fields{'revision'}->has_child('minor')->text_only;	
		}
		if( $fields{'revision'}->has_child('comment') ) {
			$fields{'rev_comment'} = $fields{'revision'}->has_child('comment')->text_only;	
		}
		if( $fields{'revision'}->has_child('text') ) {
			$fields{'rec_text'} = $fields{'revision'}->has_child('text')->text_only;	
		}
		if( $fields{'revision'}->has_child('sha1') ) {
			$fields{'rev_sha1'} = $fields{'revision'}->has_child('sha1')->text_only;	
		}
		if( $fields{'revision'}->has_child('contributor') ) {
			$fields{'rev_contributor'} = $fields{'revision'}->has_child('contributor');
			if( $fields{'rev_contributor'}->has_child('username') ) {
				$fields{'rev_contributor_user'} = $fields{'rev_contributor'}->has_child('username')->text_only;
			}
			if( $fields{'rev_contributor'}->has_child('id') ) {
				$fields{'rev_contributor_id'} = $fields{'rev_contributor'}->has_child('id')->text_only;
			}
		}
	} else { print " !!!!!! No revision for element. \n"; }
	
	# test with output debugging
	print "FILE: $file \n";
	foreach my $fld (keys(%fields)) {
		print "\t>> $fld : $fields{ $fld } \n";
	}
	print "====================================\n";
	
	# push into the DB!
	#my $table = "";
	#my $cols = "";
	#my $vals = "";
	#my $sql = $DBH->prepare( qq{INSERT INTO $table ($cols) VALUES($vals);} );     
	#$sql->execute();
	#my @results = $sql->fetchrow_array();	
	#$sql->finish();

	$elt->purge ;
}
# ============================================================================ &twig_parse
# walk through the given XML doc and call out on page records
sub twig_parse {
    my ($file,@argv)=@_;
    my $twig = XML::Twig->new(
				  twig_handlers => {
					  page => sub{ &parse_page_entity($_,$file); } ,
			      }, 
			      pretty_print => 'indented',
			      );
    $twig->parsefile("$file" ) || die $!;
    $twig->purge;
}
# ======================================================================== &get_file_names
# get file names listing from the specified directory
sub get_file_names {
    my( $dir,@argv)=@_;
    my @files;

	die "   !!! Could not use DIR: $dir [$!] !!! \n" if( !(-e $dir && -d $dir && defined($dir)) ) ;
	opendir(IMD, $dir) || die("Cannot open directory: $dir \n");
	my @thefiles=readdir(IMD);

	foreach my $f ( @thefiles ) {
		# test for '..' and '.' directories
		push @files, "$dir/$f" unless ($f =~ /^[\.]{1,2}$/ || !defined($f) || ($f =~ /\.DS_Store/) );
	}
	closedir(IMD);
	
    return \@files
}
# ================================================================================== &MAIN
# driver program
sub MAIN {	
    my @files = @{ &get_file_names( $DIR ) };
    foreach my $f (@files) {
		#print ">> FILE -- ".$f."\n";
		&twig_parse( $f );
    }
}
# =======================================================================================

&MAIN();

$DBH->disconnect;
exit;