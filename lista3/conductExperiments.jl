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
  distinctFiles = filter(x -> count(y -> y == '.', x) <= 2, distinctFiles)

  result::Vector{ExperimentResult} = []
  try
    for name in distinctFiles
      println("Loading network: $name")
      network = MyGraphAlgorithms.loadNetwork("$dirName/$name.gr")
      sources = MyGraphAlgorithms.loadSources("$dirName/$name.ss")
      totalTime = 0
      counter = 0

      if name in ["Random4-C.0.0", "Random4-C.1.0", "Random4-C.2.0"]
        println("blacklisted: $name")
        push!(result, ExperimentResult(name, Int(length(MyGraphAlgorithms.MyGraphPrimitives.getVertices(network))), Int(length(network.costs)), NaN))
        continue
      end

      #avg max timeout * number of sources
      timeout = 10 * length(sources)

      for s in sources
        println("Running for: $s")
        temp = @elapsed algorithm(network, s)
        totalTime += temp
        counter += 1
        if (totalTime > timeout)
          println("Timeout reached")
          break
        end #if
      end #for

      totalTime /= counter
      push!(result, ExperimentResult(name, Int(length(MyGraphAlgorithms.MyGraphPrimitives.getVertices(network))), Int(length(network.costs)), totalTime))
    end #for
  catch err
    showerror(stdout, err)
    println("")
  finally
    return result
  end
end

function runAndAppend(dirName::String, algorithm::Function, funName::String, output::String)
  v = runExperimentsFromDirectory(dirName, algorithm)
  open("$output_$funName", "a") do file
    for el::ExperimentResult in v
      write(file, "$(el.instanceName),$(el.numOfVertices),$(el.numOfEdges),$(el.instanceTime)\n")
    end #for
  end
end

function main()
  mainDir::String = "ch9-1.1/inputs/"

  directories = #=["Long-C", "Long-n", =#["Random4-C"]#, "Random4-n", =#["Square-C"]#, "Square-n"]

  algs = #=[(MyGraphAlgorithms.dijkstraAlgorithm, "dijkstra")][(MyGraphAlgorithms.dialAlgorithm, "dial"), =#[(MyGraphAlgorithms.radixHeapAlgorithm, "radix")]

  outputDir = "experimentsOutput/"

  for dir in directories
    fullDir = mainDir * dir
    for al in algs
      println("GOING FOR $(al[2]) in $dir")
      v = runExperimentsFromDirectory(fullDir, al[1])
      open(outputDir * "$(dir)_$(al[2])", "a") do file
        for temp in v
          write(file, "$(temp.instanceName),$(temp.numOfVertices),$(temp.numOfEdges),$(temp.instanceTime)\n")
        end #for
      end
    end #for
  end #for
end

main()