#ifndef GRAPH_HPP
#define GRAPH_HPP

#include <vector>

namespace Graph {
  class IDirectedGraph {
    public:
      virtual std::vector<unsigned> getNeighbours(unsigned vertex) = 0;
      virtual std::vector<unsigned> getVertices() = 0;

      virtual ~IDirectedGraph() = default;
  };

};

#endif //GRAPH_HPP