include("hypercube.jl")
using .HypercubeGraph
using Test


@testset "Get/Set edge" begin
  cube = Hypercube(4)

  @test getEdgeWeight(cube, UInt16(0), UInt16(1)) == UInt32(1)
  @test getEdgeWeight(cube, UInt16(0), UInt16(2)) == UInt32(1)
  setEdgeWeight!(cube, UInt16(0), UInt16(1), UInt32(10))
  setEdgeWeight!(cube, UInt16(0), UInt16(2), UInt32(20))
  @test getEdgeWeight(cube, UInt16(0), UInt16(1)) == UInt32(10)
  @test getEdgeWeight(cube, UInt16(0), UInt16(2)) == UInt32(20)

  setEdgeWeight!(cube, UInt16(11), UInt16(15), UInt32(3))
  setEdgeWeight!(cube, UInt16(14), UInt16(15), UInt32(4))

  @test getEdgeWeight(cube, UInt16(11), UInt16(15)) == UInt32(3)
  @test getEdgeWeight(cube, UInt16(14), UInt16(15)) == UInt32(4)

end #testset

@testset "Get neighbours" begin
  cube = Hypercube(4)

  @test Set(getNeighbours(cube, UInt16(0))) == Set([UInt16(1), UInt16(2), UInt16(4), UInt16(8)])
  @test Set(getNeighbours(cube, UInt16(1))) == Set([UInt16(3), UInt16(5), UInt16(9)])
  @test Set(getNeighbours(cube, UInt16(2))) == Set([UInt16(3), UInt16(6), UInt16(10)])
  @test Set(getNeighbours(cube, UInt16(3))) == Set([UInt16(7), UInt16(11)])

  @test Set(getNeighbours(cube, UInt16(4))) == Set([UInt16(5), UInt16(6), UInt16(12)])
  @test Set(getNeighbours(cube, UInt16(5))) == Set([UInt16(7), UInt16(13)])
  @test Set(getNeighbours(cube, UInt16(6))) == Set([UInt16(7), UInt16(14)])
  @test Set(getNeighbours(cube, UInt16(7))) == Set([UInt16(15)])

  @test Set(getNeighbours(cube, UInt16(8))) == Set([UInt16(9), UInt16(10), UInt16(12)])
  @test Set(getNeighbours(cube, UInt16(9))) == Set([UInt16(11), UInt16(13)])
  @test Set(getNeighbours(cube, UInt16(10))) == Set([UInt16(11), UInt16(14)])
  @test Set(getNeighbours(cube, UInt16(11))) == Set([UInt16(15)])

  @test Set(getNeighbours(cube, UInt16(12))) == Set([UInt16(13), UInt16(14)])
  @test Set(getNeighbours(cube, UInt16(13))) == Set([UInt16(15)])
  @test Set(getNeighbours(cube, UInt16(14))) == Set([UInt16(15)])
  @test Set(getNeighbours(cube, UInt16(15))) == Set([])

end #testset

@testset "Get reverse neighbours" begin
  cube = Hypercube(4)

  @test Set(getReverseNeighbours(cube, UInt16(0))) == Set([])
  @test Set(getReverseNeighbours(cube, UInt16(1))) == Set([UInt16(0)])
  @test Set(getReverseNeighbours(cube, UInt16(2))) == Set([UInt16(0)])
  @test Set(getReverseNeighbours(cube, UInt16(3))) == Set([UInt16(1), UInt16(2)])

  @test Set(getReverseNeighbours(cube, UInt16(4))) == Set([UInt16(0)])
  @test Set(getReverseNeighbours(cube, UInt16(5))) == Set([UInt16(1), UInt16(4)])
  @test Set(getReverseNeighbours(cube, UInt16(6))) == Set([UInt16(2), UInt16(4)])
  @test Set(getReverseNeighbours(cube, UInt16(7))) == Set([UInt16(3), UInt16(5), UInt16(6)])

  @test Set(getReverseNeighbours(cube, UInt16(8))) == Set([UInt16(0)])
  @test Set(getReverseNeighbours(cube, UInt16(9))) == Set([UInt16(1), UInt16(8)])
  @test Set(getReverseNeighbours(cube, UInt16(10))) == Set([UInt16(2), UInt16(8)])
  @test Set(getReverseNeighbours(cube, UInt16(11))) == Set([UInt16(3), UInt16(9), UInt16(10)])

  @test Set(getReverseNeighbours(cube, UInt16(12))) == Set([UInt16(4), UInt16(8)])
  @test Set(getReverseNeighbours(cube, UInt16(13))) == Set([UInt16(5), UInt16(9), UInt16(12)])
  @test Set(getReverseNeighbours(cube, UInt16(14))) == Set([UInt16(6), UInt16(10), UInt16(12)])
  @test Set(getReverseNeighbours(cube, UInt16(15))) == Set([UInt16(7), UInt16(11), UInt16(13), UInt16(14)])

end #testset

@testset "Random hypercube" begin
  cube = randomHyperCube(4)

  for i in 1:15
    for e in getReverseNeighbours(cube, UInt16(i))
      @test getEdgeWeight(cube, UInt16(i), e) == UInt32(0)
    end
  end
end #testset

@testset "EdmondsKarp" begin
  cube = Hypercube(3)

  setEdgeWeight!(cube, UInt16(0), UInt16(1), UInt32(2))
  setEdgeWeight!(cube, UInt16(0), UInt16(2), UInt32(3))
  setEdgeWeight!(cube, UInt16(0), UInt16(4), UInt32(3))
  setEdgeWeight!(cube, UInt16(1), UInt16(5), UInt32(1))
  setEdgeWeight!(cube, UInt16(1), UInt16(3), UInt32(1))
  setEdgeWeight!(cube, UInt16(2), UInt16(3), UInt32(3))
  setEdgeWeight!(cube, UInt16(2), UInt16(6), UInt32(2))
  setEdgeWeight!(cube, UInt16(4), UInt16(5), UInt32(3))
  setEdgeWeight!(cube, UInt16(4), UInt16(6), UInt32(1))
  setEdgeWeight!(cube, UInt16(5), UInt16(7), UInt32(2))
  setEdgeWeight!(cube, UInt16(6), UInt16(7), UInt32(1))
  setEdgeWeight!(cube, UInt16(3), UInt16(7), UInt32(2))

  flow, _ = EdmondsKarp(cube, UInt16(0), UInt16(7))
  flowSum = 0

  for e in getNeighbours(cube, UInt16(0))
    flowSum += get(flow, (UInt16(0), e), 0)
  end #for

  @test flowSum == UInt32(5)
end #testset