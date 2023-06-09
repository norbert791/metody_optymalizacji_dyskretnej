module HypercubeGraph

mutable struct Hypercube
  size::UInt8
  # Index of edge v -> w is requal to v's value prepended by the pos of bit
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
  end

  return counter
end

@inline hammingWeight(number::UInt16) = hammingDistance(number, UInt16(0))

@inline function computeIndex(from::UInt16, to::UInt16)::UInt32

  index = 1
  counter::UInt32 = UInt32(0)

  while (from & index) == (to & index)
    counter += 1
    index = index << 1
  end #while

  counter = counter << 16

  counter += from

  return counter
end #computeIndex

function setEdgeWeight!(cube::Hypercube, from::UInt16, to::UInt16, weight::UInt32)
  if weight > typemax(UInt16) + 1
    throw(error("Incorrect weight"))
  end #if

  @boundscheck if hammingDistance(from, to) != 1
    throw(error("Edge does not exist"))
  end #if

  index = computeIndex(from, to)

  #We are mapping vals from 1..2^16 to 0..2^16 - 1
  cube.capacity[index] = UInt16(weight - 1)
end

function getEdgeWeight(cube::Hypercube, from::UInt16, to::UInt16)::UInt32
  return UInt32(cube.capacity[computeIndex(from, to)]) + UInt32(1)
end



end #HypercubeGraph