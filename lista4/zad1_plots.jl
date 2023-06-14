using Plots
using CSV
using DataFrames

function main()
  df = CSV.read("experiments/zad1_results.csv", DataFrame)
  #Plot avgFlow, avgAugmentingPaths, avgTime

  t = Plots.scatter(df[!, :k], df[!, :avgFlow], title="Avg flow", xlabel="k", ylabel="flow", label="Flow")
  Plots.savefig(t, "plots/zad1_flow.png")
  t = Plots.scatter(df[!, :k], df[!, :avgAugmentingPaths], title="Avg augmenting paths", xlabel="k", ylabel="augmenting paths", label="Augmenting paths")
  Plots.savefig(t, "plots/zad1_paths.png")
  t = Plots.scatter(df[!, :k], df[!, :avgTime], title="Avg time", xlabel="k", ylabel="time", label="Time")
  Plots.savefig(t, "plots/zad1_time.png")
end

main()