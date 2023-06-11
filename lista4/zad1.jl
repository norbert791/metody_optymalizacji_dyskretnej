include("hypercube.jl")
using .HypercubeGraph
import ArgParse

function parseCommandLine()
  s = ArgParse.ArgParseSettings()

  ArgParse.@add_arg_table s begin
    "--size"
    required = true
    help = "Size of the graph"
    "--printFlow"
    help = "Print flow"
    action = :store_true
  end

  return ArgParse.parse_args(s)
end

function main()

  args = parseCommandLine()

  cubeSize = parse(UInt64, args["size"])
  cube = randomHyperCube(cubeSize)

  printHypercube(cube)

  flow, augPaths = EdmondsKarp(cube, UInt16(0), UInt16(2^cubeSize - 1))

  flowSum = 0

  for e in getNeighbours(cube, UInt16(0))
    flowSum += get(flow, (UInt16(0), e), 0)
  end #for

  println("Max flow: $flowSum")
  if args["printFlow"]
    println("Flow:")
    println(flow)
  end #if

end

main()