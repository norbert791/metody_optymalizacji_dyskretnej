module MyGraphAlgorithms

include("graphPrimitives.jl")
include("myDataStructures.jl")
using DataStructures

export dijkstraAlgorithm, dialAlgorithm

@inline function dijkstraAlgorithmTemplate(graph::MyGraphPrimitives.DirectedNetwork,
                                  source::Unsigned, queueInstance,
                                  target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}

  distances = Vector{Unsigned}(_ -> typemax(Unsigned), MyGraphPrimitives.getVertices(graph))
  enqueue!(queueInstance, source, Unsigned(0))
  distances[source] = Unsigned(0)

  while !isempty(queueInstance)
    closestVertex::Unsigned = dequeue!(queueInstance)
    if !isnothing(target) && target == closestVertex
      return distances[target]
    end #if
    
    for v in MyGraphPrimitives.getNeighbours(graph, closestVertex)
      newDist::Unsigned = MyGraphPrimitives.getWeight(graph, closestVertex, v) + distances[closestVertex]
      if newDist < distances[closestVertex]
        distances[closestVertex] = newDist
      end #if
    end #for
  end #while

  return distances
  
end #dijkstraAlgorithmTemplate

function dijkstraAlgorithm(graph::MyGraphPrimitives.DirectedNetwork, source::Unsigned, target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}
  return dijkstraAlgorithmTemplate(graph, source, DataStructures.PriorityQueue{Unsigned, Unsigned}(), target)
end

function dialAlgorithm(graph::MyGraphPrimitives.DirectedNetwork, source::Unsigned, target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}
  return dijkstraAlgorithmTemplate(graph, source, MyDataStructures.BucketPriorityQueue{Unsigned}(), target)
end #module
