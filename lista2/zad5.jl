using JuMP
using HiGHS

struct ModelData
  numOfProducts
  numOfMachines
  timeProportion
  demand
  machineTime
  machineCost
  productValue
  productCost
  prodTime
end #ModelData

function solveModel(data :: ModelData)
  model = Model(HiGHS.Optimizer)
  numOfProducts = data.numOfProducts
  numOfMachines = data.numOfMachines
  prodTime = data.prodTime
  demand = data.demand
  machineTime = data.machineTime
  machineCost = data.machineTime
  productValue = data.productValue
  productCost = data.productCost
  timeProportion = data.timeProportion
  
  @variable(model, 0 <= x[i = 1:numOfProducts] <= demand[i])
  @constraint(model, [j = 1:numOfMachines], sum(prodTime[i, j] * x[i] for i in 1:numOfProducts) <= (machineTime[j] * timeProportion))
  @objective(model, Max, sum(x[i] * (productValue[i] - productCost[i] - sum(machineCost[j] * prodTime[i, j] / timeProportion for j in 1:numOfMachines)) for i in 1:numOfProducts))

  @info "Starting model"
  print(model)
  @info "Optimization"
  optimize!(model)
  @info "Optimized model vars"
  println(value.(x))
end

function main()
  data = ModelData(0,0,0,0,0,0,0,0,0)
  open(ARGS[1]) do file
    numOfProducts = parse(Int, readline(file))
    numOfMachines = parse(Int, readline(file))
    timeProportions = parse(Int, readline(file))
    demand = []
    it = readline(file) #Read 'Demand'
    it = readline(file)

    while it != "MachineTime"
      push!(demand, parse(Int, it))
      it = readline(file)
    end #while

    machineTime = []
    it = readline(file)

    while it != "MachineCost"
      push!(machineTime, parse(Int, it))
      it = readline(file)
    end #while

    machineCost = []
    it = readline(file)

    while it != "ProductValue"
      push!(machineCost, parse(Int, it))
      it = readline(file)
    end #while

    productValue = []
    it = readline(file)

    while it != "ProductCost"
      push!(productValue, parse(Int, it))
      it = readline(file)
    end #while

    productCost = []
    it = readline(file)

    while it != "ProductTime"
      push!(productCost, parse(Int, it))
      it = readline(file)
    end #while

    prodTime = zeros(numOfProducts, numOfMachines)

    row = 1

    for l in readlines(file)
      temp = split(l)
      for col in 1:numOfMachines
        prodTime[row, col] = parse(Int, temp[col])
      end #for
    end #for

    data = ModelData(numOfProducts, numOfMachines, timeProportions, demand, machineTime, machineCost, productValue, productCost, prodTime)
  end #open

  solveModel(data)
end #main

main()