include("graphAlgorithms.jl")

import .MyGraphAlgorithms

function main()
  MyGraphAlgorithms.runForAlgorithm(MyGraphAlgorithms.radixHeapAlgorithm, "Radix")  
end #main

main()