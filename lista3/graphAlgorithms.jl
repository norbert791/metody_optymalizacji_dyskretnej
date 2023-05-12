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
end #dijkstraAlgorithm

function dialAlgorithm(graph::MyGraphPrimitives.DirectedNetwork, source::Unsigned, target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}
  wages = map(p -> p[2], graph.costs)
  return dijkstraAlgorithmTemplate(graph, source, MyDataStructures.BucketPriorityQueue{Unsigned}(findmax(wages)[1]), target)
end #dialAlgorithm

function radixHeapAlgorithm(graph::MyGraphPrimitives.DirectedNetwork, source::Unsigned, target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}
  return dijkstraAlgorithmTemplate(graph, source, MyDataStructures.RadixHeap{Unsigned, UInt64}, target)
end #radixHeapAlgorithm

function loadNetwork(filename::String)::DirectedNetwork
  result::DirectedNetwork = DirectedNetwork(1)
  nameRegex = r"p .* ([0-9]+) ([0-9]+)"
  arcRegex = r"a ([0-9]+) ([0-9]+) ([0-9]+)"

  open(filename) do file
    for line in file
      if line[1] == 'c'
        continue
      end #if
      temp = match(nameRegex, line)
      if !isnothing(temp)      
        networkSize = parse(Unsigned, temp.captures[1])
        result = DirectedNetwork(networkSize)
        continue
      end #if
      temp = match(arcRegex, line)
      if !isnothing(temp)
        p(u) = parse(Unsigned, u)
        addEdge!(result, (p(temp.captures[1]), p(temp.captures[2])), p(temp.captures[3]))
      end #if
    end #for
  end

  return result
end

function loadSources(filename::String)::Vector{Unsigned}
  sourceRegex = r"s ([0-9]+)"
  result = Vector{Unsigned}()

  open(filename) do file
    for line in file
      temp = match(sourceRegex, line)
      if !isnothing(temp)
        push!(result, parse(Unsigned, temp.captures[1]))
      end #if
    end #for
  end #open

  return result
end

function loadPairs(filename::String)::Vector{Tuple{Unsigned, Unsigned}}
  sourceRegex = r"p ([0-9]+) ([0-9]+)"
  result = Vector{Tuple{Unsigned, Unsigned}}()

  open(filename) do file
    for line in file
      temp = match(sourceRegex, line)
      if !isnothing(temp)
        push!(result, (parse(Unsigned, temp.captures[1]), parse(Unsigned, temp.captures[2])))
      end #if
    end #for
  end #open

  return result
end

end #module
