include("hypercube.jl")
using .HypercubeGraph

struct experimentResults
  flow::Float64
  augmentingPaths::Float64
  execTime::Float64
end #experimentResults

function modelAndSolve(g::BiparteGraph)
  model, f = getBiparteGraphModel(g)
  optimize!(model)
  return value.(f), 0
end #modelAndSolve

function main()

  numberOfRepetitions = 40
  maxSize = 10

  exps = Dict()

  for k in 3:maxSize
    println("Running for k = $k")

    for i in 1:k
      avgFlow = 0
      avgTime = 0
      avgAugmentingPaths = 0

      println("Running for i = $i")

      for _ in 1:numberOfRepetitions
        cube = randomBiparteGraph(k, i)

        stats = @timed modelAndSolve

        flow = stats.value[1]
        augmentingPaths = stats.value[2]
        execTime = stats.time + stats.gctime

        flowSum = 0

        for e in getNeighbours(cube, UInt64(typemax(UInt64) - 1))
          flowSum += get(flow, (UInt64(typemax(UInt64) - 1), e), 0)
        end #for

        avgFlow += flowSum
        avgTime += execTime
        avgAugmentingPaths += augmentingPaths
      end #for

      avgAugmentingPaths /= numberOfRepetitions
      avgFlow /= numberOfRepetitions
      avgTime /= numberOfRepetitions

      exps[(k, i)] = experimentResults(avgFlow, avgAugmentingPaths, avgTime)
    end #for
  end #for

  for k in 3:maxSize
    open("experiments/zad3_k$k.csv", "w") do file
      write(file, "i,avgMaxMatching\n")
      for i in 1:k
        write(file, "$i,$(exps[(k, i)].flow)\n")
      end #for
    end #open
  end #for

  for i in 1:maxSize
    open("experiments/zad3_i$i.csv", "w") do file
      write(file, "k,avgTime\n")
      for k in (max(i, 3)):maxSize
        write(file, "$k,$(exps[(k, i)].execTime)\n")
      end #for
    end #open
  end #for
end #main

main()