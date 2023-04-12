#Norbert Jaśniewicz

using JuMP
using HiGHS

struct Zad2Model
  numberOfCities
  timeTreshhold
  startIndex
  endIndex
  edges
  timeMatrix
  costMatrix
end #Zad2Model

function solveModel(zad :: Zad2Model)
  model = Model(HiGHS.Optimizer)

  numberOfCities = zad.numberOfCities
  timeTreshhold = zad.timeTreshhold

  startIndex = zad.startIndex
  endIndex = zad.endIndex

  timeMatrix = zad.timeMatrix
  costMatrix = zad.costMatrix
  edges = zad.edges

  @variable(model, x[i = 1:numberOfCities, j = 1:numberOfCities], binary=true)
  @constraint(model, [i = 1:numberOfCities; i != startIndex && i != endIndex],
              sum(x[i, j] * ((i, j) in edges) for j in 1:numberOfCities) - sum(x[j, i] * ((j, i) in edges) for j in 1:numberOfCities) == 0)
  @constraint(model, sum(x[startIndex, j] * ((startIndex, j) in edges) for j in 1:numberOfCities) -
                     sum(x[j, startIndex] * ((j, startIndex) in edges) for j in 1:numberOfCities) == 1)
  @constraint(model, sum(x[endIndex, j] * ((endIndex, j) in edges) for j in 1:numberOfCities) -
                     sum(x[j, endIndex] * ((j, endIndex) in edges) for j in 1:numberOfCities) == -1)

  @constraint(model, sum(x[i, j] * timeMatrix[i, j] for i in 1:numberOfCities for j in 1:numberOfCities) <= timeTreshhold)
  @objective(model, Min, sum(x[i, j] * costMatrix[i, j] for i in 1:numberOfCities for j in 1:numberOfCities))

  @info "Starting model"
  print(model)
  @info "Optimization"
  optimize!(model)
  @info "Optimized model vars"
  println(value.(x))
end #solveModel

function main()
  zad::Zad2Model = Zad2Model(0, 0, 0, 0, 0, 0, 0)
  open(ARGS[1], "r") do file
    numberOfCities = parse(Int,(readline(file)))
    timeTreshold = parse(Int, readline(file))
    startIndex = parse(Int, readline(file))
    endIndex = parse(Int, readline(file))
    edges = Set()
    times = zeros(numberOfCities, numberOfCities)
    costs = zeros(numberOfCities, numberOfCities)

    temp = readline(file)
    if temp != "Edges"
      throw(error("Incorrect format"))
    end #if
    
    temp = readline(file)
    while temp != "Times"
      tempArr= split(temp)
      tempArr = map(x -> parse(Int, x), tempArr)
      push!(edges, (tempArr[1], tempArr[2]))
      temp = readline(file)
    end #while

    temp = readline(file)

    while temp != "Costs"
      tempArr= split(temp)
      tempArr = map(x -> parse(Int, x), tempArr)
      times[tempArr[1], tempArr[2]] = tempArr[3]
      temp = readline(file)
    end #while

    for l in readlines(file)
      tempArr= split(l)
      tempArr = map(x -> parse(Int, x), tempArr)
      costs[tempArr[1], tempArr[2]] = tempArr[3]
    end #for

    zad = Zad2Model(numberOfCities, timeTreshold, startIndex, endIndex, edges, times, costs)
  end #open

  solveModel(zad)
end #main

main()