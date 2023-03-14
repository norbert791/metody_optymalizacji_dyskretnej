include("graphAlgorithms.jl")
using .MyGraphAlgorithms
using .MyGraphAlgorithms.MyGraphPrimitives


function main()
  try
    graph = loadGraph(ARGS[1], true)
    res = strongComponentsIterative(graph)
    if length(getVertices(graph)) <= 200
      println("Partition (of power $(length(res))) found: $res")
    else
      println("Partition (of power $(length(res))) found")
    end #if
  catch e
    println("First argument must be path to valid file")
    println(e)
  end #try
end #function

main()
