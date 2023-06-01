using DataFrames
using CSV


function main()
  instances = ["Long-C", "Long-n", "Random4-C", "Random4-n", "Square-C", "Square-n"]
  instDir = "./experimentsOutput"
  # df1 = CSV.read("$instDir/Long-C_dial", DataFrame)
  # rename!(df1, Dict("averageTime" => "dial"))
  # df2 = CSV.read("$instDir/Long-C_dijkstra", DataFrame)
  # df3 = CSV.read("$instDir/Long-C_radix", DataFrame)
  # df = innerjoin(df1, df2, on=[:numOfVertices, :numOfEdges, :instance], makeunique=true)
  # sort!(df, [:dial])

  for inst in instances
    df1 = CSV.read("$instDir/$(inst)_dijkstra", DataFrame)
    df2 = CSV.read("$instDir/$(inst)_dial", DataFrame)
    df3 = CSV.read("$instDir/$(inst)_radix", DataFrame)

    rename!(df1, Dict("averageTime" => "dijkstra"))
    rename!(df2, Dict("averageTime" => "dial"))
    rename!(df3, Dict("averageTime" => "radix"))

    df = innerjoin(df1, df2, on=[:numOfVertices, :numOfEdges, :instance])
    df = innerjoin(df, df3, on=[:numOfVertices, :numOfEdges, :instance])
    sort!(df, [:numOfVertices, :numOfEdges])

    transform!(df, AsTable([:dijkstra, :dial, :radix]) => ByRow(argmin) => :winner)

    # v1 = @chain df begin
    #   getproperty(:dijkstra) # same as above
    # end

    # v2 = @chain df begin
    #   getproperty(:dial) # same as above
    # end

    # v3 = @chain df begin
    #   getproperty(:radix) # same as above
    # end

    # v = []

    # for i in eachindex(v1)
    #   minVal
    #   if v1[i] == min(v1[i], v2[i], v3[i])
    #     push!(v, "dijkstra")
    #   elseif v2[i] < v3[i]
    #     push!(v, "dial")
    #   else
    #     push!(v, "radix")
    #   end #if
    # end #for

    # df[!, "winner"] = v

    CSV.write("processedOutput/$inst.csv", df)
  end #for

end #main

main()