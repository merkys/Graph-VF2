namespace boost {

  template <typename Graph1,
            typename Graph2>
  struct print_callback {

    print_callback(const Graph1& graph1, const Graph2& graph2, std::vector<int>& correspondence)
      : graph1_(graph1), graph2_(graph2), correspondence_(correspondence) {}

    template <typename CorrespondenceMap1To2,
              typename CorrespondenceMap2To1>
    bool operator()(CorrespondenceMap1To2 f, CorrespondenceMap2To1) const {
        BGL_FORALL_VERTICES_T(v, graph1_, Graph1) {
            correspondence_.push_back( get(vertex_index_t(), graph1_, v) );
            correspondence_.push_back( get(vertex_index_t(), graph2_, get(f, v)) );
        }

        return true;
    }
    
    private:
        const Graph1& graph1_;
        const Graph2& graph2_;
        std::vector<int>& correspondence_;
  };
}
