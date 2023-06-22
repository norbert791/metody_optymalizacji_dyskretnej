module HypercubeGraph

import DataStructures

using StatsBase, JuMP, GLPK, HiGHS

export Hypercube, setEdgeWeight!, getEdgeWeight, getNeighbours, getReverseNeighbours, getAdjacentVertices, DinicAlgorithm, getHyperCubeModel,
  bestFirstSearch, EdmondsKarp, hammingDistance, hammingWeight, randomHyperCube, printHypercube, randomBiparteGraph, printBiparteGraph, getBiparteGraphModel

mutable struct Hypercube
  size::UInt8
  # Index of edge v -> w is requal to v's value appended by the pos of bit
  # that remains set after v xor w
  capacity::Vector{UInt16}

  function Hypercube(size::Integer)
    if size < 1 || size > 16
      throw(error("incorrect size"))
    end #if
    return new(UInt8(size), zeros(2^(size) << UInt16(ceil(log2(size)))))
  end #Hypercube

end #Hypercube

@inline function hammingDistance(left::UInt16, right::UInt16)::UInt16

  xored = xor(left, right)
  counter::UInt16 = UInt16(0)

  while xored > 0
    counter += xored & 1
    xored = xored >> 1
  end #while 

  return counter
end #hammingDistance

@inline hammingWeight(number::UInt16) = hammingDistance(number, UInt16(0))

@inline function computeIndex(cube::Hypercube, from::UInt16, to::UInt16)::UInt32

  index = 1
  counter::UInt32 = UInt32(0)

  while (from & index) == (to & index)
    counter += 1
    index = index << 1
  end #while

  counter += from << UInt(ceil(log2(cube.size)))

  return counter + 1
end #computeIndex

function setEdgeWeight!(cube::Hypercube, from::UInt16, to::UInt16, weight::UInt32)
  if weight > typemax(UInt16) + 1
    throw(error("Incorrect weight"))
  end #if

  @boundscheck if from > 2^cube.size - 1 || to > 2^cube.size - 1
    throw(error("Edge does not exist"))
  end

  @boundscheck if hammingDistance(from, to) != 1
    throw(error("Edge does not exist"))
  end #if

  index = computeIndex(cube, from, to)

  #We are mapping vals from 1..2^16 to 0..2^16 - 1
  cube.capacity[index] = UInt16(weight - 1)
end #setEdgeWeight!

function getEdgeWeight(cube::Hypercube, from::UInt16, to::UInt16)::UInt32
  @boundscheck if from > 2^cube.size - 1 || to > 2^cube.size - 1
    throw(error("Edge does not exist"))
  end #if

  if hammingDistance(from, to) != 1
    return UInt32(0)
  end #if

  if hammingWeight(from) > hammingWeight(to)
    return UInt32(0)
  end #if

  return UInt32(cube.capacity[computeIndex(cube, from, to)]) + UInt32(1)
end #getEdgeWeight

@inline function getNeighbours(cube::Hypercube, vertex::UInt16)::Vector{UInt16}
  result::Vector{UInt16} = []
  index::UInt16 = 2^(cube.size - 1)

  while index > 0
    if vertex & index == 0
      push!(result, vertex | index)
    end #if
    index >>= 1
  end #while

  return result
end #getNeighbours

@inline function getReverseNeighbours(cube::Hypercube, vertex::UInt16)::Vector{UInt16}
  result::Vector{UInt16} = []
  index::UInt16 = 2^(cube.size - 1)

  while index > 0
    if vertex & index != 0
      push!(result, vertex & ~index)
    end #if
    index >>= 1
  end #while

  return result
end

@inline function getAdjacentVertices(cube::Hypercube, vertex::UInt16)::Vector{UInt16}
  result::Vector{UInt16} = []
  index::UInt16 = typemax(UInt16) - (typemax(UInt16) >> 1)

  while index > 0
    push!(result, vertex ⊻ index)
    index >>= 1
  end #while

  return result
end #getAdjacentVertices

@inline function bestFirstSearch(cube::Hypercube, flow::Dict{Tuple{UInt16,UInt16},Int64}, from::UInt16, to::UInt16)::Dict{UInt16,UInt16}
  queue = DataStructures.Queue{UInt16}()
  parent::Dict{UInt16,UInt16} = Dict{UInt16,UInt16}()

  DataStructures.enqueue!(queue, from)

  while !isempty(queue)
    current = DataStructures.dequeue!(queue)
    if current == to
      break
    end #if

    for neighbour in getNeighbours(cube, current)
      if !haskey(parent, neighbour) && neighbour != from && getEdgeWeight(cube, current, neighbour) > get(flow, (current, neighbour), 0)
        DataStructures.enqueue!(queue, neighbour)
        parent[neighbour] = current
      end #if
    end #for

    for neighbour in getReverseNeighbours(cube, current)
      if !haskey(parent, current) && current != from && 0 > get(flow, (neighbour, current), 0)
        DataStructures.enqueue!(queue, current)
        parent[current] = neighbour
      end #if
    end #for
  end #while

  return parent
