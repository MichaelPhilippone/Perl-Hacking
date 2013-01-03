use strict;
use warnings;

use GraphViz::Data::Grapher;

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

$g = GraphViz::Data::Grapher->new($struct);
print $g->as_png("graph.png");

# --------------------------------------------------
