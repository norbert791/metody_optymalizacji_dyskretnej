include("graphPrimitives.jl")

struct test{T <: Unsigned}
  x::T
  y::T
end

using Test
using .MyGraphPrimitives

@testset "DirectedGraph test" begin
  @testset "Meta" begin
    DirectedGraph{Unsigned} <: Graph
  end
  @testset "Creating" begin
    temp::DirectedGraph = DirectedGraph{Unsigned}(Unsigned(10))
    @test getVertices(temp) == 1:10
    @test size(temp.edges) == (10, 10)
  end
  @testset "Adding vertices" begin
    temp::DirectedGraph = DirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(2), Unsigned(5)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    @test temp.edges[1, 10] == 1
    @test temp.edges[2, 5] == 1
    @test temp.edges[2, 1] == 2
    @test (getNeighbours(temp, Unsigned(2))) == [1,5]
    @test (getNeighbours(temp, Unsigned(1))) == [10]
    @test (getNeighbours(temp, Unsigned(10))) == []
    @test (getNeighbours(temp, Unsigned(5))) == [2]
    # getAdjacentVertices
    @test (getAdjacentVertices(temp, Unsigned(10))) == [1]
    @test sort((getAdjacentVertices(temp, Unsigned(1)))) == [2, 10]
    @test (getAdjacentVertices(temp, Unsigned(5))) == [2]
    @test sort(getAdjacentVertices(temp, Unsigned(2))) == [1, 5]
  end
end

@testset "SimpleGraph test" begin
  @testset "Meta" begin
    SimpleGraph{Unsigned} <: Graph
  end
  @testset "Creating" begin
    temp::SimpleGraph = SimpleGraph{Unsigned}(Unsigned(10))
    @test getVertices(temp) == 1:10
    @test length(temp.edges.vals) == 60
  end
  @testset "Adding vertices" begin
    temp::SimpleGraph = SimpleGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(2), Unsigned(5)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(1), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(3), Unsigned(1)))
    addEdge!(temp, (Unsigned(8), Unsigned(4)))
    @test (getNeighbours(temp, Unsigned(2))) == [1,5]
    @test (getNeighbours(temp, Unsigned(1)))== [2, 3, 10]
    @test (getNeighbours(temp, Unsigned(10))) == [1]
    @test (getNeighbours(temp, Unsigned(5))) == [2]
    @test (getNeighbours(temp, Unsigned(4))) == [8]
    # getAdjacentVertices
    @test (getAdjacentVertices(temp, Unsigned(2))) == [1,5]
    @test (getAdjacentVertices(temp, Unsigned(1)))== [2, 3, 10]
    @test (getAdjacentVertices(temp, Unsigned(10))) == [1]
    @test (getAdjacentVertices(temp, Unsigned(5))) == [2]
    @test (getAdjacentVertices(temp, Unsigned(4))) == [8]
  end
end

@testset "SparseDirectedGraph test" begin
  @testset "Meta" begin
    SparseDirectedGraph{Unsigned} <: Graph
  end
  @testset "Creating" begin
    temp::SparseDirectedGraph = SparseDirectedGraph{Unsigned}(Unsigned(10))
    @test getVertices(temp) == 1:10
    @test size(temp.edges) == (10,)
  end
  @testset "Adding vertices" begin
    temp::SparseDirectedGraph = SparseDirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(2), Unsigned(5)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    @test (getNeighbours(temp, Unsigned(2))) == [1,5]
    @test (getNeighbours(temp, Unsigned(1))) == [10]
    @test (getNeighbours(temp, Unsigned(10))) == []
    @test (getNeighbours(temp, Unsigned(5))) == [2]
  end
end