end #bestFirstSearch

function EdmondsKarp(cube::Hypercube, from::UInt16, to::UInt16)::Tuple{Dict{Tuple{UInt16,UInt16},Int64},UInt64}
  flow::Dict{Tuple{UInt16,UInt16},Int64} = Dict()

  augmentingPaths = 0

  while true
    path = bestFirstSearch(cube, flow, from, to)
    augmentingPaths += 1

    if !haskey(path, to)
      break
    end #if

    deltaFlow = typemax(UInt32)
    current = to
    #todo: change UInt32 to Int64
    while current != from
      deltaFlow = min(deltaFlow, getEdgeWeight(cube, path[current], current) - get(flow, (path[current], current), 0))
      current = path[current]
    end #while

    current = to

    while current != from
      flow[(path[current], current)] = get(flow, (path[current], current), 0) + deltaFlow
      flow[(current, path[current])] = get(flow, (current, path[current]), 0) - deltaFlow
      current = path[current]
    end #while

  end #while

  #Comment this line to return residual graph
  filter!(x -> x.second > 0, flow)

  return flow, augmentingPaths
end #EdmondsKarp

@inline function randomWeight(cube::Hypercube, from::UInt16, to::UInt16)::UInt32
  upperBound = max(hammingWeight(from), hammingWeight(to), cube.size, cube.size - hammingWeight(to))
  return UInt32(rand(1:upperBound))
end

function randomHyperCube(size::Integer)::Hypercube
  cube = Hypercube(size)
  for from::UInt16 in 0:2^size-1
    for to::UInt16 in getNeighbours(cube, from)
      setEdgeWeight!(cube, from, to, randomWeight(cube, from, to))
    end #for
  end #for
  return cube
end #randomHyperCube

function printHypercube(cube::Hypercube)
  start = UInt16(0)
  markedVertices = zeros(Bool, 2^cube.size)
  queue = DataStructures.Queue{UInt16}()
  DataStructures.enqueue!(queue, start)

  while !isempty(queue)
    temp = DataStructures.dequeue!(queue)
    if !markedVertices[temp+1]
      markedVertices[temp+1] = true
      for neighbour in getNeighbours(cube, temp)
        println("Edge: ($temp, $neighbour) Capacity: $(getEdgeWeight(cube, temp, neighbour))")
        DataStructures.enqueue!(queue, neighbour)
      end #for
    end #if
  end #while
end #printHypercube

mutable struct BiparteGraph
  size::UInt8
  capacity::Dict{Tuple{UInt64,UInt64},Int8}
  #Mapping from V1 to V2
  neighbours::Dict{UInt64,Vector{UInt64}}
  #Mapping from V2 to V1
  reverseNeighbours::Dict{UInt64,Vector{UInt64}}
end #BiparteGraph

@inline function getNeighbours(graph::BiparteGraph, vertex::UInt64)::Union{Vector{UInt64},UnitRange{UInt64}}
  if vertex == typemax(UInt64) - 1
    return UInt64(0):UInt64(2^graph.size - 1)
  end #if

  return get(graph.neighbours, vertex, [typemax(UInt64)])
end #getNeighbours

@inline function getReverseNeighbours(graph::BiparteGraph, vertex::UInt64)::Union{Vector{UInt64},UnitRange{UInt64}}
  if vertex == typemax(UInt64)
    return UInt64(2^graph.size):UInt64((2^graph.size) * 2 - 1)
  end #if

  if vertex < graph.size
    return [typemax(UInt64) - 1]
  end #if

  return get(graph.reverseNeighbours, vertex, Vector{UInt64}())
end #getReverseNeighbours

@inline function getEdgeWeight(graph::BiparteGraph, from::UInt64, to::UInt64)::Int8
  if from == typemax(UInt64) - 1 && to < 2^graph.size - 1
    return UInt8(1)
  end #if
  if from >= 2^graph.size && from < 2^(graph.size + 1) && to == typemax(UInt64)
    return UInt8(1)
  end #if
  return get(graph.capacity, (from, to), 0)
end #getEdgeWeight

