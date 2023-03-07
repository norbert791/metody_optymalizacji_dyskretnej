module MyGraph

abstract type Graph end

import LinearAlgebra

function getVertices(graph::Graph)::range{Unsigned}
function getNeighbours(graph::Graph, vertex::Unsigned)::Vector{Unsigned}

mutable struct DirectedGraph
  vertices::range{Unsigned} = 1:0
  edges::Matrix{Unsigned, Unsigned} = []
  function DirectedGraph(numOfVertices::Unsigned)::SimpleGraph
    vertices = 1:length
    edges = zeros(numOfVertices, numOfVertices)
    return new(vertices, edges)
  end #Constructor
end #DirectedGraph 

getVertices(graph::DirectedGraph)::range{Unsigned} = graph.vertices

function getNeighbours(graph::DirectedGraph, vertex::Unsigned)::Vector{Unsigned}
  result::Vector{Unsigned} = []
  
  for el in 1:length(graph.vertices)
    if graph.edges[vertex, el] > 0
      push!(result, el)
    end #if
  end #for

  return result
end

mutable struct SimmetricSparseArray{T}
  length::Unsigned
  vals::Vector{T}
  function SimmetricSparseArray(numOfRows::Unsigned)::SimmetricSparseArray{T}
    return new(numOfRows, zeros(T, div(numOfRows * numOfRows, 2) + numOfRows))
  end
end #SimmetricSparseArray

function get(arr::SimmetricSparseArray{T}, row::Unsigned, col::Unsigned)::T
  if row > col
    row, col = col, row
  end #if

  return vals[arr.length * col + row]
end #function

function set!(arr::SimmetricSparseArray{T}, row::Unsigned, col::Unsigned, val::T)::SimmetricSparseArray{T}
  len = length(arr.vals)
  if row > col
    row, col = col, row
  end #if

  arr.vals[len * col + row] = val
  return arr
end #function

mutable struct SimpleGraph
  vertices::range{Unsigned} = 1:0
  edges::SimmetricSparseArray{Unsigned}
  function SimpleGraph(numOfVertices::Unsigned)
    return new(1:numOfVertices, SimmetricSparseArray(numOfVertices))
  end #Constructor
end #SimpleGraph

function getNeighbours(graph::SimpleGraph, vertex::Unsigned)::Vector{Unsigned}
  result::Vector{Unsigned} = []
  
  for j in 1:vertex
    if get(graph, j, vertex) > 0
      push!(result, j)
    end #if
  end #for

  return result
end #function


end #module