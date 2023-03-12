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

@testset "Topological sort test" begin
  @testset "DAG test" begin
    temp::SparseDirectedGraph{Unsigned} = SparseDirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(10), Unsigned(3)))
    addEdge!(temp, (Unsigned(10), Unsigned(4)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(8)))
    
    result = topologicalSort(temp, Unsigned(1))
    index = 1
    posMap = Dict()

    for v in result
      posMap[v] = index
      index += 1
    end

    @test posMap[1] < posMap[10]
    @test posMap[1] < posMap[5]
    @test posMap[10] < posMap[3]
    @test posMap[10] < posMap[4]
    @test posMap[5] < posMap[2]
    @test posMap[5] < posMap[8]

    esult = topologicalSort(temp, Unsigned(2))
    index = 1
    posMap = Dict()

    for v in result
      posMap[v] = index
      index += 1
    end

    @test posMap[1] < posMap[10]
    @test posMap[1] < posMap[5]
    @test posMap[10] < posMap[3]
    @test posMap[10] < posMap[4]
    @test posMap[5] < posMap[2]
    @test posMap[5] < posMap[8]
  end

  @testset "DCG test" begin
    temp::SparseDirectedGraph{Unsigned} = SparseDirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(10), Unsigned(3)))
    addEdge!(temp, (Unsigned(10), Unsigned(4)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(8)))
    addEdge!(temp, (Unsigned(4), Unsigned(1)))
    
    result = topologicalSort(temp, Unsigned(1))
    
    @test isnothing(result)
  end
end

@testset "Strong components test" begin
  temp::SparseDirectedGraph{Unsigned} = SparseDirectedGraph{Unsigned}(Unsigned(10))
  addEdge!(temp, (Unsigned(1), Unsigned(10)))
  addEdge!(temp, (Unsigned(1), Unsigned(5)))
  addEdge!(temp, (Unsigned(10), Unsigned(3)))
  addEdge!(temp, (Unsigned(10), Unsigned(4)))
  addEdge!(temp, (Unsigned(5), Unsigned(2)))
  addEdge!(temp, (Unsigned(5), Unsigned(8)))
  addEdge!(temp, (Unsigned(4), Unsigned(10)))
  addEdge!(temp, (Unsigned(3), Unsigned(4)))
  addEdge!(temp, (Unsigned(2), Unsigned(5)))
  
  components = strongComponents(temp)

  @test Set([10, 4, 3]) in components
  @test Set([2, 5]) in components
  @test Set([1]) in components
  @test Set([9]) in components
end

@testset "Biparte test" begin
  @testset "SparseDirectedGraph test" begin
    temp::SparseDirectedGraph{Unsigned} = SparseDirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(4)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(1), Unsigned(6)))
    addEdge!(temp, (Unsigned(2), Unsigned(4)))
    addEdge!(temp, (Unsigned(2), Unsigned(5)))
    addEdge!(temp, (Unsigned(2), Unsigned(6)))
    addEdge!(temp, (Unsigned(3), Unsigned(4)))
    addEdge!(temp, (Unsigned(3), Unsigned(5)))
    addEdge!(temp, (Unsigned(3), Unsigned(6)))

    left, right = isBiparte(temp)
    sort!(left); sort!(right)
    isolated = [7, 8, 9, 10]
    red = [1, 2, 3]
    blue = [4, 5, 6]
    
    @test all((x) -> x in left || x in right, isolated)
    @test all((x) -> x in left, red) || all((x) -> x in right, red)
    @test all((x) -> x in left, blue) || all((x) -> x in right, blue)

    addEdge!(temp, (Unsigned(1), Unsigned(2)))

    @test isnothing(isBiparte(temp))
  end

  @testset "SparseSimpleGraph test" begin
    temp::SparseSimpleGraph{Unsigned} = SparseSimpleGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(4)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(1), Unsigned(6)))
    addEdge!(temp, (Unsigned(2), Unsigned(4)))
    addEdge!(temp, (Unsigned(2), Unsigned(5)))
    addEdge!(temp, (Unsigned(2), Unsigned(6)))
    addEdge!(temp, (Unsigned(3), Unsigned(4)))
    addEdge!(temp, (Unsigned(3), Unsigned(5)))
    addEdge!(temp, (Unsigned(3), Unsigned(6)))

    left, right = isBiparte(temp)
    sort!(left); sort!(right)
    isolated = [7, 8, 9, 10]
    red = [1, 2, 3]
    blue = [4, 5, 6]
    
    @test all((x) -> x in left || x in right, isolated)
    @test all((x) -> x in left, red) || all((x) -> x in right, red)
    @test all((x) -> x in left, blue) || all((x) -> x in right, blue)

    addEdge!(temp, (Unsigned(1), Unsigned(2)))

    @test isnothing(isBiparte(temp))
  end
end
