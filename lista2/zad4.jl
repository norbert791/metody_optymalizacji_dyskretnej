using JuMP
using HiGHS

struct ModelData
  numOfRows
  numOfCols
  cameraRange
  occupiedSqueres
end #ModelData

function countNeighbours()
  
end

function solveModel(data :: ModelData)
  numOfRows = data.numOfRows
  numOfCols = data.numOfCols
  k = data.cameraRange
  occupiedSqueres = data.occupiedSqueres

  model = Model(HiGHS.Optimizer)
  @variable(model, x[i=1:numOfRows, j=1:numOfCols], binary=true)
  @constraint(model, [i=1:numOfRows, j=1:numOfCols; (i, j) in occupiedSqueres], x[i, j] == 0)
  @constraint(model, [(i,j) in occupiedSqueres], sum(x[i, j] for i in max(1, i - k):min(numOfRows, i + k)) + sum(x[i, j] for j in max(1, j - k):min(numOfRows, j + k)) >= 1)
  @objective(model, Min, sum(x[i, j] for i in 1:numOfRows for j in 1:numOfCols))

  @info "Starting model"
  print(model)
  @info "Optimization"
  optimize!(model)
  @info "Optimized model vars"
  println(value.(x))
end #solveModel

function main()
  modelData = ModelData(0,0,0,0)
  open(ARGS[1]) do file
    numOfRows = parse(Int, readline(file))
    numOfCols = parse(Int, readline(file))
    cameraRange = parse(Int, readline(file))
    squeres = Set()
    
    for l in readlines(file)
      temp = split(l)
      temp = map(x -> parse(Int, x), temp)
      push!(squeres, (temp[1], temp[2]))
    end #for

    modelData = ModelData(numOfRows, numOfCols, cameraRange, squeres)
  end #open

  solveModel(modelData)
end #main

main()