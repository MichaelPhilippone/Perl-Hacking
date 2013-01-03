# ##################################################################
#	Practice with Perl/Tk components
# ##################################################################
# See:
# 	http://oreilly.com/catalog/lperltk/chapter/ch02.html
# ##################################################################
#

use strict;
use warnings;
use Tk;

# for users who enable Taint Mode:
$ENV{'PATH'} = 'c:\\Windows\\system32\\';

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

sub MakeCanvasRect {
	my ($mw , $size , $step , @argv ) = @_;
	
	# Create and configure the canvas:
	my $canvas = $mw->Canvas( 
						-cursor=>"crosshair"
						, -background=>"white"
						, -width=>$size/2
						, -height=>$size/2 
					)->pack;

	# Place objects on canvas:
	$canvas->createRectangle( $step, $step, $size-$step, $size-$step, -fill=>"red" );

	for( my $i=$step; $i<$size-$step; $i+=$step ) {
		my $val = 255*$i/$size;
		my $color = sprintf( "#%02x%02x%02x", $val, $val, $val );
		$canvas->createRectangle( $i, $i, $i+$step, $i+$step, -fill=>$color );
	}
	
	# prints the cursor (x,y) coords on mouse-click
	$canvas->Tk::bind( "<Button-1>", [ sub { print "$_[1] $_[2]\n"; } , Ev('x'), Ev('y') ] );

	# $canvas->postscript( -file=>"file_name.ps" );
}

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

sub MakeGUI { 
	my (@argv) = @_;
	$\="\n";
	my $lbl;
	my $promptLbl = "Choose a rejection log to parse: ";
	my $window = MainWindow->new;
	my $file = '';
	my $delTmps = 0;
	
	my ( $size, $step , $xResize , $yResize) = ( 450 , 10 , 1 , 1);

	$window->configure( -width=>$size , -height=>$size );
	$window->resizable( $xResize , $yResize ); # resizable in both directions
	
	$lbl = $window->Label(-text => $promptLbl)->pack;
	
	#$window->Entry(-textvariable => \$promptLbl )->pack;
	$window->Label( -text => "Using the buttons below, select a file to parse for DLN numbers" )->pack;
	
	$window->Checkbutton(
				-text => "Delete Temp Files" 
				, -command => sub{ print "Del Tmps" . ($delTmps = !$delTmps) . "\n"; } 
			)->pack;
			
	$window->Button(-text => "Choose File", -command => sub{ $file = open_log( $window ); print "FILE: $file";} )->pack;
	$window->Button(
				-text => "Get DLNs from Rejection Log" , 
				-command => sub{ 
								SearchDLN( 
									RemoveRejectedRecords( $file , 1 , 1) 
									, 1 
								);
							} 
				)->pack;
	$window->Button(
				-text => "Exit"
				, -command => sub{ exit(0); } 
			)->pack(
				-expand => 1
				, -fill => 'x'
				, -padx => 15
				, -pady => 15
			);

	MakeCanvasRect($window, $size ,$step);
			
	MainLoop;
}


__END__

Pack Options

-side => 'left' | 'right' | 'top' | 'bottom'
	Puts the widget against the specified side of the window or frame

-fill => 'none' | 'x' | 'y'| 'both'
	Causes the widget to fill the allocation rectangle in the specified direction

-expand => 1 | 0
	Causes the allocation rectangle to fill the remaining space available in the window or frame

-anchor => 'n' | 'ne' | 'e' | 'se' | 's' | 'sw' | 'w' | 'nw' | 'center'
	Anchors the widget inside the allocation rectangle
	
-after => $otherwidget
	Puts $widget after $otherwidget in packing order
	
-before => $otherwidget
	Puts $widget before $otherwidget in packing order
	
-in => $otherwindow
	Packs $widget inside of $otherwindow rather than the parent of $widget, which is the default
	
-ipadx => amount
	Increases the size of the widget horizontally by amount ? 2

-ipady => amount
	Increases the size of the widget vertically by amount ? 2

-padx => amount
	Places padding on the left and right of the widget
	
-pady => amount
	Places padding on the top and bottom of the widget
	