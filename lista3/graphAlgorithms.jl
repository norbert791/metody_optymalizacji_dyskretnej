module MyGraphAlgorithms

include("graphPrimitives.jl")
include("myDataStructures.jl")
using .MyDataStructures

import .MyGraphPrimitives, ArgParse
export dijkstraAlgorithm, dialAlgorithm, radixHeapAlgorithm, loadNetwork, runForAlgorithm

@inline function dijkstraAlgorithmTemplate(graph::MyGraphPrimitives.DirectedNetwork,
                                  source::Unsigned, queueInstance,
                                  target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}

  distances::Vector{Unsigned} = map(_ -> typemax(UInt64), MyGraphPrimitives.getVertices(graph))
  enqueue!(queueInstance, source, Unsigned(0))
  distances[source] = Unsigned(0)

  while !MyDataStructures.isempty(queueInstance)
    closestVertex::Unsigned = MyDataStructures.dequeue!(queueInstance)
    if !isnothing(target) && target == closestVertex
      return distances[target]
    end #if
    
    for v in MyGraphPrimitives.getNeighbours(graph, closestVertex)
      newDist::Unsigned = MyGraphPrimitives.getWeight(graph, closestVertex, v) + distances[closestVertex]
      if newDist < distances[v]
        distances[v] = newDist
        MyDataStructures.enqueue!(queueInstance, v, newDist)
      end #if
    end #for
  end #while

  return distances
  
end #dijkstraAlgorithmTemplate

function dijkstraAlgorithm(graph::MyGraphPrimitives.DirectedNetwork, source::Unsigned, target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}
  return dijkstraAlgorithmTemplate(graph, source, MyDataStructures.PriorityQueueProxy{Unsigned, Unsigned}(), target)
end #dijkstraAlgorithm

function dialAlgorithm(graph::MyGraphPrimitives.DirectedNetwork, source::Unsigned, target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}
  wages = map(p -> p[2], graph.costs)
  return dijkstraAlgorithmTemplate(graph, source, MyDataStructures.BucketPriorityQueue{Unsigned}(findmax(wages)[1]), target)
end #dialAlgorithm

function radixHeapAlgorithm(graph::MyGraphPrimitives.DirectedNetwork, source::Unsigned, target::Union{Nothing, Unsigned} = nothing)::Union{Unsigned, Vector{Unsigned}}
  return dijkstraAlgorithmTemplate(graph, source, MyDataStructures.RadixHeap{Unsigned, UInt64}(), target)
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

#
# UTILITI FUNCTIONS
#

function loadNetwork(filename::String)::MyGraphPrimitives.DirectedNetwork
  result::MyGraphPrimitives.DirectedNetwork = MyGraphPrimitives.DirectedNetwork(Unsigned(1))
  nameRegex = r"p .* ([0-9]+) ([0-9]+)"
  arcRegex = r"a ([0-9]+) ([0-9]+) ([0-9]+)"

  open(filename) do file
    for line in readlines(file)
      if line[1] == 'c'
        continue
      end #if
      temp = match(nameRegex, line)
      if !isnothing(temp)      
        networkSize = Unsigned(parse(UInt64, temp.captures[1]))
        result = MyGraphPrimitives.DirectedNetwork(networkSize)
        continue
      end #if
      temp = match(arcRegex, line)
      if !isnothing(temp)
        p(u) = Unsigned(parse(UInt64, u))
        MyGraphPrimitives.addEdge!(result, (p(temp.captures[1]), p(temp.captures[2])), p(temp.captures[3]))
      end #if
    end #for
  end

  return result
end

function loadSources(filename::String)::Vector{Unsigned}
  sourceRegex = r"s ([0-9]+)"
  result = Vector{Unsigned}()

  open(filename) do file
    for line in readlines(file)
      if line[1] != 's'
        continue
      end #if
      temp = match(sourceRegex, line)
      if !isnothing(temp)
        push!(result, parse(UInt64, temp.captures[1]))
      end #if
    end #for
  end #open

  return result
