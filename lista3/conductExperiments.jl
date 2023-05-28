include("graphAlgorithms.jl")
import .MyGraphAlgorithms

struct ExperimentResult
  instanceName::String
  numOfVertices
  numOfEdges
  instanceTime
end #ExperimentResult

function runExperimentsFromDirectory(dirName::String, algorithm::Function)::Vector{ExperimentResult}
  files = readdir(dirName)
  files = map(x -> splitext(x)[1], files)
  distinctFiles = Set(files)

  result::Vector{ExperimentResult} = []
  try
    for name in distinctFiles
      network = MyGraphAlgorithms.loadNetwork("$dirName/$name.gr")
      sources = MyGraphAlgorithms.loadSources("$dirName/$name.ss")
      totalTime = 0
      counter = 0

      for s in sources
        println("Running for: $s")
        temp = @elapsed algorithm(network, s)
        totalTime += temp
        counter += 1
      end #for

      totalTime /= counter
      push!(result, ExperimentResult(name, length(MyGraphAlgorithms.getVertices(network)), length(network.costs), totalTime))
    end #for
  catch err
    showerror(stdout, err)
    println("")
  finally
    return result
  end
end

function main()
  directory::String = "ch9-1.1/inputs/Long-C/"

  v = runExperimentsFromDirectory("testDir", MyGraphAlgorithms.dijkstraAlgorithm)
  @show v
end

main()