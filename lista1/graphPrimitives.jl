module MyGraphPrimitives

export DirectedGraph, SimpleGraph, SparseDirectedGraph, SparseSimpleGraph, getVertices, getNeighbours, addEdge!, Graph

abstract type Graph end

import LinearAlgebra

function getVertices(graph::Graph)::UnitRange{T} end
function getNeighbours(graph::Graph, vertex::T)::Vector{T} where T <: Unsigned end
function addEdge!(graph::Graph, vertice::Tuple{T, T})::Graph where T <: Unsigned end

mutable struct DirectedGraph{T <: Unsigned} <: Graph
  vertices::UnitRange{T}
  edges::Matrix{T}
  function DirectedGraph{T}(numOfVertices::T)::DirectedGraph{T} where T <: Unsigned
    vertices = 1:numOfVertices
    edges = zeros(numOfVertices, numOfVertices)
    return new(vertices, edges)
  end #Constructor
end #DirectedGraph 

function getVertices(graph::DirectedGraph{T})::UnitRange{T} where T <: Unsigned
  return graph.vertices
end

function getNeighbours(graph::DirectedGraph{T}, vertex::T)::Vector{T} where T <: Unsigned
  result::Vector{Unsigned} = []
  
  for el in 1:length(graph.vertices)
    if graph.edges[vertex, el] > 0
      push!(result, el)
    end #if
  end #for

  return result
end #function

function addEdge!(graph::DirectedGraph{T}, edge::Tuple{T, T})::DirectedGraph{T} where T <: Unsigned
  @boundscheck(
    if !(edge[1] in graph.vertices && edge[2] in graph.vertices)
      throw(BoundsError("Edge connects nonexistent vertices"))
    end #if
  )
  graph.edges[edge[1], edge[2]] += 1
  return graph
end #function

mutable struct SimmetricSparseArray{T <: Number, W <: Unsigned}
  length::W
  vals::Vector{T}
  function SimmetricSparseArray{T, W}(numOfRows::W)::SimmetricSparseArray{T} where T <: Number where W <: Unsigned
    return new{T, W}(numOfRows, zeros(T, div(numOfRows * numOfRows, 2) + numOfRows))
  end
end #function

function get(arr::SimmetricSparseArray{T, W}, row::T, col::T)::T where T <: Number where W <: Unsigned
  if row > col
    row, col = col, row
  end #if

  #1 -> 1:10
  #2 -> 11:19
  #3 -> 20:27
  #4 -> 28:34
  
  offset::T = (arr.length + 1) * (row - 1) - (row * (row - 1)) / 2 

  return arr.vals[offset + col - row + 1]
end #function

function set!(arr::SimmetricSparseArray{T, W}, row::T, col::T, val::T)::SimmetricSparseArray{T} where T <: Number where W <: Unsigned
  if row > col
    row, col = col, row
  end #if

  #1 -> 1:10
  #2 -> 11:19
  #3 -> 20:27
  #4 -> 28:34

  #(a + (a + 2 - i)) / 2 * (i - 1) == (2a + 2 - i) / 2 * (i - 1) == (a + 1)(i - 1) - i(i - 1)/2
  offset::T = (arr.length + 1) * (row - 1) - (row * (row - 1)) / 2 
  arr.vals[offset + col - row + 1] = val
  
  return arr
end #function

mutable struct SimpleGraph{T <: Unsigned} <: Graph
  vertices::UnitRange{T}
  edges::SimmetricSparseArray{T, T}
  function SimpleGraph{T}(numOfVertices::T)::SimpleGraph{T} where T <: Unsigned
    return new{T}(1:numOfVertices, SimmetricSparseArray{T, T}(numOfVertices))
  end #Constructor
end #SimpleGraph

getVertices(graph::SimpleGraph)::UnitRange{Unsigned} = graph.vertices

function getNeighbours(graph::SimpleGraph, vertex::Unsigned)::Vector{Unsigned}
  result::Vector{Unsigned} = []
  
  for j in graph.vertices
    if get(graph.edges, j, vertex) > 0
      push!(result, j)
    end #if
  end #for

  return result
end #function

function addEdge!(graph::SimpleGraph, edge::Tuple{T, T})::SimpleGraph where T <: Unsigned
  @boundscheck(
    if !(edge[1] in graph.vertices && edge[2] in graph.vertices)
      throw(BoundsError("Edge does not connet this graph's vertices"))
    end #if
  )
  set!(graph.edges, edge[1], edge[2], get(graph.edges, edge[1], edge[2]) + 1)
  
  return graph
end #function

mutable struct SparseDirectedGraph{T <: Unsigned} <: Graph
  vertices::UnitRange{T}
  edges::Vector{Vector{Unsigned}}

  function SparseDirectedGraph{T}(numOfVertices::T)::SparseDirectedGraph{T} where T <: Unsigned
    vertices = 1:numOfVertices
    edges = [[] for _ in vertices]
    return new(vertices, edges)
  end #Constructor
end #struct

function getVertices(graph::SparseDirectedGraph{T})::UnitRange{T} where T <: Unsigned
  return graph.vertices
end #function

function getNeighbours(graph::SparseDirectedGraph{T}, vertex::T)::Vector{T} where T <: Unsigned
  return graph.edges[vertex - graph.vertices[1] + 1]
end #function

function addEdge!(graph::SparseDirectedGraph{T}, edge::Tuple{T, T})::SparseDirectedGraph{T} where T <: Unsigned
  if edge[2] in graph.edges[edge[1] - graph.vertices[1] + 1]
    return graph
  end #if
    push!(graph.edges[edge[1] - graph.vertices[1] + 1], edge[2])
    sort!(graph.edges[edge[1] - graph.vertices[1] + 1])
  return graph
end #function

mutable struct SparseSimpleGraph{T <: Unsigned} <: Graph
  vertices::UnitRange{T}
  edges::Vector{Vector{Unsigned}}

  function SparseSimpleGraph{T}(numOfVertices::T)::SparseSimpleGraph{T} where T <: Unsigned
    vertices = 1:numOfVertices
    edges = [[] for _ in vertices]
    return new(vertices, edges)
  end #Constructor

end #struct

function getVertices(graph::SparseSimpleGraph{T})::UnitRange{T} where T <: Unsigned
  return graph.vertices
end #function

function getNeighbours(graph::SparseSimpleGraph{T}, vertex::T)::Vector{T} where T <: Unsigned
  return graph.edges[vertex - graph.vertices[1] + 1]
end #function

function addEdge!(graph::SparseSimpleGraph{T}, edge::Tuple{T, T})::SparseSimpleGraph{T} where T <: Unsigned
  if !(edge[2] in graph.edges[edge[1] - graph.vertices[1] + 1])
    push!(graph.edges[edge[1] - graph.vertices[1] + 1], edge[2])
    sort!(graph.edges[edge[1] - graph.vertices[1] + 1])
  end #if

  if !(edge[1] in graph.edges[edge[2] - graph.vertices[1] + 1])
    push!(graph.edges[edge[2] - graph.vertices[1] + 1], edge[1])
    sort!(graph.edges[edge[2] - graph.vertices[1] + 1]) 
  end #if

  return graph
end #function

end #module
