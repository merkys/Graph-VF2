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

    my @vertices1 = $g1->vertices;
    my %vertices1 = map { $vertices1[$_] => $_ } 0..$#vertices1;
    my @vertices2 = $g2->vertices;
    my %vertices2 = map { $vertices2[$_] => $_ } 0..$#vertices2;

    _vf2( \@vertices1,
          [ map { [ $vertices1{$_->[0]}, $vertices1{$_->[1]} ] } $g1->edges ],
          \@vertices2,
          [ map { [ $vertices2{$_->[0]}, $vertices2{$_->[1]} ] } $g2->edges ] );
}

1;
