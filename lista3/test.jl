include("graphAlgorithms.jl")
include("graphPrimitives.jl")
using .MyGraphAlgorithms
using .MyGraphPrimitives
# using StatProfilerHTML

function main()
  n = loadNetwork("data/inputs/Long-C/Long-C.12.0.gr")
  # @show typeof(n)
  # @show MyGraphAlgorithms.MyGraphPrimitives.getVertices(n)
  @time radixHeapAlgorithm(n, Unsigned(150169))
end

main()