#Norbert Jaśniewicz

using JuMP
using HiGHS

struct ModelData
  companySupply
  airportDemand
  costs  
end #ModelData

function solveModel(data :: ModelData)
  model = Model(HiGHS.Optimizer)

  companySupply = data.companySupply #[275_000, 550_000, 660_000]
  airportDemand = data.airportDemand #[110_000, 220_000, 330_000, 440_000]
  costs = data.costs #[10 7 8; 10 11 14; 9 12 4; 11 13 9]

  numOfCompanies = length(companySupply)
  numOfAirports = length(airportDemand)

  @variable(model, 0 <= x[i = 1:numOfAirports, j = 1:numOfCompanies])
  @constraint(model, [j in 1:numOfCompanies], 0 <= sum(x[:, j]) <= companySupply[j])
  @constraint(model, [i in 1:numOfAirports], sum(x[i, :]) == airportDemand[i])
  @objective(model, Min, sum(costs[i, j] * x[i, j] for i in 1:numOfAirports for j in 1:numOfCompanies))

  @info "Starting model"
  print(model)
  @info "Optimization"
  optimize!(model)
  @info "Optimized model vars"
  println(value.(x))
end #solveModel

function main()
  zad::ModelData = ModelData(0, 0, 0)
  open(ARGS[1], "r") do file
    companySupply = []
    airportDemand = []

    temp = readline(file)
    if temp != "Supply"
      throw(error("Incorrect format"))
    end #if
    
    temp = readline(file)
    while temp != "Demand"
      push!(companySupply, parse(Int, temp))
      temp = readline(file)
    end #while

    temp = readline(file)

    while temp != "Costs"
      push!(airportDemand, parse(Int, temp))
      temp = readline(file)
    end #while

    costs = zeros(length(airportDemand), length(companySupply))
    row = 1

    for l in readlines(file)
      tempStr = l
      arr = split(tempStr)
      arr = map(x -> parse(Int, x), arr)

      for col in 1:length(companySupply)
        costs[row, col] = arr[col]
      end #for
      
      row += 1
    end #while

    zad = ModelData(companySupply, airportDemand, costs)
  end #open

  solveModel(zad)
end #main

main()