module MyDataStructures

import DataStructures
export BucketPriorityQueue, RadixHeap, enqueue!, dequeue!, isempty

#Can be optimized to store lowest nonempty bucket
mutable struct BucketPriorityQueue{T}
  buckets::Vector{DataStructures.MutableLinkedList{T}}
  numOfElems::Unsigned

  function BucketPriorityQueue{T}(upperBound::Unsigned) where T <: Any
    buckets = map(_ -> DataStructures.MutableLinkedList{T}(), 1:(upperBound + 1)) #Buckets are labeld from 1 to upperBound + 1
    return new{T}(buckets, Unsigned(0))
  end #BucketPriorityQueue
end

function enqueue!(queue::BucketPriorityQueue{T}, elem::T, priority::Unsigned) where T <: Any
  push!(queue.buckets[priority + 1], elem)
  queue.numOfElems += 1
end #enqueue!

function dequeue!(queue::BucketPriorityQueue{T})::T where T <: Any
  for elem in queue.buckets
    if !DataStructures.isempty(elem)
      queue.numOfElems -= 1
      return popfirst!(elem)
    end #if
  end #for

  throw(BoundsError("The queue is empty"))
end #dequeue!

function isempty(queue::BucketPriorityQueue{T})::Bool where T <: Any
  return queue.numOfElems == 0
end #isempty

mutable struct RadixHeap{T, E}
  buckets::Vector{Vector{Tuple{T, E}}}
  lastDeletion::E
  numOfElems::Unsigned
  oldestBitSelector::T

  function RadixHeap{T, E}() where {T <: Any, E <: Unsigned}
    selector::T = typemax(T)
    selector = selector - (selector >> 1)
    return new(map(_ -> Vector{T}(), 1:(sizeof(T) * 8 + 1)), E(0), Unsigned(0), selector)
  end #RadixHeap

end

function enqueue!(queue::RadixHeap{T, E}, elem::T, priority::E) where {T <: Any, E <: Unsigned}
  bucketIndex = findOldestBit(queue, priority ⊻ queue.lastDeletion) + 1
  queue.numOfElems += 1
  push!(queue.buckets[bucketIndex], (elem, priority))
end #enqueue!

function dequeue!(queue::RadixHeap{T, E})::T where {T <: Any, E <: Unsigned}
  if queue.numOfElems == 0
    throw(error("The queue is empty"))
  end #if

  foundIndex = 0
  
  for i in 1:length(queue.buckets)
    if !(Base.isempty(queue.buckets[i]))
      foundIndex = i
      break
    end #if
  end #for

  bucket = queue.buckets[foundIndex]
  minElem = popat!(bucket, argmin(x -> bucket[x][2], 1:length(bucket)))
  queue.lastDeletion = minElem[2]

  if Base.isempty(bucket)
    queue.buckets = [queue.buckets[foundIndex:length(queue.buckets)]; queue.buckets[1:(foundIndex - 1)]]
  end #if

  queue.numOfElems -= 1

  return minElem[1]
end #dequeue!

function isempty(queue::RadixHeap)::Bool
  return queue.numOfElems == 0
end #isempty

@inline function findOldestBit(heap::RadixHeap{T, E}, num::E) where {T <: Any, E <: Unsigned}
  sel::E = heap.oldestBitSelector
  result = sizeof(T) * 8

  while (sel & num != sel) && sel > 0
    result  -= 1
    sel = sel >> 1
  end #while

  return result
end

end #MyDataStructures