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

  # @show shiftMin
  # @show distrMin

  @variable(model, 0 <= d[i=1:numOfDistr, j=1:numOfShifts], Int)
  @variable(model, 0 <= z[i=1:numOfShifts, j=1:numOfDistr], Int)
  @constraint(model, [i=1:numOfDistr], sum(d[i, j] for j in 1:numOfShifts) == sum(z[j, i] for j in 1:numOfShifts))
  @constraint(model, [i=1:numOfDistr], sum(d[i, :]) >= distrMin[i])
  @constraint(model, [i=1:numOfDistr], sum(z[i, :]) >= shiftMin[i])
  @constraint(model, [i=1:numOfDistr, j=1:numOfShifts], minCars[i, j] <= d[i, j] <= maxCars[i, j])
  @objective(model, Min, sum(d[i, j] for i in 1:numOfDistr for j in 1:numOfShifts))

  @info "Starting model"
  print(model)
  @info "Optimization"
  optimize!(model)
  @info "Optimized model vars"
  println(value.(d))
  println(value.(z))
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