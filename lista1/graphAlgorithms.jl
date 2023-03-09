module MyGraphAlgorithms
  include("graphPrimitives.jl")
  import .MyGraphPrimitives
  using DataStructures

  export dfsOrder

  function dfsOrder(graph::R, vertex::T)::Vector{T} where {R <: MyGraphPrimitives.Graph, T <: Unsigned}
    vertices = getVertices(graph)
    length = length(vertices)
    start = vertices[1]
    result::Vector{T} = zeros(T, length)
    markedVertices = zeros(Bool, length)
    stack::Stack{T} = Stack{T}()

    push!(stack, vertex)
    while length(stack) > 0
      temp = pop!(stack)
      if markedVertices[temp - start  + 1]
        markedVertices[temp - start + 1] = true
        push!(result, temp)
        for neighbour in MyGraphPrimitives.getNeighbours(graph, temp)
          push!(stack, neighbour)
        end #for
      end #if
    end #while

    return resultes
  end #function

end #module
