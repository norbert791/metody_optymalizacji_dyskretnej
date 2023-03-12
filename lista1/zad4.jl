include("graphAlgorithms.jl")
using .MyGraphAlgorithms
using .MyGraphAlgorithms.MyGraphPrimitives


function main()
  try
    graph = loadGraph(ARGS[1], true)
    res = isBiparteIterative(graph)
    if isnothing(res)
      println("Is not biparte")
    elseif length(getVertices(graph)) <= 200
      println("Biparte partition found: $(res)")
    else
      println("Biparte partition found")
    end #if
  catch e
    println("First argument must be path to valid file")
    println(e)
  end #try
end #function

main()