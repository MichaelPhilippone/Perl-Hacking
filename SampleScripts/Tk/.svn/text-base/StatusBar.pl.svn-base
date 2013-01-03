use Tk;
use Tk::StatusBar;

my $mw = MainWindow->new;

my $Label1 = "Welcome to the statusbar";
our $Label2 = "On";
my $Progress = 0;


sub StartStop { 
	$Label2 = $Label2 eq 'On' ? 'Off' : 'On';
}
	
$mw->Button(
		-text => "Exit"
		, -command => sub{ exit(0); } 
	)->pack(
		 -anchor => 'nw'
		, -padx => 5
		, -pady => 5
		, -ipadx => 5
		, -ipady => 2
	);

$mw->Button(
		-text => "Start/Stop"
		, -command => sub{ StartStop($Label2); } 
	)->pack(
		 -anchor => 'nw'
		, -padx => 5
		, -pady => 5
		, -ipadx => 5
		, -ipady => 2
	);

$mw->Text()->pack(-expand => 1, -fill => 'both');

$sb = $mw->StatusBar();

$sb->addLabel(
	-relief         => 'flat',
	-textvariable   => \$Label1,
);

$sb->addLabel(
	-text           => 'double-click that -->',
	-width          => '20',
	-anchor         => 'center',
);

$sb->addLabel(
	-width          => 4,
	-anchor         => 'center',
	-textvariable   => \$Label2,
	-foreground     => 'blue',
	-command        => sub{ StartStop($Label2); }
	,
);

$sb->addLabel(
	-width          => 5,
	-anchor         => 'center',
	-textvariable   => \$Progress,
);

$p = $sb->addProgressBar(
	-length         => 60,
	-from           => 0,
	-to             => 100,
	-variable       => \$Progress,
);

$mw->repeat('50', sub { if ($Label2 eq 'On') { $Progress = 0 if (++$Progress > 100); } });

MainLoop();