@testset "SimpleDirectedGraph test" begin
  @testset "Meta" begin
    SparseDirectedGraph{Unsigned} <: Graph
  end
  @testset "Creating" begin
    temp::SparseDirectedGraph = SparseDirectedGraph{Unsigned}(Unsigned(10))
    @test getVertices(temp) == 1:10
    @test size(temp.edges) == (10,)
  end
  @testset "Adding vertices" begin
    temp::SparseDirectedGraph = SparseDirectedGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(2), Unsigned(5)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    @test (getNeighbours(temp, Unsigned(2))) == [1,5]
    @test (getNeighbours(temp, Unsigned(1))) == [10]
    @test (getNeighbours(temp, Unsigned(10))) == []
    @test (getNeighbours(temp, Unsigned(5))) == [2]
    # getAdjacentVertices
    @test (getAdjacentVertices(temp, Unsigned(10))) == [1]
    @test sort((getAdjacentVertices(temp, Unsigned(1)))) == [2, 10]
    @test (getAdjacentVertices(temp, Unsigned(5))) == [2]
    @test sort(getAdjacentVertices(temp, Unsigned(2))) == [1, 5]
  end
end

@testset "SparseSimpleGraph test" begin
  @testset "Meta" begin
    SimpleGraph{Unsigned} <: Graph
  end
  @testset "Creating" begin
    temp::SimpleGraph = SimpleGraph{Unsigned}(Unsigned(10))
    @test getVertices(temp) == 1:10
    @test length(temp.edges.vals) == 60
  end
  @testset "Adding vertices" begin
    temp::SparseSimpleGraph = SparseSimpleGraph{Unsigned}(Unsigned(10))
    addEdge!(temp, (Unsigned(1), Unsigned(10)))
    addEdge!(temp, (Unsigned(2), Unsigned(5)))
    addEdge!(temp, (Unsigned(2), Unsigned(1)))
    addEdge!(temp, (Unsigned(1), Unsigned(2)))
    addEdge!(temp, (Unsigned(5), Unsigned(2)))
    addEdge!(temp, (Unsigned(3), Unsigned(1)))
    addEdge!(temp, (Unsigned(8), Unsigned(4)))
    @test (getNeighbours(temp, Unsigned(2))) == [1,5]
    @test (getNeighbours(temp, Unsigned(1)))== [2, 3, 10]
    @test (getNeighbours(temp, Unsigned(10))) == [1]
    @test (getNeighbours(temp, Unsigned(5))) == [2]
    @test (getNeighbours(temp, Unsigned(4))) == [8]
    # getAdjacentVertices
    @test (getAdjacentVertices(temp, Unsigned(2))) == [1,5]
    @test (getAdjacentVertices(temp, Unsigned(1)))== [2, 3, 10]
    @test (getAdjacentVertices(temp, Unsigned(10))) == [1]
    @test (getAdjacentVertices(temp, Unsigned(5))) == [2]
    @test (getAdjacentVertices(temp, Unsigned(4))) == [8]
  end
end

@testset "Graph Load test" begin
  t = loadGraph("primitivesTestDep1.txt", false)
  @test getNeighbours(t, UInt32(1)) == [2]
  @test getNeighbours(t, UInt32(8)) == [10]
  @test getNeighbours(t, UInt32(4)) == [5, 9]
  @test getNeighbours(t, UInt32(5)) == [4, 9]

  t = loadGraph("primitivesTestDep1.txt", true)
  @test getNeighbours(t, UInt32(1)) == [2]
  @test getNeighbours(t, UInt32(4)) == [5, 9]
  @test getNeighbours(t, UInt32(8)) == [10]
  @test getNeighbours(t, UInt32(5)) == [4, 9]
  
  t = loadGraph("primitivesTestDep2.txt", false)
  @test getNeighbours(t, UInt32(1))  == [2]
  @test getNeighbours(t, UInt32(4))  == [5, 9]
  @test getNeighbours(t, UInt32(8))  == [10]
  @test getNeighbours(t, UInt32(5))  == [4, 9]
  @test getNeighbours(t, UInt32(2))  == [1]
  @test getNeighbours(t, UInt32(10)) == [8]
  @test getNeighbours(t, UInt32(9))  == [4, 5]

  t = loadGraph("primitivesTestDep2.txt", true)
  @test getNeighbours(t, UInt32(1))  == [2]
  @test getNeighbours(t, UInt32(4))  == [5, 9]
  @test getNeighbours(t, UInt32(8))  == [10]
  @test getNeighbours(t, UInt32(5))  == [4, 9]
  @test getNeighbours(t, UInt32(2))  == [1]
  @test getNeighbours(t, UInt32(10)) == [8]
  @test getNeighbours(t, UInt32(9))  == [4, 5]
end
