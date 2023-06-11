module HypercubeGraph

import DataStructures

export Hypercube, setEdgeWeight!, getEdgeWeight, getNeighbours, getReverseNeighbours, getAdjacentVertices,
  bestFirstSearch, EdmondsKarp, hammingDistance, hammingWeight, randomHyperCube, printHypercube

mutable struct Hypercube
  size::UInt8
  # Index of edge v -> w is requal to v's value appended by the pos of bit
  # that remains set after v xor w
  capacity::Vector{UInt16}

  function Hypercube(size::Integer)
    if size < 1 || size > 16
      throw(error("incorrect size"))
    end #if
    return new(UInt8(size), zeros(2^(size) * size))
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

  counter += from << UInt(ceil(log2(index)))

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

  @boundscheck if hammingDistance(from, to) != 1
    throw(error("Edge does not exist"))
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
end

end #HypercubeGraph