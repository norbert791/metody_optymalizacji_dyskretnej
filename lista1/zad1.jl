include("graphAlgorithms.jl")
using .MyGraphAlgorithms
using .MyGraphAlgorithms.MyGraphPrimitives


function main()
  try
    graph = loadGraph(ARGS[1], true)
    res = []
    if ARGS[2] == "dfs"
      res = dfsOrder(graph, UInt32(1))
    elseif ARGS[2] == "bfs"
      res = bfsOrder(graph, UInt32(1))
    else
      return
    end #if
    println("Order: $res")
    if length(ARGS) == 3 && ARGS[3] == "show"
      res = ARGS[2] == "dfs" ? dfsTree(graph, UInt32(1)) : bfsTree(graph, UInt32(1))
      println("\nTree: $res")
    else
      return
    end #if
  catch
    println("First argument must be path to valid file, second is either 'bfs' or 'dfs' and the third (optional) one is 'show'")
  end #try
end #function

main()
