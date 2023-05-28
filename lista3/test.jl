include("graphAlgorithms.jl")
include("graphPrimitives.jl")
using .MyGraphAlgorithms
using .MyGraphPrimitives
using StatProfilerHTML

function main()
  n = loadNetwork("ch9-1.1/inputs/USA-road-d/USA-road-d.BAY.gr")
  # @show typeof(n)
  # @show MyGraphAlgorithms.MyGraphPrimitives.getVertices(n)
  @time radixHeapAlgorithm(n, Unsigned(150169))
end

main()