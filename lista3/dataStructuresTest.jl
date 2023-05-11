include("myDataStructures.jl")
using .MyDataStructures
using Test

@testset "BucketPriorityQueue" begin
  queue = BucketPriorityQueue{Int}(Unsigned(50))

  enqueue!(queue, 5,  Unsigned(50))
  enqueue!(queue, 10, Unsigned(49))
  enqueue!(queue, 20, Unsigned(0))

  @test !MyDataStructures.isempty(queue)
  @test dequeue!(queue) == 20
  @test dequeue!(queue) == 10
  @test dequeue!(queue) == 5
  @test MyDataStructures.isempty(queue)
end #BucketPriorityQueue

@testset "RadixHeap" begin
  queue = RadixHeap{Int, Unsigned}()

  enqueue!(queue, 5,  Unsigned(50))
  enqueue!(queue, 10, Unsigned(49))
  enqueue!(queue, 20, Unsigned(0))

  @test !MyDataStructures.isempty(queue)
  @test dequeue!(queue) == 20
  @test dequeue!(queue) == 10
  @test dequeue!(queue) == 5
  @test MyDataStructures.isempty(queue)
end #RadixHeap