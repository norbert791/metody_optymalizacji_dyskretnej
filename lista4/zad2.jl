include("hypercube.jl")
using .HypercubeGraph
import ArgParse

function parseCommandLine()
  s = ArgParse.ArgParseSettings()

  ArgParse.@add_arg_table s begin
    "--size"
    required = true
    help = "Size of the graph"
    "--degree"
    required = true
    help = "Degree of V1"
    "--printMatching"
    help = "Print flow"
    action = :store_true
  end

  return ArgParse.parse_args(s)
end

function main()

  args = parseCommandLine()

  cubeSize = parse(UInt64, args["size"])
  degree = parse(UInt64, args["degree"])
  graph = randomBiparteGraph(cubeSize, degree)

  printBiparteGraph(graph)

  stats = @timed EdmondsKarp(graph, UInt64(typemax(UInt64) - 1), UInt64(typemax(UInt64)))

  flow = stats.value[1]
  augmentingPaths = stats.value[2]
  execTime = stats.time + stats.gctime

  flowSum = 0

  for e in getNeighbours(graph, UInt64(typemax(UInt64) - 1))
    flowSum += get(flow, (UInt64(typemax(UInt64) - 1), e), 0)
  end #for

  println("Max matching: $flowSum")

  if args["printMatching"]
    matchings = []
    for k in keys(flow)
      if k[1] == UInt64(typemax(UInt64) - 1) || k[2] == UInt64(typemax(UInt64))
        continue
      end #if
      push!(matchings, k)
    end #for
    println("Matching:")
    println(matchings)
  end #if

  write(stderr, "$execTime\n")
  write(stderr, "$augmentingPaths\n")
end #main

main()