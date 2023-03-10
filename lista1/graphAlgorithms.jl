module MyGraphAlgorithms

include("graphPrimitives.jl")
using DataStructures

export dfsOrder, dfsTree

function dfsOrder(graph::R, vertex::T)::Vector{T} where {R <: MyGraphPrimitives.Graph, T <: Unsigned}
  vertices = MyGraphPrimitives.getVertices(graph)
  len = length(vertices)
  start = vertices[1]
  result::Vector{T} = []
  markedVertices = zeros(Bool, len)
  stack::Stack{T} = Stack{T}()

  push!(stack, vertex)
  while length(stack) > 0
    temp = pop!(stack)
    if !markedVertices[temp - start  + 1]
      markedVertices[temp - start + 1] = true
      push!(result, temp)
      for neighbour in MyGraphPrimitives.getNeighbours(graph, temp)
        push!(stack, neighbour)
      end #for
    end #if
  end #while

  return result
end #function

function dfsTree(graph::R, vertex::T) where {R <: MyGraphPrimitives.Graph, T <: Unsigned}
  vertices = MyGraphPrimitives.getVertices(graph)
  len = length(vertices)
  start = vertices[1]
  markedVertices = zeros(Bool, len)

  return dfsTreePriv(graph, vertex, markedVertices, start)
end #function

function dfsTreePriv(graph::R, vertex::T, visited::Vector{Bool}, start::T) where {R <: MyGraphPrimitives.Graph, T <: Unsigned}
  result = []
  visited[vertex - start + 1] = true
  #println(MyGraphPrimitives.getNeighbours(graph, vertex))
  #println(vertex)
  for v in MyGraphPrimitives.getNeighbours(graph, vertex)
    if !visited[v - start + 1]
      temp = dfsTreePriv(graph, v, visited, start)
      push!(result, temp)
    end #if
  end #for

  return (vertex, result)
end #function

end #module
