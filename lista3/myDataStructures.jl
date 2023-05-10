module MyDataStructures

import DataStructures

mutable struct BucketPriorityQueue{T}
  buckets::Vector{DataStructures.MutableLinkedList{T}}
  numOfElems::Unsigned

  function BucketPriorityQueue(upperBound::Unsigned)
    buckets = Vector(_ -> MutableLinkedList, upperBound + 1) #Buckets are labeld from 0 to upperBound
    numOfElems = Unsigned(0)
  end
end

function enqueue!(queue::BucketPriorityQueue{T}, priority::Unsigned, elem::T) where T <: Any
  push!(queue.buckets[priority], elem)
  queue.numOfElems += 1
end

function dequeue!(queue::BucketPriorityQueue{T})::T where T <: Any
  for elem in queue.buckets
    if !isempty(elem)
      queue.numOfElems -= 1
      return popfirst!(elem)
    end #if
  end #for

  throw(BoundsError("The queue is empty"))
end

function isempty(queue::BucketPriorityQueue{T})::Bool
  return queue.numOfElems == 0
end

end #MyDataStructures