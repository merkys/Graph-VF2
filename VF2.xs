#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/vf2_sub_graph_iso.hpp>

#include "VF2.hpp"

using namespace boost;

#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Graph::VF2		PACKAGE = Graph::VF2

SV *
_vf2(vertices1, edges1, vertices2, edges2)
        SV * vertices1
        SV * edges1
        SV * vertices2
        SV * edges2
    CODE:
        typedef adjacency_list< setS, vecS, undirectedS > graph_type;

        // Build graph1
        int num_vertices1 = av_top_index((AV*) SvRV(vertices1)) + 1;
        graph_type graph1(num_vertices1);
        for (ssize_t i = 0; i <= av_top_index((AV*) SvRV(edges1)); i++) {
            AV * edge = (AV*) SvRV( av_fetch( (AV*) SvRV(edges1), i, 0 )[0] );
            add_edge( SvIV( av_fetch( edge, 0, 0 )[0] ),
                      SvIV( av_fetch( edge, 1, 0 )[0] ), graph1 );
        }

        // Build graph2
        int num_vertices2 = av_top_index((AV*) SvRV(vertices2)) + 1;
        graph_type graph2(num_vertices2);
        for (ssize_t i = 0; i <= av_top_index((AV*) SvRV(edges2)); i++) {
            AV * edge = (AV*) SvRV( av_fetch( (AV*) SvRV(edges2), i, 0 )[0] );
            add_edge( SvIV( av_fetch( edge, 0, 0 )[0] ),
                      SvIV( av_fetch( edge, 1, 0 )[0] ), graph2 );
        }

        std::vector<int> correspondence;

        // Create callback to print mappings
        print_callback< graph_type, graph_type > callback(graph1, graph2, correspondence);

        // Print out all subgraph isomorphism mappings between graph1 and graph2.
        // Vertices and edges are assumed to be always equivalent.
        vf2_subgraph_iso(graph1, graph2, callback);

        AV* map = newAV();

        for (int n : correspondence)
            av_push( map, newSViv( n ) );

        RETVAL = newRV_noinc( (SV*)map );
    OUTPUT:
        RETVAL