@inline function bestFirstSearch(graph::BiparteGraph, flow::Dict{Tuple{UInt64,UInt64},Int8}, from::UInt64, to::UInt64)::Dict{UInt64,UInt64}
  queue = DataStructures.Queue{UInt64}()
  parent::Dict{UInt64,UInt64} = Dict{UInt64,UInt64}()

  DataStructures.enqueue!(queue, from)

  while !isempty(queue)
    current = DataStructures.dequeue!(queue)
    if current == to
      break
    end #i

    for neighbour in getNeighbours(graph, current)
      if !haskey(parent, neighbour) && neighbour != from && getEdgeWeight(graph, current, neighbour) > get(flow, (current, neighbour), 0)
        DataStructures.enqueue!(queue, neighbour)
        parent[neighbour] = current
      end #if
    end #for

    for neighbour in getReverseNeighbours(graph, current)
      if !haskey(parent, current) && current != from && 0 > get(flow, (neighbour, current), 0)
        DataStructures.enqueue!(queue, current)
        parent[current] = neighbour
      end #if
    end #for
  end #while

  return parent
end #bestFirstSearch

function EdmondsKarp(graph::BiparteGraph, from::UInt64, to::UInt64)::Tuple{Dict{Tuple{UInt64,UInt64},Int8},UInt64}
  flow::Dict{Tuple{UInt64,UInt64},Int8} = Dict()

  augmentingPaths = 0

  while true
    path = bestFirstSearch(graph, flow, from, to)
    augmentingPaths += 1

    if !haskey(path, to)
      break
    end #if

    deltaFlow = typemax(UInt32)
    current = to

    while current != from
      deltaFlow = min(deltaFlow, getEdgeWeight(graph, path[current], current) - get(flow, (path[current], current), 0))
      current = path[current]
    end #while

    current = to

    while current != from
      flow[(path[current], current)] = get(flow, (path[current], current), 0) + deltaFlow
      flow[(current, path[current])] = get(flow, (current, path[current]), 0) - deltaFlow
      current = path[current]
    end #while

  end #while

  #Comment this line to return residual graph
  filter!(x -> x.second > 0, flow)

  return flow, augmentingPaths
end

function randomBiparteGraph(size::Integer, degree::Integer)::BiparteGraph
  if degree > size
    throw(ArgumentError("Degree cannot be greater than size"))
  end #if
  graph = BiparteGraph(size, Dict(), Dict(), Dict())

  for i in 0:(2^size-1)
    neighbours = sample((2^size):((2^size)*2-1), degree, replace=false)
    graph.neighbours[i] = neighbours
    for neighbour in neighbours
      graph.capacity[(i, neighbour)] = 1
      if !haskey(graph.reverseNeighbours, neighbours)
        graph.reverseNeighbours[neighbour] = []
      end #if
      push!(graph.reverseNeighbours[neighbour], i)
    end #for
  end #for

  return graph
end #randomBiparteGraph

function printBiparteGraph(graph::BiparteGraph)
  println(graph.neighbours)
end

function constructLevelGraph(cube::Hypercube, flow::Dict{Tuple{UInt16,UInt16},Int64}, from::UInt16)::Set{Tuple{UInt16,UInt16}}
  queue = DataStructures.Queue{UInt16}()
  level::Set{Tuple{UInt16,UInt16}} = Set{Tuple{UInt16,UInt16}}()

  DataStructures.enqueue!(queue, from)

  while !isempty(queue)
    current = DataStructures.dequeue!(queue)

    for neighbour in getNeighbours(cube, current)
      if !((current, neighbour) in level) &&
         getEdgeWeight(cube, current, neighbour) - get(flow, (current, neighbour), 0) != 0

        DataStructures.enqueue!(queue, neighbour)
        push!(level, (current, neighbour))
      end #if
    end #for
  end #while

  return level
end #constructLevelGraph

function findPath(cube::Hypercube, level::Set{Tuple{UInt16,UInt16}}, from::UInt16, to::UInt16)::Vector{UInt16}
  parent::Dict{UInt16,UInt16} = Dict{UInt16,UInt16}()
  neighbours = getNeighbours(cube, from)
  stack = DataStructures.Stack{UInt16}()
  parent = Dict{UInt16,UInt16}()

  push!(stack, from)
  parent[from] = from

  while !isempty(stack)
    el = pop!(stack)

    neighbours = getNeighbours(cube, el)

    for neighbour in neighbours
      if !((el, neighbour) in level)
        continue
      end #if

      parent[neighbour] = el
      push!(stack, neighbour)
    end #for

  end #while

  if !haskey(parent, to)
    return []
  end #if

  path = Vector{UInt16}()

  current = to

  while current != from
    push!(path, current)
    current = parent[current]
  end #while

  push!(path, from)

  return path
end #findOptimalPath

