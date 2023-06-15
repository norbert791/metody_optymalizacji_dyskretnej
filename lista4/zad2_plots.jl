using Plots
using CSV
using DataFrames

function main()
  for k in 3:10
    df = CSV.read("experiments/zad2_k$k.csv", DataFrame)
    #Plot avgFlow, avgAugmentingPaths, avgTime

    t = Plots.scatter(df[!, :i], df[!, :avgMaxMatching], title="Avg max matching (k=$k)", xlabel="i", ylabel="max matching", label="Max matching")
    Plots.savefig(t, "plots/zad2_k$k.png")
  end #for

  for i in 1:10
    df = CSV.read("experiments/zad2_i$i.csv", DataFrame)
    #Plot avgFlow, avgAugmentingPaths, avgTime

    t = Plots.scatter(df[!, :k], df[!, :avgTime], title="Avg time (i=$i)", xlabel="k", ylabel="time", label="Time")
    Plots.savefig(t, "plots/zad2_i$i.png")
  end #for
end #main

main()