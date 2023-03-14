include("graphAlgorithms.jl")
using .MyGraphAlgorithms
using .MyGraphAlgorithms.MyGraphPrimitives
using ProfileView

function main()
  try
    graph = loadGraph("aod_testy1/3/g3-4.txt", true)
    @profview strongComponentsIterative(graph)
    t = readline()
  catch e
    println("First argument must be path to valid file")
    println(e)
  end #try
end #function

main()