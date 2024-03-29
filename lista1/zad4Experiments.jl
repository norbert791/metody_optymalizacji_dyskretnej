include("graphAlgorithms.jl")

using .MyGraphAlgorithms
using .MyGraphAlgorithms.MyGraphPrimitives

function main()
  files = readdir("./aod_testy1/4/", join=true)

  #Compute times
  for f in files
    g = loadGraph(f, true)
    println("Computing: $f")
    @time isBiparteIterative(g)
  end #for
end

main()