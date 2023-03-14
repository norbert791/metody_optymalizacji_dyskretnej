include("graphAlgorithms.jl")

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
    @test dfsTree(temp, Unsigned(1)) == [(nothing, 1), (1, 10), (10, 4), (10, 3), (1, 5), (5, 8), (5, 2)]
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
    @test dfsTree(temp, Unsigned(1)) == [(nothing, 1), (1, 10), (10, 4), (10, 3), (1, 5), (5, 8), (5, 2)]
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
    @test dfsTree(temp, Unsigned(1)) == [(nothing, 1), (1, 10), (10, 4), (10, 3), (1, 5), (5, 8), (5, 2)]
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
    @test dfsTree(temp, Unsigned(1)) == [(nothing, 1), (1, 10), (10, 4), (10, 3), (1, 5), (5, 8), (5, 2)]
  end

  @testset "Ex. 1A" begin
    temp = loadGraph("algorithmTestDeps/algorithmTestDep1.txt", true)
    #println(temp)
    @test dfsOrder(temp, UInt32(1)) == [1, 3, 6, 5, 2, 4]

    temp = loadGraph("algorithmTestDeps/algorithmTestDep4.txt", true)
    #println(temp)
    @test dfsOrder(temp, UInt32(1)) == [1, 3, 6, 5, 4, 2]
  end

  @testset "Ex. 1B" begin
    temp = loadGraph("algorithmTestDeps/algorithmTestDep2.txt", true)
    #println(temp)
    @test dfsOrder(temp, UInt32(1)) == [1, 4, 8, 7, 3, 2, 6, 5]

    temp = loadGraph("algorithmTestDeps/algorithmTestDep5.txt", true)
    #println(temp)
    @test dfsOrder(temp, UInt32(1)) == [1, 5, 8, 7, 6, 2, 3, 4]
  end

  @testset "Ex. 1C" begin
    temp = loadGraph("algorithmTestDeps/algorithmTestDep3.txt", true)
    @test dfsOrder(temp, UInt32(1)) == [1, 3, 6, 9, 8, 7, 5, 4, 2]

    temp = loadGraph("algorithmTestDeps/algorithmTestDep6.txt", true)
    @test dfsOrder(temp, UInt32(1)) == [1, 3, 6, 9, 8, 7, 5, 4, 2]
  end

end

@testset "BFS test" begin
  @testset "SparseDirectedGraph test" begin
    temp::SparseDirectedGraph{Unsigned} = SparseDirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(1), Unsigned(5)))
    addEdge!(temp, (Unsigned(10), Unsigned(3)))
    addEdge!(temp, (Unsigned(10), Unsigned(4)))
    addEdge!(temp, (Unsigned(4), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(8)))

    @test bfsOrder(temp, Unsigned(1)) == [1, 5, 10, 2, 8, 3, 4]
    @test bfsTree(temp, Unsigned(1)) == [(nothing, 1), (1, 5), (1, 10), (5, 2), (5, 8), (10, 3), (10, 4)]
  
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

    @test bfsOrder(temp, Unsigned(1)) == [1, 4, 5, 10, 2, 8, 3]
    @test bfsTree(temp, Unsigned(1)) == [(nothing, 1), (1, 4), (1, 5), (1, 10), (5, 2), (5, 8), (10, 3)]
  end

  @testset "Ex. 1A" begin
    temp = loadGraph("algorithmTestDeps/algorithmTestDep1.txt", true)
    #println(temp)
    @test bfsOrder(temp, UInt32(1)) == [1, 2, 3, 4, 5, 6]

    temp = loadGraph("algorithmTestDeps/algorithmTestDep4.txt", true)
    #println(temp)
    @test bfsOrder(temp, UInt32(1)) == [1, 2, 3, 4, 5, 6]
  end

  @testset "Ex. 1B" begin
    temp = loadGraph("algorithmTestDeps/algorithmTestDep2.txt", true)
    #println(temp)
    @test bfsOrder(temp, UInt32(1)) == [1, 2, 4, 3, 6, 8, 5, 7]

    temp = loadGraph("algorithmTestDeps/algorithmTestDep5.txt", true)
    #println(temp)
    @test bfsOrder(temp, UInt32(1)) == [1, 2, 4, 5, 3, 6, 8, 7]
  end

  @testset "Ex. 1C" begin
    temp = loadGraph("algorithmTestDeps/algorithmTestDep3.txt", true)
    @test bfsOrder(temp, UInt32(1)) == [1, 2, 3, 4, 5, 6, 8, 7, 9]

    temp = loadGraph("algorithmTestDeps/algorithmTestDep6.txt", true)
    @test bfsOrder(temp, UInt32(1)) == [1, 2, 3, 4, 5, 6, 7, 8, 9]
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
    
    result = topologicalSort(temp)
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

    esult = topologicalSort(temp)
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
    
    result = topologicalSort(temp)
    
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

@testset "Simulated small components test" begin
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
  
  components = strongComponentsIterative(temp)

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

@testset "Biparte iterative test" begin
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

    left, right = isBiparteIterative(temp)
    sort!(left); sort!(right)
    isolated = [7, 8, 9, 10]
    red = [1, 2, 3]
    blue = [4, 5, 6]
    
    @test all((x) -> x in left || x in right, isolated)
    @test all((x) -> x in left, red) || all((x) -> x in right, red)
    @test all((x) -> x in left, blue) || all((x) -> x in right, blue)

    addEdge!(temp, (Unsigned(1), Unsigned(2)))

    @test isnothing(isBiparteIterative(temp))
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

    left, right = isBiparteIterative(temp)
    sort!(left); sort!(right)
    isolated = [7, 8, 9, 10]
    red = [1, 2, 3]
    blue = [4, 5, 6]
    
    @test all((x) -> x in left || x in right, isolated)
    @test all((x) -> x in left, red) || all((x) -> x in right, red)
    @test all((x) -> x in left, blue) || all((x) -> x in right, blue)

    addEdge!(temp, (Unsigned(1), Unsigned(2)))

    @test isnothing(isBiparteIterative(temp))
  end
end

@testset "Biparte iterative test" begin
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

    left, right = isBiparteIterative(temp)
    sort!(left); sort!(right)
    isolated = [7, 8, 9, 10]
    red = [1, 2, 3]
    blue = [4, 5, 6]
    
    @test all((x) -> x in left || x in right, isolated)
    @test all((x) -> x in left, red) || all((x) -> x in right, red)
    @test all((x) -> x in left, blue) || all((x) -> x in right, blue)

    addEdge!(temp, (Unsigned(1), Unsigned(2)))

    @test isnothing(isBiparteIterative(temp))
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

    left, right = isBiparteIterative(temp)
    sort!(left); sort!(right)
    isolated = [7, 8, 9, 10]
    red = [1, 2, 3]
    blue = [4, 5, 6]
    
    @test all((x) -> x in left || x in right, isolated)
    @test all((x) -> x in left, red) || all((x) -> x in right, red)
    @test all((x) -> x in left, blue) || all((x) -> x in right, blue)

    addEdge!(temp, (Unsigned(1), Unsigned(2)))

    @test isnothing(isBiparteIterative(temp))
  end



end
