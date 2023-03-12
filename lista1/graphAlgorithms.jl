module MyGraphAlgorithms

include("graphPrimitives.jl")
using DataStructures

export dfsOrder, dfsTree, topologicalSort, strongComponents, isBiparte

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

  for v in MyGraphPrimitives.getNeighbours(graph, vertex)
    if !visited[v - start + 1]
      temp = dfsTreePriv(graph, v, visited, start)
      push!(result, temp)
    end #if
  end #for

  return (vertex, result)
end #function

function bfsOrder(graph::R, vertex::T)::Vector{T} where {R <: MyGraphPrimitives.Graph, T <: Unsigned}
  vertices = MyGraphPrimitives.getVertices(graph)
  len = length(vertices)
  start = vertices[1]
  result::Vector{T} = []
  markedVertices = zeros(Bool, len)
  queue::Queue{T} = Queue{T}()
  push!(queue, vertex)    
  
  while !isempty(queue)
    temp = popfirst!(queue)
    if !markedVertices[temp - start + 1]
      push!(result, temp)
      markedVertices[temp - start + 1] = true
      for v in MyGraphPrimitives.getNeighbours(graph, temp)
        push!(queue, v)
      end #for
    end #if
  end #while

end #function

#=
function bfsTree(graph::R, vertex::T) where {R <: MyGraphPrimitives.Graph, T <: Unsigned}
  vertices = MyGraphPrimitives.getVertices(graph)
  len = length(vertices)
  start = vertices[1]
  result::Vector{T} = []
  markedVertices = zeros(Bool, len)
  queue::Queue{T} = Queue{T}()
  push!(queue, vertex)    
  
  while !isempty(queue)
    temp = popfirst!(queue)
    if !markedVertices[temp - start + 1]
      push!(result, temp)
      markedVertices[temp - start + 1] = true
      for v in MyGraphPrimitives.getNeighbours(graph, temp)
        push!(queue, v)
      end #for
    end #if
  end #while

end #function
=#

function topologicalSort(graph::R, vertex::T)::Union{Vector{T}, Nothing} where {R <: MyGraphPrimitives.Graph, T <: Unsigned}
  vertices = MyGraphPrimitives.getVertices(graph)
  len = length(vertices)
  start = vertices[1]
  result::Union{Vector{T}, Nothing} = []
  #0-unmarked; 1-temporary; 2-permanent
  marking = zeros(UInt8, len)
  unmarkedLeft = len

  function priv(vertex::T)::Bool #cycle found
    if marking[vertex - start + 1] == UInt(2)
      return false
    end #if
    if marking[vertex - start + 1] == UInt(1)
      result = nothing
      return true
    end #if

    marking[vertex - start + 1] = UInt(1)
    
    for v in MyGraphPrimitives.getNeighbours(graph, vertex)
      if priv(v)
        return true
      end
    end #for

    marking[vertex - start + 1] = UInt(2)
    unmarkedLeft -= 1
    push!(result, vertex)

    return false
  end #function

  index = start
  while unmarkedLeft > 0
    if priv(index)
      return nothing
    end #if
    index += 1
  end #while

  reverse!(result)

  return result
end #function

function strongComponents(graph::G) where {G <: MyGraphPrimitives.Graph}
  index = 1
  offset = MyGraphPrimitives.getVertices(graph)[1] - 1
  len = length(MyGraphPrimitives.getVertices(graph))
  stack = []
  vertexIndex = zeros(len)
  vertexLowlink = zeros(len)
  vertexOnStack = zeros(Bool, len)
  result = Set([])

  function priv(vertex)
    vertexIndex[vertex - offset] = index
    vertexLowlink[vertex - offset] = index
    index += 1
    push!(stack, vertex)
    vertexOnStack[vertex - offset] = true

    for w in MyGraphPrimitives.getNeighbours(graph, vertex)
      if vertexIndex[w - offset] == 0
        push!(result, priv(w))
        vertexLowlink[vertex - offset] = min(vertexLowlink[vertex - offset], vertexLowlink[w - offset])
      elseif vertexOnStack[w - offset]
        vertexLowlink[vertex - offset] = min(vertexLowlink[vertex - offset], vertexIndex[w - offset])
      end #if
    end #for

    if vertexLowlink[vertex - offset] == vertexIndex[vertex - offset]
      newComponent = Set()
      temp = pop!(stack)
      vertexOnStack[temp - offset] = false
      push!(newComponent, temp)
      while temp != vertex
        temp = pop!(stack)
        vertexOnStack[temp - offset] = false
        push!(newComponent, temp)
      end #while

      return newComponent
    end #if

    return Set() #This line is effectively unreachable
  end #function

  for v in MyGraphPrimitives.getVertices(graph)
    if vertexIndex[v - offset] == 0
      push!(result, priv(v))
    end #if
  end #for

  return result
end #function

function isBiparte(graph::G) where {G <: MyGraphPrimitives.Graph}
  vertices = MyGraphPrimitives.getVertices(graph)
  len = length(vertices)
  start = vertices[1]
  colorArr::Vector{Int8} = zeros(Int8, len)
  positiveColor = []
  negativeColor = []

  function priv(vertex::T, color::Int8)::Bool where T <: Unsigned
    colorArr[vertex] = color
    push!(color == 1 ? positiveColor : negativeColor, vertex)

    for v in MyGraphPrimitives.getAdjacentVertices(graph, vertex)
      if colorArr[v - start + 1] == color
        return false
      elseif colorArr[v - start + 1] == 0
        if !priv(v, -color)
          return false
        end #if
      end #if
    end #for

    return true
  end #function

  for v in vertices
    if colorArr[v] == 0
      if !priv(v, Int8(1))
        return nothing
      end #if
    end #if
  end #for

  return positiveColor, negativeColor

end #function

end #module
