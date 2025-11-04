package Graph::VF2;

use strict;
use warnings;

require Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw(
    vf2
);

# ABSTRACT: VF2 method for Perl Graph
# VERSION

require XSLoader;
XSLoader::load('Graph::VF2', $VERSION);

sub vf2
{
    my( $g1, $g2 ) = @_;
    _vf2( [ $g1->vertices ], [ $g1->edges ], [ $g2->vertices ], [ $g2->edges ] );
}

1;
