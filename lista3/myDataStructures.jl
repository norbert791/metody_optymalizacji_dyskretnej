module MyDataStructures

import DataStructures
export BucketPriorityQueue, RadixHeap, enqueue!, dequeue!, isempty

mutable struct PriorityQueueProxy{K, V}
  queue::DataStructures.PriorityQueue{K, V}

  function PriorityQueueProxy{K, V}() where {K <: Any, V <: Unsigned}
    return new{K, V}(DataStructures.PriorityQueue{K, V}())
  end #PriorityQueueAdapter
end

function enqueue!(queue::PriorityQueueProxy{K, V}, elem::K, prio::V) where {K <: Any, V <: Unsigned}
  if elem in keys(queue.queue)
    DataStructures.delete!(queue.queue, elem)
  end #if
  DataStructures.enqueue!(queue.queue, elem, prio)
end #enqueue!

function dequeue!(queue::PriorityQueueProxy{K, V})::K where {K <: Any, V <: Unsigned}
  DataStructures.dequeue!(queue.queue)
end #enqueue!

function isempty(queue::PriorityQueueProxy{K, V})::Bool where {K <: Any, V <: Unsigned}
  return DataStructures.isempty(queue.queue)
end

#Can be optimized to store lowest nonempty bucket
mutable struct BucketPriorityQueue{T}
  buckets::Dict{Unsigned, DataStructures.MutableLinkedList{T}}
  numOfElems::Unsigned

  function BucketPriorityQueue{T}() where T <: Any
    buckets = Dict()
    return new{T}(buckets, Unsigned(0))
  end #BucketPriorityQueue
end

@inline function findfirst(queue::DataStructures.MutableLinkedList{T}, elem::T) where T <: Any
  index = 1
  for v in queue
    if v == elem
      return index
    else
      index += 1
    end #if
  end

  return nothing
end

function enqueue!(queue::BucketPriorityQueue{T}, elem::T, priority::Unsigned) where T <: Any
  if !haskey(queue.buckets, priority + 1)
    queue.buckets[priority + 1] = DataStructures.MutableLinkedList{Unsigned}()
  end #if
  index = findfirst(queue.buckets[priority + 1], elem)
  if isnothing(index)
    push!(queue.buckets[priority + 1], elem)
    queue.numOfElems += 1
  else
    queue.buckets[priority + 1][index] = elem
  end #if
end #enqueue!

function dequeue!(queue::BucketPriorityQueue{T})::T where T <: Any
  if queue.numOfElems == 0
    throw(BoundsError("The queue is empty"))
  end #if

  priority = min(keys(queue.buckets)...)
  result = popfirst!(queue.buckets[priority])
  queue.numOfElems -= 1

  if DataStructures.isempty(queue.buckets[priority])
    delete!(queue.buckets, priority)
  end #if

  return result
end #dequeue!

function isempty(queue::BucketPriorityQueue{T})::Bool where T <: Any
  return queue.numOfElems == 0
end #isempty

mutable struct RadixHeap{T, E}
  buckets::Vector{Vector{Tuple{T, E}}}
  lastDeletion::E
  numOfElems::Unsigned
  oldestBitSelector::E

  function RadixHeap{T, E}() where {T <: Any, E <: Unsigned}
    selector::E = typemax(E)
    selector = selector - (selector >> 1)
    #TODO: replace 65 with size of underlying type of E
    return new(map(_ -> Vector(), 1:(65)), E(0), Unsigned(0), selector)
  end #RadixHeap

end

function enqueue!(queue::RadixHeap{T, E}, elem::T, priority::E) where {T <: Any, E <: Unsigned}
  bucketIndex = findOldestBit(queue, priority ⊻ queue.lastDeletion) + 1
  index = Base.findfirst(x -> x[1] == elem, queue.buckets[bucketIndex])
  if isnothing(index)
    push!(queue.buckets[bucketIndex], (elem, priority))
    queue.numOfElems += 1
  else
    queue.buckets[bucketIndex][index] = (elem, priority)
  end #if
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
  redistibuteBuckets!(queue, foundIndex)
    

  queue.numOfElems -= 1

  return minElem[1]
end #dequeue!

@inline function redistibuteBuckets!(queue::RadixHeap{T, E}, foundIndex) where {T <: Any, E <: Unsigned}
  while foundIndex <= length(queue.buckets)
    foundIndex += 1
  end #while

  if foundIndex > length(queue.buckets)
    return
  end #if

  redistributed = queue.buckets[foundIndex]
  queue.buckets[foundIndex] = Vector()
  minElem, _ = findmin(x -> redistributed[x][2], 1:length(redistributed))
  
  for v in redistributed
    bucketIndex = findOldestBit(queue, v[2] ⊻ queue.lastDeletion) + 1
    push!(queue.buckets[bucketIndex], minElem)
  end #for
end #redistibuteBuckets!

function isempty(queue::RadixHeap)::Bool
  return queue.numOfElems == 0
end #isempty

@inline function findOldestBit(heap::RadixHeap{T, E}, num::E) where {T <: Any, E <: Unsigned}
  sel::E = heap.oldestBitSelector
  #todo: replace 65 with sizeof underlying type of E
  result = 65

  while (sel & num != sel) && sel > 0
    result  -= 1
    sel = sel >> 1
  end #while

  return result
end

end #MyDataStructures