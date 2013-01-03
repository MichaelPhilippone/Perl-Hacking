use strict;
use warnings;

use GraphViz2;
use Log::Handler;

# --------------------------------------------------
my $logger = Log::Handler->new();
$logger-> add(
    screen => {
	maxlevel => 'debug' ,
	message_layout => "\t>> %m" ,
	minlevel => 'error' ,
    });
# --------------------------------------------------

my $g = GraphViz2->new(
    edge   => {color => 'red'},
    global => {
	directed => 0,
	format =>'png',
        #record_orientation => 'horizontal',
        record_orientation => 'vertical',
        record_shape =>'Mrecord',
    },
    graph  => {
	label => 'MY_GRAPH', 
	rankdir => 'TB' , 
        #color =>'blue',
    },
    logger => $logger,
    node   => {shape => 'square'},
    );

# build the graph and build some links
my $len=5;
foreach my $i (0..$len) {
    $g->add_node(name =>"$i");
}
foreach my $i (0..$len) {
    my $to=($i==$len)?(0):($i+1);
    $g->add_edge(from =>"$i", to =>"$to", label =>"$i-to-$to" );
}

# try a nested node set
$g->add_node(name => 'arr', label => ['a','b','c'] );
$g->add_edge(from =>"3", to =>"arr");

# do a sub-graph
$g->push_subgraph (
    name =>'sub1' ,
    graph => { 
         label =>'child',
         #color =>'red',
    } ,
    node =>{color => 'purple' , shape =>'diamond'}
    );
foreach my $i (0..$len) {
    $g->add_node(name =>"sub$i" , shape => (($i%2)?('hexagon'):('oval')) );
}
foreach my $i (0..$len) {
    my $to=($i==$len)?(0):($i+1);
    $g->add_edge(from =>"sub$i", to =>"sub$to" );
}
$g-> pop_subgraph;

# connect sub_graph to main graph
$g->add_edge(from =>"2", to =>'sub1');

$g->run(format =>'png' , output_file =>'graph2.png');
