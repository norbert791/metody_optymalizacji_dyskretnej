module MyGraph

  export DirectedGraph, SimpleGrap, getVertices, getNeighbours, addVertice!, Graph

  abstract type Graph end

  import LinearAlgebra

  function getVertices(graph::Graph)::UnitRange{Unsigned} end
  function getNeighbours(graph::Graph, vertex::Unsigned)::Vector{Unsigned} end
  function addVertice!(graph::Graph, vertice::Pair{Unsigned, Unsigned})::Graph end

  mutable struct DirectedGraph
    vertices::UnitRange{Unsigned}
    edges::Matrix{Unsigned}
    function DirectedGraph(numOfVertices::Unsigned)::SimpleGraph
      vertices = 1:numOfVertices
      edges = zeros(numOfVertices, numOfVertices)
      return new(vertices, edges)
    end #Constructor
  end #DirectedGraph 

  getVertices(graph::DirectedGraph)::UnitRange{Unsigned} = graph.vertices

  function getNeighbours(graph::DirectedGraph, vertex::Unsigned)::Vector{Unsigned}
    result::Vector{Unsigned} = []
    
    for el in 1:length(graph.vertices)
      if graph.edges[vertex, el] > 0
        push!(result, el)
      end #if
    end #for

    return result
  end #function

  function addVertice!(graph::DirectedGraph, edge::Pair{Unsigned, Unsigned})::Graph
    @boundscheck(
      if !(edge[1] in graph.vertices && edge[2] in graph.vertices)
        throw(BoundsError("Edge connects nonexistent vertices"))
      end #if
    )
    graph.edges[edge] += 1
    return graph
  end #function

  mutable struct SimmetricSparseArray{T <: Number}
    length::Unsigned
    vals::Vector{T}
    function SimmetricSparseArray{T}(numOfRows::Unsigned)::SimmetricSparseArray{T} where T <: Number
      return new(numOfRows, zeros(T, div(numOfRows * numOfRows, 2) + numOfRows))
    end
  end #function

  function get(arr::SimmetricSparseArray{T}, row::Unsigned, col::Unsigned)::T where T <: Number
    if row > col
      row, col = col, row
    end #if

    return vals[arr.length * col + row]
  end #function

  function set!(arr::SimmetricSparseArray{T}, row::Unsigned, col::Unsigned, val::T)::SimmetricSparseArray{T} where T <: Number
    if row > col
      row, col = col, row
    end #if

    arr.vals[arr.length * col + row] = val
    return arr
  end #function

  mutable struct SimpleGraph
    vertices::UnitRange{Unsigned}
    edges::SimmetricSparseArray{Unsigned}
    function SimpleGraph(numOfVertices::Unsigned)
      return new(1:numOfVertices, SimmetricSparseArray(numOfVertices))
    end #Constructor
  end #SimpleGraph

  getVertices(graph::SimpleGraph)::UnitRange{Unsigned} = graph.vertices

  function getNeighbours(graph::SimpleGraph, vertex::Unsigned)::Vector{Unsigned}
    result::Vector{Unsigned} = []
    
    for j in 1:vertex
      if get(graph, j, vertex) > 0
        push!(result, j)
      end #if
    end #for

    return result
  end #function

  function addVertice!(graph::SimpleGraph, edge::Pair{Unsigned, Unsigned})::SimpleGraph
    @boundscheck(
      if !(edge[1] in graph.vertices && edge[2] in graph.vertices)
        throw(BoundsError("Edge does not connet this graph's vertices"))
      end #if
    )
    set!(graph.edges, edge[1], edge[2], get(graph.edges, edge[1], edge[2]) + 1)

  end #function

end #module