function DinicAlgorithm(cube::Hypercube, from::UInt16, to::UInt16)::Tuple{Dict{Tuple{UInt16,UInt16},Int64},UInt64}

  flow::Dict{Tuple{UInt16,UInt16},Int64} = Dict()
  augmentingPaths = 0

  while true
    level = constructLevelGraph(cube, flow, from)
    path = findPath(cube, level, from, to)

    augmentingPaths += 1

    if isempty(path)
      break
    end #if

    #Find min capacity
    minCapacity = typemax(UInt32)

    for i in (length(path)):-1:2
      # println("Path: ", path[i], " ", path[i-1])
      # println("Flow: ", getEdgeWeight(cube, path[i], path[i-1]) - get(flow, (path[i], path[i-1]), 0))
      # println("Weight: ", getEdgeWeight(cube, path[i], path[i-1]))
      minCapacity = min(minCapacity, getEdgeWeight(cube, path[i], path[i-1]) - get(flow, (path[i], path[i-1]), 0))
    end #for

    for i in (length(path)):-1:2
      # println("Adding flow from ", path[i], " to ", path[i-1], " with capacity ", minCapacity)
      flow[(path[i], path[i-1])] = get(flow, (path[i], path[i-1]), 0) + minCapacity
      flow[(path[i-1], path[i])] = get(flow, (path[i-1], path[i]), 0) - minCapacity
    end #for

  end #while

  #Comment this line to return residual graph
  filter!(x -> x.second > 0, flow)

  return flow, augmentingPaths
end #DiracAlgorithm

function getHyperCubeModel(cube::Hypercube)
  model = Model(GLPK.Optimizer)
  # model = Model(HiGHS.Optimizer)
  numOfVertices = 2^cube.size
  @variable(model, flow[i=1:numOfVertices, j=1:numOfVertices], Int)

  for i in 1:(numOfVertices)
    for j in 1:(numOfVertices)
      if i != j
        @constraint(model, flow[i, j] >= 0)
        println(i, " ", j, " ", getEdgeWeight(cube, UInt16(i - 1), UInt16(j - 1)))
        x = Int(getEdgeWeight(cube, UInt16(i - 1), UInt16(j - 1)))
        @constraint(model, flow[i, j] <= x)
      end #if
    end #for
  end #for

  for i in 2:(numOfVertices-1)
    @constraint(model, sum(flow[i, j] for j in 1:(numOfVertices)) == sum(flow[j, i] for j in 1:(numOfVertices)))
  end #for

  # @constraint(model, sum(flow[1, j] for j in 1:(numOfVertices)) == sum(flow[j, numOfVertices] for j in 1:(numOfVertices)))

  @objective(model, Max, sum(flow[1, j] for j in 2:(numOfVertices)))

  # println(model)

  # optimize!(model)
  # println(value.(flow))

  return model, flow
end #getHyperCubeModel

function getBiparteGraphModel(graph::BiparteGraph)
  model = Model(GLPK.Optimizer)
  numOfVertices = 2^graph.size * 2
  @variable(model, flow[i=1:numOfVertices, j=1:numOfVertices], Int)
  @variable(model, source[i=1:div(numOfVertices, 2)], Int)
  @variable(model, sink[i=(div(numOfVertices, 2)+1):numOfVertices], Int)

  for i in 1:div(numOfVertices, 2)
    for j in (div(numOfVertices, 2)+1):numOfVertices
      if i != j
        @constraint(model, flow[i, j] >= 0)
        println(i, " ", j, " ", getEdgeWeight(graph, UInt64(i - 1), UInt64(j - 1)))
        x = Int(getEdgeWeight(graph, UInt64(i - 1), UInt64(j - 1)))
        @constraint(model, flow[i, j] <= x)
      end #if
    end #for
  end #for

  for i in 1:div(numOfVertices, 2)

    for i in 1:div(numOfVertices, 2)
      @constraint(model, source[i] >= 0)
      @constraint(model, source[i] <= 1)
      @constraint(model, sum(flow[i, j] for j in (div(numOfVertices, 2)+1):numOfVertices) == source[i])
    end #for

    for j in (div(numOfVertices, 2)+1):numOfVertices
      @constraint(model, sink[j] >= 0)
      @constraint(model, sink[j] <= 1)
      @constraint(model, sum(flow[i, j] for i in 1:(div(numOfVertices, 2))) == sink[j])
    end #for

    # @constraint(model, sum(flow[1, j] for j in 1:(numOfVertices)) == sum(flow[j, numOfVertices] for j in 1:(numOfVertices)))

    @objective(model, Max, sum(source[i] for i in 1:(div(numOfVertices, 2))))

    println(model)

    return model, flow
  end #getBiparteGraphModel
end

end #HypercubeGraph
