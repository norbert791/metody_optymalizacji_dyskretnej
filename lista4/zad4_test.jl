include("hypercube.jl")
using .HypercubeGraph
import ArgParse

function main()

  cubeSize = UInt64(3)
  cube = randomHyperCube(cubeSize)

  printHypercube(cube)

  stats = @timed DiracAlgorithm(cube, UInt16(0), UInt16(2^cubeSize - 1))

  flow = stats.value[1]
  augmentingPaths = stats.value[2]
  execTime = stats.time + stats.gctime

  flowSum = 0

  for e in getNeighbours(cube, UInt16(0))
    flowSum += get(flow, (UInt16(0), e), 0)
  end #for

  println("Max flow: $flowSum")
  if args["printFlow"]
    println("Flow:")
    println(flow)
  end #if

  write(stderr, "$execTime\n")
  write(stderr, "$augmentingPaths\n")
end #main

main()