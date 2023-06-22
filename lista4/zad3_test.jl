include("hypercube.jl")
using .HypercubeGraph
using JuMP

function main()
  g = randomBiparteGraph(4, 2)
  model, f = getBiparteGraphModel(g)
  # println(model)
  # optimize!(model)
  # println(value.(f))
end

main()