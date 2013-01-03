use strict;
use warnings;

use GraphViz2;
use GraphViz::Data::Grapher;
use Log::Handler;

my $g;
my $struct = {
    a => [ 1, 2, 3 ],
    b => [
        { X => 1, Y => 2 },
        {
            X => [ 1, 2, 3 ],
            Y => [ 4, 5, 6 ],
            Z => [ 7, 8, 9 ]
        },
    ],
};

my $logger = Log::Handler->new();
$logger-> add(
    screen => {
	maxlevel => 'debud' ,
	message_layout => 'm%' ,
	minlevel => 'error' ,
    });

$g = GraphViz::Data::Grapher->new($struct);
print $g->as_png("graph.png");

# --------------------------------------------------

$g = GraphViz2->new(
    edge   => {color => 'grey'},
    global => {directed => 1},
    graph  => {label => 'Adult', rankdir => 'TB'},
    logger => $logger,
    node   => {shape => 'oval'},
    );

$g->add_node(name =>'1', shape=>'oval');
$g->add_node(name =>'2', shape=>'oval');
$g->add_node(name =>'3', shape=>'oval');

$g->add_edge(from =>'1', to =>'2', arrowsize =>'2', color =>'blue');
$g->add_edge(from =>'2', to =>'3');
$g->add_edge(from =>'3', to =>'1');

$g->run(format =>'png' , output_file =>'graph2.png');
