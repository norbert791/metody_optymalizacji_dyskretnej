include("graphAlgorithms.jl")
using .MyGraphAlgorithms
using StatProfilerHTML

function main()
  n = loadNetwork("ch9-1.1/inputs/USA-road-d/USA-road-d.BAY.gr")
  @time radixHeapAlgorithm(n, Unsigned(150169))
end

main()