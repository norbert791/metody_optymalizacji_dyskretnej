include("hypercube.jl")
using .HypercubeGraph

struct experimentResults
  flow::UInt32
  augmentingPaths::UInt32
  execTime::Float64
end #experimentResults

function main()

  numberOfRepetitions = 40

  exps = Dict()

  for k in 1:16
    println("Running for k = $k")

    for i in 1:k
      avgFlow = 0
      avgTime = 0
      avgAugmentingPaths = 0

      println("Running for i = $i")

      for _ in 1:numberOfRepetitions
        cube = randomBiparteGraph(k, i)

        stats = @timed EdmondsKarp(cube, UInt64(0), UInt64(2^k - 1))

        flow = stats.value[1]
        augmentingPaths = stats.value[2]
        execTime = stats.time + stats.gctime

        flowSum = 0

        for e in getNeighbours(cube, UInt64(0))
          flowSum += get(flow, (UInt64(0), e), 0)
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

  for k in 1:16
    open("experiments/zad2_k$k.csv", "w") do file
      write(file, "k,i,avgMaxMatching\n")
      for i in 1:k
        write(file, "$k,$i,")
        write(file, exps[(k, i)].flow)
        write(file, "\n")
      end #for
    end #open
  end #for

  for i in 1:16
    for k in 1:i
      open("experiments/zad2_i$i.csv", "w") do file
        write(file, "k,i,avgTime\n")
        write(file, "$k,$i,")
        write(file, exps[(k, i)].execTime)
        write(file, "\n")
      end #open
    end #for
  end #for
end #main

main()