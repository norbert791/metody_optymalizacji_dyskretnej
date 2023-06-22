include("hypercube.jl")
using .HypercubeGraph
using JuMP

function modelAndSolve(g)
  model, f = getHyperCubeModel(g)
  optimize!(model)
  return 0, 0
end #modelAndSolve

function main()

  numberOfRepetitions = 40

  open("experiments/zad31_results.csv", "w") do file
    write(file, "k,avgFlow,avgTime,avgAugmentingPaths\n")
  end #open

  for k in 1:16
    avgFlow = 0
    avgTime = 0
    avgAugmentingPaths = 0

    println("Running for k = $k")

    for _ in 1:numberOfRepetitions
      cube = randomHyperCube(k)

      stats = @timed modelAndSolve(cube)

      flow = stats.value[1]
      augmentingPaths = stats.value[2]
      execTime = stats.time + stats.gctime

      flowSum = 0

      for e in getNeighbours(cube, UInt16(0))
        flowSum += get(flow, (UInt16(0), e), 0)
      end #for

      avgFlow += flowSum
      avgTime += execTime
      avgAugmentingPaths += augmentingPaths
    end #for

    avgAugmentingPaths /= numberOfRepetitions
    avgFlow /= numberOfRepetitions
    avgTime /= numberOfRepetitions

    open("experiments/zad31_results.csv", "a") do file
      write(file, "$k,$avgFlow,$avgTime,$avgAugmentingPaths\n")
    end #open
  end #for

end #main

main()