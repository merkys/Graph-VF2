package Graph::VF2;

use strict;
use warnings;

use Graph::Undirected;

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
    my( $g1, $g2, $options ) = @_;

    die 'input graphs must be undirected'
        unless $g1->isa( Graph::Undirected:: ) && $g2->isa( Graph::Undirected:: );

    $options = {} unless $options;
    my $vertex_correspondence_sub = exists $options->{vertex_correspondence_sub}
                                         ? $options->{vertex_correspondence_sub}
                                         : sub { 1 };

    my @vertices1 = $g1->vertices;
    my %vertices1 = map { $vertices1[$_] => $_ } 0..$#vertices1;
    my @vertices2 = $g2->vertices;
    my %vertices2 = map { $vertices2[$_] => $_ } 0..$#vertices2;

    my $map = [];
    for my $vertex (@vertices1) {
        push @$map, [ map { int $vertex_correspondence_sub->($vertex, $_) } @vertices2 ];
    }

    my $correspondence =
        _vf2( \@vertices1,
              [ map { [ $vertices1{$_->[0]}, $vertices1{$_->[1]} ] } $g1->edges ],
              \@vertices2,
              [ map { [ $vertices2{$_->[0]}, $vertices2{$_->[1]} ] } $g2->edges ],
              $map );

    my @matches;
    while (@$correspondence) {
        push @matches, [ map { [ $vertices1{2 * $_}, $vertices2{2 * $_ + 1} ] } 0..$#vertices1 ];
        pop @$correspondence for 1..(2 * @vertices1);
    }

    return @matches;
}

1;
