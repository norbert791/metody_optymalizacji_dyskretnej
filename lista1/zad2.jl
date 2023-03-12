include("graphAlgorithms.jl")
using .MyGraphAlgorithms
using .MyGraphAlgorithms.MyGraphPrimitives


function main()
  try
    graph = loadGraph(ARGS[1], true)
    res = topologicalSort(graph)
    if isnothing(res)
      println("Cycle detected")
    elseif length(getVertices(graph)) <= 200
      println("Topological order found: $res")
    else
      println("Topological order found")
    end #if
  catch e
    println("First argument must be path to valid file")
    println(e)
  end #try
end #function

main()
