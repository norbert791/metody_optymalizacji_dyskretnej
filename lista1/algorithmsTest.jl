include("graphAlgorithms.jl")
#include("graphPrimitives.jl")

using Test
using .MyGraphAlgorithms.MyGraphPrimitives
using .MyGraphAlgorithms

@testset "DFS test" begin
  @testset "DirectedGraph test" begin
    temp::DirectedGraph{Unsigned} = DirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(10), Unsigned(3)))
    addEdge!(temp, (Unsigned(10), Unsigned(4)))
    addEdge!(temp, (Unsigned(4), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(8)))

    @test dfsOrder(temp, Unsigned(1)) == [1, 10, 4, 3, 5, 8, 2]
    @test dfsTree(temp, Unsigned(1)) == (1, [(5, [(2, []), (8, [])]), (10, [(3, []), (4, [])])])
  end

  @testset "SimpleGraph test" begin
    temp::SimpleGraph{Unsigned} = SimpleGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(10), Unsigned(3)))
    addEdge!(temp, (Unsigned(10), Unsigned(4)))
    addEdge!(temp, (Unsigned(4), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(8)))

    @test dfsOrder(temp, Unsigned(1)) == [1, 10, 4, 3, 5, 8, 2]
    @test dfsTree(temp, Unsigned(1)) == (1, [(4, [(10, [(3, [])])]), (5, [(2, []), (8, [])])])
  end

  @testset "SparseDirectedGraph test" begin
    temp::SparseDirectedGraph{Unsigned} = SparseDirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(10), Unsigned(3)))
    addEdge!(temp, (Unsigned(10), Unsigned(4)))
    addEdge!(temp, (Unsigned(4), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(8)))

    @test dfsOrder(temp, Unsigned(1)) == [1, 10, 4, 3, 5, 8, 2]
    @test dfsTree(temp, Unsigned(1)) == (1, [(5, [(2, []), (8, [])]), (10, [(3, []), (4, [])])])
  
  end

  @testset "SparseSimpleGraph test" begin
    temp::SparseSimpleGraph{Unsigned} = SparseSimpleGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(10), Unsigned(3)))
    addEdge!(temp, (Unsigned(10), Unsigned(4)))
    addEdge!(temp, (Unsigned(4), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(8)))

    @test dfsOrder(temp, Unsigned(1)) == [1, 10, 4, 3, 5, 8, 2]
    @test dfsTree(temp, Unsigned(1)) == (1, [(4, [(10, [(3, [])])]), (5, [(2, []), (8, [])])])
  end
end