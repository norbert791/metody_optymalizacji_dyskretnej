using JuMP
using HiGHS

struct ModelData
  minCars
  maxCars
  distrMin
  shiftMin
end

function solveModel(data::ModelData)
  model = Model(HiGHS.Optimizer)
  maxCars = data.maxCars
  minCars = data.minCars
  distrMin = data.distrMin
  shiftMin = data.shiftMin
  numOfShifts = length(shiftMin)
  numOfDistr = length(distrMin) 

  @show shiftMin
  @show distrMin

  @variable(model,  x[i=1:numOfDistr, j=1:numOfShifts], Int)
  @constraint(model, [i=1:numOfDistr, j=1:numOfShifts], x[i, j] <= maxCars[i, j])
  @constraint(model, [i=1:numOfDistr, j=1:numOfShifts], x[i, j] >= minCars[i, j] )
  @constraint(model, [j in 1:numOfShifts], sum(x[:, j]) == sum(x[:, mod1(j + 1, numOfShifts)]))
  @constraint(model, [j in 1:numOfShifts], sum(x[:, j]) >= shiftMin[j])
  @constraint(model, [i in 1:numOfDistr], sum(x[i, :]) >= distrMin[i])
  @objective(model, Min, sum(x[:, 1]))

  @info "Starting model"
  print(model)
  @info "Optimization"
  optimize!(model)
  @info "Optimized model vars"
#  println(value.(x))
end

function main()
  modelData = ModelData(0,0,0,0)

  open(ARGS[1]) do file
    it = readline(file)
    shiftMin = map(x -> parse(Int, x), split(it))
    it = readline(file)
    distrMin = map(x -> parse(Int, x), split(it))
    
    minCars = zeros(length(distrMin), length(shiftMin))
    it = readline(file)
    index = 1

    while it != "MaxCars"
      temp = split(it)
      temp = map(x -> parse(Int, x), temp)

      for j in eachindex(temp)
        minCars[index, j] = temp[j]
      end #el
      
      index += 1
      it = readline(file)
    end #while

    maxCars = zeros(length(distrMin), length(shiftMin))
    index = 1

    for l in readlines(file)
      temp = split(l)
      temp = map(x -> parse(Int, x), temp)
      
      for j in eachindex(temp)
        maxCars[index, j] = temp[j]
      end #el

      index += 1
    end #for

    modelData = ModelData(minCars, maxCars, distrMin, shiftMin)
  end #open

  solveModel(modelData)
end #main

main()