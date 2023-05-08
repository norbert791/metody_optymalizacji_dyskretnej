#ifndef DIRECTED_NEIGHBOUR_LIST_GRAPH
#define DIRECTED_NEIGHBOUR_LIST_GRAPH

#include <unordered_map>
#include "IGraph.hpp"

namespace Graph {
  class DirectedGraphNeighbourList : public IDirectedGraph {
    public:
      inline DirectedGraphNeighbourList(unsigned lowerBound, unsigned UpperBound) :
        lowerBound{lowerBound}, upperBound{upperBound} {};

      virtual std::vector<unsigned> getVertices() override;
      virtual std::vector<unsigned> getNeighbours(unsigned vertex) override;
    private:
      const unsigned lowerBound = 0;
      const unsigned upperBound = 0;
      std::unordered_map<unsigned, std::vector<unsigned>> neighbours{};
  };
};


#endif //DIRECTED_NEIGHBOUR_LIST_GRAPH