end

function loadPairs(filename::String)::Vector{Tuple{Unsigned, Unsigned}}
  sourceRegex = r"q ([0-9]+) ([0-9]+)"
  result = Vector{Tuple{Unsigned, Unsigned}}()

  open(filename) do file
    for line in readlines(file)
      if line[1] != 'q'
        continue
      end #if
      temp = match(sourceRegex, line)
      if !isnothing(temp)
        push!(result, (Unsigned(parse(UInt64, temp.captures[1])), Unsigned(parse(UInt64, temp.captures[2]))))
      end #if
    end #for
  end #open

  return result
end

function parseCommandLine()
  s = ArgParse.ArgParseSettings()

  ArgParse.@add_arg_table s begin
    "--d"
      help = "network file dir"
    "--ss"
      help = "sources file dir"
      default = ""
    "--oss"
      help = "output (for sources) file dir"
      default = ""
    "--p2p"
      help = "pairs file dir"
      default = ""
    "--op2p"
      help = "output (for pairs) dir"
      default = ""
  end

  return ArgParse.parse_args(s)
end

function writeResultForSources(outputDir::String, networkDir::String, sourcesDir::String,
                               network::MyGraphPrimitives.DirectedNetwork, algName::String, avgTime)
  open(outputDir, "w") do file
    write(file, "p res sp ss $algName\n")
    write(file, "f $networkDir $sourcesDir\n")
    numOfVertices = length(MyGraphPrimitives.getVertices(network))
    numOfEdges = length(network.costs)
    costs = map(x -> x, values(network.costs))
    minCost = min(costs...)
    maxCost = max(costs...)
    write(file, "g $numOfVertices $numOfEdges $minCost $maxCost\n")
    write(file, "t $avgTime\n")
  end #open
end #writeResultForSources

function writeResultForPairs(outputDir::String, networkDir::String, sourcesDir::String,
  network::MyGraphPrimitives.DirectedNetwork, algName::String, results)

  open(outputDir, "w") do file
    write(file, "p res sp ss $algName\n")
    write(file, "f $networkDir $sourcesDir\n")
    numOfVertices = length(MyGraphPrimitives.getVertices(network))
    numOfEdges = length(network.costs)
    costs = map(x -> x, values(network.costs))
    minCost = min(costs...)
    maxCost = max(costs...)
    write(file, "g $numOfVertices $numOfEdges $minCost $maxCost\n")
    
    for x in results
      write(file, "d $(x[1]) $(x[2]) $(x[3])\n")
    end #for
  end #open
end #writeResultForPairs

function runForAlgorithm(algorithm::Function, algorithmName::String)
  parsedArgs = parseCommandLine()
  network = loadNetwork(parsedArgs["d"])
  sources = nothing
  pairs = nothing
  output = ""

  if parsedArgs["ss"] != ""
    sources = loadSources(parsedArgs["ss"])
    output = parsedArgs["oss"]
    @assert output != "" "-oss arg requiered for ss arg"
  end #if

  if parsedArgs["p2p"] != ""
    pairs = loadPairs(parsedArgs["p2p"])
    output = parsedArgs["op2p"]
    @assert output != "" "-op2p arg requiered for p2p arg"
  end #if

  if !isnothing(sources)
    times = []
    for s in sources
      t = @elapsed algorithm(network, s)
      push!(times, t)
    end #for
    result = sum(times) / length(times)
    writeResultForSources(output, parsedArgs["d"], parsedArgs["ss"], network, algorithmName, result)      
    return
  end #if

  if !isnothing(pairs)
    result = []

    for p in pairs
      println("Running for $p")
      r = algorithm(network, p[1], p[2])
      push!(result, (p[1], p[2], r))
    end #for
    
    writeResultForPairs(output, parsedArgs["d"], parsedArgs["p2p"], network, algorithmName, result)
    return
  end #if

  println("Neither -ss nor -p2p specified")
end #createProgram

end #module
