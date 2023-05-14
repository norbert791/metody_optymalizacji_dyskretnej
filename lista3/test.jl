include("graphAlgorithms.jl")
using .MyGraphAlgorithms

function main()
  n = loadNetwork("ch9-1.1/inputs/USA-road-d/USA-road-d.BAY.gr")
  println(dijkstraAlgorithm(n, Unsigned(0x0000000000025cb5), Unsigned(0x000000000002b975)))
end

main()