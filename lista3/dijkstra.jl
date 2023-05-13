include("graphAlgorithms.jl")

import .MyGraphAlgorithms

function main()
  MyGraphAlgorithms.runForAlgorithm(MyGraphAlgorithms.dijkstraAlgorithm, "Dijkstra")  
end #main

main()