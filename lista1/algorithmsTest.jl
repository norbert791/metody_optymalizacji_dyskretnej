include("graphPrimitives.jl")
include("graphAlgorithms.jl")

using Test
using .MyGraphAlgorithms
using .MyGraphPrimitives

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

    @test dfsOrder(temp, Unsigned(1)) == [1, 10, 3, 4, 5, 2, 8]
  end
end